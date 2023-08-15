part of 'deliver_cubit.dart';

class DeliverState {
  final MapAddress? pickUpAddress;
  final MapAddress? dropOffAddress;
  final double distance;
  final bool? isObtainDirection;
  final bool isLocationUpdated;
  final List<LatLng> pLineCoordinates;
  final Set<Polyline> polylineSet;
  final Set<Marker> markerSet;
  final Set<Circle> circleSet;
  final Position? currentPosition;
  final UserDelivery? sender;
  final UserDelivery? receiver;
  final List<Payload> payloads;
  final Vehicle? vehicle;
  final int carrier;
  final double totalPayment;

  DeliverState({
    this.pickUpAddress,
    this.dropOffAddress,
    this.currentPosition,
    this.distance = 0,
    this.sender,
    this.receiver,
    this.vehicle,
    this.carrier = 0,
    this.totalPayment = 0,
    bool? isLocationUpdated,
    List<LatLng>? pLineCoordinates,
    Set<Polyline>? polylineSet,
    Set<Marker>? markerSet,
    Set<Circle>? circleSet,
    List<Payload>? payloads,
  })  : pLineCoordinates = pLineCoordinates ?? [],
        polylineSet = polylineSet ?? {},
        markerSet = markerSet ?? {},
        circleSet = circleSet ?? {},
        payloads = payloads ?? [],
        isLocationUpdated = isLocationUpdated ?? false,
        isObtainDirection = (pickUpAddress != null && dropOffAddress != null);

  DeliverState copyWith({
    MapAddress? pickUpAddress,
    MapAddress? dropOffAddress,
    double? distance,
    bool? isLocationUpdated,
    List<LatLng>? pLineCoordinates,
    Set<Polyline>? polylineSet,
    Set<Marker>? markerSet,
    Set<Circle>? circleSet,
    Position? currentPosition,
    UserDelivery? sender,
    UserDelivery? receiver,
    List<Payload>? payloads,
    Vehicle? vehicle,
    int? carrier,
    double? totalPayment,
  }) {
    return DeliverState(
      pickUpAddress: pickUpAddress ?? this.pickUpAddress,
      dropOffAddress: dropOffAddress ?? this.dropOffAddress,
      distance: distance ?? this.distance,
      isLocationUpdated: isLocationUpdated ?? this.isLocationUpdated,
      pLineCoordinates: pLineCoordinates ?? this.pLineCoordinates,
      polylineSet: polylineSet ?? this.polylineSet,
      markerSet: markerSet ?? this.markerSet,
      circleSet: circleSet ?? this.circleSet,
      currentPosition: currentPosition ?? this.currentPosition,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      payloads: payloads ?? this.payloads,
      vehicle: vehicle ?? this.vehicle,
      carrier: carrier ?? this.carrier,
      totalPayment: totalPayment ?? this.totalPayment,
    );
  }

  // create to json state
  Map<String, dynamic> toJson() {
    return {
      'pickUpAddress': pickUpAddress?.toJson(),
      'dropOffAddress': dropOffAddress?.toJson(),
      'distance': distance,
      // 'currentPosition': currentPosition?.toJson(),
      // 'isLocationUpdated': isLocationUpdated,
      // 'pLineCoordinates': pLineCoordinates.map((e) => e.toJson()).toList(),
      // 'polylineSet': polylineSet.map((e) => e.toJson()).toList(),
      // 'markerSet': markerSet.map((e) => e.toJson()).toList(),
      // 'circleSet': circleSet.map((e) => e.toJson()).toList(),
      'sender': sender?.toJson(),
      'receiver': receiver?.toJson(),
      'payloads': payloads.map((e) => e.toJson()).toList(),
      'vehicle': vehicle?.toJson(),
      'carrier': carrier,
      'totalPayment': totalPayment,
    };
  }
}
