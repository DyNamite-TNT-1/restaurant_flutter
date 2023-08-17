import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }

//change from "2023-08-17T17:44:36.415Z" to "17/08/2023 17:44"
  String toDateTime() {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(this);
    var inputDate = DateTime.parse(parseDate.toString());
    return DateFormat('dd/MM/yyyy HH:mm').format(inputDate);
  }
}
