import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/text_style.dart';
import '../../../router/builder.dart';
import '../../app/bloc/app_bloc.dart';

class CustomEndDrawer extends StatelessWidget {
  const CustomEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo_transparant.png',
                    height: 100,
                  ),
                  const SizedBox(height: 80),
                  if (Platform.isAndroid)
                    OutlinedButton(
                      onPressed: () {
                        SettingsRoute().go(context);
                        GoRouter.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Colors.white,
                        ),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Settings',
                        style: AppTextStyles.textStyleNormal.copyWith(
                          fontSize: 14,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  BlocBuilder<AppBloc, AppState>(
                    bloc: getIt<AppBloc>(),
                    builder: (context, state) {
                      if (state.user != null) {
                        return Column(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                OrderRoute(initIndex: 0).go(context);
                                GoRouter.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Pesanan Saya',
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  fontSize: 14,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  OutlinedButton(
                    onPressed: () {
                      AboutMeRoute().go(context);
                      GoRouter.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.white,
                      ),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'About Me',
                      style: AppTextStyles.textStyleNormal.copyWith(
                        fontSize: 14,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<AppBloc, AppState>(
                    bloc: getIt<AppBloc>(),
                    builder: (context, state) {
                      if (state.user != null) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: TextButton(
                            onPressed: () {
                              showLogoutDialog(context);
                            },
                            child: Text(
                              'Log Out',
                              style: AppTextStyles.textStyleBold.copyWith(
                                color: AppColors.yellowColor,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.secondaryColor,
                        Color(0xFF005FA3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(3, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Konfirmasi Log Out',
                        style: AppTextStyles.textStyleBold.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Apakah Anda yakin ingin logout?',
                        style: AppTextStyles.textStyleNormal.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: Text(
                                'Batal',
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.redColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                await GoogleSignIn().signOut();
                                getIt<AppBloc>().add(SetUserLogout());
                                Navigator.of(dialogContext).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Log Out',
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: -60,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/dialog.png',
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
