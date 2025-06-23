import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/custom_step_tracker.dart';
import '../../../misc/date_helper.dart';
import '../../../misc/snackbar.dart';
import '../../../misc/theme.dart';
import '../../../router/builder.dart';
import '../../../widgets/header/header_section.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';
import '../cubit/tracking_cubit.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage(
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
      create: (context) =>
          TrackingCubit()..getDetailTracking(noTracking, initIndex, idOrder),
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
                            delegate: SliverChildListDelegate([
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DetailRow(
                                        title: 'Nomor Resi',
                                        value:
                                            state.tracking?.cnote?.cnoteNo ?? "",
                                        isRight: false,
                                      ),
                                      DetailRow(
                                        title: 'Tanggal Pengiriman',
                                        value: DateHelper.parseDate(
                                            state.tracking?.cnote?.cnoteDate ??
                                                DateTime.now().toString()),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DetailRow(
                                        title: 'Estimasi',
                                        value: state.tracking?.cnote
                                                ?.estimateDelivery ??
                                            "",
                                        isRight: false,
                                      ),
                                      DetailRow(
                                        title: 'Jenis Layanan',
                                        value: state.tracking?.cnote
                                                ?.cnoteServicesCode ??
                                            "",
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DetailRow(
                                        title: 'Penjual',
                                        value: store,
                                        isRight: false,
                                      ),
                                      DetailRow(
                                        title: 'Pembeli',
                                        value: state.tracking?.cnote
                                                ?.cnoteReceiverName ??
                                            "",
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Status",
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: fontSizeDefault,
                                        ),
                                      ),
                                      Text(
                                        state.tracking?.cnote?.podStatus ?? "",
                                        style: const TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: fontSizeExtraLarge,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  state.tracking?.cnote?.photo != null
                                      ? InkWell(
                                          onTap: () {
                                            PageDetailProofShippingRoute(
                                                    noTracking: state.tracking
                                                            ?.cnote?.cnoteNo ??
                                                        "",
                                                    store: store,
                                                    initIndex: state.initIndex,
                                                    idOrder: state.idOrder,
                                                    $extra: state.tracking!)
                                                .go(context);
                                          },
                                          child: const Text(
                                            "Lihat Bukti Pengiriman",
                                            style: TextStyle(
                                              color: AppColors.blueColor,
                                              fontSize: fontSizeDefault,
                                            ),
                                          ),
                                        )
                                      : Container(),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                          steps: state.tracking?.history?.reversed
                                                  .map((e) {
                                                final isLast = e == lastOrder;
                                                return Steps(
                                                  title: Text(e.desc ?? ""),
                                                  description: e.date,
                                                  state: isLast
                                                      ? TrackerState.complete
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
                          ])),
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
    required this.value,
    this.isRight = true,
  });

  final String title;
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
