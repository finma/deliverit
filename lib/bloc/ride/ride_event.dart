part of 'ride_bloc.dart';

abstract class RideEvent {}

class RideEventRequest extends RideEvent {
  RideEventRequest({
    required this.pickUp,
    required this.dropOff,
    required this.paymentMethod,
    required this.sender,
    required this.receiver,
  });

  final MapAddress pickUp;
  final MapAddress dropOff;
  final String paymentMethod;
  final UserDelivery sender;
  final UserDelivery receiver;
}

class RideEventCancel extends RideEvent {}
