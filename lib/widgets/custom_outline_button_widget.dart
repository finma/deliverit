import 'package:flutter/material.dart';

import '/config/app_color.dart';

class ButtonOutlineCustom extends StatelessWidget {
  const ButtonOutlineCustom({
    Key? key,
    required this.label,
    required this.onTap,
    this.isExpanded = true,
    this.icon,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final bool isExpanded;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColor.primary,
              width: 1,
            ),
            color: Colors.transparent,
          ),
          width: isExpanded ? double.infinity : null,
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
            vertical: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon!,
              if (icon != null) const SizedBox(width: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
