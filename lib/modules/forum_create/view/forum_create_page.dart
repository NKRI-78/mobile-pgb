import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/text_style.dart';
import '../../../widgets/button/custom_button.dart';
import '../../forum/cubit/forum_cubit.dart';
import '../cubit/forum_create_cubit.dart';
import '../widget/_button_media.dart';
import '../widget/_thumbnail_media.dart';

part '../widget/_input_description.dart';

class ForumCreatePage extends StatelessWidget {
  const ForumCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForumCreateCubit(),
      child: ForumCreateView(),
    );
  }
}

class ForumCreateView extends StatelessWidget {
  const ForumCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: Color(0xFFF8F9FA),
          title: Text(
            'Create Interaksi',
            style: AppTextStyles.textStyleBold.copyWith(fontSize: 20),
          ),
          centerTitle: true,
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
        bottomNavigationBar: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom > 0
                ? MediaQuery.of(context).viewInsets.bottom
                : 20,
            left: 20,
            right: 20,
          ),
          child: SafeArea(
            top: false,
            child: BlocBuilder<ForumCreateCubit, ForumCreateState>(
              builder: (context, state) {
                return CustomButton(
                  backgroundColour: AppColors.secondaryColor,
                  textColour: AppColors.whiteColor,
                  text: state.loading ? 'Loading...' : 'Posting',
                  onPressed: state.loading
                      ? null
                      : () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (dialogContext) {
                              return WillPopScope(
                                onWillPop: () async => false,
                                child: Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              AppColors.secondaryColor,
                                            ),
                                            strokeWidth: 3,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Text(
                                          'Sedang Memposting...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Mohon tunggu sebentar',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                          await context
                              .read<ForumCreateCubit>()
                              .createForum(context);

                          if (context.mounted) {
                            Navigator.of(context).pop();

                            if (context
                                .read<ForumCreateCubit>()
                                .state
                                .description
                                .trim()
                                .isNotEmpty) {
                              getIt<ForumCubit>().fetchForum();
                              Navigator.pop(context);
                            }
                          }
                        },
                  child: state.loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 10),
              InputDescription(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Tambahkan Media',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ButtonMedia(),
              SizedBox(height: 16),
              ThumbnailMedia(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
