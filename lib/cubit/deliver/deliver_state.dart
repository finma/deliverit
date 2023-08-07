part of 'deliver_cubit.dart';

class DeliverState {
  final MapAddress? pickUpAddress;
  final MapAddress? dropOffAddress;
  final bool? isObtainDirection;
  final bool isLocationUpdated;
  final List<LatLng> pLineCoordinates;
  final Set<Polyline> polylineSet;
  final Set<Marker> markerSet;
  final Set<Circle> circleSet;
  final Position? currentPosition;

  DeliverState({
    this.pickUpAddress,
    this.dropOffAddress,
    this.currentPosition,
    bool? isLocationUpdated,
    List<LatLng>? pLineCoordinates,
    Set<Polyline>? polylineSet,
    Set<Marker>? markerSet,
    Set<Circle>? circleSet,
  })  : pLineCoordinates = pLineCoordinates ?? [],
        polylineSet = polylineSet ?? {},
        markerSet = markerSet ?? {},
        circleSet = circleSet ?? {},
        isLocationUpdated = isLocationUpdated ?? false,
        isObtainDirection = (pickUpAddress != null && dropOffAddress != null);

  DeliverState copyWith({
    MapAddress? pickUpAddress,
    MapAddress? dropOffAddress,
    bool? isLocationUpdated,
    List<LatLng>? pLineCoordinates,
    Set<Polyline>? polylineSet,
    Set<Marker>? markerSet,
    Set<Circle>? circleSet,
    Position? currentPosition,
  }) {
    return DeliverState(
      pickUpAddress: pickUpAddress ?? this.pickUpAddress,
      dropOffAddress: dropOffAddress ?? this.dropOffAddress,
      isLocationUpdated: isLocationUpdated ?? this.isLocationUpdated,
      pLineCoordinates: pLineCoordinates ?? this.pLineCoordinates,
      polylineSet: polylineSet ?? this.polylineSet,
      markerSet: markerSet ?? this.markerSet,
      circleSet: circleSet ?? this.circleSet,
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }

  // create to json state
  Map<String, dynamic> toJson() {
    return {
      'pickUpAddress': pickUpAddress?.toJson(),
      'dropOffAddress': dropOffAddress?.toJson(),
      'currentPosition': currentPosition?.toJson(),
      'isLocationUpdated': isLocationUpdated,
      'pLineCoordinates': pLineCoordinates.map((e) => e.toJson()).toList(),
      'polylineSet': polylineSet.map((e) => e.toJson()).toList(),
      'markerSet': markerSet.map((e) => e.toJson()).toList(),
      'circleSet': circleSet.map((e) => e.toJson()).toList(),
    };
  }
}
