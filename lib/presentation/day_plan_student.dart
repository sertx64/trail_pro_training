import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/student_report.dart';
import 'package:trailpro_planning/presentation/reports_widget.dart';
import 'package:trailpro_planning/presentation/sent_report_widget.dart';

class DayPlan extends StatefulWidget {
  const DayPlan({super.key});

  @override
  State<DayPlan> createState() => _DayPlanState();
}

class _DayPlanState extends State<DayPlan> {

  final Management management = GetIt.instance<Management>();

 //List<String>? reports;

  // @override
  // void initState() {
  //   (management.yearWeekIndex * 10 + management.currentDayWeekIndex <
  //           int.parse(yearWeekNow()) * 10 + dayWeekNow())
  //       ? loadReports()
  //       : null;
  //   super.initState();
  // }
  //
  // void loadReports() async {
  //   reports = await getReports(management.dayPlanStudentGroup['date']!);
  //   setState(() {});
  // }

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
                      const Text('групповая тренировка'),
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
                      const SizedBox(height: 18),
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
                    visible: (management.yearWeekIndex * 10 + management.currentDayWeekIndex <
                        int.parse(yearWeekNow()) * 10 + dayWeekNow())
                        ? true
                        : false,
                    child: (management.isLoadingReports)
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Color.fromRGBO(255, 132, 26, 1),
                            strokeWidth: 6,
                          ))
                        : (management.reportsOfDay.contains(Management.userLogin))
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Уже оставляли отчёт:'),
                                  ReportsWidget(management.reportsOfDay),
                                ],
                              )
                            : SentReportWidget(dayPlanGroup['date']!)),
              ],
            ),
          )),
    );
  }
}
