import 'package:bloc/bloc.dart';

import '/model/nearby_available_drivers.dart';

part 'nearby_event.dart';
part 'nearby_state.dart';

class NearbyBloc extends Bloc<NearbyEvent, NearbyState> {
  NearbyBloc() : super(NearbyState(drivers: [])) {
    on<NearbyEventAdd>(_addNearbyAvailableDriver);

    on<NearbyEventRemove>(_removeNearbyAvailableDriver);

    on<NearbyEventUpdate>(_updateNearbyAvailableDriver);
  }

  void _addNearbyAvailableDriver(
      NearbyEventAdd event, Emitter<NearbyState> emit) {
    state.drivers.add(event.driver);
  }

  void _removeNearbyAvailableDriver(
      NearbyEventRemove event, Emitter<NearbyState> emit) {
    state.drivers.removeWhere((element) => element.key == event.key);
  }

  void _updateNearbyAvailableDriver(
      NearbyEventUpdate event, Emitter<NearbyState> emit) {
    final int index =
        state.drivers.indexWhere((element) => element.key == event.driver.key);

    state.drivers[index].latitude = event.driver.latitude;
    state.drivers[index].longitude = event.driver.longitude;
  }
}
