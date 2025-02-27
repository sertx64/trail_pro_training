import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/presentation/reports/reports_widget.dart';

class DayPlan extends StatelessWidget {
  DayPlan({super.key});

  final Management management = GetIt.instance<Management>();

  @override
  Widget build(BuildContext context) {
    Map<String, String> dayPlanGroup = management.dayPlanStudentGroup;
    Map<String, String> dayPlanPersonal = management.dayPlanStudentPersonal;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                  visible:
                      (dayPlanGroup['label_training']! == '') ? false : true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Групповая тренировка'),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(255, 132, 26, 1),
                              fontSize: 19),
                          dayPlanGroup['label_training']!),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(1, 57, 104, 1),
                              fontSize: 20),
                          dayPlanGroup['description_training']!),
                      //const SizedBox(height: 18),
                    ],
                  ),
                ),
                Visibility(
                  visible:
                      (dayPlanPersonal['label_training']! == '') ? false : true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('персональная'),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(255, 132, 26, 1),
                              fontSize: 19),
                          dayPlanPersonal['label_training']!),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(1, 57, 104, 1),
                              fontSize: 20),
                          dayPlanPersonal['description_training']!),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
                Visibility(
                  visible: (management.yearWeekIndex * 10 +
                              management.currentDayWeekIndex <
                          int.parse(DatePasing().yearWeekNow()) * 10 + DatePasing().dayWeekNow() && dayPlanGroup['label_training']! != '')
                      ? true
                      : false,
                  child: ReportsWidget(dayPlanGroup['date']!),
                ),
              ],
            ),
          )),
    );
  }
}
