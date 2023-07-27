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

                        //* NAME
                        CustomTextFormField(
                          controller: nameController,
                          hintText: 'nama lengkap',
                          iconAsset: AppAsset.iconProfile,
                        ),
                        const SizedBox(height: 20),

                        //* EMAIL ADDRESS
                        CustomTextFormField(
                          controller: emailController,
                          hintText: 'abc@email.com',
                          iconAsset: AppAsset.iconMail,
                        ),
                        const SizedBox(height: 20),

                        //* PASSWORD
                        CustomTextFormField(
                          controller: passwordController,
                          hintText: 'kata sandi',
                          iconAsset: AppAsset.iconLock,
                          isPassword: true,
                        ),
                        const SizedBox(height: 20),

                        //* CONFIRM PASSWORD
                        CustomTextFormField(
                          controller: confirmPasswordController,
                          hintText: 'konfirmasi kata sandi',
                          iconAsset: AppAsset.iconLock,
                          isPassword: true,
                        ),
                        const SizedBox(height: 52),

                        ButtonCustom(
                          label: 'SIMPAN',
                          // icon: AppAsset.logoGoogle,
                          onTap: () {
                            final Map<String, dynamic> dataUser = {
                              "name": nameController.text,
                              "email": emailController.text,
                              "password": passwordController.text,
                              "confirmPassword": confirmPasswordController.text,
                            };

                            debugPrint('$dataUser');
                            context.goNamed(Routes.otp);
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
