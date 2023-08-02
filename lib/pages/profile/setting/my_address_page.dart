import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/routes/router.dart';

class MyAddressPage extends StatelessWidget {
  const MyAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alamat Saya',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          addressHeader(context),
          const Divider(thickness: 3, height: 0),
          customListItem(
            context: context,
            title: 'Cikara Studio',
            subtitle:
                'Perum Cipta Graha Mandiri Blok C 108, Sukarindik, Kec.Bungursari, Tasikmalaya',
            onEditPressed: () {},
          ),
        ],
      ),
    );
  }

  Padding addressHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Alamat saya',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  context.goNamed(Routes.createAddress);
                },
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColor.primary,
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppColor.primary,
                      ),
                      SizedBox(width: 2),
                      Text(
                        'Tambah Alamat',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget customListItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    VoidCallback? onEditPressed,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ImageIcon(
                AssetImage(AppAsset.iconLocation),
                color: AppColor.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.mode_edit_outline_outlined,
                  color: AppColor.primary,
                ),
                onPressed: onEditPressed,
              ),
            ],
          ),
        ),
        const Divider(thickness: 3, height: 0),
      ],
    );
  }
}
