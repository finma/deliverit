import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/config/app_color.dart';
import '/config/app_symbol.dart';
import '/config/app_format.dart';
import '/cubit/deliver/deliver_cubit.dart';
import '/data/payload.dart';
import '/data/vehicle.dart';
import '/model/payload.dart';
import '/model/vehicle.dart';
import '/widgets/custom_button_widget.dart';

class DeliveryDetailPage extends StatelessWidget {
  DeliveryDetailPage({super.key});

  // * data dummy
  final List<Payload> dummyPayloads = DataPayload.all;
  final Vehicle dummyVehicle = DataVehicle.all[1];
  final int dummyCarrier = 1;

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
      bottomSheet: _buildBottomSheetButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // * CARD PICK UP ADDRESS
            _buildCardAddress(
              title: 'Alamat pengambilan',
              placeName: 'Cikara Studio',
              address:
                  'Perum Cipta Graha Mandiri Blok C 108, Sukarindik, Kec.Bungursari, Tasikmalaya',
              phoneNumber: '081123456789',
              userName: 'Firman Maulana',
              note: '',
            ),
            const SizedBox(height: 24),

            // * CARD DROP OFF ADDRESS
            _buildCardAddress(
              title: 'Alamat pengiriman',
              placeName: 'Jl.Kona 1',
              address:
                  'Jl.Kona 1 sukabungur , Sukarindik, Kec.Bungursari, Tasikmalaya',
              phoneNumber: '081123456789',
              userName: 'Maulana',
              // note: '',
            ),
            const SizedBox(height: 24),

            // * CARD PAYLOADS
            _buildCardListPayload(payloads: dummyPayloads),
            const SizedBox(height: 24),

            // * CARD VEHICLE
            _buildCardVehicle(vehicle: dummyVehicle, carrier: dummyCarrier),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }

  Container _buildBottomSheetButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: BlocBuilder<DeliverCubit, DeliverState>(
        builder: (context, state) {
          double totalPrice = 0;
          double distance = state.distance;

          if (state.vehicle != null) {
            totalPrice = (state.vehicle!.price.toDouble() * distance) +
                (state.carrier.toDouble() * 50000);
          }

          return IntrinsicHeight(
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.money_dollar_circle,
                      color: AppColor.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Tunai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.more_vert_rounded),
                      color: Colors.black,
                      visualDensity: VisualDensity.comfortable,
                      onPressed: () {
                        debugPrint('more');
                      },
                    )
                  ],
                ),
                const SizedBox(height: 8),
                ButtonCustom(
                  // label: 'Pilih Kendaraan',
                  // isDisabled: state.vehicle == null,
                  onTap: () {
                    // context.goNamed(Routes.deliveryDetail);
                    // debugPrint('vehicle: ${state.toJson()}');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppFormat.currency(totalPrice),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

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
