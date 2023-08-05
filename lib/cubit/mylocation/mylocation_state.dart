// part of 'mylocation_cubit.dart';

// abstract class MylocationState {}

// class MylocationInitial extends MylocationState {}

// class MylocationNotPermission extends MylocationState {
//   MylocationNotPermission(this.message);

//   final String message;
// }

// class MylocationLoaded extends MylocationState {
//   MylocationLoaded(this.position);

//   final Position position;
// }

part of 'mylocation_cubit.dart';

class MylocationState {
  final Position? position;

  MylocationState({this.position});

  MylocationState copyWith({
    Position? position,
  }) {
    return MylocationState(
      position: position ?? this.position,
    );
  }
}
