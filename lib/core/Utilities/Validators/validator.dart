import 'package:intl/intl.dart';

class Validators {
  static String dateTimeToString(DateTime? dateTime) {
    if (dateTime != null) {
      final DateFormat format = DateFormat("EEE, d MMM");
      return format.format(dateTime);
    } else {
      return "";
    }
  }

  static String dateTimeToAMString(DateTime? dateTime) {
    if (dateTime != null) {
      final DateFormat format = DateFormat("h a");
      return format.format(dateTime);
    } else {
      return "";
    }
  }

  static String dateTimeToWeekDay(DateTime? dateTime) {
    if (dateTime != null) {
      final DateFormat format = DateFormat("EEEE");
      return format.format(dateTime);
    } else {
      return "";
    }
  }
}
