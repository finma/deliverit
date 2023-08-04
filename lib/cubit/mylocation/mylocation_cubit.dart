import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';

part 'mylocation_state.dart';

class MylocationCubit extends Cubit<MylocationState> {
  MylocationCubit() : super(MylocationInitial());

  void addLocation(Position position) {
    emit(MylocationLoaded(position));
  }

  void removeLocation() {
    emit(MylocationInitial());
  }

  void updateLocation(Position position) {
    emit(MylocationLoaded(position));
  }

  void notPermission(String message) {
    emit(MylocationNotPermission(message));
  }
}
