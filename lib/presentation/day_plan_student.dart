import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/provider_test.dart';
import 'package:trailpro_planning/domain/student_report.dart';

class DayPlan extends StatelessWidget {
  DayPlan({super.key});
  final Map<String, String> dayPlanMap = ProviderTest.dayPlanStudent;
  final TextEditingController _load = TextEditingController();
  final TextEditingController _feeling = TextEditingController();

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
              const SizedBox(height: 18),
              TextField(
                textAlign: TextAlign.center,
                cursorColor: const Color.fromRGBO(255, 132, 26, 1),
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: 'Нагрузка',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                controller: _load,
              ),
              const SizedBox(height: 10),
              TextField(
                textAlign: TextAlign.center,
                cursorColor: const Color.fromRGBO(255, 132, 26, 1),
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: 'Самочуствие',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                controller: _feeling,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(110, 40),
                      backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                  onPressed: () {
                    sentReport(dayPlanMap['date']!, _load.text, _feeling.text);
                    context.go('/studentscreen');
                  },
                  child: const Text(
                      style: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(255, 132, 26, 1)),
                      'Отчёт')),
            ],
          )),
    );
  }
}
