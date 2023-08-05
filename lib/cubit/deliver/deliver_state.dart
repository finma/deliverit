part of 'deliver_cubit.dart';

class DeliverState {
  final MapAddress? pickUpAddress;
  final MapAddress? dropOffAddress;
  final bool? isObtainDirection;

  DeliverState({this.pickUpAddress, this.dropOffAddress})
      : isObtainDirection = (pickUpAddress != null && dropOffAddress != null);

  DeliverState copyWith({
    MapAddress? pickUpAddress,
    MapAddress? dropOffAddress,
  }) {
    return DeliverState(
      pickUpAddress: pickUpAddress ?? this.pickUpAddress,
      dropOffAddress: dropOffAddress ?? this.dropOffAddress,
    );
  }
}
