import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '/bloc/auth/auth_bloc.dart';
import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/routes/router.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final List<Map<String, dynamic>> menu = [
    {
      'icon': AppAsset.iconProfile,
      'label': 'Akun Saya',
      'route': Routes.account,
    },
    {
      'icon': AppAsset.iconMessage,
      'label': 'Pesan',
      'route': Routes.message,
    },
    {
      'icon': AppAsset.iconLove,
      'label': 'Mitra Favorit',
      'route': Routes.mitraFavourite,
    },
    {
      'icon': AppAsset.iconClock,
      'label': 'Riwayat Pesanan',
      'route': Routes.history,
    },
    {
      'icon': AppAsset.iconSetting,
      'label': 'Pengaturan',
      'route': Routes.setting,
    },
    {
      'icon': AppAsset.iconQuestionMark,
      'label': 'Bantuan',
      'route': Routes.help,
    },
    {
      'icon': AppAsset.iconLogout,
      'label': 'Keluar',
      'route': Routes.login,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthStateError) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 2,
            );
          }

          if (state is AuthStateUnauthenticated) {
            Fluttertoast.showToast(
              msg: 'Berhasil keluar',
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 2,
            );
            context.goNamed(Routes.login);
          }
        },
        child: Stack(
          children: [
            Container(
              color: AppColor.primary,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Column(
                    children: [
                      // * AVATAR
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            AppAsset.profile,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // * NAME
                      const Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: menu.length,
                        itemBuilder: (context, index) {
                          return MenuItem(
                            label: menu[index]['label'],
                            icon: menu[index]['icon'],
                            routeName: menu[index]['route'],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.routeName,
    // required this.onTap,
  }) : super(key: key);

  final String label;
  final String icon;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (routeName == Routes.login) {
          context.read<AuthBloc>().add(AuthEventLogout());
        } else {
          context.goNamed(routeName);
        }
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ImageIcon(
              AssetImage(icon),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
