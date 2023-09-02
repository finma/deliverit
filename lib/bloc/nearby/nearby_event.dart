part of 'nearby_bloc.dart';

abstract class NearbyEvent {}

class NearbyEventAdd extends NearbyEvent {
  NearbyEventAdd({required this.driver});

  final NearbyAvailableDrivers driver;
}

class NearbyEventRemove extends NearbyEvent {
  NearbyEventRemove({required this.key});

  final String key;
}

class NearbyEventUpdate extends NearbyEvent {
  NearbyEventUpdate({required this.driver});

  final NearbyAvailableDrivers driver;
}
