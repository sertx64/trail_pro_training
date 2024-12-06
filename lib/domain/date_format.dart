import 'package:intl/intl.dart';
import 'package:week_number/iso.dart';

String yearWeekNow() {
  final now = DateTime.now();
  String year = DateFormat('yyyy').format(now);
  int week = now.weekNumber;


  return (week < 10) ? '${year}0$week' : '$year$week';
}

String dateNow() {
  final now = DateTime.now();
  String date = DateFormat('dd.MM.yyyy').format(now);
  return date;
}