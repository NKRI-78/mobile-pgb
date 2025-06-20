import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../misc/text_style.dart';
import '../../../misc/helper.dart';
import '../../../misc/price_currency.dart';
import '../cubit/checkout_cubit.dart';

class CostShipping extends StatelessWidget {
  const CostShipping({super.key, required this.idStore, required this.weight});

  final String idStore;
  final String weight;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        const Map<String, String> serviceDisplayMap = {
          'REG': 'JNE Reguler',
          'JTR': 'JNE Trucking Reguler',
          'JTR<130': 'JNE Trucking < 130',
          'JTR>130': 'JNE Trucking > 130',
          'JTR>200': 'JNE Trucking > 200',
          'CTC': 'JNE Reguler',
          'CTCYES': 'JNE Reguler YES',
          'CTCSPS': 'JNE Reguler OKE',
          'YES': 'JNE Reguler YES',
          'SPS': 'JNE Reguler OKE',
        };

        String getServiceDisplayName(String code) {
          return serviceDisplayMap[code] ?? code;
        }

        return Scaffold(
          body: ListView(
            children: [
              // ======== Header ========
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Pilih Pengiriman",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey.shade300,
              ),

              // ======== Instant Courier (Gojek/Grab) ========
              if (state.costV3.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'Kurir Instant',
                    style: AppTextStyles.textStyleBold,
                  ),
                ),
                ...state.costV3.map((costItem) {
                  return InkWell(
                    onTap: () {
                      context.read<CheckoutCubit>().setInstant(
                            costItem,
                            idStore,
                            note: '',
                          );
                      final ct = context.read<CheckoutCubit>();
                      ct.copyState(
                          newState: ct.state.copyWith(typeShipping: "Instant"));
                      Navigator.pop(context);
                      context.read<CheckoutCubit>().updateCheckout(
                            checkout: state.checkout,
                            shippings: state.shippings,
                          );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${costItem.courierServiceName} (${Price.currency((costItem.price ?? 0).toDouble())})',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Estimasi ${getDurationInBahasa(costItem.duration)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          (costItem.logoUrl != null)
                              ? Image.network(
                                  costItem.logoUrl!,
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.local_shipping),
                                )
                              : const Icon(Icons.local_shipping),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
              Divider(
                height: 1,
                color: Colors.grey.shade300,
              ),

              // ======== Regular Courier (JNE/Sicepat) ========
              if (state.cost.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'Kurir Reguler',
                    style: AppTextStyles.textStyleBold,
                  ),
                ),
                ...state.cost.map((e) {
                  return InkWell(
                    onTap: () {
                      context.read<CheckoutCubit>().setCourier(
                          e.serviceDisplay ?? "",
                          getServiceDisplayName(e.serviceDisplay ?? ""),
                          e.price ?? "",
                          "${e.etdFrom} - ${e.etdThru}",
                          idStore,
                          "jne",
                          "",
                          e.logoUrl ?? "");
                      Navigator.pop(context);
                      context.read<CheckoutCubit>().updateCheckout(
                            checkout: state.checkout,
                            shippings: state.shippings,
                          );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${getServiceDisplayName(e.serviceDisplay ?? "")} (${Price.currency(int.parse(e.price ?? "0").toDouble())})',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Estimasi ${Helper.getEstimatedDateRange(e.etdFrom ?? "0", e.etdThru ?? "0")}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          (e.logoUrl != null)
                              ? Image.network(
                                  e.logoUrl!,
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.local_shipping),
                                )
                              : const Icon(Icons.local_shipping),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
              Divider(
                height: 1,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        );
      },
    );
  }
}

String getDurationInBahasa(String? duration) {
  if (duration == null || duration.isEmpty) return "-";

  String result = duration;

  result = result.replaceAll(RegExp(r'hours?', caseSensitive: false), 'jam');
  result = result.replaceAll(RegExp(r'days?', caseSensitive: false), 'hari');
  result =
      result.replaceAll(RegExp(r'minutes?', caseSensitive: false), 'menit');
  result = result.replaceAll(RegExp(r'soon', caseSensitive: false), 'Segera');

  return result.trim();
}
