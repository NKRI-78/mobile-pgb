import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/text_style.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';
import '../../app/bloc/app_bloc.dart';
import '../cubit/news_all_cubit.dart';
import '../widget/list_news.dart';

class NewsAllPage extends StatelessWidget {
  const NewsAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<NewsAllCubit>()..fetchNews(),
      child: NewsAllView(),
    );
  }
}

class NewsAllView extends StatelessWidget {
  const NewsAllView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return BlocBuilder<NewsAllCubit, NewsAllState>(
          builder: (_, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'All News',
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
              body: SmartRefresher(
                controller: NewsAllCubit.newsRefreshCtrl,
                enablePullDown: true,
                enablePullUp: state.newsPagination?.next != null,
                onRefresh: () async {
                  await context.read<NewsAllCubit>().onRefresh();
                },
                onLoading: () async {
                  await context.read<NewsAllCubit>().loadMoreNews();
                },
                header: ClassicHeader(
                  textStyle: const TextStyle(color: AppColors.secondaryColor),
                  iconPos: IconPosition.left,
                  spacing: 5.0,
                  refreshingText: "Memuat berita...",
                  idleText: "Tarik untuk menyegarkan",
                  releaseText: "Lepaskan untuk menyegarkan",
                  completeText: "Berhasil diperbarui",
                  failedText: "Gagal memperbarui",
                  refreshingIcon: const Icon(Icons.autorenew,
                      color: AppColors.secondaryColor),
                  failedIcon: const Icon(Icons.error, color: Colors.red),
                  completeIcon:
                      const Icon(Icons.done, color: AppColors.buttonBlueColor),
                  idleIcon: const Icon(Icons.arrow_downward,
                      color: AppColors.secondaryColor),
                  releaseIcon: const Icon(Icons.refresh,
                      color: AppColors.secondaryColor),
                ),
                child: CustomScrollView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  slivers: [
                    BlocBuilder<NewsAllCubit, NewsAllState>(
                      buildWhen: (previous, current) =>
                          previous.news != current.news ||
                          previous.loading != current.loading,
                      builder: (context, state) {
                        return SliverPadding(
                          padding: const EdgeInsets.all(20),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                state.loading
                                    ? const LoadingPage()
                                    : state.news.isEmpty
                                        ? const EmptyPage(
                                            msg: "Tidak ada Berita..")
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: state.news
                                                .map((e) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    child: ListNews(news: e)))
                                                .toList()),
                              ],
                            ),
                          ),
                        );
                      },
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
}
