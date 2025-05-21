import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:mobile_pgb/misc/theme.dart';
import 'package:mobile_pgb/modules/update_shipping_address/cubit/update_shipping_address_cubit.dart';
import 'package:mobile_pgb/widgets/button/custom_button.dart';
import 'package:mobile_pgb/widgets/header/header_section.dart';
import 'package:mobile_pgb/widgets/map/custom_select_location.dart';
import 'package:mobile_pgb/widgets/map/custom_select_map_location.dart';
import 'package:mobile_pgb/widgets/pages/empty_page.dart';
import 'package:mobile_pgb/widgets/pages/loading_page.dart';

part '../widgets/_input_location.dart';
part '../widgets/_input_location_lebel.dart';
part '../widgets/_input_name.dart';
part '../widgets/_input_phone.dart';
part '../widgets/_input_detail_address.dart';
part '../widgets/input_label.dart';

class UpdateAddressPage extends StatelessWidget {
  const UpdateAddressPage({super.key, this.idAddress});

  final String? idAddress;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateShippingAddressCubit>(
      create: (context) => UpdateShippingAddressCubit()..fetchDetailAddress(idAddress ?? "0"),
      child: const UpdateAddressView(),
    );
  }
}

class UpdateAddressView extends StatefulWidget {
  const UpdateAddressView({super.key});

  @override
  State<UpdateAddressView> createState() => _UpdateAddressViewState();
}

class _UpdateAddressViewState extends State<UpdateAddressView> {
  bool defaultLocation = false;
  bool isCheck = true;
  List<String> typePlace = ['Rumah', 'Kantor', 'Apartement', 'Kos'];

  late TextEditingController typeAddressC;

  @override
  void initState() {
    super.initState();
    typeAddressC = TextEditingController();
  }

  @override
  void dispose() {
    typeAddressC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateShippingAddressCubit, UpdateShippingAddressState>(
      builder: (context, state) {
        final TextEditingController ctrName = TextEditingController(text: state.nameAddress);
        final TextEditingController ctrPhone = TextEditingController(text: state.phoneNumber);
        typeAddressC.text = state.label;
        final TextEditingController ctrCurrentAddress = TextEditingController(text: state.currentAddress);
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              const HeaderSection(titleHeader: "Ubah Alamat"),
              state.loading
                    ? const SliverFillRemaining(
                        child: Center(child: CustomLoadingPage()),
                      )
                    : state.detailAddress == null
                        ? const SliverFillRemaining(
                            child: Center(
                                child: EmptyPage(msg: "Alamat tidak ditemukan")))
                        : SliverList.list(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Nama Penerima",
                                style: TextStyle(
                                  fontSize: fontSizeDefault,
                                )),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(6.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1.0,
                                        blurRadius: 3.0,
                                        offset: const Offset(0.0, 1.0))
                                  ],
                                ),
                                child: TextFormField(
                                    controller: ctrName,
                                    cursorColor: AppColors.blackColor,
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.sentences,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.singleLineFormatter
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: "Nama Penerima",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 15.0),
                                      isDense: true,
                                      hintStyle: TextStyle(color: AppColors.blackColor),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey, width: 0.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey, width: 0.5),
                                      ),
                                    ),
                                  ),
                              )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Phone",
                                style: TextStyle(
                                  fontSize: fontSizeDefault,
                                )),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(6.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 1.0,
                                          blurRadius: 3.0,
                                          offset: const Offset(0.0, 1.0))
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: ctrPhone,
                                    cursorColor: AppColors.blackColor,
                                    maxLength: 13,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.singleLineFormatter
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: "Phone",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 15.0),
                                      isDense: true,
                                      hintStyle: TextStyle(color: AppColors.blackColor),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey, width: 0.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey, width: 0.5),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Label Alamat",
                                style: TextStyle(
                                  fontSize: fontSizeDefault,
                                )),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(6.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 1.0,
                                          blurRadius: 3.0,
                                          offset: const Offset(0.0, 1.0))
                                    ],
                                  ),
                                  child: TextFormField(
                                    onTap: () {
                                      setState(() {
                                        isCheck = false;
                                      });
                                    },
                                    cursorColor: AppColors.blackColor,
                                    controller: typeAddressC,
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.sentences,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.singleLineFormatter
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: "Ex: Rumah",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 15.0),
                                      isDense: true,
                                      hintStyle: TextStyle(color: AppColors.blackColor),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey, width: 0.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey, width: 0.5),
                                      ),
                                    ),
                                  ),
                                )),
                            isCheck
                                ? const SizedBox()
                                : Container(
                                    height: 35.0,
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        ...typePlace.map((e) => GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  print("Select $e");
                                                  isCheck = true;
                                                  typeAddressC.text = e;
                                                  var cubit = context.read<UpdateShippingAddressCubit>();
                                                  cubit.copyState(newState: cubit.state.copyWith(label: e));
                                                });
                                              },
                                              child: Container(
                                                  height: 20,
                                                  padding: const EdgeInsets.all(8),
                                                  margin: const EdgeInsets.only(right: 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(35),
                                                      color: AppColors.whiteColor,
                                                      border: Border.all(
                                                          color: Colors.grey[350]!)),
                                                  child: Center(
                                                      child: Text(e,
                                                          style: TextStyle(
                                                            color: AppColors.whiteColor,
                                                            fontSize: 14,
                                                          )))),
                                            ))
                                      ],
                                    )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
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
                                  // Memanggil widget pemilihan lokasi
                                  var data =
                                      await CustomSelectLocationWidget.go(
                                    context,
                                    administration:
                                        state.selectedAdministration,
                                  );

                                  // Jika data lokasi dipilih, perbarui state dengan Cubit
                                  if (data != null && context.mounted) {
                                    context
                                        .read<UpdateShippingAddressCubit>()
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
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _InputLocationLabel(),
                            const _InputLocation(),
                            Padding(
                              padding:  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Detail Alamat",
                                      style: TextStyle(
                                        fontSize: fontSizeDefault,
                                      )),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius: BorderRadius.circular(10.0)),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius: BorderRadius.circular(6.0),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                spreadRadius: 1.0,
                                                blurRadius: 3.0,
                                                offset: const Offset(0.0, 1.0))
                                          ],
                                        ),
                                        child: TextFormField(
                                          minLines: 3,
                                          maxLines: 5,
                                          cursorColor: AppColors.blackColor,
                                          controller: ctrCurrentAddress,
                                          keyboardType: TextInputType.text,
                                          textCapitalization: TextCapitalization.sentences,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.singleLineFormatter
                                          ],
                                          decoration: const InputDecoration(
                                            hintText: "Detail Alamat",
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 12.0, horizontal: 15.0),
                                            isDense: true,
                                            hintStyle: TextStyle(color: AppColors.blackColor),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.grey, width: 0.5),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.grey, width: 0.5),
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: CustomButton(
                            backgroundColour: AppColors.secondaryColor,
                            onPressed: state.loading
                                ? null
                                : () async {
                                    if (context.mounted) {
                                      FocusScope.of(context).unfocus();
                                    }
                                    context.read<UpdateShippingAddressCubit>().submit(
                                      context: context,
                                      currentAddress: ctrCurrentAddress.text,
                                      label: typeAddressC.text,
                                      name: ctrName.text,
                                      phoneNumber: ctrPhone.text,
                                    );
                                  },
                            textColour: AppColors.whiteColor,
                            text: "Ubah Alamat"),
                      )
                    ])
            ],
          ),
        );
      },
    );
  }
}
