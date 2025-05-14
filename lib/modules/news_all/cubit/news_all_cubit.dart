import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../misc/injections.dart';
import '../../../repositories/home_repository/home_repository.dart';
import '../../../repositories/home_repository/models/data_pagination.dart';
import '../../../repositories/home_repository/models/news_model.dart';
import '../../../repositories/home_repository/models/pagination_model.dart';

part 'news_all_state.dart';

class NewsAllCubit extends Cubit<NewsAllState> {
  NewsAllCubit() : super(const NewsAllState()) {
    fetchNews();
  }

  HomeRepository repo = getIt<HomeRepository>();

  static RefreshController newsRefreshCtrl = RefreshController();

  void copyState({required NewsAllState newState}) {
    emit(newState);
  }

  Future<void> fetchNews() async {
    try {
      emit(state.copyWith(loading: true));
      DataPagination<NewsModel> data = await repo.getNews();
      emit(
        state.copyWith(
            news: data.list,
            nextPageNews: data.paginate.next,
            newsPagination: data.paginate),
      );
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> onRefresh() async {
    DataPagination<NewsModel> data = await repo.getNews();

    emit(
      state.copyWith(
        news: data.list,
        nextPageNews: data.paginate.next,
        newsPagination: data.paginate,
      ),
    );
    newsRefreshCtrl.refreshCompleted();
  }

  FutureOr<void> loadMoreNews() async {
    try {
      DataPagination<NewsModel> data =
          await repo.getNews(page: state.nextPageNews);

      debugPrint('data news call ${state.news}');

      emit(state.copyWith(
          news: [...state.news, ...data.list],
          nextPageNews: data.paginate.next,
          newsPagination: data.paginate));
    } catch (e) {
      debugPrint("error news $e");
    } finally {
      newsRefreshCtrl.loadComplete();
    }
  }
}
