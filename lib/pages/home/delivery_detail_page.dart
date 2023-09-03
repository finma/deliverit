import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/bloc/auth/auth_bloc.dart';
import '/bloc/ride/ride_bloc.dart';
import '/config/app_color.dart';
import '/config/app_symbol.dart';
import '/config/app_format.dart';
import '/cubit/deliver/deliver_cubit.dart';
import '/cubit/select_cubit.dart';
import '/model/payload.dart';
import '/model/vehicle.dart';
import '/routes/router.dart';
import '/widgets/custom_button_widget.dart';

class DeliveryDetailPage extends StatelessWidget {
  DeliveryDetailPage({super.key});

  final SelectCubit<int> selectPayment = SelectCubit(1);
  final int wallet = 0;
  final int cash = 1;

  // data dummy wallet
  final double myWallet = 50000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Detail Pengiriman',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
          color: Colors.black,
        ),
      ),
      bottomSheet: _buildBottomSheetButton(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // * CARD PICK UP ADDRESS
            BlocBuilder<DeliverCubit, DeliverState>(
              builder: (context, state) {
                return _buildCardAddress(
                  title: 'Alamat pengambilan',
                  placeName: state.pickUpAddress!.placeName!,
                  address: state.pickUpAddress!.placeFormattedAddress!,
                  phoneNumber: state.sender!.phoneNumber,
                  userName: state.sender!.name,
                  note: state.sender!.note,
                );
              },
            ),
            const SizedBox(height: 24),

            // * CARD DROP OFF ADDRESS
            BlocBuilder<DeliverCubit, DeliverState>(
              builder: (context, state) {
                return _buildCardAddress(
                  title: 'Alamat pengiriman',
                  placeName: state.dropOffAddress!.placeName!,
                  address: state.dropOffAddress!.placeFormattedAddress!,
                  phoneNumber: state.receiver!.phoneNumber,
                  userName: state.receiver!.name,
                  note: state.receiver!.note,
                );
              },
            ),
            const SizedBox(height: 24),

            // * CARD PAYLOADS
            BlocBuilder<DeliverCubit, DeliverState>(
              builder: (context, state) {
                return _buildCardListPayload(payloads: state.payloads);
              },
            ),
            const SizedBox(height: 24),

            // * CARD VEHICLE
            BlocBuilder<DeliverCubit, DeliverState>(
              builder: (context, state) {
                return _buildCardVehicle(
                  vehicle: state.vehicle!,
                  carrier: state.carrier,
                );
              },
            ),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }

  Container _buildBottomSheetButton(BuildContext context) {
    DeliverCubit deliverCubit = context.read<DeliverCubit>();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: IntrinsicHeight(
        child: Column(
          children: [
            BlocBuilder<SelectCubit<int>, int>(
              bloc: selectPayment,
              builder: (context, state) {
                return Row(
                  children: [
                    Icon(
                      state == cash
                          ? CupertinoIcons.money_dollar_circle
                          : Icons.wallet_rounded,
                      color: AppColor.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state == cash ? 'Tunai' : 'Wallet',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.more_vert_rounded),
                      color: Colors.black,
                      visualDensity: VisualDensity.comfortable,
                      onPressed: () => _buildBottomSheetPayment(context),
                    )
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            ButtonCustom(
              onTap: () {
                final String paymentMethod =
                    selectPayment.state == cash ? 'Cash' : 'Wallet';

                context.read<DeliverCubit>().setIscomplete(true);
                context.read<DeliverCubit>().setIsSearching(true);
                context.read<DeliverCubit>().addPaymentMethod(paymentMethod);

                context.read<RideBloc>().add(RideEventRequest(
                      pickUp: deliverCubit.state.pickUpAddress!,
                      dropOff: deliverCubit.state.dropOffAddress!,
                      paymentMethod: paymentMethod,
                      sender: deliverCubit.state.sender!,
                      receiver: deliverCubit.state.receiver!,
                    ));

                context.goNamed(Routes.deliver);
                // debugPrint('vehicle: ${state.toJson()}');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<DeliverCubit, DeliverState>(
                        builder: (context, state) {
                          return Text(
                            AppFormat.currency(state.totalPayment),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Perkiraan biaya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Row(
                    children: [
                      Text(
                        'Pesan Sekarang',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 24,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _buildBottomSheetPayment(BuildContext context) => showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pilih Metode Pembayaran',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close_rounded),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Metode Pembayaran',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => selectPayment.setSelectedValue(wallet),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.wallet_rounded,
                              color: AppColor.primary,
                            ),
                            const SizedBox(width: 18),
                            BlocBuilder<SelectCubit<int>, int>(
                              bloc: selectPayment,
                              builder: (context, state) {
                                DeliverCubit deliverCubit =
                                    context.read<DeliverCubit>();
                                double totalPayment = 0;
                                double distance = AppFormat.countDistance(
                                    deliverCubit
                                        .state.directionDetails!.distanceValue!
                                        .toDouble());

                                if (deliverCubit.state.vehicle != null) {
                                  totalPayment = AppFormat.countTotalPayment(
                                    vehiclePrice:
                                        deliverCubit.state.vehicle!.price,
                                    distance: distance,
                                    carrier: deliverCubit.state.carrier,
                                  );
                                }

                                return Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 3),
                                      const Text(
                                        'Wallet',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (myWallet < totalPayment)
                                        Text(
                                          'Saldo kurang ${AppFormat.currency(totalPayment - myWallet)}',
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            // const Spacer(),
                            BlocBuilder<SelectCubit<int>, int>(
                              bloc: selectPayment,
                              builder: (context, state) {
                                return Icon(
                                  Icons.radio_button_on,
                                  color: state == wallet
                                      ? AppColor.primary
                                      : Colors.grey,
                                  size: 28,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(thickness: 2),
                    const SizedBox(height: 10),
                    const Text(
                      'Metode Pembayaran Lainnya',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => selectPayment.setSelectedValue(cash),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              CupertinoIcons.money_dollar_circle,
                              color: AppColor.primary,
                            ),
                            const SizedBox(width: 18),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 3),
                                  Text(
                                    'Tunai',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Siapin uang pas ya, biar ga usah repot nungguin kembalian.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BlocBuilder<SelectCubit<int>, int>(
                              bloc: selectPayment,
                              builder: (context, state) {
                                return Icon(
                                  Icons.radio_button_on,
                                  color: state == cash
                                      ? AppColor.primary
                                      : Colors.grey,
                                  size: 28,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                ButtonCustom(
                  label: 'Lanjutkan Pemesanan',
                  onTap: () => context.pop(),
                )
              ],
            ),
          );
        },
      );

  Container _buildCardVehicle(
      {required Vehicle vehicle, required int carrier}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
        //create box shadow
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Column(
                children: [
                  Icon(
                    Icons.directions_car_outlined,
                    color: AppColor.primary,
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 3),
                  const Text('Mobil yang dipilih'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            vehicle.image,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$carrier pengangkut tambahan',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _buildCardListPayload({
    required List<Payload> payloads,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
        //create box shadow
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Column(
                children: [
                  Icon(
                    CupertinoIcons.cube_box,
                    color: AppColor.primary,
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    const Text('Barang yang akan dikirim'),
                    const SizedBox(height: 8),
                    ...payloads
                        .map((payload) => _buildItemPayload(payload))
                        .toList()
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Column _buildItemPayload(Payload payload) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payload.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    Payload.sizeToString(payload.size),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text('${AppSymbol.multiplication} ${payload.qty}'),
          ],
        ),
        const Divider(thickness: 1, height: 24)
      ],
    );
  }

  Container _buildCardAddress({
    required String title,
    required String userName,
    required String placeName,
    required String address,
    required String phoneNumber,
    String? note,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
        //create box shadow
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Column(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColor.primary,
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      placeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      address,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Divider(thickness: 1, height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.person_outline_rounded, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Text(
                      '$phoneNumber ($userName)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.outlined_flag_rounded, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Text(
                      note != null && note != '' ? note : 'Tidak ada catatan',
                      // note  ?? 'Tidak ada catatan',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
