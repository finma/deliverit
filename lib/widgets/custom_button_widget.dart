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
    this.isDisabled = false,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final bool isExpanded;
  final ButtonType type;
  final String? icon;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isDisabled
        ? Colors.grey
        : (type == ButtonType.primary ? AppColor.primary : Colors.white);
    Color textColor = isDisabled
        ? Colors.white
        : (type == ButtonType.primary ? Colors.white : Colors.black);

    return Material(
      borderRadius: BorderRadius.circular(15),
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: isDisabled ? null : onTap,
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
                  color: textColor,
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
