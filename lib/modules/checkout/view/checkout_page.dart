import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:mobile_pgb/misc/injections.dart';
import 'package:mobile_pgb/misc/price_currency.dart';
import 'package:mobile_pgb/misc/snackbar.dart';
import 'package:mobile_pgb/misc/theme.dart';
import 'package:mobile_pgb/modules/checkout/cubit/checkout_cubit.dart';
import 'package:mobile_pgb/modules/checkout/widget/card_address.dart';
import 'package:mobile_pgb/repositories/checkout_repository/models/checkout_detail_model.dart';
import 'package:mobile_pgb/router/builder.dart';
import 'package:mobile_pgb/widgets/button/custom_button.dart';
import 'package:mobile_pgb/widgets/header/header_section.dart';
import 'package:mobile_pgb/widgets/image/image_avatar.dart';
import 'package:mobile_pgb/widgets/image/image_card.dart';
import 'package:mobile_pgb/widgets/pages/empty_page.dart';
import 'package:mobile_pgb/widgets/pages/loading_page.dart'; 

part '../widget/list_checkout.dart';
part '../widget/checkout_now.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key, this.from = "", this.qty, this.productId});

  final String from;
  final String? qty;
  final String? productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: getIt<CheckoutCubit>()..init(context: context, from: from, qty: qty, productId: productId),
        child: CheckoutView(from: from,));
  }
}

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key, required this.from});

  final String from;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          bottomNavigationBar: state.loading ? null : state.checkout.isEmpty && state.checkoutNow?.data == null ? null : Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withOpacity(0.50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Total\n",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: fontSizeExtraLarge,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: '${Price.currency(state.totalPrice)}',
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: fontSizeExtraLarge,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ]
                  )
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: CustomButton(
                      backgroundColour: AppColors.secondaryColor,
                      onPressed: state.loading ? null : () async {
                        var cubit = context.read<CheckoutCubit>();
                        if (state.channel == null) {
                          ShowSnackbar.snackbar(context, "Silahkan pilih metode pembayaran", isSuccess: false);
                        } else {
                          try {
                            var paymentNumber = await cubit.checkoutItem();
                            if (context.mounted) {
                              WaitingPaymentRoute(id: paymentNumber).go(context);
                            } 
                          } catch (e) {
                            if (context.mounted) {
                              ShowSnackbar.snackbar(context, e.toString(), isSuccess: false);
                            }
                          }
                        }
                      },
                      textColour: AppColors.whiteColor,
                      text: "Checkout"),
                )
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await context.read<CheckoutCubit>().init(
                context: context,
                from: state.from,
                productId: state.productId,
                qty: state.qty,
              );
            },
            child: CustomScrollView(
              slivers: [
                const HeaderSection(titleHeader: "Checkout"),
                state.loading
                ? const SliverFillRemaining(
                    child: Center(child: CustomLoadingPage()),
                  )
                : (state.checkout.isEmpty && state.checkoutNow?.data == null)
                  ? const SliverFillRemaining(
                      child: Center(child: EmptyPage(msg: "Checkout Empty")))
                  :  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 50),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 15.0,),
                          child: BlocBuilder<CheckoutCubit, CheckoutState>(
                            builder: (context, state) {
                              final data = state.shipping?.data;
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Alamat Pengiriman",
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize:
                                                fontSizeSmall,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          AddressRoute().push(context);
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.location_pin,
                                              size: 15,
                                            ),
                                            Text(
                                              "Pilih Alamat",
                                              style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize:
                                                      fontSizeSmall,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if(state.shipping != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: CardAddress(
                                      data: data,
                                    ),
                                  )
                                  else 
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColors.blackColor,
                                          ),
                                          children: [
                                            const TextSpan(text: 'Anda belum menambahkan alamat, silahkan '),
                                            TextSpan(
                                              text: "tambah alamat baru",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.blueColor
                                              ),
                                                recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                CreateAddressRoute().push(context);
                                              }
                                            )
                                          ]
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        if(from == "CART")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: state.checkout
                              .map((e) => ListCheckout(
                                    cart: e,
                                  ))
                              .toList(),
                        )
                        else 
                        const CheckoutNow(),
                        BlocBuilder<CheckoutCubit, CheckoutState>(
                          builder: (context, state) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                                  child: InkWell(
                                    onTap: () {
                                      if(context.mounted){
                                        context.read<CheckoutCubit>().getPaymentChannel(
                                          context,
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.2))
                                      ),
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          state.channel != null ? 
                                            ImageCard(
                                                image: state.channel?.logo ?? "", 
                                                height: 40, 
                                                radius: 0, 
                                                width: 50, 
                                                imageError: imageDefaultData
                                            ) :
                                            const Icon(
                                              Icons.account_balance,
                                              size: 40,
                                              color: AppColors.blackColor,
                                            ),
                                          Expanded(
                                            child: Text(
                                              state.loadingChannel ? "Loading..." : state.channel != null
                                                  ?  "${state.channel?.name == "Saldo" ? "PGB  Wallet" : state.channel?.name} ${state.channel?.paymentType == "APP" ? 
                                                  '( ${Price.currency(state.channel?.user?.balance?.toDouble() ?? 0)} )' : ""}"
                                                  : 'Pilih metode pembayaran',
                                              textAlign: TextAlign.end,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: fontSizeDefault,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          const Icon(Icons.arrow_circle_right)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Container(
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.2))
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Rincian Pembayaran",
                                    style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: fontSizeDefault,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const Divider(thickness: .3, color: AppColors.blackColor,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Harga Produk",
                                          style: TextStyle(
                                            fontSize: fontSizeDefault,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(Price.currency(state.totalPriceProduct),
                                          style: const TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: fontSizeDefault,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  state.totalCost == 0 ? Container() : Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Biaya Ongkir",
                                          style: TextStyle(
                                            fontSize: fontSizeDefault,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(Price.currency(state.totalCost),
                                          style: const TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: fontSizeDefault,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  state.adminFee == 0 ? Container() : Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Biaya Admin",
                                          style: TextStyle(
                                            fontSize: fontSizeDefault,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(Price.currency(state.adminFee),
                                          style: const TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: fontSizeDefault,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Total Pembayaran",
                                          style: TextStyle(
                                            fontSize: fontSizeDefault,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(Price.currency(state.totalPrice),
                                          style: const TextStyle(
                                            fontSize: fontSizeDefault,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ),
                      ]
                    )
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
