import 'package:deliverit/pages/profile_page.dart';
import 'package:go_router/go_router.dart';

import '/pages/home_page.dart';
import '/pages/login_page.dart';
import '/pages/register_page.dart';
import '/pages/verfication_pages.dart';

part 'route_names.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (context, state) => HomePage(),
      routes: [
        GoRoute(
          path: 'profile',
          name: Routes.profile,
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
    // GoRoute(
    //   path: '/home',
    //   name: Routes.home,
    //   builder: (context, state) => HomePage(),
    //   routes: [
    //     GoRoute(
    //       path: '/profile',
    //       name: Routes.profile,
    //       builder: (context, state) => const ProfilePage(),
    //     ),
    //   ],
    // ),
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: Routes.register,
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: '/otp',
      name: Routes.otp,
      builder: (context, state) => const VerificationPage(),
    ),
  ],
);
