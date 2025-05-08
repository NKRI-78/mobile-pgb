import 'package:flutter/material.dart';

import '../../../misc/text_style.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 0,
        childAspectRatio: 0.8,
        children: [
          _buildMenuItem(context, 'Mart', 'assets/icons/mart.png'),
          _buildMenuItem(context, 'Event', 'assets/icons/event.png'),
          _buildMenuItem(
              context, 'Member Near', 'assets/icons/member_near.png'),
          _buildMenuItem(context, 'PPOB', 'assets/icons/ppob.png'),
          _buildMenuItem(context, 'Media', 'assets/icons/media.png'),
          _buildMenuItem(context, 'Berita', 'assets/icons/news.png'),
          _buildMenuItem(context, 'About Us', 'assets/icons/about.png'),
          _buildMenuItem(context, 'Forum', 'assets/icons/forum.png'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String iconPath) {
    return InkWell(
      onTap: () {
        // Ganti sesuai kebutuhan navigasi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title diklik')),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF393FCD),
                    Color(0xFF0F124B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.textStyleNormal.copyWith(
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
