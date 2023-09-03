part of 'ride_bloc.dart';

abstract class RideEvent {}

class RideEventRequest extends RideEvent {
  RideEventRequest({
    required this.pickUp,
    required this.dropOff,
    required this.user,
    required this.paymentMethod,
    this.pickupNote,
    this.dropoffNote,
  });

  final MapAddress pickUp;
  final MapAddress dropOff;
  final User user;
  final String paymentMethod;
  final String? pickupNote;
  final String? dropoffNote;
}

class RideEventCancel extends RideEvent {}
