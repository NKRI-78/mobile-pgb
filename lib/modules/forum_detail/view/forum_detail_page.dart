import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:go_router/go_router.dart';

import '../../../misc/colors.dart';
import '../../../misc/modal.dart';
import '../../../misc/text_style.dart';
import '../../../repositories/forum_repository/models/forum_detail_model.dart';
import '../../../repositories/forum_repository/models/forums_model.dart';
import '../../../router/builder.dart';
import '../../../widgets/detect_text/detect_text.dart';
import '../../../widgets/image/image_avatar.dart';
import '../../../widgets/like/like_comment.dart';
import '../../../widgets/like/like_comment_top.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';
import '../../../widgets/pages/video/video_player.dart';
import '../cubit/forum_detail_cubit.dart';
import '../widget/comment_forum.dart';
import '../widget/detail_card_header/detail_card_header_forum.dart';
import '../widget/media/media_file.dart';
import '../widget/media/media_images.dart';

part '../widget/_input_comment.dart';
part '../widget/detail_forum.dart';

final GlobalKey dataKey = GlobalKey();

class ForumDetailPage extends StatelessWidget {
  const ForumDetailPage({super.key, required this.idForum});

  final String idForum;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForumDetailCubit()..init(idForum),
      child: ForumDetailView(),
    );
  }
}

class ForumDetailView extends StatefulWidget {
  const ForumDetailView({super.key});

  @override
  State<ForumDetailView> createState() => _ForumDetailViewState();
}

class _ForumDetailViewState extends State<ForumDetailView>
    with TickerProviderStateMixin {
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForumDetailCubit, ForumDetailState>(
      builder: (context, state) {
        return Portal(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Detail Interaksi",
                style: AppTextStyles.textStyleBold,
              ),
              centerTitle: true,
              toolbarHeight: 80,
              elevation: 0,
              surfaceTintColor: Colors.white,
              backgroundColor: AppColors.whiteColor,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 24,
                ),
                onPressed: () {
                  GoRouter.of(context).pop();
                },
              ),
            ),
            bottomNavigationBar: InputComment(
              idForum: state.detailForum?.id ?? 0,
              gk: dataKey,
              inputNode: myFocusNode,
            ),
            body: CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: [
                state.loading
                    ? const SliverFillRemaining(
                        child: Center(child: CustomLoadingPage()),
                      )
                    : state.detailForum == null
                        ? const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: EmptyPage(
                                msg: "Tidak ada postingan",
                                noImage: true,
                                height: 0.50,
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                DetailForum(
                                  focusNode: myFocusNode,
                                  forum: state.detailForum,
                                )
                              ],
                            ),
                          )
              ],
            ),
          ),
        );
      },
    );
  }
}
