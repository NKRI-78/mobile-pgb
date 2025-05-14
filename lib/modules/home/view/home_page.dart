import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../misc/injections.dart';
import '../../../misc/theme.dart';
import '../../app/bloc/app_bloc.dart';
import '../bloc/home_bloc.dart';
import '../../../router/builder.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
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
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appState) {
        final bool isLoggedIn = appState.isLoggedIn;
        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
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
                                // TODO: Navigate to Profile Page
                                debugPrint('Navigating to Profile Page');
                              } else {
                                RegisterRoute().go(context);
                              }
                            },
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.primaryColor,
                              backgroundImage: isLoggedIn
                                  ? AssetImage('assets/images/user.png')
                                  : AssetImage(imageDefaultUser),
                            ),
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.notifications_none_outlined,
                        color: AppColors.greyColor,
                        size: 28,
                      ),
                      onPressed: () {},
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
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          CustomName(
                            isLoggedIn: isLoggedIn,
                          ),
                          SizedBox(height: 10),
                          CustomBanner(),
                          SizedBox(height: 10),
                          CustomMenu(),
                          _buildNewsSectionHeader(context),
                          if (state.isLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          else if (state.news.isEmpty)
                            const Center(
                              heightFactor: 5,
                              child: Text('Tidak ada Berita..'),
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
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (isLoggedIn) {
                              // TODO: Navigate to SOS Page
                              debugPrint('Navigating to SOS Page');
                              // SosRoute().go(context);
                            } else {
                              RegisterRoute().go(context);
                            }
                          },
                          child: Image.asset(
                            'assets/icons/sos.png',
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                  ],
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
