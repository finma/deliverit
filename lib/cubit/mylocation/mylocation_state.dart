part of 'mylocation_cubit.dart';

abstract class MylocationState {}

class MylocationInitial extends MylocationState {}

class MylocationNotPermission extends MylocationState {
  MylocationNotPermission(this.message);

  final String message;
}

class MylocationLoaded extends MylocationState {
  MylocationLoaded(this.position);

  final Position position;
}
