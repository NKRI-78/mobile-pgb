import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static String formatToDayMonthYear(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.year}';
    } catch (e) {
      return '-';
    }
  }

  static String formatDate(DateTime formatDate) {
    initializeDateFormatting("id");
    return DateFormat.yMMMMEEEEd("id").format(formatDate);
  }

  static String getDate(DateTime dateTime) {
    final now = DateTime(dateTime.year, dateTime.month, dateTime.day,
        dateTime.hour, dateTime.minute);
    initializeDateFormatting("id");
    return DateFormat.yMMMMEEEEd("id").format(now);
  }

  static String parseDate(String formatDate) {
    initializeDateFormatting("id");
    DateTime dateParse = DateTime.parse(formatDate);
    final result =
        DateTime(dateParse.year, dateParse.month, dateParse.day, 9, 0, 0);
    String date = DateFormat("d MMMM y", "id_ID").format(result);

    return date;
  }

  static String parseDateExpired(String formatDate, String type) {
    initializeDateFormatting("id");
    DateTime dateParse =
        DateTime.parse(formatDate).add(const Duration(hours: 7));
    String date = DateFormat("dd MMM yyyy HH:mm", "id_ID").format(dateParse.add(
      type == "VIRTUAL_ACCOUNT"
          ? const Duration(
              days: 1,
            )
          : const Duration(
              minutes: 15,
            ),
    ));
    return date;
  }

  static String getFormatedDate(String formatDate) {
    DateTime dateParse = DateTime.parse(formatDate);
    final result =
        DateTime(dateParse.year, dateParse.month, dateParse.day, 9, 0, 0);
    String date = DateFormat("yyyy-MM-dd").format(result);
    return date;
  }

  static String getFormatedDateWithHours(String formatDate) {
    DateTime dateParse = DateTime.parse(formatDate);
    final result = DateTime(dateParse.year, dateParse.month, dateParse.day,
            dateParse.hour, dateParse.minute, 9, 0, 0)
        .add(Duration(hours: 7));
    initializeDateFormatting("id");
    String date = DateFormat("dd MMMM yyyy | HH:mm a", "id_ID").format(result);
    return date;
  }

  static String getMonthYear(String formatDate) {
    initializeDateFormatting("id");
    DateTime dateParse = DateTime.parse(formatDate);
    return DateFormat("MMMM yyyy", "id_ID").format(dateParse);
  }

  static int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  static String formatFullDate(String? formatDate) {
    if (formatDate == null || formatDate.isEmpty) return "-";
    try {
      final date = DateTime.parse(formatDate).toLocal();
      return DateFormat("dd MMMM yyyy | HH.mm 'WIB'", "id_ID").format(date);
    } catch (e) {
      return "-";
    }
  }
}
