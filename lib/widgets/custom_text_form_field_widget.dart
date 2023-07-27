import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '/config/app_color.dart';

class PasswordCubit extends Cubit<bool> {
  PasswordCubit() : super(true);

  void togglePasswordVisibility() {
    emit(!state);
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.iconAsset,
    this.isDense = true,
    this.isPassword = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String iconAsset;
  final bool isDense;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordCubit(),
      child: BlocBuilder<PasswordCubit, bool>(
        builder: (context, isPasswordHidden) {
          return TextFormField(
            controller: controller,
            obscureText: isPassword ? isPasswordHidden : false,
            decoration: InputDecoration(
              isDense: isDense,
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
              prefixIcon: ImageIcon(
                AssetImage(iconAsset),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        context
                            .read<PasswordCubit>()
                            .togglePasswordVisibility();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColor.secondary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColor.secondary),
              ),
            ),
          );
        },
      ),
    );
  }
}