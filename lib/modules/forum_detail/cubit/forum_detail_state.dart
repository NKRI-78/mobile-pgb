part of 'forum_detail_cubit.dart';

class ForumDetailState extends Equatable {
  final ForumDetailModel? detailForum;
  final ProfileModel? profile;
  final String idForum;
  final String inputComment;
  final bool loading;
  final bool loadingComment;
  final int initIndex;
  final int idOrder;
  final int commentId;
  final int? lastIdComment;
  final ForumComment? comment;
  final Map<String, int>? shownReplies;
  final Map<String, List<Replies>> pendingReplies;
  final String? replyTargetCommentId; // ➜ Tambahan

  const ForumDetailState({
    this.comment,
    this.profile,
    this.detailForum,
    this.idForum = "",
    this.inputComment = "",
    this.loading = false,
    this.loadingComment = false,
    this.initIndex = 0,
    this.idOrder = 0,
    this.commentId = 0,
    this.lastIdComment = 0,
    this.shownReplies,
    this.pendingReplies = const {},
    this.replyTargetCommentId = "",
  });

  @override
  List<dynamic> get props => [
        profile,
        detailForum,
        idForum,
        inputComment,
        loading,
        loadingComment,
        initIndex,
        idOrder,
        commentId,
        lastIdComment,
        comment,
        shownReplies,
        pendingReplies,
        replyTargetCommentId,
      ];

  ForumDetailState copyWith({
    ForumComment? comment,
    ProfileModel? profile,
    ForumDetailModel? detailForum,
    String? idForum,
    String? inputComment,
    bool? loading,
    bool? loadingComment,
    int? initIndex,
    int? idOrder,
    int? commentId,
    int? lastIdComment,
    Map<String, int>? shownReplies,
    Map<String, List<Replies>>? pendingReplies,
    String? replyTargetCommentId,
  }) {
    return ForumDetailState(
      comment: comment ?? this.comment,
      profile: profile ?? this.profile,
      detailForum: detailForum ?? this.detailForum,
      idForum: idForum ?? this.idForum,
      inputComment: inputComment ?? this.inputComment,
      loading: loading ?? this.loading,
      loadingComment: loadingComment ?? this.loadingComment,
      initIndex: initIndex ?? this.initIndex,
      idOrder: idOrder ?? this.idOrder,
      commentId: commentId ?? this.commentId,
      lastIdComment: lastIdComment ?? this.lastIdComment,
      shownReplies: shownReplies ?? this.shownReplies,
      pendingReplies: pendingReplies ?? this.pendingReplies,
      replyTargetCommentId: replyTargetCommentId ?? this.replyTargetCommentId,
    );
  }

  int getShownCount(String commentId) => shownReplies?[commentId] ?? 0;
  List<Replies> getPending(String commentId) => pendingReplies[commentId] ?? [];
}
