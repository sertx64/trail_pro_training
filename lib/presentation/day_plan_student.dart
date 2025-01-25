import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/student_report.dart';

class DayPlan extends StatefulWidget {
  const DayPlan({super.key});

  @override
  State<DayPlan> createState() => _DayPlanState();
}

class _DayPlanState extends State<DayPlan> {
  final Map<String, String> dayPlanGroup = Management.dayPlanStudentGroup;
  final Map<String, String> dayPlanPersonal = Management.dayPlanStudentPersonal;

  List<String>? reports;
  String textFeedback = '';
  double _load = 3.0;
  double _feeling = 3.0;

  @override
  void initState() {
    (Management.currentWeek * 10 +
        Management.currentDayWeek <
        int.parse(yearWeekNow()) * 10 + dayWeekNow())
    ? loadReports()
    : null;
    super.initState();
  }

  void loadReports() async {
    reports = await getReports(dayPlanGroup['date']!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controllerFeedback =
        TextEditingController(text: textFeedback);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 57, 104, 1),
        title: Text(
            style: const TextStyle(color: Colors.white, fontSize: 27),
            dayPlanGroup['date']!),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Visibility(
                  visible: (dayPlanGroup['label_training']! == '')
                      ? false
                      : true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('групповая тренировка'),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(255, 132, 26, 1), fontSize: 19),
                          dayPlanGroup['label_training']!),


                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(1, 57, 104, 1), fontSize: 20),
                          dayPlanGroup['description_training']!),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
                Visibility(
                  visible: (dayPlanPersonal['label_training']! == '')
                      ? false
                      : true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('персональная'),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(255, 132, 26, 1), fontSize: 19),
                          dayPlanPersonal['label_training']!),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(1, 57, 104, 1), fontSize: 20),
                          dayPlanPersonal['description_training']!),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),

                Visibility(
                    visible: (Management.currentWeek * 10 +
                                Management.currentDayWeek <
                            int.parse(yearWeekNow()) * 10 + dayWeekNow())
                        ? true
                        : false,
                    child: (reports == null)
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Color.fromRGBO(255, 132, 26, 1),
                            strokeWidth: 6,
                          ))
                        : (reports!.contains(Management.userLogin))
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Уже оставляли отчёт:'),
                                  Text(
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 20),
                                      'Вы испытали нагрузку: ${reports![
                                      reports!.indexOf(Management.userLogin) +
                                          1]}'),
                                  Text(
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 20),
                                      'Ваше самочуствие: ${reports![
                                  reports!.indexOf(Management.userLogin) +
                                      2]}'),
                                  const Text('Также оставили комментарий:'),
                                  Text(reports![
                                      reports!.indexOf(Management.userLogin) +
                                          3]),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 20),
                                      'Нагрузка: ${_load.toStringAsFixed(0)}'),
                                  Slider(
                                    min: 1,
                                    max: 5,
                                    divisions: 4,
                                    value: _load,
                                    label: _load.toStringAsFixed(0),
                                    activeColor: Colors.red,
                                    thumbColor:
                                        const Color.fromRGBO(255, 132, 26, 1),
                                    onChanged: (newValue) {
                                      textFeedback = controllerFeedback.text;
                                      _load = newValue;
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 20),
                                      'Самочуствие: ${_feeling.toStringAsFixed(0)}'),
                                  Slider(
                                    min: 1,
                                    max: 5,
                                    divisions: 4,
                                    value: _feeling,
                                    label: _feeling.toStringAsFixed(0),
                                    activeColor: Colors.blue,
                                    thumbColor:
                                        const Color.fromRGBO(255, 132, 26, 1),
                                    onChanged: (newValue) {
                                      textFeedback = controllerFeedback.text;
                                      _feeling = newValue;
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  const Text('Впечатления (не обязательно)'),
                                  TextField(
                                    maxLength: 200,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                      ),
                                    ),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(1, 57, 104, 1),
                                        fontSize: 16),
                                    controller: controllerFeedback,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(110, 40),
                                          backgroundColor: const Color.fromRGBO(
                                              1, 57, 104, 1)),
                                      onPressed: () {
                                        if (controllerFeedback.text == '') {
                                          controllerFeedback.text =
                                              'нет комментария';
                                        }
                                        sentReport(
                                            dayPlanGroup['date']!,
                                            _load.toStringAsFixed(0),
                                            _feeling.toStringAsFixed(0),
                                            controllerFeedback.text);
                                        context.go('/studentscreen');
                                      },
                                      child: const Text(
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromRGBO(
                                                  255, 132, 26, 1)),
                                          'Отчёт')),
                                ],
                              )),
              ],
            ),
          )),
    );
  }
}
