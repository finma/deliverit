import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/data/payload.dart';
import '/model/payload.dart';
import '/widgets/custom_button_widget.dart';

class PayloadDetailPage extends StatelessWidget {
  PayloadDetailPage({Key? key}) : super(key: key);

  final List<Payload> defaultPayloads = DataPayload.all;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildGuidelineCard(context),
                _buildCargoDescriptionCard(),
              ],
            ),
            const SizedBox(height: 40),
            _buildPayloadChips()
          ],
        ),
      ),
    );
  }

  Column _buildPayloadChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Barang yang biasa dibawa',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: defaultPayloads
              .map((payload) => RawChip(
                    label: Text('${payload.name} (${payload.size})'),
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // TODO: add action to store payload
                      debugPrint(payload.name);
                    },
                  ))
              .toList(),
        )
      ],
    );
  }

  // Widget for displaying the guideline card
  Widget _buildGuidelineCard(BuildContext context) {
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
              onTap: () => _buildModalBottomSheet(context),
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

  Future<dynamic> _buildModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Image.asset(AppAsset.fotoPayload),
              const SizedBox(height: 36),
              const Text(
                'Panduan Ukuran Barang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Kecil : Bisa diangkat satu tangan\nSedang : Bisa diangkat dua tangan\nBesar : Harus diangkut dua orang atau lebih',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Spacer(),
              ButtonCustom(
                label: 'Saya mengerti',
                onTap: () {
                  context.pop();
                },
              )
            ],
          ),
        );
      },
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
