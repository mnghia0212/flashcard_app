import 'package:intl/intl.dart';

class Helpers {
  static String stringToDateTime(String dateString) {
    DateTime parsedDate = DateTime.parse(dateString);
     String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }
}
