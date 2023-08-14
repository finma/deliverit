import 'package:go_router/go_router.dart';

import '/model/address.dart';

import '/pages/home/choose_vehicle_page.dart';
import '/pages/home/deliver_page.dart';
import '/pages/home/delivery_detail_page.dart';
import '/pages/home/location_detail_page.dart';
import '/pages/home/home_page.dart';
import '/pages/home/payload_detail_page.dart';
import '/pages/home/search_page.dart';
import '/pages/login_page.dart';
import '/pages/register_page.dart';
import '/pages/reset_password_page.dart';
import '/pages/verfication_pages.dart';

import '/pages/profile/profile_page.dart';
import '/pages/profile/account/account_page.dart';
import '/pages/profile/help/help_page.dart';
import '/pages/profile/history/history_page.dart';
import '/pages/profile/message/message_page.dart';
import '/pages/profile/mitra_favourite/mitra_favourite_page.dart';
import '/pages/profile/setting/setting_page.dart';
import '/pages/profile/setting/change_password_page.dart';
import '/pages/profile/setting/create_address_page.dart';
import '/pages/profile/setting/update_address_page.dart';
import '/pages/profile/setting/my_address_page.dart';
import '/pages/profile/setting/payment_method_page.dart';

part 'route_names.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (context, state) => HomePage(),
      routes: [
        GoRoute(
          path: 'deliver',
          name: Routes.deliver,
          builder: (context, state) => const DeliverPage(),
          routes: [
            GoRoute(
              path: 'search',
              name: Routes.searchPage,
              builder: (context, state) => SearchPage(),
            ),
            GoRoute(
              path: 'delivery-detail',
              name: Routes.locationDetail,
              builder: (context, state) => LocationDetailPage(),
              routes: [
                GoRoute(
                  path: 'payload-detail',
                  name: Routes.payloadDetail,
                  builder: (context, state) => PayloadDetailPage(),
                  routes: [
                    GoRoute(
                      path: 'choose-vehicle',
                      name: Routes.chooseVehicle,
                      builder: (context, state) => ChooseVehiclePage(),
                      routes: [
                        GoRoute(
                          path: 'delivery-detail',
                          name: Routes.deliveryDetail,
                          builder: (context, state) => DeliveryDetailPage(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        GoRoute(
          path: 'profile',
          name: Routes.profile,
          builder: (context, state) => ProfilePage(),
          routes: [
            GoRoute(
              path: 'account',
              name: Routes.account,
              builder: (context, state) => AccountPage(),
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
                  builder: (context, state) => MyAddressPage(),
                  routes: [
                    GoRoute(
                      path: 'create-address',
                      name: Routes.createAddress,
                      builder: (context, state) => CreateAddressPage(),
                    ),
                    GoRoute(
                      path: 'update-address',
                      name: Routes.updateAddress,
                      builder: (context, state) => UpdateAddressPage(
                        address: state.extra as Address,
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'payment-method',
                  name: Routes.paymentMethod,
                  builder: (context, state) => const PaymentMethodPage(),
                ),
                GoRoute(
                  path: 'change-password',
                  name: Routes.changePassword,
                  builder: (context, state) => ChangePasswordPage(),
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
    GoRoute(
      path: '/reset-password',
      name: Routes.resetPassword,
      builder: (context, state) => ResetPasswordPage(),
    ),
  ],
);
