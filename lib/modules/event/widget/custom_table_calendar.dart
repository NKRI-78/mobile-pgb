import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';

class CustomTableCalendar extends StatefulWidget {
  final Map<DateTime, List<String>> events;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CustomTableCalendar({
    super.key,
    required this.events,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<CustomTableCalendar> createState() => _CustomTableCalendarState();
}

class _CustomTableCalendarState extends State<CustomTableCalendar> {
  late final ValueNotifier<DateTime> _focusedDay;
  late DateTime _selectedDay;

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = ValueNotifier(widget.selectedDate);
    _selectedDay = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      color: AppColors.buttonBlueColor,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TableCalendar<String>(
          rowHeight: 36,
          locale: 'id_ID',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay.value,
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay.value = focusedDay;
            });
            widget.onDateSelected(selectedDay);
          },
          eventLoader: (day) {
            final normalizedDay = _normalizeDate(day);
            return widget.events[normalizedDay] ?? [];
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleTextStyle: AppTextStyles.textStyleBold.copyWith(
              fontSize: 14,
              color: AppColors.whiteColor,
            ),
            titleCentered: true,
            leftChevronIcon: SizedBox(
              height: 50,
              width: 50,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                  ),
                  color: AppColors.blackColor,
                  onPressed: () {
                    setState(() {
                      _focusedDay.value =
                          _focusedDay.value.subtract(const Duration(days: 30));
                    });
                  },
                ),
              ),
            ),
            rightChevronIcon: SizedBox(
              height: 50,
              width: 50,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  color: AppColors.blackColor,
                  onPressed: () {
                    setState(() {
                      _focusedDay.value =
                          _focusedDay.value.add(const Duration(days: 30));
                    });
                  },
                ),
              ),
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 12,
            ),
            weekendStyle: TextStyle(
              color: AppColors.redColor,
              fontSize: 12,
            ),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.secondaryColor.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 12,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.secondaryColor,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 12,
            ),
            markerDecoration: const BoxDecoration(
              color: AppColors.blueColor,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(
              color: AppColors.redColor,
              fontSize: 12,
            ),
            defaultTextStyle: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 12,
            ),
            outsideTextStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  right: 3,
                  bottom: -1,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${events.length}',
                      style: AppTextStyles.textStyleNormal.copyWith(
                        color: AppColors.blackColor,
                        fontSize: 8,
                      ),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
