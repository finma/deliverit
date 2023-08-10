import 'package:flutter/material.dart';

import '/config/app_color.dart';
import '/cubit/switch_cubit.dart';
import '/cubit/deliver/deliver_cubit.dart';
import '/model/user_delivery.dart';
import '/widgets/custom_button_widget.dart';

class DeliveryDetailPage extends StatelessWidget {
  DeliveryDetailPage({super.key});

  final TextEditingController nameController1 = TextEditingController();
  final TextEditingController phoneNumberController1 = TextEditingController();
  final TextEditingController noteController1 = TextEditingController();

  final TextEditingController nameController2 = TextEditingController();
  final TextEditingController phoneNumberController2 = TextEditingController();
  final TextEditingController noteController2 = TextEditingController();

  final _formSenderKey = GlobalKey<FormState>();
  final _formReceiverKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DeliverCubit deliverCubit = context.read<DeliverCubit>();

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
                      // * FORM PENGIRIM
                      FormDetail(
                        formKey: _formSenderKey,
                        title: 'Pengirim Barang',
                        nameController: nameController1,
                        phoneNumberController: phoneNumberController1,
                        noteController: noteController1,
                      ),
                      const SizedBox(height: 32),

                      // * FORM PENERIMA
                      FormDetail(
                        formKey: _formReceiverKey,
                        title: 'Penerima Barang',
                        isReceiver: true,
                        nameController: nameController2,
                        phoneNumberController: phoneNumberController2,
                        noteController: noteController2,
                        senderName: nameController1.text,
                        senderphoneNumber: phoneNumberController1.text,
                        senderNote: noteController1.text,
                      ),
                      const SizedBox(height: 32),

                      // * BUTTON LANJUTKAN
                      ButtonCustom(
                        label: 'LANJUTKAN',
                        onTap: () {
                          // debugPrint('${deliverCubit.state.toJson()}');
                          if (_formSenderKey.currentState!.validate() &&
                              _formReceiverKey.currentState!.validate()) {
                            UserDelivery sender = UserDelivery(
                              name: nameController1.text,
                              phoneNumber: phoneNumberController1.text,
                              note: noteController1.text,
                            );

                            UserDelivery receiver = UserDelivery(
                              name: nameController2.text,
                              phoneNumber: phoneNumberController2.text,
                              note: noteController2.text,
                            );

                            deliverCubit.addSender(sender);
                            deliverCubit.addReceiver(receiver);
                            // debugPrint('${deliverCubit.state.toJson()}');
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
    required this.phoneNumberController,
    required this.noteController,
    this.senderName,
    this.senderphoneNumber,
    this.senderNote,
    this.isReceiver = false,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final String title;
  final TextEditingController nameController;
  final TextEditingController phoneNumberController;
  final TextEditingController noteController;
  final String? senderName;
  final String? senderphoneNumber;
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
                        phoneNumberController.text = senderphoneNumber ?? '';
                      } else {
                        nameController.text = '';
                        phoneNumberController.text = '';
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
                controller: phoneNumberController,
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
                  decoration: InputDecoration(
                    hintText:
                        'Catatan ${isReceiver ? "penerima" : "pengirim"} (nama gedung, lantai, lantai 2 gedung A, dll)',
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
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
