import 'package:intl/intl.dart';

class Dateutils {
  static String formatDate(DateTime date) {
    final formatter = DateFormat.yMMMMd();
    return formatter.format(date);
  }
}
