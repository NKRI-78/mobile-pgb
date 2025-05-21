import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/snackbar.dart';
import '../../../misc/text_style.dart';
import '../../../repositories/ppob_repository/models/pulsa_data_model.dart';
import '../../../router/builder.dart';
import '../../../widgets/button/custom_button.dart';
import '../../../widgets/contact/contact_list_ppob.dart';
import '../../app/bloc/app_bloc.dart';
import '../cubit/ppob_cubit.dart';
import '../widget/custom_button_wallet.dart';
import '../widget/custom_list_pulsa_data_section.dart';

part '../widget/custom_card_section.dart';
part '../widget/custom_field_section.dart';
part '../widget/custom_payment_section.dart';

class PpobPage extends StatelessWidget {
  const PpobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PpobCubit(),
      child: const PpobView(),
    );
  }
}

class PpobView extends StatefulWidget {
  const PpobView({super.key});

  @override
  State<PpobView> createState() => _PpobViewState();
}

class _PpobViewState extends State<PpobView> {
  int selectedIndex = -1;
  String? selectedType;
  final ValueNotifier<PulsaDataModel?> selectedPulsaDataNotifier =
      ValueNotifier(null);
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PpobCubit>().getProfile();
  }

  @override
  void dispose() {
    _controller.dispose();
    selectedPulsaDataNotifier.dispose();
    super.dispose();
  }

  void _onCardSelected(int index) {
    setState(() {
      selectedIndex = index;
      selectedType = index == 0 ? "PULSA" : (index == 1 ? "DATA" : null);
      selectedPulsaDataNotifier.value = null;
    });

    final cubit = context.read<PpobCubit>();

    if (selectedType == null) {
      cubit.clearPulsaData();
    } else if (_controller.text.length >= 5) {
      cubit.fetchPulsaData(
        prefix: _controller.text.substring(0, 5),
        type: selectedType!,
      );
    }
  }

  void _onPulsaDataSelected(PulsaDataModel pulsa) {
    selectedPulsaDataNotifier.value = pulsa;
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.select((PpobCubit cubit) => cubit.state.profile);

    // Susun widget di luar builder delegate agar childCount bisa akses
    final widgets = <Widget>[
      CustomButtonWallet(
        saldo: profile?.balance ?? 0,
        isLoading: profile == null,
      ),
      CustomCardSection(
        selectedIndex: selectedIndex,
        onCardSelected: _onCardSelected,
      ),
      const SizedBox(height: 20),
    ];

    if (selectedIndex == 0 || selectedIndex == 1) {
      widgets.addAll([
        CustomFieldSection(controller: _controller, type: selectedType),
        const SizedBox(height: 10),
        BlocBuilder<PpobCubit, PpobState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                heightFactor: 5,
                child:
                    CircularProgressIndicator(color: AppColors.secondaryColor),
              );
            } else if (state.isSuccess == true && state.pulsaData.isNotEmpty) {
              return CustomListPulsaDataSection(
                pulsaData: state.pulsaData,
                onSelected: _onPulsaDataSelected,
              );
            } else if (state.isSuccess == false) {
              return const Center(
                child: Text(
                  "Terjadi kesalahan",
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ]);
    } else if (selectedIndex == 2) {
      widgets.addAll([
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/coming_soon.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ]);
    }

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom > 0
              ? MediaQuery.of(context).viewInsets.bottom
              : 10,
          left: 20,
          right: 20,
        ),
        child: SafeArea(
          top: false,
          child: ValueListenableBuilder<PulsaDataModel?>(
            valueListenable: selectedPulsaDataNotifier,
            builder: (context, selectedPulsaData, child) {
              return InkWell(
                onTap: (selectedIndex == -1 || selectedPulsaData == null)
                    ? null
                    : () {
                        _customPaymentSection(
                          context,
                          [selectedPulsaData],
                          _controller.text,
                          selectedType ?? "PULSA",
                        );
                        final cubit = context.read<PpobCubit>();
                        cubit.copyState(
                          newState: cubit.state.copyWith(
                            selectedPulsaData: selectedPulsaData,
                          ),
                        );
                      },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (selectedIndex == -1 || selectedPulsaData == null)
                        ? Colors.grey
                        : AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "Lanjutkan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.primaryColor,
            surfaceTintColor: Colors.transparent,
            pinned: true,
            elevation: 2,
            title: Text(
              'PPOB',
              style: AppTextStyles.textStyleBold,
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => widgets[index],
                childCount: widgets.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
