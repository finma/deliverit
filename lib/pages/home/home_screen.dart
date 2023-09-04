import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/routes/router.dart';
import '/widgets/cutom_dropdown_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: HeaderSection(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                  ItemDeliverit(
                    title: 'Angkut Barang',
                    subTitle:
                        'Ngirim barang besar atau\njumlah banyak jadi mudah.\n(Contoh: motor)',
                    icon: AppAsset.fotoBox,
                    onTap: () {
                      debugPrint('Angkut barang');
                    },
                  ),
                  const SizedBox(height: 16),
                  ItemDeliverit(
                    title: 'Pindahan',
                    subTitle:
                        'Mau angkut barang ke tempat\nbaru? Sama DeliverIt bisa\nsekali jalan. (Contoh: pindahan\nrumah)',
                    icon: AppAsset.fotoBox,
                    onTap: () {
                      context.goNamed(Routes.deliver);
                    },
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                child: HeaderContent(),
              ),
            ],
          ),
          Positioned(
            top: 152,
            left: (MediaQuery.of(context).size.width - 316) / 2,
            child: Image.asset(
              AppAsset.fotoBanner,
            ),
          )
        ],
      ),
    );
  }
}

class HeaderContent extends StatelessWidget {
  HeaderContent({super.key});

  final List<String> dummyData = [
    'Perum CGM Blok A',
    'Desa Salagedang, Kecamatan Sukahaji, Kabupaten Majalengka',
    'Perum CGM Blok C',
    'Perum CGM Blok D',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context.pushNamed(Routes.profile);
            },
            child: Container(
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: CustomDropdown(
              items: dummyData,
            ),
          ),
          const NotificationIcon(),
        ],
      ),
    );
  }
}

class ItemDeliverit extends StatelessWidget {
  final String title;
  final String subTitle;
  final String icon;
  final void Function()? onTap;

  const ItemDeliverit({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
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
    );
  }
}
