part of 'ride_bloc.dart';

abstract class RideState {}

class RideStateInitial extends RideState {}

class RideStateLoading extends RideState {}

class RideStateRequest extends RideState {}

class RideStateCancel extends RideState {}

class RideStateSuccess extends RideState {}

class RideStateError extends RideState {
  RideStateError(this.message);

  final String message;
}
