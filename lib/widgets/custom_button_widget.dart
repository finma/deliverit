import 'package:flutter/material.dart';

import '/config/app_color.dart';

enum ButtonType { primary, secondary }

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    Key? key,
    required this.label,
    required this.onTap,
    this.isExpanded = true,
    this.type = ButtonType.primary,
    this.icon,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final bool isExpanded;
  final ButtonType type;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      color: type == ButtonType.primary ? AppColor.primary : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Container(
          width: isExpanded ? double.infinity : null,
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
            vertical: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Image.asset(icon!),
              if (icon != null) const SizedBox(width: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: type == ButtonType.primary ? 1 : 0,
                  color:
                      type == ButtonType.primary ? Colors.white : Colors.black,
                  fontWeight: type == ButtonType.primary
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
