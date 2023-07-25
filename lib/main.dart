import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/config/app_color.dart';
import '/routes/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: AppColor.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.secondary,
        ),
      ),
      routerConfig: router,
    );
  }
}
