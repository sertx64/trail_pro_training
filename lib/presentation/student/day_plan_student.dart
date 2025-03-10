import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/presentation/reports/reports_widget.dart';




class DayPlan extends StatelessWidget {
  const DayPlan({super.key});


  @override
  Widget build(BuildContext context) {
    final List<DayPlanModel> dayPlan = GoRouterState.of(context).extra as List<DayPlanModel>;
    final DayPlanModel dayPlanGroup = dayPlan[0];
    final DayPlanModel dayPlanPersonal = dayPlan[1];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(1, 57, 104, 1),
        title: Text(
            style: const TextStyle(color: Colors.white, fontSize: 27),
            dayPlanGroup.date),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible:
                      (dayPlanGroup.label == '') ? false : true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Групповая тренировка'),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(255, 132, 26, 1),
                              fontSize: 19),
                          dayPlanGroup.label),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(1, 57, 104, 1),
                              fontSize: 20),
                          dayPlanGroup.description),
                    ],
                  ),
                ),
                Visibility(
                  visible:
                      (dayPlanPersonal.label == '') ? false : true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('персональная'),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(255, 132, 26, 1),
                              fontSize: 19),
                          dayPlanPersonal.label),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(1, 57, 104, 1),
                              fontSize: 20),
                          dayPlanPersonal.description),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
                Visibility(
                  visible: (DatePasing().isAfterDay(dayPlanGroup.date) && dayPlanGroup.label != '')
                      ? true
                      : false,
                  child: ReportsWidget(dayPlanGroup.date),
                ),
              ],
            ),
          )),
    );
  }
}
