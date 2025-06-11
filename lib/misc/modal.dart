import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repositories/membernear_repository/models/membernear_model.dart';
import 'colors.dart';
import 'snackbar.dart';
import 'text_style.dart';
import 'theme.dart';

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
                          showCancelButton ?? false
                              ? Expanded(
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
                                      style: AppTextStyles.textStyleNormal
                                          .copyWith(
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
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
                      height: 140,
                      width: 140,
                      fit: BoxFit.contain,
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

  static Future<void> showModalMemberNearDetail(
      BuildContext context, MemberNearData membernear) {
    return showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (BuildContext context) {
          String resultText = (membernear.distance.toString().length < 4)
              ? membernear.distance.toString()
              : membernear.distance.toString().substring(0, 4);
          return Container(
            height: 420.0,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 370.0,
                    decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //     colors: [
                        //       AppColors.blueColor,
                        //       AppColors.whiteColor.withValues(alpha: 0.5),
                        //     ],
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter),
                        color: AppColors.secondaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                  ),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        CircleAvatar(
                          maxRadius: 50.0,
                          backgroundImage: NetworkImage(
                            (membernear.profile?.avatarLink?.isEmpty ?? true)
                                ? "https://i.ibb.co.com/vxkjJQD/Png-Item-1503945.png"
                                : membernear.profile?.avatarLink ?? "",
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(membernear.profile?.fullname ?? "",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                  fontSize: fontSizeOverLarge,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor)),
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              "${membernear.profile?.kta}",
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: fontSizeDefault,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor)),
                        ),
                        const SizedBox(height: 8.0),
                        Text('$resultText KM',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: fontSizeDefault,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor,
                            )),
                        const SizedBox(height: 50.0),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await openWhatsApp(membernear, context);
                          },
                          icon: const Icon(Icons.chat),
                          label: const Text(
                            'Hubungi melalui WhatsApp',
                            style: TextStyle(color: AppColors.blackColor),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          );
        });
  }
}

Future<void> openWhatsApp(
    MemberNearData membernear, BuildContext context) async {
  debugPrint("Number IS ; 62${membernear.phone?.substring(1)}");
  final url = Platform.isIOS
      ? "whatsapp://send?phone=62${membernear.phone?.substring(1)}"
      : "https://wa.me/62${membernear.phone?.substring(1)}";
  final uri = Uri.parse(url);

  if (!await launchUrl(uri)) {
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    ShowSnackbar.snackbar(
        // ignore: use_build_context_synchronously
        context,
        'Nomor ini tidak bisa dihubungi',
        isSuccess: false);
  }
}
