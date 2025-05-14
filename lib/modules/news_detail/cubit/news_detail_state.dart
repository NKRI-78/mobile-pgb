part of 'news_detail_cubit.dart';

final class NewsDetailState extends Equatable {
  final int idNews;
  final DetailNewsModel? news;
  final bool loading;

  const NewsDetailState({
    this.idNews = 0,
    this.news,
    this.loading = false,
  });

  NewsDetailState copyWith({
    int? idNews,
    DetailNewsModel? news,
    bool? loading,
  }) {
    return NewsDetailState(
      idNews: idNews ?? this.idNews,
      news: news ?? this.news,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [
        idNews,
        news,
        loading,
      ];
}
