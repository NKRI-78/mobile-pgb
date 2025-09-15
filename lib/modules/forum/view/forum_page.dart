import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widget/forum_header_section.dart';
import '../widget/list_forum.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';
import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/text_style.dart'; 
import '../cubit/forum_cubit.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ForumCubit>(),
      child: const ForumView(),
    );
  }
}

class ForumView extends StatefulWidget {
  const ForumView({super.key});

  @override
  State<ForumView> createState() => _ForumViewState();
}

class _ForumViewState extends State<ForumView> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      context.read<ForumCubit>().init();
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForumCubit, ForumState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Interaksi", style: AppTextStyles.textStyleBold),
            centerTitle: true,
            toolbarHeight: 80,
            elevation: 0,
            surfaceTintColor: Colors.white,
            backgroundColor: AppColors.whiteColor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 24,
              ),
              onPressed: () {
                GoRouter.of(context).pop();
              },
            ),
          ),
          body: RefreshIndicator(
            color: AppColors.secondaryColor,
            onRefresh: () async {
              context.read<ForumCubit>().init();
              await Future.delayed(const Duration(seconds: 1));
            },
            child: Column(
              children: [
                ForumHeaderSection(),
                Expanded(
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      BlocBuilder<ForumCubit, ForumState>(
                        buildWhen: (previous, current) =>
                            previous.forums != current.forums ||
                            previous.loading != current.loading,
                        builder: (context, state) {
                          if (state.loading) {
                            return const SliverToBoxAdapter(
                                child: CustomLoadingPage());
                          }
                          if (state.forums.isEmpty) {
                            return const SliverToBoxAdapter(
                                child: EmptyPage(msg: "Tidak ada Interaksi.."));
                          }
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return ForumListSection(
                                    forums: state.forums[index]);
                              },
                              childCount: state.forums.length,
                            ),
                          );
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
