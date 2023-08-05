import 'package:bloc/bloc.dart';

import '/model/map_address.dart';

part 'deliver_state.dart';

class DeliverCubit extends Cubit<DeliverState> {
  DeliverCubit()
      : super(DeliverState(pickUpAddress: null, dropOffAddress: null));

  void setPickUpAddress(MapAddress address) {
    emit(state.copyWith(pickUpAddress: address));
  }

  void setDropOffAddress(MapAddress address) {
    emit(state.copyWith(dropOffAddress: address));
  }
}
