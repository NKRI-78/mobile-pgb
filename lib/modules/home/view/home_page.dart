import 'package:badges/badges.dart' as Badges;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  bool isFloatingVisible = true;
  late bool isPresenceEnabled;

  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  late AnimationController _blinkController;

  Future<void> _onRefresh(BuildContext context) async {
    context.read<HomeBloc>().add(HomeInit(context: context));
  }

  @override
  void initState() {
    super.initState();

    final remoteConfig = getIt<FirebaseRemoteConfig>();
    isPresenceEnabled = remoteConfig.getBool('is_presence');

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (isPresenceEnabled) {
      _blinkController.repeat();
    }

    _pulseScale = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeOut),
    );

    _pulseOpacity = Tween<double>(begin: 0.35, end: 0.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appState) {
        final bool isLoggedIn = appState.isLoggedIn;

        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final bool showFloating =
                isLoggedIn && isPresenceEnabled && isFloatingVisible;

            if (!showFloating && _blinkController.isAnimating) {
              _blinkController.stop();
            }

            if (showFloating && !_blinkController.isAnimating) {
              _blinkController.repeat();
            }

            return FloatingDraggableWidget(
              key: ValueKey(isFloatingVisible),
              floatingWidget:
                  showFloating ? _floatingAbsensi(context) : const SizedBox(),
              floatingWidgetWidth: 90,
              floatingWidgetHeight: 125,
              autoAlign: true,
              isDraggable: true,
              deleteWidgetPadding: EdgeInsets.only(bottom: 50),
              deleteWidget: _deleteArea(),
              deleteWidgetAlignment: Alignment.bottomCenter,
              onDeleteWidget: () {
                _blinkController.stop();
                setState(() {
                  isFloatingVisible = false;
                });
              },
              mainScreenWidget: Scaffold(
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
                              child: state.isLoading
                                  ? SizedBox(
                                      width: 45,
                                      height: 45,
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.white,
                                        child: Container(
                                          width: double.infinity,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                      ),
                                    )
                                  : ClipOval(
                                      child: isLoggedIn &&
                                              (state
                                                      .profile
                                                      ?.profile
                                                      ?.avatarLink
                                                      ?.isNotEmpty ??
                                                  false)
                                          ? FadeInImage.assetNetwork(
                                              placeholder: imageDefaultUser,
                                              image: state.profile!.profile!
                                                  .avatarLink!,
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
                            position:
                                Badges.BadgePosition.topEnd(end: 2, top: 0),
                            showBadge: state.badges?.unreadCount == null ||
                                    state.badges?.unreadCount == 0
                                ? false
                                : true,
                            badgeStyle:
                                Badges.BadgeStyle(padding: EdgeInsets.all(5)),
                            badgeContent: Text(
                              state.loadingNotif
                                  ? '..'
                                  : '${state.badges?.unreadCount}',
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
                body: Stack(
                  children: [
                    SafeArea(
                      bottom: true,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          if (isPresenceEnabled) {
                            setState(() {
                              isFloatingVisible = true;
                            });
                            _blinkController.repeat();
                          }
                          await _onRefresh(context);
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 16),
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: const Center(
                                    child: CustomLoadingPage(
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                )
                              else if (state.news.isEmpty)
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                          image: AssetImage(imageDefaultData),
                                          height: 120,
                                        ),
                                        Text('Tidak ada Berita..',
                                            style:
                                                AppTextStyles.textStyleNormal),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                ListView.builder(
                                  cacheExtent: 500,
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
                            ],
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

  Widget _deleteArea() {
    return Container(
      height: 60,
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.redColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Center(
        child: Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _floatingAbsensi(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PresenceRoute().push(context);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _blinkController,
            builder: (_, __) {
              return Transform.scale(
                scale: _pulseScale.value,
                child: Opacity(
                  opacity: _pulseOpacity.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 91, 93, 224),
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4F46E5),
                  Color(0xFF2563EB),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Image.asset(
              "assets/icons/deklarasi.png",
              color: AppColors.whiteColor,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
              height: 55,
              width: 55,
            ),
          ),
        ],
      ),
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
