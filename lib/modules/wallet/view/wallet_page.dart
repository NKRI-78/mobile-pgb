import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../misc/colors.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/text_style.dart';
import '../cubit/wallet_cubit.dart';
import '../models/top_up_model.dart';

part '../widget/_field_nominal.dart';
part '../widget/_grid_denom.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletCubit()..fetchProfile(),
      child: WalletView(),
    );
  }
}

class WalletView extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, st) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? MediaQuery.of(context).viewInsets.bottom
                  : 10,
              left: 20,
              right: 20,
            ),
            child: SafeArea(
              top: false,
              child: InkWell(
                onTap: () {
                  context.read<WalletCubit>().checkTopUp(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "Lanjut Bayar",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.primaryColor,
                surfaceTintColor: Colors.transparent,
                pinned: true,
                elevation: 2,
                title: Text(
                  'Top Up',
                  style: AppTextStyles.textStyleBold,
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              height: 70,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Member Name",
                                          style: AppTextStyles.textStyleNormal
                                              .copyWith(
                                            fontSize: 10,
                                          ),
                                        ),
                                        st.profile?.profile?.fullname == null
                                            ? Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade100,
                                                child: Container(
                                                  width: 100,
                                                  height: 14,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                st.profile?.profile?.fullname ??
                                                    "",
                                                style: AppTextStyles
                                                    .textStyleBold
                                                    .copyWith(
                                                  fontSize: 12,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 40,
                                    color: AppColors.greyColor
                                        .withValues(alpha: 0.5),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Saldo e-Wallet",
                                          style: AppTextStyles.textStyleNormal
                                              .copyWith(
                                            fontSize: 10,
                                          ),
                                        ),
                                        st.profile?.balance == null
                                            ? Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade100,
                                                child: Container(
                                                  width: 80,
                                                  height: 16,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                Price.currency(st
                                                        .profile?.balance
                                                        .toDouble() ??
                                                    0),
                                                style: AppTextStyles
                                                    .textStyleBold
                                                    .copyWith(
                                                  fontSize: 14,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      _GridDenom(
                        controller: controller,
                      ),
                      _FieldNominal(
                        controller: controller,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
