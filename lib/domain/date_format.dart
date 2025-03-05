import 'package:intl/intl.dart';
import 'package:week_number/iso.dart';

class DatePasing {

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

  int dayWeekNow() {
    final now = DateTime.now();
    return now.weekday;
  }

  bool isAfterDay (String dateString) {

    // Преобразование строки в объект DateTime
    DateTime date = DateFormat("dd.MM.yyyy").parse(dateString);

    // Получение текущей даты
    DateTime now = DateTime.now();

    // Проверка, наступил ли этот день
    if (now.isAfter(date)) {
      return true;
    } else if (now.isBefore(date)) {
      return false;
    } else {
      return true;
    }
  }

}