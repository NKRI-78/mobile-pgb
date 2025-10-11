import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../repositories/forum_repository/models/forum_detail_model.dart';
import '../../../widgets/detect_text/detect_text.dart';
import '../../../widgets/image/image_avatar.dart';
import '../../app/bloc/app_bloc.dart';
import '../cubit/forum_detail_cubit.dart';
import '../view/forum_detail_page.dart';

class CardReply extends StatelessWidget {
  const CardReply({super.key, this.comment, required this.focusNode});

  final Replies? comment;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final userId = getIt<AppBloc>().state.user?.id;
    final user = comment?.user;

    return BlocBuilder<ForumDetailCubit, ForumDetailState>(
      builder: (context, state) {
        final isHighlighted = comment?.id == state.lastIdComment;

        return Padding(
          key: GlobalObjectKey(comment?.id ?? 0),
          padding: const EdgeInsets.only(left: 65, bottom: 5, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  ImageAvatar(
                    image: user?.profile?.avatarLink ?? "",
                    radius: 18,
                  ),
                  const SizedBox(width: 10),
                  // Bubble
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: isHighlighted
                                ? AppColors.secondaryColor
                                : AppColors.greyColor.withValues(alpha: 0.3),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.profile == null
                                    ? "Akun Terhapus"
                                    : user?.profile?.fullname ?? "",
                                style: TextStyle(
                                    color: isHighlighted
                                        ? AppColors.whiteColor
                                        : user?.profile == null ? AppColors.redColor : AppColors.blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              DetectText(
                                text: comment?.comment ?? "",
                                colorText: isHighlighted
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              timeago.format(
                                comment?.createdAt != null
                                    ? DateTime.parse(comment!.createdAt!)
                                    : DateTime.now(),
                                locale: 'id',
                              ),
                              style: const TextStyle(
                                color: AppColors.greyColor,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                FocusScope.of(context).requestFocus(focusNode);
                                SystemChannels.textInput
                                    .invokeMethod("TextInput.show");

                                // Prefill reply input
                                if ((comment?.userId ?? 0) == userId) {
                                  commentKey.currentState?.controller?.text =
                                      "";
                                } else {
                                  final mention = user?.username ??
                                      user?.profile?.fullname?.split(' ').first;
                                  commentKey.currentState?.controller?.text =
                                      "@$mention ";
                                }
                                print("ID user : ${comment?.userId}");
                                print("ID user : $userId");
                                var cubit =
                                    context.read<ForumDetailCubit>();
                                // Simpan target balasan
                                cubit.setReplyTargetCommentId(comment?.commentId.toString() ?? "0");
                                // Set parent comment ID
                                context.read<ForumDetailCubit>().copyState(
                                      newState: context
                                          .read<ForumDetailCubit>()
                                          .state
                                          .copyWith(
                                              commentId:
                                                  comment?.commentId ?? 0),
                                    );
                              },
                              child: const Text(
                                "Balas",
                                style: TextStyle(
                                  color: AppColors.greyColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
