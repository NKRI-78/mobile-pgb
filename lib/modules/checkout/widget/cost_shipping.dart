import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pgb/misc/helper.dart';
import '../../../misc/colors.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/theme.dart';
import '../cubit/checkout_cubit.dart';

class CostShipping extends StatelessWidget {
  const CostShipping({super.key, required this.idStore, required this.weight});

  final String idStore;
  final String weight;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        double gramsToKilograms(double grams) {
          return grams / 1000;
        }

        const Map<String, String> serviceDisplayMap = {
          'REG': 'Reguler',
          'JTR': 'JNE Trucking Reguler',
          'JTR<130': 'JNE Trucking < 130 kg',
          'JTR>130': 'JNE Trucking > 130 kg',
          'JTR>200': 'JNE Trucking > 200 kg',
          'CTC': 'City Courier',
          'CTCYES': 'City Courier YES',
          'CTCSPS': 'City Courier SPS',
        };

        String getServiceDisplayName(String code) {
          return serviceDisplayMap[code] ?? code; // fallback ke kode asli kalau tidak dikenali
        }

        print(weight);
        return Scaffold(
          body: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        textScaler: const TextScaler.linear(1.5),
                        textAlign: TextAlign.left,
                        text: TextSpan(children: [
                          WidgetSpan(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Image.asset(
                                  "assets/icons/close-icon-ractangle.png",
                                  width: 20,
                                  height: 20,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(
                              text: "Pilih Pengiriman",
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: fontSizeLarge,
                                  fontWeight: FontWeight.bold))
                        ])),
                  ],
                ),
              ),
              // Container(
              //   width: double.infinity,
              //   height: 50,
              //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: AppColors.greyColor, width: 5, strokeAlign: 1)
              //   ),
              //   child: Text(
              //     "Berat ${gramsToKilograms(double.parse(weight))} kg"
              //   ),
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: state.cost
                    .map((e) => InkWell(
                          onTap: () {
                            context.read<CheckoutCubit>().setCourier(
                                  getServiceDisplayName(e.serviceDisplay ?? ""),
                                  e.price ?? "",
                                  "${e.etdFrom} - ${e.etdThru}",
                                  idStore,
                                  "jne",
                                  "",
                                );
                            Navigator.pop(context);
                            context.read<CheckoutCubit>().updateCheckout(
                                checkout: state.checkout,
                                shippings: state.shippings);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                    '${getServiceDisplayName(e.serviceDisplay ?? "")} ( ${Price.currency(int.parse(e.price ?? "0").toDouble())} )',
                                                style: const TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: fontSizeLarge,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ])),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                  text: TextSpan(children: [
                                                const TextSpan(
                                                    text: 'Estimasi tiba ',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blackColor,
                                                        fontSize: fontSizeLarge,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: Helper.getEstimatedDateRange(e.etdFrom ?? "0", e.etdThru ?? "0"),
                                                    style: const TextStyle(
                                                        color: AppColors
                                                            .blackColor,
                                                        fontSize: fontSizeLarge,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ])),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Image.asset(
                                      "assets/icons/logo-jne.png",
                                      width: 50,
                                      height: 50,
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                color:
                                    AppColors.greyColor.withValues(alpha: 0.5),
                                height: 3,
                                thickness: 1,
                              )
                            ],
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
        );
      },
    );
  }
}
