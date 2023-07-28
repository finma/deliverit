import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/routes/router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menu = [
      {
        'icon': AppAsset.iconProfile,
        'label': 'Akun Saya',
        'onTap': () {
          // context.goNamed('account');
          debugPrint('account');
        },
      },
      {
        'icon': AppAsset.iconMessage,
        'label': 'Pesan',
        'onTap': () {
          // context.goNamed('message');
          debugPrint('message');
        },
      },
      {
        'icon': AppAsset.iconLove,
        'label': 'Mitra Favorit',
        'onTap': () {
          // context.goNamed('mitra_favourite');
          debugPrint('mitra_favourite');
        },
      },
      {
        'icon': AppAsset.iconClock,
        'label': 'Riwayat Pesanan',
        'onTap': () {
          // context.goNamed('history');
          debugPrint('history');
        },
      },
      {
        'icon': AppAsset.iconSetting,
        'label': 'Pengaturan',
        'onTap': () {
          // context.goNamed('setting');
          debugPrint('setting');
        },
      },
      {
        'icon': AppAsset.iconQuestionMark,
        'label': 'Bantuan',
        'onTap': () {
          // context.goNamed('help');
          debugPrint('help');
        },
      },
      {
        'icon': AppAsset.iconLogout,
        'label': 'Keluar',
        'onTap': () {
          // TODO: create method logout
          context.goNamed(Routes.login);
        },
      },
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Stack(
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
                        return GestureDetector(
                          onTap: menu[index]['onTap'],
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                ImageIcon(
                                  AssetImage('${menu[index]['icon']}'),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '${menu[index]['label']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}
