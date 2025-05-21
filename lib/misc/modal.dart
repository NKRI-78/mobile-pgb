import 'dart:io';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:mobile_pgb/misc/text_style.dart';
import 'package:mobile_pgb/misc/theme.dart';
import 'package:url_launcher/url_launcher.dart';

enum BackgroundConfirmModal {
  confirmDelete,
  joinEvent,
  joinCheckin,
  logoutBakcgroud
}

class GeneralModal {
  late BackgroundConfirmModal assets;
  String get asset {
    if (assets == BackgroundConfirmModal.confirmDelete) {
      return 'assets/icons/delete-icon.png';
    } else if (assets == BackgroundConfirmModal.joinEvent) {
      return 'assets/icons/joined-event.png';
    } else if (assets == BackgroundConfirmModal.joinCheckin) {
      return 'assets/icons/join-check-in.png';
    }
    return 'assets/images/logout-icon-confirm.png';
  }

  static Future<void> showConfirmModal({
    required String msg,
    bool? showCancelButton = false,
    required BuildContext context,
    required void Function() onPressed,
    String? locationImage,
    String? textConfirm,
  }) {
    return showDialog(
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
                      const SizedBox(height: 12),
                      Text(
                        msg,
                        style: AppTextStyles.textStyleNormal.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          showCancelButton ?? false ?  Expanded(
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
                                'Tutup',
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                          ) : Container(),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.redColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: onPressed,
                              child: Text(
                                textConfirm ?? "Konfirmasi",
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
                      // color: AppColors.whiteColor,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.6),
                      //     blurRadius: 8,
                      //     offset: const Offset(3, 4),
                      //   ),
                      // ],
                    ),
                    child: Image.asset(
                      locationImage ?? imageDefaultData,
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
