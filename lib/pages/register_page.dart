import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/config/app_asset.dart';
import '/routes/router.dart';
import '/widgets/background_mesh_widget.dart';
import '/widgets/custom_button_widget.dart';
import '/widgets/custom_text_form_field_widget.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // controller
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundMesh(),
          LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        //* LOGO
                        Column(
                          children: [
                            const SizedBox(height: 40),
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: Image.asset(
                                AppAsset.logoDeliverit,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const Text(
                              'DeliverIt',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 50),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Daftar',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              //* NAME
                              CustomTextFormField(
                                controller: nameController,
                                hintText: 'nama lengkap',
                                iconAsset: AppAsset.iconProfile,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama lengkap tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              //* EMAIL ADDRESS
                              CustomTextFormField(
                                controller: emailController,
                                hintText: 'abc@email.com',
                                iconAsset: AppAsset.iconMail,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email tidak boleh kosong';
                                  }

                                  if (!EmailValidator.validate(value)) {
                                    return 'Masukkan email yang valid';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

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
                              const SizedBox(height: 20),

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
                              const SizedBox(height: 52),
                            ],
                          ),
                        ),

                        ButtonCustom(
                          label: 'SIMPAN',
                          // icon: AppAsset.logoGoogle,
                          onTap: () {
                            debugPrint('${_formKey.currentState}');
                            if (_formKey.currentState!.validate()) {
                              final Map<String, dynamic> dataUser = {
                                "name": nameController.text,
                                "email": emailController.text,
                                "password": passwordController.text,
                                "confirmPassword":
                                    confirmPasswordController.text,
                              };

                              debugPrint('$dataUser');
                              context.goNamed(Routes.otp);
                            }
                          },
                        ),

                        const Spacer(),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Sudah punya Akun?',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.goNamed(Routes.login);
                                  },
                                  child: const Text(
                                    'Masuk',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
