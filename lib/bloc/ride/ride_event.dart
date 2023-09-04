part of 'ride_bloc.dart';

abstract class RideEvent {}

class RideEventRequest extends RideEvent {
  RideEventRequest({
    required this.pickUp,
    required this.dropOff,
    required this.paymentMethod,
    required this.sender,
    required this.receiver,
    required this.distance,
    required this.totalPayment,
    required this.payloads,
    required this.vehicle,
    required this.carrier,
  });

  final MapAddress pickUp;
  final MapAddress dropOff;
  final String paymentMethod;
  final UserDelivery sender;
  final UserDelivery receiver;
  final double distance;
  final double totalPayment;
  final List<Payload> payloads;
  final Vehicle vehicle;
  final int carrier;
}

class RideEventCancel extends RideEvent {}
