import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import '../../../misc/snackbar.dart';
import '../../../misc/date_helper.dart';
import '../../../router/builder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/text_style.dart';
import '../../../misc/theme.dart';
import '../../../widgets/button/custom_button.dart';
import '../../../widgets/pages/loading_page.dart';
import '../cubit/profile_cubit.dart';

part '../widget/custom_card_profile.dart';
part '../widget/custom_data_profile.dart';
part '../widget/custom_download_kta.dart';
part '../view/preview_kta_page.dart';

final GlobalKey _ktaFrontKey = GlobalKey();
final GlobalKey _ktaBackKey = GlobalKey();

enum CardSide { front, back }

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ProfileCubit>()..getProfile(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text('Profile', style: AppTextStyles.textStyleBold),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: state.isLoading
                ? const Center(child: CustomLoadingPage())
                : SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = constraints.maxWidth;
                                  final height = width * 0.70;

                                  return SizedBox(
                                    height: height,
                                    child: PageView(
                                      controller: _pageController,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _currentPage = index;
                                        });
                                      },
                                      children: [
                                        RepaintBoundary(
                                          key: _ktaFrontKey,
                                          child: CustomCardProfile(
                                            isForExport: true,
                                            cardSide: CardSide.front,
                                            onCardSideChanged: (_) {},
                                            createAt: state.profile?.profile
                                                    ?.createdAt ??
                                                '-',
                                            noKta:
                                                state.profile?.profile?.kta ??
                                                    '-',
                                            nama: state.profile?.profile
                                                    ?.fullname ??
                                                '-',
                                            tempatTglLahir: state
                                                    .profile
                                                    ?.identityCard
                                                    ?.birthPlaceAndDate ??
                                                '-',
                                            agama: state.profile?.identityCard
                                                    ?.religion ??
                                                '-',
                                            alamat: state.profile?.identityCard
                                                    ?.address ??
                                                '-',
                                            rtRw: state.profile?.identityCard
                                                    ?.villageUnit ??
                                                '-',
                                            kelurahan: state
                                                    .profile
                                                    ?.identityCard
                                                    ?.administrativeVillage ??
                                                '-',
                                            kecamatan: state
                                                    .profile
                                                    ?.identityCard
                                                    ?.subDistrict ??
                                                '-',
                                            fotoPath: state.profile?.profile
                                                    ?.avatarLink ??
                                                imageDefaultUser,
                                          ),
                                        ),
                                        RepaintBoundary(
                                          key: _ktaBackKey,
                                          child: CustomCardProfile(
                                            isForExport: true,
                                            cardSide: CardSide.back,
                                            onCardSideChanged: (_) {},
                                            createAt: state.profile?.profile
                                                    ?.createdAt ??
                                                '-',
                                            noKta:
                                                state.profile?.profile?.kta ??
                                                    '-',
                                            nama: state.profile?.profile
                                                    ?.fullname ??
                                                '-',
                                            tempatTglLahir: state
                                                    .profile
                                                    ?.identityCard
                                                    ?.birthPlaceAndDate ??
                                                '-',
                                            agama: state.profile?.identityCard
                                                    ?.religion ??
                                                '-',
                                            alamat: state.profile?.identityCard
                                                    ?.address ??
                                                '-',
                                            rtRw: state.profile?.identityCard
                                                    ?.villageUnit ??
                                                '-',
                                            kelurahan: state
                                                    .profile
                                                    ?.identityCard
                                                    ?.administrativeVillage ??
                                                '-',
                                            kecamatan: state
                                                    .profile
                                                    ?.identityCard
                                                    ?.subDistrict ??
                                                '-',
                                            fotoPath: state.profile?.profile
                                                    ?.avatarLink ??
                                                imageDefaultUser,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  2,
                                  (index) {
                                    final isActive = _currentPage == index;
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      width: isActive ? 10 : 8,
                                      height: isActive ? 10 : 8,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? AppColors.secondaryColor
                                            : AppColors.greyColor,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          CustomDownloadKta(
                            controller: _pageController,
                            noKta: state.profile?.profile?.kta ?? '-',
                            nama: state.profile?.profile?.fullname ?? '-',
                            tempatTglLahir: state
                                    .profile?.identityCard?.birthPlaceAndDate ??
                                '-',
                            agama: state.profile?.identityCard?.religion ?? '-',
                            alamat: state.profile?.identityCard?.address ?? '-',
                            rtRw:
                                state.profile?.identityCard?.villageUnit ?? '-',
                            kelurahan: state.profile?.identityCard
                                    ?.administrativeVillage ??
                                '-',
                            kecamatan:
                                state.profile?.identityCard?.subDistrict ?? '-',
                            fotoPath: state.profile?.profile?.avatarLink ??
                                imageDefaultUser,
                            createAt: state.profile?.profile?.createdAt ?? '-',
                            ktaFrontKey: _ktaFrontKey,
                          ),
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
              ? const SizedBox.shrink()
              : SafeArea(
                  minimum:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: CustomButton(
                    onPressed: () => ProfileUpdateRoute().go(context),
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
