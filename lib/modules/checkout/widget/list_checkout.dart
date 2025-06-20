part of '../view/checkout_page.dart';

class ListCheckout extends StatefulWidget {
  const ListCheckout({super.key, required this.cart});

  final CheckoutDetailModel cart;

  @override
  State<ListCheckout> createState() => _ListCheckoutState();
}

class _ListCheckoutState extends State<ListCheckout> {
  int counterInit = 1;
  int minValue = 1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        double totalWeight = widget.cart.carts?.fold(0.0, (sum, cart) {
              return sum! + ((cart.product?.weight ?? 0) * cart.quantity!);
            }) ??
            0;
        double totalPrice = widget.cart.carts?.fold(0.0, (sum, cart) {
              return sum! + ((cart.product?.price ?? 0) * cart.quantity!);
            }) ??
            0;
        double totalCost = state.shippings?.values.fold(
              0.0,
              (sum, item) =>
                  sum! +
                  (int.tryParse(item["cost"]?.toString() ??
                              item["price"]?.toString() ??
                              '0')
                          ?.toDouble() ??
                      0.0),
            ) ??
            0.0;

        print("Total Cost: $totalCost");

        double total = totalPrice + totalCost;
        final shipping = state.shippings?[widget.cart.id.toString()];

        String from = "0";
        String thru = "0";

        if (shipping != null && shipping['etd'] != null) {
          final etdParts = shipping['etd'].toString().split("-");
          if (etdParts.length == 2) {
            from = etdParts[0].trim();
            thru = etdParts[1].trim();
          }
        }
        if (shipping != null && shipping['duration'] != null) {
          final etdParts = shipping['duration'].toString().split("-");
          if (etdParts.length == 2) {
            from = etdParts[0].trim();
            thru = etdParts[1].trim();
          }
        }

        print(state.shippings);
        return Container(
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.blackColor.withValues(alpha: 0.2))),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageAvatar(image: widget.cart.linkPhoto ?? "", radius: 15),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.cart.name ?? "",
                      style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: fontSizeDefault,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.cart.carts!
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          ImageCard(
                                            image:
                                                (e.product?.pictures?.isEmpty ??
                                                        false)
                                                    ? ""
                                                    : e.product?.pictures?.first
                                                            .link ??
                                                        "",
                                            height: 80,
                                            radius: 10,
                                            width: 80,
                                            imageError: imageDefaultBanner,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  e.product?.name ?? "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          fontSizeDefault),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  '${Price.currency(e.price?.toDouble() ?? 0)} x ${e.quantity}',
                                                  style: const TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: fontSizeSmall),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              Divider(
                color: AppColors.blackColor.withOpacity(0.2),
                height: 5,
                thickness: 1,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(5.0),
                onTap: () async {
                  if (context.mounted) {
                    context.read<CheckoutCubit>().getCostItemV2(
                          context: context,
                          storeId: widget.cart.id.toString(),
                          weight: totalWeight.toString(),
                        );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      state.shippings?[widget.cart.id.toString()] == null
                          ? const SizedBox.shrink()
                          : CachedNetworkImage(
                              imageUrl:
                                  state.shippings![widget.cart.id.toString()]
                                          ['logo_url'] ??
                                      "",
                              width: 40,
                              height: 40,
                              placeholder: (context, url) => const SizedBox(
                                width: 40,
                                height: 40,
                                child: Center(child: CustomLoadingPage()),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.local_shipping),
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 12,
                        child: Text(
                          state.shippings?[widget.cart.id.toString()] == null
                              ? 'PILIH PENGIRIMAN'
                              : '${Helper().getCourierServiceDisplay(state.shippings![widget.cart.id.toString()])} | ${Price.currency(int.tryParse(state.shippings![widget.cart.id.toString()]['cost']?.toString() ?? state.shippings![widget.cart.id.toString()]['price']?.toString() ?? '0')?.toDouble() ?? 0.0)} \nEstimasi tiba ${Helper.getEstimatedDateRange(from, thru)}',
                          style: const TextStyle(
                              fontSize: fontSizeSmall,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: AppColors.blackColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
