import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';

import '/model/map_address.dart';
import '/model/user.dart';

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
      'pickUp': pickUpMap,
      'dropOff': dropOffMap,
      'createdAt': DateTime.now().toString(),
      'riderName': event.user.name,
      'riderPhone': event.user.phoneNumber,
      'pickupAddress': event.pickUp.placeName,
      'dropoffAddress': event.dropOff.placeName,
    };

    rideRequestRef.set(rideInfo);
  }

  void _rideEventCancel(RideEventCancel event, Emitter<RideState> emit) {
    rideRequestRef.remove();
  }
}
