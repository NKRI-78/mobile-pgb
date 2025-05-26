import 'package:flutter/material.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/text_style.dart';
import '../../../router/builder.dart';
import '../../app/bloc/app_bloc.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 0,
        childAspectRatio: 0.75,
        children: [
          _buildMenuItem(context, 'Mart', 'assets/icons/mart.png', 0),
          _buildMenuItem(context, 'Event', 'assets/icons/event.png', 1),
          _buildMenuItem(
              context, 'Member Near', 'assets/icons/member_near.png', 2),
          _buildMenuItem(context, 'PPOB', 'assets/icons/ppob.png', 3),
          _buildMenuItem(context, 'Media', 'assets/icons/media.png', 4),
          _buildMenuItem(context, 'About Us', 'assets/icons/about.png', 5),
          _buildMenuItem(context, 'Interaksi', 'assets/icons/forum.png', 6),
          _buildMenuItem(context, 'SOS', 'assets/icons/sos.png', 7),
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
            elevation: 6,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: index == 7
                    ? LinearGradient(
                        colors: [
                          AppColors.redColor,
                          Color(0xFFB71C1C),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
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
          const SizedBox(height: 3),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: AppTextStyles.textStyleNormal.copyWith(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    final isLoggedIn = getIt<AppBloc>().state.user != null;

    // Media dan About bisa diakses tanpa login
    if (index == 4) {
      MediaRoute().go(context);
      return;
    }
    if (index == 5) {
      AboutRoute().go(context);
      return;
    }

    // Semua menu lainnya wajib login
    if (isLoggedIn) {
      switch (index) {
        case 0:
          ShopRoute().go(context);
          break;
        case 1:
          EventRoute().go(context);
          break;
        case 2:
          MemberNearRoute().go(context);
          break;
        case 3:
          PpobRoute().go(context);
          break;
        case 6:
          ForumRoute().go(context);
          break;
        case 7:
          SosRoute().go(context);
          break;
      }
    } else {
      RegisterRoute().go(context);
    }
  }
}
