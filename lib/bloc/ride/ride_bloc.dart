import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';

import '/model/map_address.dart';
import '/model/payload.dart';
import '/model/user_delivery.dart';
import '/model/vehicle.dart';

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

    Map rideInfo = {
      'createdAt': DateTime.now().toString(),
      'driverId': 'waiting',
      'totalPayment': event.totalPayment,
      'paymentMethod': event.paymentMethod,
      'pickup': event.pickUp.toJson(),
      'dropoff': event.dropOff.toJson(),
      'distance': event.distance,
      'sender': event.sender.toJson(),
      'receiver': event.receiver.toJson(),
      'payloads': event.payloads.map((e) => e.toJson()).toList(),
      'vehicle': event.vehicle,
      'carrier': event.carrier,
    };

    rideRequestRef.set(rideInfo);
  }

  void _rideEventCancel(RideEventCancel event, Emitter<RideState> emit) {
    rideRequestRef.remove();
  }
}
