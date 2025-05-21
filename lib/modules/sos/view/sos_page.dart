import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../router/builder.dart';
import '../cubit/sos_page_cubit.dart';

part '../widget/custom_card_section.dart';

class SosPage extends StatelessWidget {
  const SosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SosCubit()..getProfile(),
      child: SosView(),
    );
  }
}

class SosView extends StatelessWidget {
  const SosView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SosCubit, SosState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppColors.primaryColor,
            title: Text(
              'SOS',
              style: AppTextStyles.textStyleBold,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Keadaan darurat apa yang\nmenimpa anda ?",
                    style: AppTextStyles.textStyleBold.copyWith(
                      color: AppColors.greyColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                    children: [
                      customCardSection(
                        icon: 'assets/images/kecelakaan.png',
                        label: 'Kecelakaan',
                        onTap: () {
                          SosDetailRoute(
                            sosType: 'Kecelakaan',
                            message:
                                '${state.profile?.profile?.fullname} butuh bantuan terjadi Kecelakaan',
                          ).go(context);
                        },
                      ),
                      customCardSection(
                        icon: 'assets/images/pencurian.png',
                        label: 'Pencurian',
                        onTap: () {
                          SosDetailRoute(
                                  sosType: 'Pencurian',
                                  message:
                                      '${state.profile?.profile?.fullname} butuh bantuan terjadi Pencurian')
                              .go(context);
                        },
                      ),
                      customCardSection(
                        icon: 'assets/images/kebakaran.png',
                        label: 'Kebakaran',
                        onTap: () {
                          SosDetailRoute(
                                  sosType: 'Kebakaran',
                                  message:
                                      '${state.profile?.profile?.fullname} butuh bantuan terjadi Kebakaran')
                              .go(context);
                        },
                      ),
                      customCardSection(
                        icon: 'assets/images/bencana_alam.png',
                        label: 'Bencana Alam',
                        onTap: () {
                          SosDetailRoute(
                                  sosType: 'Bencana Alam',
                                  message:
                                      '${state.profile?.profile?.fullname} butuh bantuan terjadi Bencana Alam')
                              .go(context);
                        },
                      ),
                      customCardSection(
                        icon: 'assets/images/donor_darah.png',
                        label: 'Donor Darah',
                        onTap: () {
                          SosDetailRoute(
                                  sosType: 'Donor Darah',
                                  message:
                                      '${state.profile?.profile?.fullname} butuh bantuan Donor Darah')
                              .go(context);
                        },
                      ),
                      customCardSection(
                        icon: 'assets/images/kerusuhan.png',
                        label: 'Kerusuhan',
                        onTap: () {
                          SosDetailRoute(
                                  sosType: 'Kerusuhan',
                                  message:
                                      '${state.profile?.profile?.fullname} butuh bantuan terjadi Kerusuhan')
                              .go(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
