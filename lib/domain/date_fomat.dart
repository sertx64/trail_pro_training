import 'package:intl/intl.dart';
import 'package:week_number/iso.dart';

String yearWeekNow() {
  final now = DateTime.now();
  String year = DateFormat('yyyy').format(now);
  int week = now.weekNumber;

  return '$year$week';
}
