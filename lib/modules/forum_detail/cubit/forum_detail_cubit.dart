import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/bloc/app_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/forum_repository/forum_repository.dart';
import '../../../repositories/forum_repository/models/forum_detail_model.dart';
import '../../../repositories/profile_repository/models/profile_model.dart';
import '../../../repositories/profile_repository/profile_repository.dart';
import '../../../router/builder.dart';
import '../../forum/cubit/forum_cubit.dart';

part 'forum_detail_state.dart';

class ForumDetailCubit extends Cubit<ForumDetailState> {
  ForumDetailCubit() : super(const ForumDetailState());

  ForumRepository repo = ForumRepository();
  ProfileRepository repoProfile = getIt<ProfileRepository>();

  void init(String idForum) async {
    emit(state.copyWith(loading: true));
    await Future.wait([
      fetchForumDetail(idForum),
      fetchProfile(),
    ]);
    emit(state.copyWith(loading: false));
  }

  void copyState({required ForumDetailState newState}) {
    emit(newState);
  }

  Future<void> fetchForumDetail(String idForum) async {
    try {
      emit(state.copyWith(loading: true));
      var detailForum = await repo.getDetailForum(idForum);

      emit(state.copyWith(detailForum: detailForum, loading: false));
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> fetchProfile() async {
    try {
      emit(state.copyWith(loading: true));
      var profile = await repoProfile.getProfile();

      emit(state.copyWith(loading: false, profile: profile));
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> deleteForum(
      {required String idForum, required BuildContext context}) async {
    try {
      await repo.deleteForum(idForum.toString());
      Future.delayed(Duration.zero, () {
        Navigator.of(context, rootNavigator: true).pop();
        ForumRoute().go(context);
        getIt<ForumCubit>().fetchForum();
        ShowSnackbar.snackbar(context, "Berhasil menghapus postingan",
            isSuccess: true);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createComment(
      BuildContext context, String idForum, GlobalKey gk) async {
    try {
      emit(state.copyWith(loadingComment: true));
      int? idNewComment;
      if (state.inputComment.trim() == "") {
        return;
      } else {
        idNewComment = await repo.createComment(
          inputComment: state.inputComment,
          forumId: idForum,
          commentId: state.commentId,
        );
      }

      final detailForum = await repo.getDetailForum(idForum);
      final app = getIt<AppBloc>();
      final newReply = Replies(
        id: idNewComment,
        comment: state.inputComment,
        user: User(
          email: app.state.profile?.email ?? "",
          phone: app.state.profile?.phone ?? "",
          profile: ProfileUser(
            fullname: app.state.profile?.profile?.fullname,
            avatarLink: app.state.profile?.profile?.avatarLink,
            userId: app.state.user?.id,
            id: app.state.profile?.profile?.id,
          ),
        ),
        createdAt: DateTime.now().toIso8601String(),
      );

      final parentCommentId = state.replyTargetCommentId;
      if (parentCommentId != null) {
        addPendingReply(parentCommentId, newReply);
      }

      emit(state.copyWith(
          detailForum: detailForum,
          idForum: idForum,
          lastIdComment: idNewComment,
          replyTargetCommentId: ""));

      await Future.delayed(const Duration(milliseconds: 100));
      Scrollable.ensureVisible(
          alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
          GlobalObjectKey(idNewComment!).currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease);

      emit(state.copyWith(inputComment: "", commentId: 0));
      Future.delayed(const Duration(seconds: 2), () {
        emit(state.copyWith(lastIdComment: 0));
      });
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.secondaryColor,
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      emit(state.copyWith(loadingComment: false));
    }
  }

  Future<void> setLikeUnlike(
      {required String commentId, required String idForum}) async {
    try {
      await repo.setLikeUnlike(commentId);
      final comment = await repo.getDetailForum(idForum);
      emit(ForumDetailState(
          idForum: idForum, detailForum: comment, loading: false));
    } catch (e) {
      ///
    }
  }

  Future<void> setLikeUnlikeForum({required String idForum}) async {
    try {
      // emit(state.copyWith(loading: true));
      await repo.setLikeUnlikeForum(idForum);
      final comment = await repo.getDetailForum(idForum);
      emit(state.copyWith(idForum: idForum, detailForum: comment));
    } catch (e) {
      rethrow;
    }
  }

  void addPendingReply(String commentId, Replies newReply) {
    final currentPending = state.pendingReplies[commentId] ?? [];
    emit(state.copyWith(
      pendingReplies: {
        ...state.pendingReplies,
        commentId: [...currentPending, newReply],
      },
    ));
  }

  void showMore(String commentId, int totalReplies) {
    final currentShown = state.getShownCount(commentId);

    if (currentShown >= totalReplies) {
      emit(state.copyWith(
        shownReplies: {
          ...?state.shownReplies,
          commentId: 0,
        },
        pendingReplies: {
          ...state.pendingReplies,
          commentId: [],
        },
      ));
    } else {
      final newShown = (currentShown + 5).clamp(0, totalReplies);
      emit(state.copyWith(
        shownReplies: {
          ...?state.shownReplies,
          commentId: newShown,
        },
        pendingReplies: {
          ...state.pendingReplies,
          commentId: [],
        },
      ));
    }
  }

  void setReplyTargetCommentId(String commentId) {
    emit(state.copyWith(replyTargetCommentId: commentId));
  }

  int getShownCount(String commentId) {
    return state.getShownCount(commentId);
  }
}
