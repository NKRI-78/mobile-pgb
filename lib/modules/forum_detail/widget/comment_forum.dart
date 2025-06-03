import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pgb/repositories/forum_repository/models/forum_detail_model.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../widgets/detect_text/detect_text.dart';
import '../../../widgets/image/image_avatar.dart';
import '../../app/bloc/app_bloc.dart';
import '../cubit/forum_detail_cubit.dart';
import '../view/forum_detail_page.dart';
import '_card_reply.dart';

class CommentForum extends StatefulWidget {
  const CommentForum(
      {super.key, required this.comment, required this.focusNode});

  final ForumComment comment;
  final FocusNode focusNode;

  @override
  State<CommentForum> createState() => _CommentForumState();
}

class _CommentForumState extends State<CommentForum> {
  @override
  Widget build(BuildContext context) {
    final user = widget.comment.user;
    final userId = getIt<AppBloc>().state.user?.id;
    return BlocBuilder<ForumDetailCubit, ForumDetailState>(
      builder: (context, state) {
        final replies = widget.comment.replies ?? [];
        final shownCount = state.getShownCount(widget.comment.id.toString());
        final totalReplies = replies.length;
        final pending = state.getPending(widget.comment.id.toString());

        final displayedReplies = replies.take(shownCount).toList();

        return Container(
          key: GlobalObjectKey(widget.comment.id ?? 0),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                        onTap: () {},
                        child: ImageAvatar(
                            image: user?.profile == null
                                ? user?.profile?.avatarLink ?? ""
                                : user?.profile?.avatarLink ?? "",
                            radius: 18)),
                  ),
                  Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                color: widget.comment.id == state.lastIdComment
                                    ? AppColors.secondaryColor
                                    : AppColors.greyColor.withOpacity(0.3)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        user?.profile == null
                                            ? user?.profile?.fullname ?? ""
                                            : user?.profile?.fullname ?? "",
                                        style: TextStyle(
                                            color: widget.comment.id ==
                                                    state.lastIdComment
                                                ? AppColors.whiteColor
                                                : AppColors.blackColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                DetectText(
                                  text: widget.comment.comment ?? "",
                                  colorText:
                                      widget.comment.id == state.lastIdComment
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                timeago.format(
                                  widget.comment.createdAt != null
                                      ? DateTime.parse(
                                          widget.comment.createdAt!)
                                      : DateTime.now(),
                                  locale: 'id',
                                ),
                                style: const TextStyle(
                                  color: AppColors.greyColor,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    int commentId = 0;
                                    commentId = widget.comment.id ?? 0;
                                    FocusScope.of(context)
                                        .requestFocus(widget.focusNode);
                                    SystemChannels.textInput
                                        .invokeMethod("TextInput.show");

                                    if (widget.comment.userId == userId) {
                                      commentKey
                                          .currentState!.controller!.text = "";
                                    } else {
                                      final mentionName = user?.username ??
                                          user?.profile?.fullname
                                              ?.split(' ')
                                              .first ??
                                          '';
                                      commentKey.currentState!.controller!
                                          .text = "@$mentionName ";
                                    }

                                    var cubit =
                                        context.read<ForumDetailCubit>();
                                    // Simpan target balasan
                                    cubit.setReplyTargetCommentId(commentId.toString());
                                    cubit.copyState(
                                        newState: cubit.state.copyWith(
                                      commentId: commentId,
                                    ));
                                    debugPrint("Id Comment ${state.commentId}");
                                  });
                                },
                                child: const Text(
                                  "Balas",
                                  style: TextStyle(
                                      color: AppColors.greyColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
              // Balasan baru yang belum masuk daftar utama
              ...pending.map((reply) => CardReply(
                    focusNode: widget.focusNode,
                    comment: reply,
                  )),

              // Balasan yang dimunculkan dari daftar utama
              ...displayedReplies.map((reply) => CardReply(
                    focusNode: widget.focusNode,
                    comment: reply,
                  )),

              if (shownCount < replies.length)
                GestureDetector(
                  onTap: () {
                    context.read<ForumDetailCubit>().showMore(
                          widget.comment.id.toString(),
                          replies.length,
                        );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 65, top: 8),
                    child: Text(
                      'Lihat balasan lainnya (${totalReplies - shownCount})',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                //  if (shownCount > 0)
                // InkWell(
                //   onTap: () {
                //     context.read<ForumDetailCubit>().showMore(widget.comment.id.toString(), 0);
                //   },
                //   child: const Padding(
                //     padding: EdgeInsets.only(left: 65, top: 8),
                //     child: Text(
                //       'Sembunyikan balasan',
                //       style: TextStyle(color: Colors.blue),
                //     ),
                //   ),
                // ),
                if (shownCount >= totalReplies && totalReplies > 5)
                GestureDetector(
                  onTap: () {
                    context.read<ForumDetailCubit>().showMore(widget.comment.id.toString(), totalReplies);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 65, top: 8),
                    child: Text(
                      'Sembunyikan balasan',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
