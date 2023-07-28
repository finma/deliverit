import 'package:deliverit/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/config/app_asset.dart';
import '/widgets/custom_button_widget.dart';
import '/widgets/custom_text_form_field_widget.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});

  final TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 90, 30, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Setel ulang kata sandi',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const SizedBox(
                width: 275,
                child: Text(
                  'Silakan masukkan alamat email Anda untuk meminta pengaturan ulang kata sandi',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //* EMAIL ADDRESS
                    CustomTextFormField(
                      controller: emailController,
                      hintText: 'abc@email.com',
                      iconAsset: AppAsset.iconMail,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ButtonCustom(
                label: 'KIRIM',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    context.goNamed(Routes.home);
                    debugPrint('Email: ${emailController.text}');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
