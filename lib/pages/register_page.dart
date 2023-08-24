import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '/bloc/auth/auth_bloc.dart';
import '/config/app_asset.dart';
import '/routes/router.dart';
import '/widgets/background_mesh_widget.dart';
import '/widgets/custom_button_widget.dart';
import '/widgets/custom_text_form_field_widget.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
                                hintText: 'Nama lengkap',
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
                                hintText: 'Alamat email',
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

                              //* PHONE NUMBER
                              CustomTextFormField(
                                controller: phoneNumberController,
                                hintText: 'Nomor telepon',
                                iconAsset: AppAsset.iconCall,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nomor telepon tidak boleh kosong';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              //* PASSWORD
                              CustomTextFormField(
                                controller: passwordController,
                                hintText: 'Kata sandi',
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
                                hintText: 'Konfirmasi kata sandi',
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

                        BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is AuthStateError) {
                              Fluttertoast.showToast(
                                msg: state.message,
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 2,
                              );
                            }

                            if (state is AuthStateRegister) {
                              Fluttertoast.showToast(
                                msg: 'Registrasi berhasil',
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 2,
                              );

                              // TODO: OTP not implemented yet, so go to home page
                              // context.goNamed(Routes.otp);
                              context.goNamed(Routes.home);
                            }
                          },
                          builder: (context, state) {
                            final bool isLoading = state is AuthStateLoading;

                            return ButtonCustom(
                              label: 'SIMPAN',
                              isLoading: isLoading,
                              onTap: () {
                                // debugPrint('${_formKey.currentState}');
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                        AuthEventRegister(
                                          name: nameController.text.trim(),
                                          email: emailController.text.trim(),
                                          phoneNumber:
                                              phoneNumberController.text.trim(),
                                          password:
                                              passwordController.text.trim(),
                                        ),
                                      );
                                }
                              },
                            );
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
