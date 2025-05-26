import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import '../../../router/builder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../misc/text_style.dart';
import '../../../misc/theme.dart';
import '../../../widgets/button/custom_button.dart';
import '../../../widgets/pages/loading_page.dart';
import '../cubit/profile_cubit.dart';

part '../widget/custom_card_profile.dart';
part '../widget/custom_data_profile.dart';
part '../widget/custom_download_kta.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ProfileCubit>()..getProfile(),
      child: ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Profile',
              style: AppTextStyles.textStyleBold.copyWith(),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: state.isLoading
                ? Center(
                    child: CustomLoadingPage(),
                  )
                : SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CustomCardProfile(
                            noKta: state.profile?.profile?.kta ?? '-',
                            nama: state.profile?.profile?.fullname ?? '-',
                            tempatTglLahir:
                                state.profile?.profile?.birthPlaceAndDate ??
                                    '-',
                            agama: state.profile?.profile?.religion ?? '-',
                            alamat:
                                state.profile?.profile?.administrativeVillage ??
                                    '-',
                            fotoPath: state.profile?.profile?.avatarLink ??
                                imageDefaultUser,
                          ),
                          CustomDownloadKta(),
                          CustomDataProfile(
                            email: state.profile?.email ?? '',
                            nama: state.profile?.profile?.fullname ?? '',
                            noTlp: state.profile?.phone ?? '',
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          bottomNavigationBar: state.isLoading
              ? SizedBox.shrink()
              : SafeArea(
                  minimum: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: CustomButton(
                    onPressed: () {
                      ProfileUpdateRoute().go(context);
                    },
                    text: "Edit",
                    backgroundColour: AppColors.secondaryColor,
                    textColour: AppColors.buttonWhiteColor,
                  ),
                ),
        );
      },
    );
  }
}
