import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/injections.dart';
import '../../../repositories/news_repository/models/news_detail_model.dart';
import '../../../repositories/news_repository/news_repository.dart';

part 'news_detail_state.dart';

class NewsDetailCubit extends Cubit<NewsDetailState> {
  NewsDetailCubit() : super(const NewsDetailState());

  NewsRepository repoNews = getIt<NewsRepository>();

  void copyState({required NewsDetailState newState}) {
    emit(newState);
  }

  Future<void> fetchDetailNews(int newsId) async {
    emit(state.copyWith(loading: true));
    try {
      final news = await repoNews.getDetailNews(newsId);
      emit(state.copyWith(
        news: news,
        idNews: newsId,
      ));
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }
}
