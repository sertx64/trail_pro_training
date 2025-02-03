import 'package:flutter/material.dart';
import 'package:trailpro_planning/domain/student_report.dart';

class ReportsWidget extends StatelessWidget {
  const ReportsWidget(this.reports, {super.key});
  final List<String> reports;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  style: const TextStyle(color: Colors.green, fontSize: 20),
                  splitReports(reports)[index][0]),
              Row(
                children: [
                  Text(
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      'Нагрузка ${splitReports(reports)[index][1]}'),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                      'Самочуствие ${splitReports(reports)[index][2]}'),
                ],
              ),
              Text(splitReports(reports)[index][3]),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: splitReports(reports).length,
      ),
    );
  }
}
