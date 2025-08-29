import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widget/custom_field_listrik_section.dart';
import '../../../repositories/ppob_repository/models/listrik_data_model.dart';
import '../../../widgets/pages/loading_page.dart';

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
import '../widget/custom_list_listrik_data_section.dart';
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
  final ValueNotifier<ListrikDataModel?> selectedListrikDataNotifier =
      ValueNotifier(null);

  final TextEditingController _pulsaDataController = TextEditingController();
  final TextEditingController _listrikController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<PpobCubit>().getProfile();
  }

  @override
  void dispose() {
    _pulsaDataController.dispose();
    _listrikController.dispose();
    selectedPulsaDataNotifier.dispose();
    selectedListrikDataNotifier.dispose();
    super.dispose();
  }

  void _onCardSelected(int index) {
    setState(() {
      selectedIndex = index;
      selectedType = index == 0
          ? "PULSA"
          : index == 1
              ? "DATA"
              : index == 2
                  ? "PLN"
                  : null;

      selectedPulsaDataNotifier.value = null;
      selectedListrikDataNotifier.value = null;
    });

    final cubit = context.read<PpobCubit>();

    if (selectedType == null) {
      cubit.clearPulsaData();
    } else if (selectedType == "PLN") {
      cubit.fetchListrikData();
    } else if (_pulsaDataController.text.length >= 5) {
      cubit.fetchPulsaData(
        prefix: _pulsaDataController.text.substring(0, 5),
        type: selectedType!,
      );
    }
  }

  void _onPulsaDataSelected(PulsaDataModel pulsa) {
    selectedPulsaDataNotifier.value = pulsa;
  }

  void _onListrikDataSelected(ListrikDataModel listrik) {
    selectedListrikDataNotifier.value = listrik;
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.select((PpobCubit cubit) => cubit.state.profile);

    final widgets = <Widget>[
      CustomButtonWallet(
        saldo: profile?.balance ?? 0,
        isLoading: profile == null,
      ),
      CustomCardSection(
        selectedIndex: selectedIndex,
        onCardSelected: _onCardSelected,
      ),
      const SizedBox(height: 12),
    ];

    if (selectedIndex == 0 || selectedIndex == 1) {
      widgets.addAll([
        CustomFieldSection(
            controller: _pulsaDataController, type: selectedType),
        const SizedBox(height: 5),
        BlocBuilder<PpobCubit, PpobState>(builder: (context, state) {
          if (state.isLoading) return CustomLoadingPage();

          if (state.isSuccess == true) {
            return CustomListPulsaDataSection(
              pulsaData: state.pulsaData,
              onSelected: _onPulsaDataSelected,
            );
          }
          return const SizedBox.shrink();
        })
      ]);
    } else if (selectedIndex == 2) {
      widgets.addAll([
        CustomFieldListrikSection(controller: _listrikController),
        const SizedBox(height: 5),
        BlocBuilder<PpobCubit, PpobState>(
          builder: (context, state) {
            if (state.isLoading) return CustomLoadingPage();
            if (state.isSuccess == true && state.listrikData.isNotEmpty) {
              return CustomListListrikDataSection(
                listrikData: state.listrikData,
                onSelected: _onListrikDataSelected,
              );
            }
            if (state.isSuccess == false) {
              return Center(
                  child: Text("Terjadi kesalahan",
                      style: AppTextStyles.textStyleBold));
            }
            return const SizedBox.shrink();
          },
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
          child: Builder(
            builder: (context) {
              if (selectedIndex == 2) {
                return ValueListenableBuilder<ListrikDataModel?>(
                  valueListenable: selectedListrikDataNotifier,
                  builder: (context, selectedListrik, _) {
                    final length = _listrikController.text.length;
                    final isValid = selectedIndex != -1 &&
                        selectedListrik != null &&
                        (length >= 11 && length <= 12);

                    return IgnorePointer(
                      ignoring: !isValid,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color:
                              isValid ? AppColors.secondaryColor : Colors.grey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            _customPaymentSection(
                              context,
                              [selectedListrik!],
                              _listrikController.text,
                              "PLN",
                            );
                            context.read<PpobCubit>().copyState(
                                  newState: context
                                      .read<PpobCubit>()
                                      .state
                                      .copyWith(
                                        selectedListrikData: selectedListrik,
                                      ),
                                );
                          },
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
                      ),
                    );
                  },
                );
              } else {
                return ValueListenableBuilder<PulsaDataModel?>(
                  valueListenable: selectedPulsaDataNotifier,
                  builder: (context, selectedPulsa, _) {
                    return InkWell(
                      onTap: (selectedIndex == -1 || selectedPulsa == null)
                          ? null
                          : () {
                              _customPaymentSection(
                                context,
                                [selectedPulsa],
                                _pulsaDataController.text,
                                selectedType ?? "PULSA",
                              );
                              context.read<PpobCubit>().copyState(
                                    newState: context
                                        .read<PpobCubit>()
                                        .state
                                        .copyWith(
                                          selectedPulsaData: selectedPulsa,
                                        ),
                                  );
                            },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: (selectedIndex == -1 || selectedPulsa == null)
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
                );
              }
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
