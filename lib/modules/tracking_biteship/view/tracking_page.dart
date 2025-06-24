import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pgb/misc/text_style.dart';
import 'package:mobile_pgb/widgets/image/image_card.dart';
import 'package:mobile_pgb/widgets/photo_view/custom_fullscreen_preview.dart';
import '../../../misc/colors.dart';
import '../../../misc/custom_step_tracker.dart';
import '../../../misc/snackbar.dart';
import '../../../misc/theme.dart';
import '../../webview/webview.dart';
import '../cubit/tracking_cubit.dart';
import '../../../widgets/header/header_section.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';

class TrackingBitshipPage extends StatelessWidget {
  const TrackingBitshipPage(
      {super.key,
      required this.noTracking,
      required this.store,
      required this.initIndex,
      required this.idOrder});

  final String noTracking;
  final String store;
  final int initIndex;
  final int idOrder;

  @override
  Widget build(BuildContext context) {
    print("No Tracking : $noTracking");
    return BlocProvider<TrackingCubit>(
      create: (context) => TrackingCubit()
        ..getDetailTrackingBiteship(noTracking, initIndex, idOrder),
      child: TrackingView(
        store: store,
      ),
    );
  }
}

class TrackingView extends StatelessWidget {
  const TrackingView({super.key, required this.store});

  final String store;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingCubit, TrackingState>(
      builder: (context, state) {
        final lastOrder = state.tracking?.history?.last;
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: CustomScrollView(
            slivers: [
              const HeaderSection(titleHeader: "Lacak"),
              state.loading
                  ? const SliverFillRemaining(
                      child: Center(child: CustomLoadingPage()),
                    )
                  : state.tracking == null
                      ? const SliverFillRemaining(
                          child: Center(
                              child: EmptyPage(msg: "Resi tidak ditemukan")))
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      border: Border.all(
                                          color: AppColors.blackColor
                                              .withValues(alpha: 0.2))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Detail",
                                            style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: fontSizeExtraLarge,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                          thickness: .3,
                                          color: AppColors.blackColor),
                                      Text(
                                        "No Resi",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            state.tracking?.waybillId ?? "",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              try {
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text: state.tracking
                                                                ?.waybillId ??
                                                            ""));
                                                if (context.mounted) {
                                                  ShowSnackbar.snackbar(context,
                                                      "Berhasil menyalin nomor resi",
                                                      isSuccess: true);
                                                }
                                              } catch (e) {
                                                ///
                                              }
                                            },
                                            child: const Icon(
                                              Icons.copy,
                                              size: 20,
                                              color: AppColors.blueColor,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Penjual",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.tracking?.origin
                                                    ?.contactName ??
                                                "-",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.greyColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            state.tracking?.origin?.address ??
                                                "-",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Pembeli",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.tracking?.destination
                                                    ?.contactName ??
                                                "-",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.greyColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            state.tracking?.destination
                                                    ?.address ??
                                                "-",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      border: Border.all(
                                          color: AppColors.blackColor
                                              .withValues(alpha: 0.2))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Kurir",
                                            style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: fontSizeExtraLarge,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            state.tracking?.courier?.company
                                                    ?.toUpperCase() ??
                                                "-",
                                            style: AppTextStyles.textStyleBold,
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                          thickness: .3,
                                          color: AppColors.blackColor),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomFullscreenPreview(
                                                            imageUrl: state
                                                                    .tracking
                                                                    ?.courier
                                                                    ?.driverPhotoUrl ??
                                                                "-"),
                                                  ),
                                                );
                                              },
                                              child: ImageCard(
                                                image: state.tracking?.courier
                                                        ?.driverPhotoUrl ??
                                                    "-",
                                                radius: 8,
                                                width: 60,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              // Supaya teks tidak overflow dan fleksibel
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Bagian Atas
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        state.tracking?.courier
                                                                ?.driverName ??
                                                            "",
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize:
                                                              fontSizeDefault,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        state.tracking?.courier
                                                                ?.driverPlateNumber ??
                                                            "",
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .greyColor,
                                                          fontSize:
                                                              fontSizeDefault,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${state.tracking?.courier?.driverPhone}',
                                                    style: const TextStyle(
                                                      color:
                                                          AppColors.greyColor,
                                                      fontSize: fontSizeDefault,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    border: Border.all(
                                      color: AppColors.blackColor
                                          .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomStepTracker(
                                              dotSize: 10,
                                              selectedColor: Colors.green,
                                              unSelectedColor: Colors.red,
                                              stepTrackerType:
                                                  StepTrackerType.dotVertical,
                                              pipeSize: 30,
                                              steps: state.tracking?.history
                                                      ?.reversed
                                                      .map((e) {
                                                    final isLast =
                                                        e == lastOrder;
                                                    return Steps(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(e.status
                                                                  ?.replaceAll(
                                                                      '_', ' ')
                                                                  .toUpperCase() ??
                                                              ""),
                                                          if (e.status ==
                                                              "allocated")
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                final url = state
                                                                    .tracking
                                                                    ?.link;
                                                                if (url !=
                                                                    null) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              WebViewScreen(
                                                                        url:
                                                                            url,
                                                                        title:
                                                                            'Lacak Pengiriman',
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    AppColors
                                                                        .blueColor,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  vertical: 12,
                                                                  horizontal: 5,
                                                                ),
                                                                minimumSize:
                                                                    Size(0, 0),
                                                                tapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                                visualDensity:
                                                                    VisualDensity
                                                                        .compact,
                                                                elevation: 2,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                "Lacak Pengiriman",
                                                                style: AppTextStyles
                                                                    .textStyleNormal
                                                                    .copyWith(
                                                                  color: AppColors
                                                                      .whiteColor,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      description: e.note,
                                                      state: isLast
                                                          ? TrackerState
                                                              .complete
                                                          : TrackerState.none,
                                                    );
                                                  }).toList() ??
                                                  [],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
            ],
          ),
        );
      },
    );
  }
}

class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.title,
    this.address = "",
    required this.value,
    this.isRight = true,
  });

  final String title;
  final String address;
  final String value;
  final bool? isRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            isRight == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.blackColor,
            ),
          ),
          Text(
            address,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title == "Nomor Resi"
                  ? const SizedBox(
                      width: 6,
                    )
                  : Container(),
              title == "Nomor Resi"
                  ? InkWell(
                      onTap: () async {
                        try {
                          await Clipboard.setData(ClipboardData(text: value));
                          if (context.mounted) {
                            ShowSnackbar.snackbar(
                                context, "Berhasil menyalin nomor resi",
                                isSuccess: true);
                          }
                        } catch (e) {
                          ///
                        }
                      },
                      child: const Icon(
                        Icons.copy,
                        size: 20,
                        color: AppColors.blueColor,
                      ),
                    )
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}
