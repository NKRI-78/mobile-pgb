import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/location.dart';
import '../../../misc/text_style.dart';
import '../cubit/sos_page_cubit.dart';

class SosDetailPage extends StatelessWidget {
  const SosDetailPage({
    super.key,
    // required this.isLoggedIn,
    required this.sosType,
    required this.message,
  });

  // final bool isLoggedIn;
  final String sosType;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SosDetailView(
      // isLoggedIn: isLoggedIn,
      sosType: sosType,
      message: message,
    );
  }
}

class SosDetailView extends StatelessWidget {
  const SosDetailView({
    super.key,
    // required this.isLoggedIn,
    required this.sosType,
    required this.message,
  });

  // final bool isLoggedIn;
  final String sosType;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Kirim SOS',
          style: AppTextStyles.textStyleBold,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.blackColor,
            size: 24,
          ),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.redColor,
              ),
              child: const Icon(
                Icons.warning,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(sosType, style: AppTextStyles.textStyleBold),
            Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: ConfirmationSlider(
                foregroundColor: AppColors.greyColor,
                text: 'Geser untuk mengirim',
                onConfirmation: () async {
                  debugPrint("Confirm");

                  var position = await determinePosition(context);

                  debugPrint('Position: $position');

                  if (context.mounted) {
                    buildAgreementDialog(context, sosType, message);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future buildAgreementDialog(
      BuildContext context, String title, String message) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BlocProvider.value(
          value: getIt<SosCubit>(),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Center(
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
                            'Sebar Berita?',
                            style: AppTextStyles.textStyleBold.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Anda akan dihubungi pihak berwenang\napabila menyalahgunakan SOS\ntanpa tujuan dan informasi yang benar',
                            style: AppTextStyles.textStyleNormal.copyWith(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<SosCubit, SosState>(
                            builder: (context, state) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: state.isLoading
                                          ? null
                                          : () => Navigator.of(context).pop(),
                                      child: Text(
                                        'Batal',
                                        style: AppTextStyles.textStyleNormal
                                            .copyWith(
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: state.isLoading
                                          ? null
                                          : () {
                                              context.read<SosCubit>().sendSos(
                                                    title,
                                                    message,
                                                    context,
                                                  );
                                            },
                                      child: state.isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              'Kirim',
                                              style: AppTextStyles
                                                  .textStyleNormal
                                                  .copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -60,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/ic-alert.png',
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }
        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
