import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/cubit/deliver/deliver_cubit.dart';
import '/cubit/select_cubit.dart';
import '/data/payload.dart';
import '/model/payload.dart';
import '/routes/router.dart';
import '/widgets/custom_button_widget.dart';
import '/widgets/custom_outline_button_widget.dart';

class PayloadDetailPage extends StatelessWidget {
  PayloadDetailPage({Key? key}) : super(key: key);

  final List<Payload> defaultPayloads = DataPayload.all;

  final TextEditingController payloadNameController = TextEditingController();
  final SelectCubit<String> selectSize = SelectCubit('');
  final List<String> sizeOptions = ['kecil', 'sedang', 'besar'];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Detail Muatan',
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
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: BlocBuilder<DeliverCubit, DeliverState>(
          builder: (context, state) {
            return ButtonCustom(
              label: 'Lanjut',
              isDisabled: state.payloads.isEmpty,
              onTap: () => context.goNamed(Routes.chooseVehicle),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<DeliverCubit, DeliverState>(
              builder: (context, state) {
                // debugPrint('state ${state.toJson()}');
                // debugPrint('build');

                // * GUIDELINE CARD
                if (state.payloads.isEmpty) {
                  return Stack(
                    children: [
                      _buildGuidelineCard(context),
                      _buildCargoDescriptionCard(context),
                    ],
                  );
                }

                // * LIST PAYLOAD
                return Column(
                  children: [
                    ...state.payloads
                        .map((payload) => _buildItemPayload(
                              payload.id!,
                              payload.name,
                              Payload.sizeToString(payload.size),
                              payload.qty,
                              context,
                            ))
                        .toList(),
                    const SizedBox(height: 40),
                    ButtonOutlineCustom(
                      label: 'Tambah Barang',
                      icon: const Icon(
                        Icons.add_circle_outline_rounded,
                        color: AppColor.primary,
                      ),
                      onTap: () => openDialog(context),
                    )
                  ],
                );
              },
            ),
            // * PAYLOAD CHIPS
            const SizedBox(height: 40),
            _buildPayloadChips(context)
          ],
        ),
      ),
    );
  }

  Container _buildItemPayload(
    String id,
    String name,
    String size,
    int qty,
    BuildContext context,
  ) {
    final DeliverCubit deliverCubit = context.read<DeliverCubit>();
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                size,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => deliverCubit.removePayload(id),
                icon:
                    const Icon(Icons.delete_outline_rounded, color: Colors.red),
                label: const Text(
                  'Hapus',
                  style: TextStyle(color: Colors.red),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => deliverCubit.removeQtyPayload(id),
                icon: const Icon(
                  Icons.remove_circle_outline_rounded,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                qty.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => deliverCubit.addQtyPayload(id),
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildPayloadChips(BuildContext context) {
    // debugPrint('build chips');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Barang yang biasa dibawa',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: defaultPayloads
              .map((payload) => RawChip(
                    label: Text(
                        '${payload.name} (${Payload.sizeToString(payload.size)})'),
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // debugPrint(payload.name);
                      context.read<DeliverCubit>().addPayload(payload);
                    },
                  ))
              .toList(),
        )
      ],
    );
  }

  // Widget for displaying the guideline card
  Widget _buildGuidelineCard(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            color: AppColor.secondary,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: () => _buildModalBottomSheet(context),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ImageIcon(
                      AssetImage(AppAsset.iconPoint),
                      color: Colors.black,
                    ),
                    Text(
                      'Lihat panduan ukuran barang',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _buildModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Image.asset(AppAsset.fotoPayload),
              const SizedBox(height: 36),
              const Text(
                'Panduan Ukuran Barang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Kecil : Bisa diangkat satu tangan\nSedang : Bisa diangkat dua tangan\nBesar : Harus diangkut dua orang atau lebih',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Spacer(),
              ButtonCustom(
                label: 'Saya mengerti',
                onTap: () {
                  context.pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  // Widget for displaying the cargo description card
  Widget _buildCargoDescriptionCard(BuildContext context) {
    return Container(
      height: 215,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Column(
        children: [
          Image.asset(AppAsset.fotoBox),
          const SizedBox(height: 10),
          const Text(
            'Tulis barang yang mau dikirim',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Deskripsiin barangmu supaya lengkap supaya driver bisa verifikasi,dan agar dilindungi oleh DeliveIt',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),
          ButtonCustom(
            label: 'Mulai',
            isExpanded: false,
            onTap: () {
              debugPrint('menambahkan barang');
              openDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Future openDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Tambah Barang',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            titlePadding: const EdgeInsets.symmetric(vertical: 16),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  payloadNameController.clear();
                  selectSize.setSelectedValue('');
                  context.pop();
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final payload = Payload(
                      name: payloadNameController.text,
                      size: Payload.stringToSize(selectSize.state),
                      qty: 1,
                    );

                    //* Add payload to state
                    context.read<DeliverCubit>().addPayload(payload);
                    // debugPrint('${payload.toJson()}');

                    payloadNameController.clear();
                    selectSize.setSelectedValue('');
                    context.pop();
                  }
                },
                child: const Text('Tambahkan'),
              )
            ],
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // * INPUT NAMA BARANG
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama Barang',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(
                          controller: payloadNameController,
                          autofocus: true,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama barang tidak boleh kosong';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Masukan nama barang',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // * INPUT UKURAN BARANG
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Ukuran Barang',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      BlocBuilder<SelectCubit<String>, String>(
                        bloc: selectSize,
                        builder: (context, state) {
                          // debugPrint('state $state');
                          return DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              value: state.length > 1 ? state : null,
                              alignment: Alignment.centerLeft,
                              hint: Text(
                                'Pilih ukuran barang',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              onChanged: (value) {
                                selectSize.setSelectedValue(value as String);
                              },
                              items: sizeOptions
                                  .map((String item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      ))
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
}
