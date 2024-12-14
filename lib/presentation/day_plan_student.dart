import 'package:flutter/material.dart';
import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/provider_test.dart';

class DayPlan extends StatelessWidget {
  DayPlan({super.key});
  final Map<String, String> dayPlanMap = ProviderTest.dayPlanStudent;

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
                      color: Color.fromRGBO(1, 57, 104, 1), fontSize: 25),
                  dayPlanMap['description_training']!),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(110, 40),
                      backgroundColor:
                      const Color.fromRGBO(1, 57, 104, 1)),
                  onPressed: () async {
                    List<String>? reportsList = await ApiGSheet().getReportsList(dayPlanMap['date']!);
                    reportsList!.add(ProviderTest.userLogin);
                    reportsList.add('9');
                    reportsList.add('8');
                    //ProviderTest.reportsList = reportsList;
                    ApiGSheet().sendReportsList(dayPlanMap['date']!, reportsList);
                  },
                  child: const Text(
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(255, 132, 26, 1)),
                      'Отчёт')),
            ],
          )),
    );
  }
}
