import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../cubit/event_cubit.dart';
import '../widget/custom_table_calendar.dart';
import '../../../router/builder.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';

import '../../../misc/text_style.dart';
import '../../../repositories/event_repository/models/event_model.dart';
import '../widget/custom_card_event.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<EventCubit>()..fetchEvent(),
      child: const EventView(),
    );
  }
}

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  // Simpan tanggal tanpa jam, menit, detik
  DateTime _selectedDate = normalizeDate(DateTime.now());

  // Helper untuk normalize tanggal (hilangkan jam, menit, detik)
  static DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Map<DateTime, List<EventModel>> groupEventsByDate(List<EventModel> events) {
    final Map<DateTime, List<EventModel>> data = {};

    for (final event in events) {
      DateTime current = normalizeDate(event.startDate);
      final end = normalizeDate(event.endDate);

      while (!current.isAfter(end)) {
        if (!data.containsKey(current)) {
          data[current] = [];
        }
        data[current]!.add(event);
        current = current.add(const Duration(days: 1));
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
        final rawEvents = state.events ?? [];
        final groupedEvents = groupEventsByDate(rawEvents);

        // Normalize _selectedDate saat akses map
        final selectedEvents =
            groupedEvents[normalizeDate(_selectedDate)] ?? [];

        return RefreshIndicator(
          color: AppColors.secondaryColor,
          onRefresh: () async {
            await context.read<EventCubit>().fetchEvent();
          },
          child: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              title: Text(
                'Event',
                style: AppTextStyles.textStyleBold,
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: BlocBuilder<EventCubit, EventState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(
                    child: CustomLoadingPage(),
                  );
                }
                if (state.errorMessage.isNotEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      Center(
                        child: EmptyPage(
                          msg:
                              'Gagal memuat Event\nkembali lagi untuk merefresh..',
                        ),
                      ),
                    ],
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      CustomTableCalendar(
                        events: groupedEvents.map((key, value) =>
                            MapEntry(key, value.map((e) => e.title).toList())),
                        selectedDate: _selectedDate,
                        onDateSelected: (date) {
                          setState(() => _selectedDate = normalizeDate(date));
                        },
                      ),
                      const SizedBox(height: 16),
                      if (selectedEvents.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "Tidak ada event pada tanggal ini.",
                              style: AppTextStyles.textStyleNormal,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else if (selectedEvents.length == 1)
                        Builder(builder: (context) {
                          final event = selectedEvents[0];
                          return CustomCardEventSection(
                            imageUrl: selectedEvents[0].imageUrl,
                            title: selectedEvents[0].title,
                            startDate: selectedEvents[0].startDate,
                            endDate: selectedEvents[0].endDate,
                            onTap: () {
                              EventDetailRoute(idEvent: event.id).go(context);
                            },
                          );
                        })
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: selectedEvents.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            final event = selectedEvents[index];
                            return CustomCardEventSection(
                              imageUrl: event.imageUrl,
                              title: event.title,
                              startDate: event.startDate,
                              endDate: event.endDate,
                              onTap: () {
                                EventDetailRoute(idEvent: event.id).go(context);
                              },
                            );
                          },
                        ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
