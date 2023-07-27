import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../config/app_color.dart';

class CustomPinput extends StatelessWidget {
  CustomPinput({
    Key? key,
    required this.controller,
    required this.focusNode,
  }) : super(key: key);

  TextEditingController controller;

  FocusNode focusNode;

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

    return Pinput(
      controller: controller,
      focusNode: focusNode,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // androidSmsAutofillMethod:
      //     AndroidSmsAutofillMethod.smsUserConsentApi,
      // listenForMultipleSmsOnAndroid: true,
      defaultPinTheme: defaultPinTheme,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukan kode verifikasi';
        }

        return null;
        // return value == '2222' ? null : 'Pin is incorrect';
      },
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
      autofocus: true,
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
    );
  }
}
