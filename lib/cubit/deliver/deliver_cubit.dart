import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/model/map_address.dart';

part 'deliver_state.dart';

class DeliverCubit extends Cubit<DeliverState> {
  DeliverCubit()
      : super(DeliverState(
          pickUpAddress: null,
          dropOffAddress: null,
          pLineCoordinates: [],
          polylineSet: {},
          markerSet: {},
          circleSet: {},
        ));

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

  void clearPickUpAddress() {
    emit(state.copyWith(pickUpAddress: null));
  }

  void clearDropOffAddress() {
    emit(state.copyWith(dropOffAddress: null));
  }

  void clearPLinesCoordinates() {
    emit(state.copyWith(pLineCoordinates: []));
  }

  void clearPolylineSet() {
    emit(state.copyWith(polylineSet: {}));
  }

  void clearMarkerSet() {
    emit(state.copyWith(markerSet: {}));
  }

  void clearCircleSet() {
    emit(state.copyWith(circleSet: {}));
  }
}
