import 'package:intl/intl.dart';

String yearWeekNow() {
  // Получаем текущую дату
  final now = DateTime.now();

  // Форматируем строку для отображения года
  String year = DateFormat('yyyy').format(now);

  // Используем класс DateFormat для получения номера недели
  int weekNumber = int.parse(DateFormat('w').format(now));

  String yearweek = '$year$weekNumber';
  return yearweek;
}