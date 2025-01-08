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
  final Map<String, String> dayPlanMap = Management.dayPlanStudent;

  List<String>? reports;

  double _load = 5.0;
  double _feeling = 5.0;

  @override
  void initState() {
    loadReports();
    super.initState();
  }

  void loadReports() async {
    reports = await getReports(dayPlanMap['date']!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 57, 104, 1),
        title: Text(
            style: const TextStyle(color: Colors.white, fontSize: 27),
            dayPlanMap['date']!),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  style: const TextStyle(
                      color: Color.fromRGBO(255, 132, 26, 1), fontSize: 19),
                  dayPlanMap['label_training']!),
              const SizedBox(height: 16),
              const Text('План:'),
              Text(
                  style: const TextStyle(
                      color: Color.fromRGBO(1, 57, 104, 1), fontSize: 20),
                  dayPlanMap['description_training']!),
              const SizedBox(height: 18),
              Visibility(
                  visible: (Management.currentWeek * 10 +
                              Management.currentDayWeek <=
                          int.parse(yearWeekNow()) * 10 + dayWeekNow())
                      ? true
                      : false,
                  child: (reports == null)
                      ? const Text('проверяем')
                      : (reports!.contains(Management.userLogin))
                          ? const Text('уже был отчёт')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Нагрузка: ${_load.toStringAsFixed(0)}'),
                                Slider(
                                  min: 1,
                                  max: 10,
                                  divisions: 9,
                                  value: _load,
                                  label: _load.toStringAsFixed(0),
                                  activeColor: Colors.red,
                                  thumbColor:
                                      const Color.fromRGBO(255, 132, 26, 1),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _load = newValue;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                Text(
                                    'Самочуствие: ${_feeling.toStringAsFixed(0)}'),
                                Slider(
                                  min: 1,
                                  max: 10,
                                  divisions: 9,
                                  value: _feeling,
                                  label: _feeling.toStringAsFixed(0),
                                  activeColor: Colors.blue,
                                  thumbColor:
                                      const Color.fromRGBO(255, 132, 26, 1),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _feeling = newValue;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(110, 40),
                                        backgroundColor: const Color.fromRGBO(
                                            1, 57, 104, 1)),
                                    onPressed: () {
                                      sentReport(
                                          dayPlanMap['date']!,
                                          _load.toStringAsFixed(0),
                                          _feeling.toStringAsFixed(0));
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
          )),
    );
  }
}
