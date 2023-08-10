import 'package:flutter/material.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/widgets/custom_button_widget.dart';

class PayloadDetailPage extends StatelessWidget {
  const PayloadDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Detail Muatan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                _buildGuidelineCard(),
                _buildCargoDescriptionCard(),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget for displaying the guideline card
  Widget _buildGuidelineCard() {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            color: AppColor.secondary,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: () {
                debugPrint('buka panduan');
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ImageIcon(
                      AssetImage(AppAsset.iconPoint),
                      color: Colors.black,
                    ),
                    Text(
                      'Lihat panduan ukuran barang',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for displaying the cargo description card
  Widget _buildCargoDescriptionCard() {
    return Container(
      height: 215,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Column(
        children: [
          Image.asset(AppAsset.fotoBox),
          const SizedBox(height: 10),
          const Text(
            'Tulis barang yang mau dikirim',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Deskripsiin barangmu supaya lengkap supaya driver bisa verifikasi,dan agar dilindungi oleh DeliveIt',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),
          ButtonCustom(
            label: 'Mulai',
            isExpanded: false,
            onTap: () {
              debugPrint('menambahkan barang');
            },
          ),
        ],
      ),
    );
  }
}
