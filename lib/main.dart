import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/bloc/auth/auth_bloc.dart';
import '/bloc/nearby/nearby_bloc.dart';
import '/bloc/ride/ride_bloc.dart';
import '/cubit/deliver/deliver_cubit.dart';
import '/cubit/navigation_cubit.dart';
import '/config/app_color.dart';
import '/firebase_options.dart';
import '/routes/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => RideBloc()),
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => NearbyBloc()),
        BlocProvider(create: (_) => DeliverCubit()),
      ],
      child: const MyApp(),
    ),
  );
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
