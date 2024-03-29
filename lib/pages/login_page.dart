import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '/bloc/auth/auth_bloc.dart';
import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/cubit/switch_cubit.dart';
import '/routes/router.dart';
import '/widgets/background_mesh_widget.dart';
import '/widgets/custom_button_widget.dart';
import '/widgets/custom_text_form_field_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // state cubit
  final SwitchCubit _switchCubit = SwitchCubit(false);

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
                        const SizedBox(height: 100),

                        //* FORM LOGIN
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
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        Row(
                          children: [
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
                                      },
                                    );
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

                        BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            // Go to home page when login success
                            if (state is AuthStateAuthenticated) {
                              Fluttertoast.showToast(
                                msg: 'Berhasil masuk',
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 3,
                              );

                              context.goNamed(Routes.home);
                            }

                            if (state is AuthStateError) {
                              // debugPrint('Error: ${state.message}');
                              Fluttertoast.showToast(
                                msg: state.message,
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 3,
                              );
                            }
                          },
                          builder: (context, state) {
                            final isLoading = state is AuthStateLoading;

                            return ButtonCustom(
                              label: 'MASUK',
                              isLoading: isLoading,
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                        AuthEventLogin(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        ),
                                      );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        Text(
                          'ATAU',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
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
                        ),

                        const Spacer(),

                        //* CREATE ACCOUNT
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 32),
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
