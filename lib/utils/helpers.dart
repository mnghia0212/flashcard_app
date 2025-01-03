import 'package:intl/intl.dart';

class Helpers {
  static String stringToDateTime(String dateString) {
    DateFormat format = DateFormat.yMMMd();
    final date = format.parse(dateString);
   
    return DateFormat.yMMMd().format(date);
  }
}
