import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';

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

  // * CURRENT LOCATION
  Position? currentLocation;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

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
        CameraPosition(target: latlngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-7.319563, 108.202972),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
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
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              compassEnabled: true,
              onMapCreated: (controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {
                  bottomPaddingOfMap = 120;
                });

                // * GET CURRENT LOCATION
                locatePosition();
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              debugPrint('Cari lokasi tujuan');
                            },
                            child: Container(
                              // width: double.infinity,
                              height: 32,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                children: const [
                                  ImageIcon(AssetImage(AppAsset.iconLocation)),
                                  SizedBox(width: 12),
                                  Text(
                                    'Cari lokasi tujuan',
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 22),
                        GestureDetector(
                          onTap: () {
                            locatePosition();
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child:
                                const ImageIcon(AssetImage(AppAsset.iconGps)),
                          ),
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
}
