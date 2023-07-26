import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/config/app_asset.dart';
import '/routes/router.dart';
import '/widgets/background_mesh_widget.dart';
import '/widgets/custom_button_widget.dart';
import '/widgets/custom_text_form_field_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundMesh(
        child: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
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
                    const SizedBox(height: 100),

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
                    Row(
                      children: [
                        Row(
                          children: [
                            Switch.adaptive(
                              value: false,
                              onChanged: (value) {
                                // TODO: Switch Ingatkan saya
                              },
                            ),
                            const Text('Ingatkan saya'),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // TODO: Lupa kata sandi
                          },
                          child: const Text('Lupa kata sandi?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ButtonCustom(
                      label: 'MASUK',
                      // icon: AppAsset.logoGoogle,
                      onTap: () {
                        // TODO: login method
                        final Map<String, dynamic> dataUser = {
                          "email": emailController.text,
                          "password": passwordController.text,
                        };

                        print(dataUser);
                        context.goNamed(Routes.home);
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'ATAU',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    ButtonCustom(
                      label: 'Login dengan Google',
                      onTap: () {
                        // TODO: Login dengan Google
                      },
                      type: ButtonType.secondary,
                      icon: AppAsset.logoGoogle,
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 40),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tidak punya Akun?',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            TextButton(
              onPressed: () {
                context.goNamed(Routes.register);
              },
              child: const Text(
                'Buat akun',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
