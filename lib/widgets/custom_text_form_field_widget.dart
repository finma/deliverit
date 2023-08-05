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
    this.iconAsset,
    this.icon,
    this.isDense = true,
    this.isPassword = false,
    this.maxLines = 1,
    this.validator,
    this.paddingVertical = 20,
    this.paddingHorizontal = 16,
    this.borderRadius = 12,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String? iconAsset;
  final Icon? icon;
  final bool isDense;
  final bool isPassword;
  final int maxLines;
  final String? Function(String?)? validator;
  final double paddingVertical;
  final double paddingHorizontal;
  final double borderRadius;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordCubit(),
      child: BlocBuilder<PasswordCubit, bool>(
        builder: (context, isPasswordHidden) {
          return TextFormField(
            controller: controller,
            obscureText: isPassword ? isPasswordHidden : false,
            validator: validator,
            maxLines: maxLines,
            textAlign: TextAlign.start,
            onChanged: onChanged,
            decoration: InputDecoration(
              isDense: isDense,
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14),
              contentPadding: EdgeInsets.symmetric(
                vertical: paddingVertical,
                horizontal: paddingHorizontal,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: icon ??
                    Image.asset(
                      iconAsset!,
                      width: 24,
                      height: 24,
                    ),
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
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: AppColor.secondary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: AppColor.secondary),
              ),
            ),
          );
        },
      ),
    );
  }
}
