import 'package:flutter/material.dart';

import '../../../misc/colors.dart';
import '../widget/custom_banner.dart';
import '../widget/custom_drawer.dart';
import '../widget/custom_menu.dart';
import '../widget/custom_name.dart';
import '../widget/custom_news.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: AppColors.primaryColor,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 80,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: 16,
                  top: 20,
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: Image.asset(
                      'assets/images/user.png',
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 45,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_none_outlined,
                color: AppColors.greyColor,
                size: 28,
              ),
              onPressed: () {},
            ),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: AppColors.greyColor,
                  size: 28,
                ),
              );
            }),
          ],
        ),
      ),
      endDrawer: const CustomEndDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              spacing: 10,
              children: [
                CustomName(),
                CustomBanner(),
                CustomMenu(),
                CustomNews(),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // todo: implement SOS button action
                  debugPrint('SOS Button Pressed');
                },
                child: Image.asset(
                  'assets/icons/sos.png',
                  width: 150,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
