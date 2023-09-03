import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';

import '/model/map_address.dart';
import '/model/user_delivery.dart';

part 'ride_event.dart';
part 'ride_state.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  RideBloc() : super(RideStateInitial()) {
    on<RideEventRequest>(_rideEventRequest);

    on<RideEventCancel>(_rideEventCancel);
  }

  late DatabaseReference rideRequestRef;

  void _rideEventRequest(RideEventRequest event, Emitter<RideState> emit) {
    rideRequestRef =
        FirebaseDatabase.instance.ref().child('rideRequests').push();

    Map pickUpMap = {
      'latitude': event.pickUp.latitude.toString(),
      'longitude': event.pickUp.longitude.toString(),
    };

    Map dropOffMap = {
      'latitude': event.dropOff.latitude.toString(),
      'longitude': event.dropOff.longitude.toString(),
    };

    Map rideInfo = {
      'driverId': 'waiting',
      'paymentMethod': event.paymentMethod,
      'senderName': event.sender.name,
      'senderPhone': event.sender.phoneNumber,
      'senderNote': event.sender.note,
      'receiverName': event.receiver.name,
      'receiverPhone': event.receiver.phoneNumber,
      'receiverNote': event.receiver.note,
      'pickup': pickUpMap,
      'pickupAddress': event.pickUp.placeName,
      'pickupFullAddress': event.pickUp.placeFormattedAddress,
      'dropoff': dropOffMap,
      'dropoffAddress': event.dropOff.placeName,
      'dropoffFullAddress': event.dropOff.placeFormattedAddress,
      'createdAt': DateTime.now().toString(),
    };

    rideRequestRef.set(rideInfo);
  }

  void _rideEventCancel(RideEventCancel event, Emitter<RideState> emit) {
    rideRequestRef.remove();
  }
}
