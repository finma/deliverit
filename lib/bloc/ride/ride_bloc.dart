import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import '/config/firebase.dart';
import '/model/map_address.dart';
import '/model/nearby_available_drivers.dart';
import '/model/payload.dart';
import '/model/user_delivery.dart';
import '/model/vehicle.dart';

part 'ride_event.dart';
part 'ride_state.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  RideBloc() : super(RideStateInitial()) {
    on<RideEventRequest>(_rideEventRequest);

    on<RideEventCancel>(_rideEventCancel);

    on<RideEventError>(_rideEventError);

    on<RideEventSuccess>(_rideEventSuccess);
  }

  late DatabaseReference rideRequestRef;
  late String status;

  Future<void> _rideEventRequest(
      RideEventRequest event, Emitter<RideState> emit) async {
    // print('event.driver: ${event.driver}');
    emit(RideStateRequest());

    //* if the driver is null, then we will emit error
    if (event.driver == null) {
      await Future.delayed(const Duration(seconds: 30));
      emit(RideStateError('Driver tidak ditemukan! Coba beberapa saat lagi.'));
      return;
    }

    status = 'requesting';
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
      'vehicle': event.vehicle.toJson(),
      'carrier': event.carrier,
    };

    await rideRequestRef.set(rideInfo);

    await driverRef
        .child(event.driver!.key)
        .child('newRide')
        .set(rideRequestRef.key);

    DatabaseEvent res =
        await driverRef.child(event.driver!.key).child('token').once();

    if (res.snapshot.value != null) {
      String token = res.snapshot.value.toString();

      // print('debug: send notification to driver');

      //* send notification to driver
      sendNotificationToDriver(token, rideRequestRef.key!);
    } else {
      emit(RideStateError('Driver tidak ditemukan! Coba beberapa saat lagi.'));
    }

    //* listen to the driver response
    const oneSecondPassed = Duration(seconds: 1);
    Timer.periodic(oneSecondPassed, (timer) async {
      //* if the driver is not responding, then we will cancel the request
      if (status != 'requesting') {
        await driverRef
            .child(event.driver!.key)
            .child('newRide')
            .set('cancelled');
        driverRef.child(event.driver!.key).child('newRide').onDisconnect();
        driverRequestTimeout = 30;
        timer.cancel();
      }

      driverRequestTimeout = driverRequestTimeout - 1;

      //* if the driver accept the request, then we will emit success
      driverRef
          .child(event.driver!.key)
          .child('newRide')
          .onValue
          .listen((dbEvent) {
        if (dbEvent.snapshot.value.toString() == 'accepted') {
          driverRef.child(event.driver!.key).child('newRide').onDisconnect();
          driverRequestTimeout = 30;
          timer.cancel();

          add(RideEventSuccess());
        }
      });

      //* if the driver not accept and timeout, then we will emit error
      if (driverRequestTimeout == 0) {
        await driverRef
            .child(event.driver!.key)
            .child('newRide')
            .set('timeout');
        driverRef.child(event.driver!.key).child('newRide').onDisconnect();
        driverRequestTimeout = 30;
        timer.cancel();

        add(RideEventError('Driver tidak merespon! Coba beberapa saat lagi.'));
      }
    });
  }

  void _rideEventCancel(RideEventCancel event, Emitter<RideState> emit) {
    rideRequestRef.remove();
    status = 'normal';
  }

  void _rideEventError(RideEventError event, Emitter<RideState> emit) {
    emit(RideStateError(event.message));
  }

  void _rideEventSuccess(RideEventSuccess event, Emitter<RideState> emit) {
    emit(RideStateSuccess());
  }

  void sendNotificationToDriver(String token, String rideRequestId) {
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };

    Map notificationMap = {
      'title': 'Pesanan Baru!',
      'body': 'Hallo, ada pesanan masuk buat kamu nih!',
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_request_id': rideRequestId,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };

    http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headerMap,
      body: jsonEncode(bodyMap),
    );

    // print('debug: send notification to driver success ${jsonEncode(bodyMap)}');
  }
}
