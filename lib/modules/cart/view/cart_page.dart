// import 'package:cart_stepper/cart_stepper.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:mobile_pgb/misc/custom_cart_stepper.dart';
import 'package:mobile_pgb/misc/price_currency.dart';
import 'package:mobile_pgb/misc/theme.dart';
import 'package:mobile_pgb/modules/cart/cubit/cart_cubit.dart';
import 'package:mobile_pgb/repositories/cart_repository/models/cart_model.dart';
import 'package:mobile_pgb/router/builder.dart';
import 'package:mobile_pgb/widgets/button/custom_button.dart';
import 'package:mobile_pgb/widgets/header/header_section.dart';
import 'package:mobile_pgb/widgets/image/image_avatar.dart';
import 'package:mobile_pgb/widgets/image/image_card.dart';
import 'package:mobile_pgb/widgets/pages/empty_page.dart';
import 'package:mobile_pgb/widgets/pages/loading_page.dart';

part '../widgets/list_product.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>(
        create: (context) => CartCubit()..fetchCart(context),
        child: const CartView());
  }
}

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(builder: (context, state) {
      final total = context.watch<CartCubit>().totalSelectedPrice;
      final hasSelected = context.watch<CartCubit>().hasSelectedItems;
      return Scaffold(
        backgroundColor: AppColors.primaryColor,
        bottomNavigationBar: state.loading
            ? null
            : state.cart.isEmpty
                ? null
                : SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color:
                            AppColors.whiteColor.withAlpha((0.5 * 255).round()),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          total == 0
                              ? Container()
                              : RichText(
                                  text: TextSpan(children: [
                                  const TextSpan(
                                      text: "Total\n",
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: fontSizeExtraLarge,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          '${Price.currency(total.toDouble())}',
                                      style: const TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: fontSizeExtraLarge,
                                          fontWeight: FontWeight.bold))
                                ])),
                          SizedBox(
                            width: 150,
                            height: 50,
                            child: CustomButton(
                              backgroundColour: AppColors.secondaryColor,
                              onPressed: hasSelected
                                  ? () {
                                      CheckoutRoute(from: "CART").push(context);
                                    }
                                  : null,
                              text: "Next",
                              textColour: AppColors.whiteColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
        body: RefreshIndicator(
          onRefresh: () async {
            await context.read<CartCubit>().fetchCart(context);
          },
          child: CustomScrollView(
            slivers: [
              const HeaderSection(titleHeader: "Keranjang Saya"),
              state.loading
                  ? const SliverFillRemaining(
                      child: Center(child: CustomLoadingPage()),
                    )
                  : state.cart.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                              child: EmptyPage(msg: "Keranjang anda kosong")))
                      : SliverList(
                          delegate: SliverChildListDelegate([
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: state.cart
                                .map((e) => ListProduct(
                                      cart: e,
                                    ))
                                .toList(),
                          )
                        ])),
            ],
          ),
        ),
      );
    });
  }
}
