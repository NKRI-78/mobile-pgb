import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../misc/colors.dart';
import '../../../misc/snackbar.dart';
import '../../../misc/theme.dart';
import '../cubit/need_riview_cubit.dart';
import '../../../repositories/oder_repository/models/need_riview_model.dart';
import '../../../widgets/button/custom_button.dart';
import '../../../widgets/image/image_card.dart';

class ListRiview extends StatelessWidget {
  const ListRiview({super.key, this.e});

  final NeedRiviewModel? e;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NeedRiviewCubit, NeedRiviewState>(
      builder: (context, st) {
        final rating = st.productRatings[e?.id.toString() ?? "0"];
        final files = st.pickedFile[e?.id.toString()]?['gallery'] ?? [];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ImageCard(
                      image: (e?.product?.pictures?.isEmpty ?? false)
                          ? ""
                          : e?.product?.pictures?.first.link ?? "",
                      height: 50,
                      radius: 0,
                      width: 50,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          e?.product?.name ?? "",
                          maxLines: 2,
                          style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: fontSizeDefault,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            RatingBar(
              alignment: Alignment.centerLeft,
              size: 40,
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              onRatingChanged: (value) {
                context
                    .read<NeedRiviewCubit>()
                    .updateRating(e?.id.toString() ?? "0", value.toInt());
              },
              initialRating: 0,
              maxRating: 5,
            ),
            Container(
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(10.0)),
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1.0,
                          blurRadius: 3.0,
                          offset: const Offset(0.0, 1.0))
                    ],
                  ),
                  child: TextFormField(
                    minLines: 3,
                    maxLines: 5,
                    cursorColor: AppColors.blackColor,
                    onChanged: (value) {
                      context
                          .read<NeedRiviewCubit>()
                          .setMessage(e?.id.toString() ?? "", value);
                    },
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter
                    ],
                    decoration: InputDecoration(
                      hintText: "Ulasan kamu",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 15.0),
                      isDense: true,
                      hintStyle: TextStyle(
                          color: AppColors.greyColor.withValues(alpha: 0.8)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                  ),
                )),
            Wrap(
              spacing: 10,
              children: [
                ...files.asMap().entries.map((entry) {
                  final index = entry.key;
                  final file = entry.value;
                  return Stack(
                    children: [
                      Image.file(file,
                          width: 100, height: 100, fit: BoxFit.cover),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => context
                              .read<NeedRiviewCubit>()
                              .removeImage(
                                  e?.id.toString() ?? "0", 'gallery', index),
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: AppColors.redColor,
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.close,
                                  size: 20, color: AppColors.primaryColor)),
                        ),
                      )
                    ],
                  );
                }),
                if (files.length < 3)
                  GestureDetector(
                    onTap: () => context.read<NeedRiviewCubit>().uploadImg(
                        context, e?.id.toString() ?? "0", 'gallery',
                        max: 3),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: AppColors.primaryColor,
                      child: const Icon(Icons.add_a_photo),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomButton(
                  onPressed: st.loadingSubmit
                      ? null
                      : () {
                          if (rating == null || rating == 0) {
                            ShowSnackbar.snackbar(
                                context, "Rating bintang harus diisi",
                                isSuccess: false);
                          } else {
                            try {
                              if (context.mounted) {
                                context.read<NeedRiviewCubit>().userRating(
                                    e?.id.toString() ?? "", context);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ShowSnackbar.snackbar(context, e.toString(),
                                    isSuccess: false);
                              }
                            }
                          }
                        },
                  backgroundColour: AppColors.secondaryColor,
                  textColour: AppColors.whiteColor,
                  text: "Beri Penilaian"),
            )
          ],
        );
      },
    );
  }
}
