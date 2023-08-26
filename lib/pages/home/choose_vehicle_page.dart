import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/config/app_color.dart';
import '/config/app_format.dart';
import '/config/app_symbol.dart';
import '/cubit/deliver/deliver_cubit.dart';
import '/cubit/select_cubit.dart';
import '/data/vehicle.dart';
import '/model/vehicle.dart';
import '/routes/router.dart';
import '/widgets/custom_button_widget.dart';

class ChooseVehiclePage extends StatelessWidget {
  ChooseVehiclePage({super.key});

  final List<Vehicle> vehicles = DataVehicle.all;
  final SelectCubit<int> selectVehicle = SelectCubit(0);

  @override
  Widget build(BuildContext context) {
    DeliverCubit deliverCubit = context.read<DeliverCubit>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Pilih Kendaraan',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildListVehicles(context, deliverCubit),
                const SizedBox(height: 32),
                _buildAddCarrier(deliverCubit)
              ],
            ),
          ),
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
          double totalPayment = 0;
          String duration = state.directionDetails!.durationText!;
          double distance = AppFormat.countDistance(
              state.directionDetails!.distanceValue!.toDouble());

          if (state.vehicle != null) {
            totalPayment = AppFormat.countTotalPayment(
              vehiclePrice: state.vehicle!.price,
              distance: distance,
              carrier: state.carrier,
            );
          }

          return IntrinsicHeight(
            child: Column(
              children: [
                Text(
                  'Total jarak $distance km ${AppSymbol.dot} $duration',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ButtonCustom(
                  isDisabled: state.vehicle == null,
                  onTap: () {
                    context.read<DeliverCubit>().addTotalPayment(totalPayment);
                    context.goNamed(Routes.deliveryDetail);
                    // debugPrint('vehicle: ${state.totalPayment}');
                  },
                  child: state.vehicle == null
                      ? const Text(
                          'Pilih Kendaraan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppFormat.currency(totalPayment),
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
                                  'Lanjut',
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

  Column _buildAddCarrier(DeliverCubit deliverCubit) {
    return Column(
      children: [
        const Row(
          children: [
            Text(
              'Tambah Pengangkut',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 24),
            Icon(
              CupertinoIcons.exclamationmark_circle,
              size: 18,
            )
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Pengangkut bisa bantuin kamu mindahin barang. Rp.50.000/pengangkut.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => deliverCubit.removeCarrier(),
                    icon: const Icon(
                      Icons.remove_circle_outline_rounded,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  BlocBuilder<DeliverCubit, DeliverState>(
                    builder: (context, state) {
                      return Text(
                        state.carrier.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: () => deliverCubit.addCarrier(),
                    icon: const Icon(
                      Icons.add_circle_outline_rounded,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  SizedBox _buildListVehicles(BuildContext context, DeliverCubit deliverCubit) {
    return SizedBox(
      // padding: const EdgeInsets.all(16),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: vehicles.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];

          // * LIST ITEM
          return Material(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: () {
                selectVehicle.setSelectedValue(vehicle.id);
                deliverCubit.addVehicle(vehicle);
              },
              borderRadius: BorderRadius.circular(24),
              child: BlocBuilder<SelectCubit<int>, int>(
                bloc: selectVehicle,
                builder: (context, value) {
                  return Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: value == vehicle.id ||
                                    deliverCubit.state.vehicle == vehicle
                                ? AppColor.primary
                                : Colors.transparent,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 150,
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
                                  'Berat maks: ${vehicle.maxWeight} Kg',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  'Biaya /km: ${AppFormat.currency(vehicle.price.toDouble())}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // * CHIP
                      if (value == vehicle.id ||
                          deliverCubit.state.vehicle == vehicle)
                        const Positioned(
                          top: 2,
                          right: 8,
                          child: Chip(
                            backgroundColor: AppColor.primary,
                            elevation: 0,
                            visualDensity: VisualDensity.compact,
                            label: Text(
                              'dipilih',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
