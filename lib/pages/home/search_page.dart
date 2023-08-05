import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/cubit/deliver/deliver_cubit.dart';
import '/widgets/custom_text_form_field_widget.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final TextEditingController pickUpController = TextEditingController();
  final TextEditingController dropOffController = TextEditingController();

  final List placePrediction = [
    {
      'mainText': 'Perum Indah',
      'secondaryText':
          'Perum Indah Mandiri Blok A 08, Sukarindik, Kec.Bungursari, Tasikmalaya'
    },
    {
      'mainText': 'Cikara Studio',
      'secondaryText':
          'Perum Cipta Graha Mandiri Blok C 108, Sukarindik, Kec.Bungursari, Tasikmalaya'
    },
    {
      'mainText': 'Cikara',
      'secondaryText':
          'Perum Cipta Graha Mandiri Blok C 108, Sukarindik, Kec.Bungursari, Tasikmalaya'
    },
    {
      'mainText': 'Perum Indah',
      'secondaryText':
          'Perum Indah Mandiri Blok A 08, Sukarindik, Kec.Bungursari, Tasikmalaya'
    },
    {
      'mainText': 'Cikara Studio',
      'secondaryText':
          'Perum Cipta Graha Mandiri Blok C 108, Sukarindik, Kec.Bungursari, Tasikmalaya'
    },
    {
      'mainText': 'Cikara',
      'secondaryText':
          'Perum Cipta Graha Mandiri Blok C 108, Sukarindik, Kec.Bungursari, Tasikmalaya'
    },
  ];

  @override
  Widget build(BuildContext context) {
    DeliverCubit deliverCubit = context.read<DeliverCubit>();

    if (deliverCubit.state.pickUpAddress != null) {
      pickUpController.text = deliverCubit.state.pickUpAddress!.placeName!;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
        title: const Text(
          'Mau kirim barang kemana?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // * SEARCH BAR
          Container(
            width: double.infinity,
            // height: 150,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColor.primary,
            ),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: pickUpController,
                  iconAsset: AppAsset.iconLocation,
                  hintText: 'Lokasi Pengambilan Barang',
                  paddingVertical: 8,
                  borderRadius: 100,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: dropOffController,
                  iconAsset: AppAsset.iconLocation,
                  hintText: 'Lokasi Tujuan Barang',
                  paddingVertical: 8,
                  borderRadius: 100,
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              // height: MediaQuery.of(context).size.height - 254,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              // color: Colors.amber,
              child: ListView.builder(
                itemCount: placePrediction.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 16, top: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ImageIcon(
                          AssetImage(AppAsset.iconPoint),
                          color: Colors.black,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                placePrediction[index]['mainText'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                placePrediction[index]['secondaryText'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
