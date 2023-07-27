import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '/config/app_color.dart';
import '/cubit/countdown_cubit.dart';
import '/widgets/background_mesh_widget.dart';
import '/widgets/custom_button_widget.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  late CountdownCubit _countdownCubit;
  final int countdownDuration = 60;

  @override
  void initState() {
    debugPrint('INIT STATE');
    super.initState();
    _countdownCubit = CountdownCubit(countdownDuration);
    _countdownCubit.startCountdown();
  }

  @override
  void dispose() {
    _countdownCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = AppColor.primary;
    const fillColor = Colors.white;
    final borderColor = Colors.grey.shade300;

    final defaultPinTheme = PinTheme(
      width: 55,
      height: 55,
      textStyle: const TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
    );

    debugPrint('BUILD');

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
                    const SizedBox(height: 100),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Verifikasi',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Kami telah mengirimkan kode\nverifikasi kepada Anda',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Pinput(
                      controller: pinController,
                      focusNode: focusNode,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // androidSmsAutofillMethod:
                      //     AndroidSmsAutofillMethod.smsUserConsentApi,
                      // listenForMultipleSmsOnAndroid: true,
                      defaultPinTheme: defaultPinTheme,
                      // validator: (value) {
                      //   return value == '2222' ? null : 'Pin is incorrect';
                      // },
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      // onCompleted: (pin) {
                      //   debugPrint('onCompleted: $pin');
                      // },
                      // onChanged: (value) {
                      //   debugPrint('onChanged: $value');
                      // },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 1,
                            color: focusedBorderColor,
                          ),
                        ],
                      ),
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: focusedBorderColor),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          color: fillColor,
                          border: Border.all(color: focusedBorderColor),
                        ),
                      ),
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(color: Colors.redAccent),
                      ),
                    ),
                    const SizedBox(height: 52),
                    ButtonCustom(
                      label: 'LANJUTKAN',
                      // icon: AppAsset.logoGoogle,
                      onTap: () {
                        debugPrint('value: ${pinController.text}');
                      },
                    ),
                    // const SizedBox(height: 14),
                    BlocBuilder<CountdownCubit, int>(
                      bloc: _countdownCubit,
                      builder: (context, state) {
                        debugPrint('BUILD COUNTDOWN');

                        if (state == 0) {
                          return Column(
                            children: [
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  _countdownCubit.startCountdown();
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero),
                                ),
                                child: const Text(
                                  'Kirim ulang kode',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          );
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 64),
                            const Text(
                              'Kirim ulang kode masuk ',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '0.${state < 10 ? '0$state' : state}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColor.primary,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
