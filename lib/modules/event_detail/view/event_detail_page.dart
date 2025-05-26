import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../misc/theme.dart';
import '../../../widgets/button/custom_button.dart';
import '../../../widgets/photo_view/custom_fullscreen_preview.dart';
import '../cubit/event_detail_cubit.dart';

part '../widget/custom_deskripsi_detail_event.dart';
part '../widget/custom_image_detail_event.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key, required this.idEvent});

  final int idEvent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventDetailCubit()..fetchDetailEvent(idEvent),
      child: EventDetailView(
        idEvent: idEvent,
      ),
    );
  }
}

class EventDetailView extends StatelessWidget {
  const EventDetailView({super.key, required this.idEvent});

  final int idEvent;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailCubit, EventDetailState>(
      builder: (context, state) {
        final eventData = state.event?.data;
        final imageUrl = eventData?.imageUrl?.isNotEmpty == true
            ? eventData?.imageUrl
            : null;
        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Detail Event',
              style: AppTextStyles.textStyleBold,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _customDetailEvent(context, imageUrl),
                SizedBox(height: 20),
                state.loading
                    ? _customLoadingContent()
                    : _customDeskripsi(eventData),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(10),
            child: state.loading
                ? SizedBox.shrink()
                : CustomButton(
                    onPressed: state.isJoined
                        ? null
                        : () async {
                            await context
                                .read<EventDetailCubit>()
                                .joinEvent(context);
                          },
                    text: state.isJoined ? "Sudah Bergabung" : "Bergabung",
                    backgroundColour:
                        state.isJoined ? Colors.grey : AppColors.secondaryColor,
                    textColour: AppColors.whiteColor,
                  ),
          ),
        );
      },
    );
  }
}
