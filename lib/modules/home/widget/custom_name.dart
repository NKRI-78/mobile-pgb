import 'package:flutter/material.dart';

import '../../../misc/colors.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/text_style.dart';
import '../../../router/builder.dart';

class CustomName extends StatelessWidget {
  final bool isLoggedIn;
  final String? fullname;
  final String? balance;
  const CustomName({
    super.key,
    required this.isLoggedIn,
    required this.fullname,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  isLoggedIn
                      ? 'Hello, ${formatFullname(fullname ?? '')}'
                      : 'Selamat Datang,',
                  style: AppTextStyles.textStyleBold.copyWith(
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  maxLines: 2,
                ),
              ),
              isLoggedIn
                  ? ElevatedButton(
                      onPressed: () {
                        WalletRoute().push(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        backgroundColor: AppColors.secondaryColor,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size(0, 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'Saldo e-Wallet',
                        style: AppTextStyles.textStyleNormal.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        RegisterRoute().go(context);
                      },
                      icon: Icon(
                        Icons.login_outlined,
                        size: 14,
                        color: AppColors.whiteColor,
                      ),
                      label: Text("Login"),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        backgroundColor: AppColors.secondaryColor,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size(0, 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        textStyle: AppTextStyles.textStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(height: 4),
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
                isLoggedIn && balance != null
                    ? Price.currency(double.tryParse(balance ?? '0') ?? 0)
                    : '',
                style: AppTextStyles.textStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatFullname(String name) {
    return name
        .toLowerCase()
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }
}
