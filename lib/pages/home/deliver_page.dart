import 'dart:async';

import 'package:deliverit/cubit/select_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/cubit/deliver/deliver_cubit.dart';
import '/cubit/mylocation/mylocation_cubit.dart';
import '/model/map_address.dart';
import '/routes/router.dart';
import '/services/googlemap.dart';
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
  var geoLocator = Geolocator();
  CameraPosition? myLocation;
  SelectCubit<bool> isDirectionObtained = SelectCubit(false);

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(-7.319563, 108.202972),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    MylocationCubit mylocationCubit = context.read<MylocationCubit>();
    DeliverCubit deliverCubit = context.read<DeliverCubit>();

    // * SET INITIAL CAMERA POSITION
    if (mylocationCubit.state.position != null) {
      // debugPrint('my location: ${mylocationCubit.state.position}');
      myLocation = CameraPosition(
        target: LatLng(
          mylocationCubit.state.position!.latitude,
          mylocationCubit.state.position!.longitude,
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

      // * ADD CURRENT LOCATION TO CUBIT
      mylocationCubit.addLocation(position);

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
        deliverCubit.setPickUpAddress(address);
      }
    }

    debugPrint('BUILD PAGE');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        onPressed: () {
          context.pop();
        },
        child: const Icon(
          Icons.arrow_back_rounded,
          color: AppColor.primary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: SafeArea(
        child: Stack(
          children: [
            // * GOOGLE MAP
            BlocBuilder<DeliverCubit, DeliverState>(
              builder: (context, state) {
                debugPrint('GOOGLE MAP');
                if (!isDirectionObtained.state &&
                    state.isObtainDirection == true) {
                  debugPrint('obtain direction');
                  getPlaceDirection();
                  isDirectionObtained.setSelectedValue(true);
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
                  polylines: polylineSet,
                  markers: markerSet,
                  circles: circleSet,
                  onMapCreated: (controller) {
                    _controllerGoogleMap.complete(controller);
                    newGoogleMapController = controller;

                    // * GET CURRENT LOCATION
                    locatePosition();
                  },
                );
              },
            ),

            // * SEARCH BAR
            Positioned(
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
                            if (deliverCubit.state.pickUpAddress != null) {
                              pickUpController.text =
                                  deliverCubit.state.pickUpAddress!.placeName!;
                            }

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
                            if (state.dropOffAddress != null) {
                              dropOffController.text =
                                  state.dropOffAddress!.placeName!;
                            }

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
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos = context.read<DeliverCubit>().state.pickUpAddress;
    var finalPos = context.read<DeliverCubit>().state.dropOffAddress;

    var pickUpLatLng = LatLng(initialPos!.latitude!, initialPos.longitude!);
    var dropOffLatLng = LatLng(finalPos!.latitude!, finalPos.longitude!);

    var details = await GoogleMapService.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    debugPrint('encoded points: ${details.encodedPoints}');

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints!);

    pLineCoordinates.clear();

    if (decodedPolylinePointsResult.isNotEmpty) {
      for (var pointLatLng in decodedPolylinePointsResult) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: const PolylineId('polylineId'),
        color: AppColor.primary,
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

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

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

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

    setState(() {
      markerSet.add(pickUpMarker);
      markerSet.add(dropOffMarker);
    });

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

    setState(() {
      circleSet.add(pickUpCircle);
      circleSet.add(dropOffCircle);
    });
  }
}
