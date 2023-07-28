import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/cubit/navigation_cubit.dart';
import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/pages/home_screen.dart';
import '/pages/mitra_page.dart';
import '/pages/order_page.dart';
import '/pages/telphone_page.dart';
import '/pages/wallet_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Widget> screens = [
    const HomeScreen(),
    const OrderPage(),
    const WalletPage(),
    const MitraPage(),
    const TelphonePage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: BlocBuilder<NavigationCubit, int>(
          builder: (context, indexPage) {
            return screens[indexPage];
          },
        ),
      ),
      floatingActionButton: const FloatingActionButtonWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBarWidget(),
    );
  }
}

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      buildWhen: (previous, current) => false,
      builder: (context, indexPage) {
        return FloatingActionButton(
          backgroundColor: AppColor.primary,
          child: const ImageIcon(
            AssetImage(AppAsset.iconHome),
            color: Colors.white,
          ),
          onPressed: () {
            context.read<NavigationCubit>().setTabIndex(0);
          },
        );
      },
    );
  }
}

class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            // * LEFT TAB BAR ICONS
            NavigationButton(
              iconAsset: AppAsset.iconBag,
              title: 'Order',
              tabIndex: 1,
            ),
            SizedBox(width: 16),
            NavigationButton(
              iconAsset: AppAsset.iconWallet,
              title: 'Wallet',
              tabIndex: 2,
            ),
            // * RIGHT TAB BAR ICONS
            Spacer(),
            NavigationButton(
              iconAsset: AppAsset.iconPeople,
              title: 'Mitra',
              tabIndex: 3,
            ),
            SizedBox(width: 16),
            NavigationButton(
              iconAsset: AppAsset.iconCall,
              title: 'Telepon',
              tabIndex: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final String iconAsset;
  final String title;
  final int tabIndex;

  const NavigationButton({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 40,
      onPressed: () {
        context.read<NavigationCubit>().setTabIndex(tabIndex);
      },
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, indexPage) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage(iconAsset),
                color: indexPage == tabIndex ? AppColor.primary : Colors.grey,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  color: indexPage == tabIndex ? AppColor.primary : Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
