import 'package:flutter/material.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/widgets/cutom_dropdown_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<String> dummyData = [
    'Perum CGM Blok A',
    'Desa Salagedang, Kecamatan Sukahaji, Kabupaten Majalengka',
    'Perum CGM Blok C',
    'Perum CGM Blok D',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 350,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: const BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                          ),
                          child: header(),
                        ),
                      ],
                    ),

                    // * BANNER
                    Positioned(
                      top: 152,
                      left: (MediaQuery.of(context).size.width - 316) / 2,
                      child: Image.asset(
                        AppAsset.fotoBanner,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Mau pesan DeliverIt\nbuat apa?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ImageIcon(
                          AssetImage(AppAsset.iconExclamationMark),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    itemDeliverit(
                      title: 'Angkut Barang',
                      subTitle:
                          'Ngirim barang besar atau\njumlah banyak jadi mudah.\n(Contoh: motor)',
                      icon: AppAsset.fotoBox,
                      onTap: () {
                        debugPrint('Angkut barang');
                      },
                    ),
                    const SizedBox(height: 16),
                    itemDeliverit(
                      title: 'Pindahan',
                      subTitle:
                          'Mau angkut barang ke tempat\nbaru? Sama DeliverIt bisa\nsekali jalan. (Contoh: pindahan\nrumah)',
                      icon: AppAsset.fotoBox,
                      onTap: () {
                        debugPrint('Pindahan');
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector itemDeliverit({
    required String title,
    required String subTitle,
    required String icon,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 128,
        decoration: BoxDecoration(
          color: AppColor.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Row(
              children: [
                Image.asset(icon),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subTitle,
                      style: const TextStyle(fontSize: 12),
                      softWrap: true,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }

  Stack header() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: Image.asset(
                    AppAsset.profile,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              //* CUSTOM DROPDOWN
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: CustomDropdown(
                  items: dummyData,
                ),
              ),
              Material(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(36),
                child: InkWell(
                  onTap: () {
                    // TODO: create method open notification
                    debugPrint('open notif');
                  },
                  borderRadius: BorderRadius.circular(36),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        const ImageIcon(
                          AssetImage(AppAsset.iconNotification),
                          color: Colors.white,
                          size: 72,
                        ),

                        //* NOTIFICATION BADGE
                        Positioned(
                          top: 5,
                          right: 6,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColor.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColor.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
