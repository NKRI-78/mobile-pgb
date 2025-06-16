import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../cubit/list_address_cubit.dart';
import '../widgets/card_list_address.dart';
import '../../../router/builder.dart';
import '../../../widgets/button/custom_button.dart';
import '../../../widgets/header/header_section.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';

class ListAddressPage extends StatelessWidget {
  const ListAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListAddressCubit>.value(
        value: getIt<ListAddressCubit>()..getListAddress(),
        child: const ListAddressView());
  }
}

class ListAddressView extends StatelessWidget {
  const ListAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListAddressCubit, ListAddressState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.all(10),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  radius: 12,
                  onPressed: () {
                    CreateAddressRoute().push(context);
                  },
                  backgroundColour: AppColors.buttonBlueColor,
                  textColour: AppColors.whiteColor,
                  text: "Tambah Alamat",
                ),
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              const HeaderSection(titleHeader: "Alamat Saya"),
              state.loading
                  ? const SliverFillRemaining(
                      child: Center(child: CustomLoadingPage()),
                    )
                  : state.address.isEmpty
                      ? const SliverFillRemaining(
                          child:
                              Center(child: EmptyPage(msg: "Belum ada alamat")))
                      : SliverList.list(
                          children: state.address
                              .map((e) => CardListAddress(
                                    addressList: e,
                                  ))
                              .toList())
            ],
          ),
        );
      },
    );
  }
}
