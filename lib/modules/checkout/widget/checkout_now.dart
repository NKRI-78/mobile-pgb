part of '../view/checkout_page.dart';

class CheckoutNow extends StatefulWidget {
  const CheckoutNow({super.key});

  @override
  State<CheckoutNow> createState() => _CheckoutNowState();
}

class _CheckoutNowState extends State<CheckoutNow> {
  int counterInit = 1;
  int minValue = 1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        String from = "0";
        String thru = "0";

        var shipping =
            state.shippings?[state.checkoutNow?.data?.store?.id.toString()];

        if (shipping != null && shipping['courier_code'] == "jne") {
          from = shipping['etd_from'];
          thru = shipping['etd_thru'];
        }
        if (shipping != null && shipping['duration'] != null) {
          final etdParts = shipping['duration'].toString().split("-");
          if (etdParts.length == 2) {
            from = etdParts[0].trim();
            thru = etdParts[1].trim();
          }
        }

        // String from = state
        //         .shippings?[state.checkoutNow?.data?.store?.id.toString()]
        //             ['etd']
        //         .toString()
        //         .split("-")[0]
        //         .trim() ??
        //     "0";
        // String thru = state
        //         .shippings?[state.checkoutNow?.data?.store?.id.toString()]
        //             ['etd']
        //         .toString()
        //         .split("-")[1]
        //         .trim() ??
        //     "0";
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
                    ImageAvatar(
                        image: state.checkoutNow?.data?.store?.linkPhoto ?? "-",
                        radius: 15),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      state.checkoutNow?.data?.store?.name ?? "",
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    ImageCard(
                                        image: (state.checkoutNow?.data
                                                    ?.pictures?.isEmpty ??
                                                false)
                                            ? ""
                                            : state.checkoutNow?.data?.pictures
                                                    ?.first.link ??
                                                "",
                                        height: 80,
                                        radius: 10,
                                        width: 80,
                                        imageError: imageDefaultData),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            state.checkoutNow?.data?.name ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSizeDefault),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${Price.currency(state.checkoutNow?.data?.price?.toDouble() ?? 0)} x ${state.checkoutNow?.qty}',
                                            style: const TextStyle(
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.bold,
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
                    ),
                  ],
                ),
              ),
              Divider(
                color: AppColors.blackColor.withOpacity(0.2),
                height: 5,
                thickness: 1,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(5.0),
                onTap: state.loadingCost
                    ? null
                    : () async {
                        if (context.mounted) {
                          context.read<CheckoutCubit>().getCostItemV2(
                              context: context,
                              storeId: state.checkoutNow?.data?.store?.id
                                      .toString() ??
                                  "",
                              weight:
                                  state.checkoutNow?.data?.weight.toString() ??
                                      "");
                        }
                      },
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        state.shippings?[state.checkoutNow?.data?.store?.id
                                    .toString()] ==
                                null
                            ? const SizedBox.shrink()
                            : CachedNetworkImage(
                                imageUrl: shipping['logo_url'] ?? "",
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
                            state.loadingCost
                                ? "Loading..."
                                : shipping == null
                                    ? 'PILIH PENGIRIMAN'
                                    : '${Helper().getCourierServiceDisplay(shipping)} | ${Price.currency(int.tryParse(shipping['cost']?.toString() ?? shipping['price']?.toString() ?? '0')?.toDouble() ?? 0.0)} \nEstimasi tiba ${Helper.getEstimatedDateRange(from, thru)}',
                            style: const TextStyle(
                              fontSize: fontSizeSmall,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 2,
                            child: Icon(Icons.keyboard_arrow_right,
                                color: AppColors.blackColor))
                      ],
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
