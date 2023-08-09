import 'package:flutter/material.dart';

import '/config/app_color.dart';
import '/cubit/switch_cubit.dart';
import '/widgets/custom_button_widget.dart';

class DeliveryDetailPage extends StatelessWidget {
  DeliveryDetailPage({super.key});

  final TextEditingController nameController1 = TextEditingController();
  final TextEditingController noHPController1 = TextEditingController();
  final TextEditingController noteController1 = TextEditingController();

  final TextEditingController nameController2 = TextEditingController();
  final TextEditingController noHPController2 = TextEditingController();
  final TextEditingController noteController2 = TextEditingController();

  final _formSenderKey = GlobalKey<FormState>();
  final _formReceiverKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Pengirim dan Penerima Barang',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      FormDetail(
                        formKey: _formSenderKey,
                        title: 'Pengirim Barang',
                        nameController: nameController1,
                        noHPController: noHPController1,
                        noteController: noteController1,
                      ),
                      const SizedBox(height: 32),
                      FormDetail(
                        formKey: _formReceiverKey,
                        title: 'Penerima Barang',
                        isReceiver: true,
                        nameController: nameController2,
                        noHPController: noHPController2,
                        noteController: noteController2,
                        senderName: nameController1.text,
                        senderNoHP: noHPController1.text,
                        senderNote: noteController1.text,
                      ),
                      const SizedBox(height: 32),
                      ButtonCustom(
                        label: 'LANJUTKAN',
                        onTap: () {
                          if (_formSenderKey.currentState!.validate() &&
                              _formReceiverKey.currentState!.validate()) {
                            //TODO: save data to cubit
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FormDetail extends StatelessWidget {
  FormDetail({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.title,
    required this.nameController,
    required this.noHPController,
    required this.noteController,
    this.senderName,
    this.senderNoHP,
    this.senderNote,
    this.isReceiver = false,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final String title;
  final TextEditingController nameController;
  final TextEditingController noHPController;
  final TextEditingController noteController;
  final String? senderName;
  final String? senderNoHP;
  final String? senderNote;
  final bool isReceiver;

  final SwitchCubit _switchCubit = SwitchCubit(false);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isReceiver)
          Row(
            children: [
              BlocBuilder<SwitchCubit, bool>(
                bloc: _switchCubit,
                builder: (context, state) {
                  return Switch.adaptive(
                    value: state,
                    activeColor: AppColor.primary,
                    onChanged: (value) {
                      _switchCubit.toggleSwitch();
                      if (value) {
                        nameController.text = senderName ?? '';
                        noHPController.text = senderNoHP ?? '';
                        noteController.text = senderNote ?? '';
                      } else {
                        nameController.text = '';
                        noHPController.text = '';
                        noteController.text = '';
                      }
                    },
                  );
                },
              ),
              const Text('Gunakan data pengirim'),
            ],
          ),
        SizedBox(height: isReceiver ? 6 : 32),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * NAMA PENGIRIM
              const Text(
                'Nama Pengirim',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextFormField(
                controller: nameController,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama pengirim tidak boleh kosong';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Masukan nama pengirim',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // * NOMOR TELEPON
              const Text(
                'Nomor Telepon',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextFormField(
                controller: noHPController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Masukan nomor telepon',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // * CATATAN
              const Text(
                'Catatan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: TextFormField(
                  controller: noteController,
                  maxLines: 5,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText:
                        'Catatan Pengirim (nama gedung, lantai, lantai 2 gedung A, dll)',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
