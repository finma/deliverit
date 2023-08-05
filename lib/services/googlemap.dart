import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '/config/map_config.dart';
import '/cubit/deliver/deliver_cubit.dart';
import '/helper/api.dart';
import '/model/map_address.dart';
import '/model/place_prediction.dart';

class GoogleMapService {
  static Future<String> searchCoordinateAddress(
      Position position, BuildContext context) async {
    String placeAddress = '';
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      MapAddress userPickupAddress = MapAddress();
      userPickupAddress.longitude = position.longitude.toString();
      userPickupAddress.latitude = position.latitude.toString();
      userPickupAddress.placeName = placeAddress;

      // debugPrint('address: $placeAddress');

      if (context.mounted) {
        context.read<DeliverCubit>().setPickUpAddress(userPickupAddress);
      }
    }

    return placeAddress;
  }

  static Future<List<PlacePrediction>> findPlace(String placeName) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:id&language=id';

    if (placeName.length > 1) {
      var response = await RequestHelper.getRequest(url);

      if (response != 'failed') {
        if (response['status'] == 'OK') {
          var predictions = response['predictions'];

          List<PlacePrediction> placeList = (predictions as List)
              .map((e) => PlacePrediction.fromJson(e))
              .toList();

          // debugPrint('prediction: ${placeList[0].mainText}');

          return placeList;
        }
      }
    }

    return [];
  }
}
