import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/config/app_asset.dart';
import '/routes/router.dart';
import '/widgets/custom_button_widget.dart';
import '/widgets/custom_text_form_field_widget.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ubah Kata Sandi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 137),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  //* PASSWORD
                  CustomTextFormField(
                    controller: passwordController,
                    hintText: 'kata sandi',
                    iconAsset: AppAsset.iconLock,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  //* CONFIRM PASSWORD
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    hintText: 'konfirmasi kata sandi',
                    iconAsset: AppAsset.iconLock,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi kata sandi tidak boleh kosong';
                      }

                      if (value != passwordController.text) {
                        return 'Kata sandi tidak cocok';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(30),
        child: ButtonCustom(
          label: 'SIMPAN',
          onTap: () {
            if (_formKey.currentState!.validate()) {
              context.goNamed(Routes.resetPassword);
              debugPrint('SIMPAN');
            }
          },
        ),
      ),
    );
  }
}
