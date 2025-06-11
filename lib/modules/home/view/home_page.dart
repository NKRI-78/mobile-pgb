import 'package:badges/badges.dart' as Badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/text_style.dart';
import '../../../misc/theme.dart';
import '../../../router/builder.dart';
import '../../../widgets/pages/loading_page.dart';
import '../../app/bloc/app_bloc.dart';
import '../bloc/home_bloc.dart';
import '../widget/custom_banner.dart';
import '../widget/custom_drawer.dart';
import '../widget/custom_menu.dart';
import '../widget/custom_name.dart';
import '../widget/custom_news.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<HomeBloc>()..add(HomeInit(context: context)),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    context.read<HomeBloc>().add(HomeInit(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appState) {
        final bool isLoggedIn = appState.isLoggedIn;
        // final isVerified = appState.user?.emailVerified != null;

        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            // print("CEK USER ${appState.user}");
            // print("CEK EMAIL VERIF ${isVerified}");
            return Scaffold(
              backgroundColor: AppColors.primaryColor,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: AppBar(
                  backgroundColor: AppColors.primaryColor,
                  surfaceTintColor: Colors.transparent,
                  toolbarHeight: 80,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: SafeArea(
                    child: Stack(
                      children: [
                        Positioned(
                          left: 16,
                          top: 20,
                          child: GestureDetector(
                            onTap: () {
                              if (isLoggedIn) {
                                ProfileRoute().go(context);
                              } else {
                                RegisterRoute().go(context);
                              }
                            },
                            child: ClipOval(
                              child: isLoggedIn &&
                                      (state.profile?.profile?.avatarLink
                                              ?.isNotEmpty ??
                                          false)
                                  ? FadeInImage.assetNetwork(
                                      placeholder: imageDefaultUser,
                                      image:
                                          state.profile!.profile!.avatarLink!,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      imageDefaultUser,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 55,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/logo.png',
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: [
                    BlocBuilder<AppBloc, AppState>(
                      builder: (context, state) {
                        return Badges.Badge(
                          position: Badges.BadgePosition.topEnd(end: 2, top: 0),
                          showBadge:
                              state.badgeCart == null || state.badgeCart?.totalItem == 0
                                  ? false
                                  : true,
                          badgeStyle: Badges.BadgeStyle(
                            padding: EdgeInsets.all(5)
                          ),
                          badgeContent: Text(
                            state.loadingNotif ? '..' : '${state.badgeCart?.totalItem}',
                            style: const TextStyle(
                              fontSize: fontSizeSmall,
                              color: Colors.white,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.notifications_none_outlined,
                              color: AppColors.greyColor,
                              size: 28,
                            ),
                            onPressed: () {
                              if (isLoggedIn) {
                                NotificationRoute().go(context);
                              } else {
                                RegisterRoute().go(context);
                              }
                            },
                          ),
                        );
                      },
                    ),
                    Builder(builder: (context) {
                      return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          color: AppColors.greyColor,
                          size: 28,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              endDrawer: const CustomEndDrawer(),
              body: SizedBox.expand(
                child: RefreshIndicator(
                  onRefresh: () => _onRefresh(context),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        CustomName(
                          balance: state.profile?.balance.toString(),
                          fullname: state.profile?.profile?.fullname,
                          isLoggedIn: isLoggedIn,
                        ),
                        SizedBox(height: 10),
                        CustomBanner(),
                        SizedBox(height: 10),
                        CustomMenu(),
                        _buildNewsSectionHeader(context),
                        if (state.isLoading)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: const Center(
                              child: CustomLoadingPage(
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          )
                        else if (state.news.isEmpty)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image(
                                    image: AssetImage(imageDefaultData),
                                    height: 120,
                                  ),
                                  Text('Tidak ada Berita..',
                                      style: AppTextStyles.textStyleNormal),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.news.take(5).length,
                            itemBuilder: (context, index) {
                              final newsItem = state.news[index];
                              return CustomNews(
                                imageUrl: newsItem.linkImage,
                                title: newsItem.title,
                                content: newsItem.content,
                                onTap: () {
                                  if (newsItem.id != null) {
                                    NewsDetailRoute(newsId: newsItem.id!)
                                        .go(context);
                                  }
                                },
                              );
                            },
                          ),
                        // SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNewsSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('News', style: AppTextStyles.textStyleBold),
          InkWell(
            onTap: () {
              NewsAllRoute().go(context);
            },
            child: Row(
              children: [
                Text(
                  'Lihat Semuanya',
                  style: AppTextStyles.textStyleNormal.copyWith(
                    color: AppColors.greyColor,
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.greyColor, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
