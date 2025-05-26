import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../misc/colors.dart';
import '../../../misc/snackbar.dart';
import '../../../misc/theme.dart';
import '../cubit/list_address_cubit.dart';
import '../../../repositories/list_address_repository/models/address_list_model.dart';
import '../../../router/builder.dart';
import '../../../widgets/button/custom_button.dart';

class CardListAddress extends StatelessWidget {
  const CardListAddress({
    super.key,
    required this.addressList,
  });

  final AddressListModel addressList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: AppColors.blueColor, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      IntrinsicWidth(
                        child: Text(
                          addressList.label ?? "",
                          style: const TextStyle(
                              color: AppColors.blueColor,
                              fontSize: fontSizeLarge,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (addressList.isSelected ?? false)
                        IntrinsicWidth(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 8),
                            decoration: BoxDecoration(
                              color: AppColors.blueColor, // Background color
                              borderRadius:
                                  BorderRadius.circular(5), // Rounded corners
                            ),
                            child: const Text(
                              "UTAMA",
                              style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: fontSizeSmall,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  addressList.name ?? "",
                  style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: fontSizeSmall,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  addressList.phoneNumber ?? "",
                  style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: fontSizeSmall,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${addressList.address?.province} ${addressList.address?.city} ${addressList.address?.district} ${addressList.address?.postalCode}',
                  style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: fontSizeSmall,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "( ${addressList.address?.detailAddress ?? ""} )",
                    style: const TextStyle(
                        color: AppColors.blackColor,
                        fontSize: fontSizeSmall,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: CustomButton(
                          backgroundColour: AppColors.buttonBlueColor,
                          onPressed: () {
                            UpdateAddressRoute(
                                    idAddress: addressList.id.toString())
                                .push(context);
                          },
                          text: "Ubah Alamat",
                          textColour: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    addressList.isSelected == false
                        ? Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: double.infinity,
                              child: PopupMenuButton(
                                color: AppColors.whiteColor,
                                iconColor: AppColors.blueColor,
                                iconSize: 20,
                                icon: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: AppColors.blueColor)),
                                  child: Icon(Icons.more_horiz),
                                ),
                                itemBuilder: (BuildContext buildContext) {
                                  return [
                                    const PopupMenuItem(
                                        value: "/selectMain",
                                        child: Text(
                                            "Jadikan Alamat Utama & Pilih",
                                            style: TextStyle(
                                                color: AppColors.greyColor,
                                                fontSize: fontSizeSmall,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SF Pro'))),
                                    const PopupMenuItem(
                                        value: "/delete",
                                        child: Text("Hapus Alamat",
                                            style: TextStyle(
                                                color: AppColors.greyColor,
                                                fontSize: fontSizeSmall,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SF Pro'))),
                                  ];
                                },
                                onSelected: (value) {
                                  if (value == "/delete") {
                                    try {
                                      context
                                          .read<ListAddressCubit>()
                                          .deleteAddress(
                                              addressList.id.toString());
                                      ShowSnackbar.snackbar(
                                          context, "Berhasil hapus alamat",
                                          isSuccess: true);
                                    } catch (e) {
                                      ShowSnackbar.snackbar(
                                          context, e.toString(),
                                          isSuccess: false);
                                    }
                                  } else if (value == "/selectMain") {
                                    try {
                                      context
                                          .read<ListAddressCubit>()
                                          .selectMainAddress(
                                              addressList.id.toString());
                                      ShowSnackbar.snackbar(context,
                                          "Berhasil menjadikan alamat utama",
                                          isSuccess: true);
                                    } catch (e) {
                                      ShowSnackbar.snackbar(
                                          context, e.toString(),
                                          isSuccess: false);
                                    }
                                  }
                                },
                              ),
                            ),
                          )
                        : Container(),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
