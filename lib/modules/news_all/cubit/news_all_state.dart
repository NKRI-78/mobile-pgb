part of 'news_all_cubit.dart';

final class NewsAllState extends Equatable {
  final List<NewsModel> news;
  final int nextPageNews;
  final PaginationModel? newsPagination;
  final bool loading;

  const NewsAllState({
    this.news = const [],
    this.nextPageNews = 1,
    this.newsPagination,
    this.loading = false,
  });

  @override
  List<Object?> get props => [
        news,
        nextPageNews,
        newsPagination,
        loading,
      ];

  NewsAllState copyWith({
    List<NewsModel>? news,
    int? nextPageNews,
    PaginationModel? newsPagination,
    bool? loading,
  }) {
    return NewsAllState(
      news: news ?? this.news,
      nextPageNews: nextPageNews ?? this.nextPageNews,
      newsPagination: newsPagination ?? this.newsPagination,
      loading: loading ?? this.loading,
    );
  }
}
