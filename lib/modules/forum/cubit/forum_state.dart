part of 'forum_cubit.dart';

final class ForumState extends Equatable {
  final List<ForumsModel> forums;
  final int nextPageForums;
  final ProfileModel? profile;
  final double scrollOffset;

  final bool loading;

  const ForumState({
    this.profile,
    this.forums = const [],
    this.nextPageForums = 1,
    this.loading = false,
    this.scrollOffset = 0.0,
  });

  @override
  List<Object?> get props => [
        forums,
        nextPageForums,
        loading,
        profile,
        scrollOffset,
      ];

  ForumState copyWith({
    List<ForumsModel>? forums,
    int? nextPageForums,
    bool? loading,
    ProfileModel? profile,
    double? scrollOffset,
  }) {
    return ForumState(
      forums: forums ?? this.forums,
      nextPageForums: nextPageForums ?? this.nextPageForums,
      loading: loading ?? this.loading,
      profile: profile ?? this.profile,
      scrollOffset: scrollOffset ?? this.scrollOffset,
    );
  }
}
