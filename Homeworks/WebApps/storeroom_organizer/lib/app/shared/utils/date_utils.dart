import 'package:intl/intl.dart';

class DateUtils {
  static String formatDateToDescription(DateTime date) {
    final formatter = DateFormat.yMMMMd();
    return formatter.format(date);
  }

  static String formatDate(String dateText) {
    final date = DateTime.parse(dateText);
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static DateTime toDate(String dateText) {
    final date = DateTime.parse(dateText);
    return date;
  }
}
