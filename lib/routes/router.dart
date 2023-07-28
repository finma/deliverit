import 'package:deliverit/pages/profile/setting/change_password_page.dart';
import 'package:deliverit/pages/profile/setting/my_address_page.dart';
import 'package:deliverit/pages/profile/setting/payment_method_page.dart';
import 'package:go_router/go_router.dart';

import '/pages/account_page.dart';
import '/pages/help_page.dart';
import '/pages/history_page.dart';
import '/pages/home_page.dart';
import '/pages/login_page.dart';
import '/pages/message_page.dart';
import '/pages/mitra_favourite_page.dart';
import '/pages/profile_page.dart';
import '/pages/register_page.dart';
import '/pages/setting_page.dart';
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
          builder: (context, state) => ProfilePage(),
          routes: [
            GoRoute(
              path: 'account',
              name: Routes.account,
              builder: (context, state) => const AccountPage(),
            ),
            GoRoute(
              path: 'message',
              name: Routes.message,
              builder: (context, state) => const MessagePage(),
            ),
            GoRoute(
              path: 'mitra-favourite',
              name: Routes.mitraFavourite,
              builder: (context, state) => const MitraFavouritePage(),
            ),
            GoRoute(
              path: 'history',
              name: Routes.history,
              builder: (context, state) => const HistoryPage(),
            ),
            GoRoute(
              path: 'setting',
              name: Routes.setting,
              builder: (context, state) => const SettingPage(),
              routes: [
                GoRoute(
                  path: 'my-address',
                  name: Routes.myAddress,
                  builder: (context, state) => const MyAddressPage(),
                ),
                GoRoute(
                  path: 'payment-method',
                  name: Routes.paymentMethod,
                  builder: (context, state) => const PaymentMethodPage(),
                ),
                GoRoute(
                  path: 'change-password',
                  name: Routes.changePassword,
                  builder: (context, state) => const ChangePasswordPage(),
                ),
              ],
            ),
            GoRoute(
              path: 'help',
              name: Routes.help,
              builder: (context, state) => const HelpPage(),
            ),
          ],
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
