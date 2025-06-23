import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../misc/colors.dart';
import '../../../misc/theme.dart';
import '../cubit/create_shipping_address_cubit.dart';
import '../../../widgets/button/custom_button.dart';
import '../../../widgets/header/header_section.dart';
import '../../../widgets/map/custom_select_location.dart';
import '../../../widgets/map/custom_select_map_location.dart';

part '../widgets/_input_location.dart';
part '../widgets/_input_location_lebel.dart';
part '../widgets/_input_name.dart';
part '../widgets/_input_phone.dart';
part '../widgets/_input_detail_address.dart';
part '../widgets/input_label.dart';

class CreateAddressPage extends StatelessWidget {
  const CreateAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateShippingAddressCubit>(
      create: (context) => CreateShippingAddressCubit(),
      child: const CreateAddressView(),
    );
  }
}

class CreateAddressView extends StatelessWidget {
  const CreateAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateShippingAddressCubit, CreateShippingAddressState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: CustomScrollView(
            slivers: [
              const HeaderSection(titleHeader: "Tambah Alamat"),
              SliverList.list(
                children: [
                  const InputName(),
                  const InputPhone(),
                  const InputLabel(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text("Daerah/Wilayah",
                              style: TextStyle(
                                fontSize: fontSizeDefault,
                              )),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1.0,
                                  blurRadius: 3.0,
                                  offset: const Offset(0.0, 1.0))
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              if (context.mounted) {
                                FocusScope.of(context).unfocus();
                              }
                              var data = await CustomSelectLocationWidget.go(
                                context,
                                administration: state.selectedAdministration,
                              );

                              // Jika data lokasi dipilih, perbarui state dengan Cubit
                              if (data != null && context.mounted) {
                                context
                                    .read<CreateShippingAddressCubit>()
                                    .updateShopAddress(
                                      province: data.province.name,
                                      city: data.city.name,
                                      subDistrict: data.subDistrict.name,
                                      postalCode: data.postalCode.name,
                                      district: data.district.name,
                                    );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      state.city != ""
                                          ? '${state.province} ${state.city} ${state.district} ${state.postalCode}'
                                          : "Pilih Alamat",
                                      style: const TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 14),
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        size: 20,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InputLocationLabel(),
                        _InputLocation(),
                        // Container(
                        //   margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        //   decoration: BoxDecoration(
                        //     color: whiteColor,
                        //     borderRadius: BorderRadius.circular(10),
                        //     border: Border.all(color: blackColor.withOpacity(0.2))
                        //   ),
                        //   child: const Row(
                        //     children: [
                        //       Icon(
                        //         Icons.location_on,
                        //         size: 20,
                        //       )
                        //     ],
                        //   ),
                        // ),
                        InputDetailAddress()
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(
              onPressed: state.loading
                  ? null
                  : () async {
                      if (context.mounted) {
                        FocusScope.of(context).unfocus();
                      }
                      context
                          .read<CreateShippingAddressCubit>()
                          .submit(context: context);
                    },
              backgroundColour: AppColors.blueColor,
              textColour: AppColors.whiteColor,
              text: "Tambah Alamat",
            ),
          ),
        );
      },
    );
  }
}
