import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' hide Marker;

import '/bloc/auth/auth_bloc.dart';
import '/bloc/nearby/nearby_bloc.dart';
import '/bloc/ride/ride_bloc.dart';
import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/cubit/deliver/deliver_cubit.dart';
import '/cubit/select_cubit.dart';
import '/model/map_address.dart';
import '/model/nearby_available_drivers.dart';
import '/routes/router.dart';
import '/services/googlemap.dart';
import '/widgets/custom_button_widget.dart';
import '/widgets/custom_text_form_field_widget.dart';

class DeliverPage extends StatefulWidget {
  const DeliverPage({super.key});

  @override
  State<DeliverPage> createState() => _DeliverPageState();
}

class _DeliverPageState extends State<DeliverPage> {
  // * CONTROLLER GOOGLE MAP
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  late GoogleMapController newGoogleMapController;

  final TextEditingController pickUpController = TextEditingController();
  final TextEditingController dropOffController = TextEditingController();

  // * CURRENT LOCATION
  Position? currentLocation;
  Geolocator geoLocator = Geolocator();
  CameraPosition? myLocation;

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(-7.319563, 108.202972),
    zoom: 14.4746,
  );

  SelectCubit<bool> nearbyAvailableDriverKeysLoaded = SelectCubit(false);
  SelectCubit<bool> isRequestSuccess = SelectCubit(false);

  late BitmapDescriptor nearbyIcon;

  List<NearbyAvailableDrivers> availableDrivers = [];

  @override
  Widget build(BuildContext context) {
    DeliverCubit deliverCubit = context.read<DeliverCubit>();

    // * SET INITIAL CAMERA POSITION
    if (deliverCubit.state.currentPosition != null) {
      myLocation = CameraPosition(
        target: LatLng(
          deliverCubit.state.currentPosition!.latitude,
          deliverCubit.state.currentPosition!.longitude,
        ),
        zoom: 16,
      );
    }

    // * FUNCTION TO GET CURRENT LOCATION
    void locatePosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      // * CHECK LOCATION SERVICE
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled');
      }

      // * CHECK LOCATION PERMISSION
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // * GET CURRENT LOCATION
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLocation = position;

      // debugPrint('location: $position');

      // * MOVE CAMERA TO CURRENT LOCATION
      LatLng latlngPosition = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition =
          CameraPosition(target: latlngPosition, zoom: 16);
      newGoogleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      // * GET CURRENT ADDRESS
      if (context.mounted) {
        MapAddress address =
            await GoogleMapService.searchCoordinateAddress(position);

        // * ADD CURRENT ADDRESS AND POSITION TO CUBIT
        deliverCubit.setPickUpAddress(address);
        deliverCubit.addCurrentPosition(position);

        createIconMarker();

        initGeoFireListener();
      }
    }

    // debugPrint('BUILD PAGE');

    return WillPopScope(
      onWillPop: () {
        //* CLEAR STATE IF OBTAIN DIRECTION ON BACK PRESSED
        if (deliverCubit.state.isObtainDirection == true) {
          deliverCubit.clearState();
        }

        return Future.value(true);
      },
      child: Scaffold(
        floatingActionButton: _buildFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        body: SafeArea(
          child: Stack(
            children: [
              // * GOOGLE MAP
              BlocBuilder<DeliverCubit, DeliverState>(
                builder: (context, state) {
                  // debugPrint('GOOGLE MAP');
                  //* GET CURRENT LOCATION
                  if (state.pickUpAddress == null) {
                    locatePosition();
                  }

                  //* GET DIRECTION
                  if (state.isLocationUpdated &&
                      state.isObtainDirection == true) {
                    // debugPrint('obtain direction');
                    getPlaceDirection();
                    context.read<DeliverCubit>().setIsLocationUpdated(false);
                  }

                  return GoogleMap(
                    padding: const EdgeInsets.only(bottom: 200),
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: myLocation ?? initialCameraPosition,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    compassEnabled: true,
                    polylines: state.polylineSet,
                    markers: state.markerSet,
                    circles: state.circleSet,
                    onMapCreated: (controller) {
                      _controllerGoogleMap.complete(controller);
                      newGoogleMapController = controller;
                    },
                  );
                },
              ),

              BlocBuilder<DeliverCubit, DeliverState>(
                builder: (context, state) {
                  // debugPrint('BUILD BOTTOM SHEET ${state.toJson()}}');
                  return Visibility(
                    visible: !state.isSearching,
                    replacement: _buildSearchingDriverBottomSheet(),
                    child: _buildSearchBottomSheet(context),
                  );
                },
              ),

              // * SEARCH BAR
              // _buildSearchBottomSheet()
            ],
          ),
        ),
      ),
    );
  }

  Positioned _buildSearchBottomSheet(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mau kirim barang kemana?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                BlocBuilder<DeliverCubit, DeliverState>(
                  builder: (context, state) {
                    //* SET PICK UP ADDRESS
                    pickUpController.text =
                        state.pickUpAddress?.placeName ?? '';

                    return CustomTextFormField(
                      controller: pickUpController,
                      iconAsset: AppAsset.iconLocation,
                      hintText: 'Lokasi Pengambilan Barang',
                      paddingVertical: 8,
                      borderRadius: 100,
                      isDisabled: true,
                      onTap: () => context.goNamed(Routes.searchPage),
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<DeliverCubit, DeliverState>(
                  builder: (context, state) {
                    // * SET DROP OFF ADDRESS
                    dropOffController.text =
                        state.dropOffAddress?.placeName ?? '';

                    return CustomTextFormField(
                      controller: dropOffController,
                      iconAsset: AppAsset.iconLocation,
                      hintText: 'Lokasi Tujuan Barang',
                      paddingVertical: 8,
                      borderRadius: 100,
                      isDisabled: true,
                      onTap: () => context.goNamed(Routes.searchPage),
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<DeliverCubit, DeliverState>(
                  builder: (context, state) {
                    return Visibility(
                      visible: state.isObtainDirection == true,
                      child: ButtonCustom(
                        label: state.isComplete ? 'Ubah Data' : 'Lanjutkan',
                        onTap: () => context.goNamed(Routes.locationDetail),
                        type: ButtonType.secondary,
                      ),
                    );
                  },
                ),
                BlocBuilder<DeliverCubit, DeliverState>(
                  builder: (context, state) {
                    return Visibility(
                      visible:
                          state.isComplete && state.isObtainDirection == true,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          BlocBuilder<RideBloc, RideState>(
                            builder: (context, rideState) {
                              return ButtonCustom(
                                label: 'Pesan Sekarang',
                                onTap: () {
                                  final drivers =
                                      context.read<NearbyBloc>().state.drivers;
                                  context
                                      .read<DeliverCubit>()
                                      .setIsSearching(true);

                                  context.read<RideBloc>().add(RideEventRequest(
                                        pickUp: state.pickUpAddress!,
                                        dropOff: state.dropOffAddress!,
                                        paymentMethod: state.paymentMethod!,
                                        sender: state.sender!,
                                        receiver: state.receiver!,
                                        distance: state
                                            .directionDetails!.distanceValue!
                                            .toDouble(),
                                        totalPayment: state.totalPayment,
                                        payloads: state.payloads,
                                        vehicle: state.vehicle!,
                                        carrier: state.carrier,
                                        driver: drivers.isNotEmpty
                                            ? drivers[0]
                                            : null,
                                      ));

                                  availableDrivers = context
                                      .read<NearbyBloc>()
                                      .state
                                      .drivers
                                      .toList();
                                },
                                type: ButtonType.secondary,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Positioned _buildSearchingDriverBottomSheet() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColor.secondary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: BlocConsumer<RideBloc, RideState>(
          listener: (context, state) {
            if (state is RideStateError) {
              Fluttertoast.showToast(
                msg: state.message,
                timeInSecForIosWeb: 2,
              );

              context.read<DeliverCubit>().setIsSearching(false);
              context.read<RideBloc>().add(RideEventCancel());
            }

            if (state is RideStateSuccess && !isRequestSuccess.state) {
              Fluttertoast.showToast(
                msg: 'Berhasil memesan driver',
                timeInSecForIosWeb: 2,
              );

              context.read<DeliverCubit>().setIsSearching(false);

              isRequestSuccess.setSelectedValue(true);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const Text(
                  'Sedang mencari driver ...',
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Lottie.asset(AppAsset.animSearching, width: 250, height: 250),
                ButtonCustom(
                  label: 'Batalkan',
                  onTap: () {
                    context.read<DeliverCubit>().setIsSearching(false);
                    context.read<RideBloc>().add(RideEventCancel());
                  },
                  type: ButtonType.primary,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  BlocBuilder<DeliverCubit, DeliverState> _buildFloatingActionButton() {
    return BlocBuilder<DeliverCubit, DeliverState>(
      builder: (context, state) {
        // debugPrint('BUILD FAB : ${state.toJson()}');
        return FloatingActionButton(
          mini: true,
          backgroundColor: Colors.white,
          onPressed: () {
            if (state.isObtainDirection == true) {
              context.read<DeliverCubit>().clearState();
            } else {
              context.pop();
            }
          },
          child: state.isObtainDirection == true
              ? const Icon(
                  Icons.close_rounded,
                  color: AppColor.primary,
                )
              : const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColor.primary,
                ),
        );
      },
    );
  }

  Future<void> getPlaceDirection() async {
    // * GET PICK UP AND DROP OFF ADDRESS
    DeliverCubit deliverCubit = context.read<DeliverCubit>();
    MapAddress? initialPos = deliverCubit.state.pickUpAddress;
    MapAddress? finalPos = deliverCubit.state.dropOffAddress;

    LatLng pickUpLatLng = LatLng(initialPos!.latitude!, initialPos.longitude!);
    LatLng dropOffLatLng = LatLng(finalPos!.latitude!, finalPos.longitude!);

    //* GET DIRECTION DETAILS
    var details = await GoogleMapService.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    // debugPrint('encoded points: ${details.encodedPoints}');
    deliverCubit.setDirectionDetails(details);

    // * DECODE POLYLINE POINTS
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints!);

    // * ADD DECODED POLYLINE POINTS TO ARRAY
    deliverCubit.clearPLinesCoordinates();
    if (decodedPolylinePointsResult.isNotEmpty) {
      for (var pointLatLng in decodedPolylinePointsResult) {
        deliverCubit.addPLineCoordinates(
            LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    // * CREATE POLYLINE
    deliverCubit.clearPolylineSet();
    Polyline polyline = Polyline(
      polylineId: const PolylineId('polylineId'),
      color: AppColor.primary,
      jointType: JointType.round,
      points: deliverCubit.state.pLineCoordinates,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    deliverCubit.addPolyline(polyline);

    // * CREATE BOUND LATLNG TO FIT TWO MARKERS
    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
        northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
      );
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
        northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
      );
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    // * MOVE CAMERA TO FIT TWO MARKERS
    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    // * CREATE MARKER
    Marker pickUpMarker = Marker(
      markerId: const MarkerId('pickUpId'),
      position: pickUpLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: 'Lokasi Pengambilan Barang',
        snippet: initialPos.placeName,
      ),
    );

    Marker dropOffMarker = Marker(
      markerId: const MarkerId('dropOffId'),
      position: dropOffLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: 'Lokasi Tujuan Barang',
        snippet: finalPos.placeName,
      ),
    );

    deliverCubit.addMarker(pickUpMarker);
    deliverCubit.addMarker(dropOffMarker);

    // * CREATE CIRCLE
    Circle pickUpCircle = Circle(
      circleId: const CircleId('pickUpId'),
      fillColor: AppColor.primary,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: AppColor.primary,
    );

    Circle dropOffCircle = Circle(
      circleId: const CircleId('dropOffId'),
      fillColor: AppColor.primary,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: AppColor.primary,
    );

    deliverCubit.addCircle(pickUpCircle);
    deliverCubit.addCircle(dropOffCircle);
  }

  void initGeoFireListener() {
    Geofire.initialize('availableDrivers');

    Geofire.queryAtLocation(
            currentLocation!.latitude, currentLocation!.longitude, 30)
        ?.listen((map) {
      // print('map: $map');
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyAvailableDrivers nearbyAvailableDrivers =
                NearbyAvailableDrivers(
              key: map['key'],
              latitude: map['latitude'],
              longitude: map['longitude'],
            );

            context
                .read<NearbyBloc>()
                .add(NearbyEventAdd(driver: nearbyAvailableDrivers));

            if (nearbyAvailableDriverKeysLoaded.state == true) {
              updateAvailableDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            context.read<NearbyBloc>().add(NearbyEventRemove(key: map['key']));
            updateAvailableDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyAvailableDrivers nearbyAvailableDrivers =
                NearbyAvailableDrivers(
              key: map['key'],
              latitude: map['latitude'],
              longitude: map['longitude'],
            );

            context
                .read<NearbyBloc>()
                .add(NearbyEventUpdate(driver: nearbyAvailableDrivers));
            updateAvailableDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriversOnMap();
            break;
        }
      }

      setState(() {});
    });
  }

  void updateAvailableDriversOnMap() {
    NearbyBloc nearbyBloc = context.read<NearbyBloc>();
    DeliverCubit deliverCubit = context.read<DeliverCubit>();

    deliverCubit.clearMarkerSet();

    Set<Marker> tMarkers = <Marker>{};

    for (NearbyAvailableDrivers driver in nearbyBloc.state.drivers) {
      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);

      Marker marker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverPosition,
        icon: nearbyIcon,
      );

      tMarkers.add(marker);
    }

    deliverCubit.addMarkerSet(tMarkers);
  }

  void createIconMarker() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(2, 2));
    BitmapDescriptor.fromAssetImage(imageConfiguration, AppAsset.iconPickup)
        .then((value) {
      nearbyIcon = value;
    });
  }
}
