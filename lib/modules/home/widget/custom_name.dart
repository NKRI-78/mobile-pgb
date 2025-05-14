import 'package:flutter/material.dart';
import '../../../router/builder.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';

class CustomName extends StatelessWidget {
  final bool isLoggedIn;
  const CustomName({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isLoggedIn ? 'Hello, Hernan' : 'Selamat Datang,',
                style: AppTextStyles.textStyleBold,
              ),
              isLoggedIn
                  ? Text(
                      'Saldo e-Wallet',
                      style: AppTextStyles.textStyleNormal.copyWith(
                        color: AppColors.greyColor,
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        RegisterRoute().go(context);
                      },
                      icon: Icon(
                        Icons.login,
                        size: 14,
                        color: AppColors.whiteColor,
                      ),
                      label: Text("Login"),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        backgroundColor: AppColors.secondaryColor,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size(0, 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: AppTextStyles.textStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Partai Gema Bangsa',
                style: AppTextStyles.textStyleNormal.copyWith(
                  color: AppColors.greyColor,
                ),
              ),
              Text(
                isLoggedIn ? 'Rp 1.000.000' : '',
                style: AppTextStyles.textStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
