import 'package:flutter/material.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';

class MitraFavouritePage extends StatelessWidget {
  const MitraFavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mitra Favorit',
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
            title: 'Alfian',
            subtitle: 'B 1234 CA (Pick up)',
            onCallPressed: () {},
            onChatPressed: () {},
          ),
          customListItem(
            context: context,
            title: 'Rizki',
            subtitle: 'B 1234 CA (Truk)',
            onCallPressed: () {},
            onChatPressed: () {},
          ),
          customListItem(
            context: context,
            title: 'Jamal',
            subtitle: 'B 1234 CA (Box)',
            onCallPressed: () {},
            onChatPressed: () {},
          ),
        ],
      ),
    );
  }

  Padding addressHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        child: Text(
          'Mitra Favorit Saya',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget customListItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    VoidCallback? onCallPressed,
    VoidCallback? onChatPressed,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  AppAsset.profile,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
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
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const ImageIcon(
                  AssetImage(AppAsset.iconCall),
                  color: AppColor.primary,
                ),
                onPressed: onCallPressed,
              ),
              IconButton(
                icon: const ImageIcon(
                  AssetImage(AppAsset.iconMessage),
                  color: AppColor.primary,
                ),
                onPressed: onChatPressed,
              ),
            ],
          ),
        ),
        const Divider(thickness: 3, height: 0),
      ],
    );
  }
}
