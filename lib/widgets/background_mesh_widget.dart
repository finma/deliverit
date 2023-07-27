import 'dart:ui';

import 'package:deliverit/config/app_color.dart';
import 'package:flutter/material.dart';

class BackgroundMesh extends StatelessWidget {
  const BackgroundMesh({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          right: -20,
          top: -20,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColor.gradient,
              borderRadius: BorderRadius.circular(250),
            ),
          ),
        ),
        Positioned(
          left: -100,
          top: 300,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColor.gradient,
              borderRadius: BorderRadius.circular(250),
            ),
          ),
        ),
        Positioned(
          right: -100,
          top: 500,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColor.gradient,
              borderRadius: BorderRadius.circular(250),
            ),
          ),
        ),
        Positioned(
          left: -100,
          top: 700,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColor.gradient,
              borderRadius: BorderRadius.circular(250),
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: const SizedBox(),
          ),
        ),
        SafeArea(child: child ?? Container()),
      ],
    );
  }
}
