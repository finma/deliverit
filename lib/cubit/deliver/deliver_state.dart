part of 'deliver_cubit.dart';

class DeliverState {
  final MapAddress? pickUpAddress;
  final MapAddress? dropOffAddress;
  final DirectionDetails? directionDetails;
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
  final String? paymentMethod;
  final bool isComplete;
  final bool isSearching;

  DeliverState({
    this.pickUpAddress,
    this.dropOffAddress,
    this.directionDetails,
    this.currentPosition,
    this.sender,
    this.receiver,
    this.vehicle,
    this.carrier = 0,
    this.totalPayment = 0,
    this.paymentMethod,
    this.isComplete = false,
    this.isSearching = false,
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
    DirectionDetails? directionDetails,
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
    String? paymentMethod,
    bool? isComplete,
    bool? isSearching,
  }) {
    return DeliverState(
      pickUpAddress: pickUpAddress ?? this.pickUpAddress,
      dropOffAddress: dropOffAddress ?? this.dropOffAddress,
      directionDetails: directionDetails ?? this.directionDetails,
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
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isComplete: isComplete ?? this.isComplete,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  // create to json state
  Map<String, dynamic> toJson() {
    return {
      'pickUpAddress': pickUpAddress?.toJson(),
      'dropOffAddress': dropOffAddress?.toJson(),
      'directionDetails': directionDetails?.toJson(),
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
      'paymentMethod': paymentMethod,
      'isComplete': isComplete,
      'isSearching': isSearching,
    };
  }
}
