import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/routes/router.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          children: [
            ItemSetting(
              title: 'Alamat saya',
              route: Routes.myAddress,
            ),
            SizedBox(height: 22),
            ItemSetting(
              title: 'Metode pembayaran',
              route: Routes.paymentMethod,
            ),
            SizedBox(height: 22),
            ItemSetting(
              title: 'Ubah kata sandi',
              route: Routes.changePassword,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemSetting extends StatelessWidget {
  final String title;
  final String route;

  const ItemSetting({
    Key? key,
    required this.title,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
