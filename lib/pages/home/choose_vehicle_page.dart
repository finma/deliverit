import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/config/app_color.dart';
import '/config/app_format.dart';
import '/cubit/select_cubit.dart';
import '/data/vehicle.dart';
import '/model/vehicle.dart';

class ChooseVehiclePage extends StatelessWidget {
  ChooseVehiclePage({super.key});

  final List<Vehicle> vehicles = DataVehicle.all;
  final SelectCubit<int> selectVehicle = SelectCubit(0);

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildListVehicles(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildListVehicles(BuildContext context) {
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
              onTap: () => selectVehicle.setSelectedValue(vehicle.id),
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
                            color: value == vehicle.id
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
                      if (value == vehicle.id)
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
