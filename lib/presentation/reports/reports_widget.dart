import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/student_report.dart';
import 'package:trailpro_planning/presentation/reports/sent_report_widget.dart';

class ReportsWidget extends StatelessWidget {
  ReportsWidget({super.key});
  final Management management = GetIt.instance<Management>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
        valueListenable: management.reportsOfDay,
        builder: (context, value, child) {
          return (!management.isLoadingReports)
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color.fromRGBO(255, 132, 26, 1),
                  strokeWidth: 6,
                ))
              : (!value.contains(Management.userLogin) && Management.userLogin != '')
                  ? SentReportWidget(management.dayPlanStudentGroup['date']!)
                  : SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  style: const TextStyle(
                                      color: Colors.green, fontSize: 20),
                                  StudentReport().splitReports(value)[index][0]),
                              Row(
                                children: [
                                  Text(
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 16),
                                      'Нагрузка ${StudentReport().splitReports(value)[index][1]}'),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 16),
                                      'Самочуствие ${StudentReport().splitReports(value)[index][2]}'),
                                ],
                              ),
                              Text(StudentReport().splitReports(value)[index][3]),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemCount: StudentReport().splitReports(value).length,
                      ),
                    );
        });
  }
}
