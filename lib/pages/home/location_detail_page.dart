import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/config/app_color.dart';
import '/cubit/switch_cubit.dart';
import '/cubit/deliver/deliver_cubit.dart';
import '/model/user_delivery.dart';
import '/routes/router.dart';
import '/widgets/custom_button_widget.dart';

class LocationDetailPage extends StatelessWidget {
  LocationDetailPage({super.key});

  final TextEditingController _senderNameController = TextEditingController();
  final TextEditingController _senderPhoneController = TextEditingController();
  final TextEditingController _senderNoteController = TextEditingController();

  final TextEditingController _receiverNameController = TextEditingController();
  final TextEditingController _receiverPhoneController =
      TextEditingController();
  final TextEditingController _receiverNoteController = TextEditingController();

  final _formSenderKey = GlobalKey<FormState>();
  final _formReceiverKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DeliverCubit deliverCubit = context.read<DeliverCubit>();

    if (deliverCubit.state.sender != null) {
      _senderNameController.text = deliverCubit.state.sender!.name;
      _senderPhoneController.text = deliverCubit.state.sender!.phoneNumber;
      _senderNoteController.text = deliverCubit.state.sender!.note ?? '';
    }

    if (deliverCubit.state.receiver != null) {
      _receiverNameController.text = deliverCubit.state.receiver!.name;
      _receiverPhoneController.text = deliverCubit.state.receiver!.phoneNumber;
      _receiverNoteController.text = deliverCubit.state.receiver!.note ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Detail Pengirim dan Penerima Barang',
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
      bottomSheet: _buildBottomSheetButton(deliverCubit, context),
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
                        nameController: _senderNameController,
                        phoneNumberController: _senderPhoneController,
                        noteController: _senderNoteController,
                      ),
                      const SizedBox(height: 32),

                      // * FORM PENERIMA
                      FormDetail(
                        formKey: _formReceiverKey,
                        title: 'Penerima Barang',
                        isReceiver: true,
                        nameController: _receiverNameController,
                        phoneNumberController: _receiverPhoneController,
                        noteController: _receiverNoteController,
                        senderName: _senderNameController.text,
                        senderphoneNumber: _senderPhoneController.text,
                        senderNote: _senderNoteController.text,
                      ),
                      const SizedBox(height: 100),
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

  Container _buildBottomSheetButton(
      DeliverCubit deliverCubit, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: ButtonCustom(
        label: 'Lanjut',
        onTap: () {
          // debugPrint('${deliverCubit.state.toJson()}');
          if (_formSenderKey.currentState!.validate() &&
              _formReceiverKey.currentState!.validate()) {
            UserDelivery sender = UserDelivery(
              name: _senderNameController.text,
              phoneNumber: _senderPhoneController.text,
              note: _senderNoteController.text,
            );

            UserDelivery receiver = UserDelivery(
              name: _receiverNameController.text,
              phoneNumber: _receiverPhoneController.text,
              note: _receiverNoteController.text,
            );

            deliverCubit.addSender(sender);
            deliverCubit.addReceiver(receiver);
            // debugPrint('${deliverCubit.state.toJson()}');

            context.goNamed(Routes.payloadDetail);
          }
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
