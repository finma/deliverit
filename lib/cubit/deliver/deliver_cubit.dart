import 'package:bloc/bloc.dart';
import 'package:deliverit/model/user_delivery.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/model/map_address.dart';

part 'deliver_state.dart';

class DeliverCubit extends Cubit<DeliverState> {
  DeliverCubit()
      : super(DeliverState(
          currentPosition: null,
          pickUpAddress: null,
          dropOffAddress: null,
          pLineCoordinates: [],
          polylineSet: {},
          markerSet: {},
          circleSet: {},
        ));

  // create void add current location
  void addCurrentPosition(Position position) {
    emit(state.copyWith(currentPosition: position));
  }

  void setPickUpAddress(MapAddress address) {
    emit(state.copyWith(pickUpAddress: address));
  }

  void setDropOffAddress(MapAddress address) {
    emit(state.copyWith(dropOffAddress: address));
  }

  void setIsLocationUpdated(bool value) {
    emit(state.copyWith(isLocationUpdated: value));
  }

  // create void to add new pline coordinates to array pline coordinates
  void addPLineCoordinates(LatLng coordinate) {
    final List<LatLng> newPlineCoordinates = [...state.pLineCoordinates];
    newPlineCoordinates.add(coordinate);
    emit(state.copyWith(pLineCoordinates: newPlineCoordinates));
  }

  // create void to add new poliline to set poliline
  void addPolyline(Polyline polyline) {
    final Set<Polyline> newPolylineSet = {...state.polylineSet};
    newPolylineSet.add(polyline);
    emit(state.copyWith(polylineSet: newPolylineSet));
  }

  // create void to add new marker to set marker
  void addMarker(Marker marker) {
    final Set<Marker> newMarkerSet = {...state.markerSet};
    newMarkerSet.add(marker);
    emit(state.copyWith(markerSet: newMarkerSet));
  }

  // create void to add new circle to set circle
  void addCircle(Circle circle) {
    final Set<Circle> newCircleSet = {...state.circleSet};
    newCircleSet.add(circle);
    emit(state.copyWith(circleSet: newCircleSet));
  }

  // create void to add sender
  void addSender(UserDelivery sender) {
    emit(state.copyWith(sender: sender));
  }

  // create void to add receiver
  void addReceiver(UserDelivery receiver) {
    emit(state.copyWith(receiver: receiver));
  }

  // create void to clear current position
  void clearCurrentPosition() {
    emit(state.copyWith(currentPosition: null));
  }

  // create void to clear pick up address
  void clearPickUpAddress() {
    emit(state.copyWith(pickUpAddress: null));
  }

  // create void to clear drop off address
  void clearDropOffAddress() {
    emit(state.copyWith(dropOffAddress: null));
  }

  // create void to clear is location updated
  void clearPLinesCoordinates() {
    emit(state.copyWith(pLineCoordinates: []));
  }

  // create void to clear polyline set
  void clearPolylineSet() {
    emit(state.copyWith(polylineSet: {}));
  }

  // create void to clear marker set
  void clearMarkerSet() {
    emit(state.copyWith(markerSet: {}));
  }

  // create void to clear circle set
  void clearCircleSet() {
    emit(state.copyWith(circleSet: {}));
  }

  // create void to clear sender
  void clearSender() {
    emit(state.copyWith(sender: null));
  }

  // create void to clear receiver
  void clearReceiver() {
    emit(state.copyWith(receiver: null));
  }

  // create void to clear all state
  void clearState() {
    emit(DeliverState());
  }
}
