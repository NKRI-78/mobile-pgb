import 'package:flutter/material.dart';
import '../../../router/builder.dart';

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
          _buildMenuItem(context, 'Mart', 'assets/icons/mart.png', 0),
          _buildMenuItem(context, 'Event', 'assets/icons/event.png', 1),
          _buildMenuItem(
              context, 'Member Near', 'assets/icons/member_near.png', 2),
          _buildMenuItem(context, 'PPOB', 'assets/icons/ppob.png', 3),
          _buildMenuItem(context, 'Media', 'assets/icons/media.png', 4),
          _buildMenuItem(context, 'Berita', 'assets/icons/news.png', 5),
          _buildMenuItem(context, 'About Us', 'assets/icons/about.png', 6),
          _buildMenuItem(context, 'Forum', 'assets/icons/forum.png', 7),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, String iconPath, int index) {
    return InkWell(
      onTap: () {
        _navigateToPage(context, index);
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

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        RegisterRoute().go(context);
        break;
      case 1:
        RegisterRoute().go(context);
        break;
      case 2:
        RegisterRoute().go(context);
        break;
      case 3:
        RegisterRoute().go(context);
        break;
      case 4:
        MediaRoute().go(context);
        break;
      case 5:
        RegisterRoute().go(context);
        break;
      case 6:
        AboutRoute().go(context);
        break;
      case 7:
        RegisterRoute().go(context);
        break;
      default:
        // Fallback jika index tidak dikenali
        break;
    }
  }
}
