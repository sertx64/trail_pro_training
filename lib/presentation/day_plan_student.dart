import 'package:flutter/material.dart';
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
          child: Text(
          style: const TextStyle(color: Color.fromRGBO(1, 57, 104, 1), fontSize: 25),
          dayPlanMap['description_training']!)),
    );
  }
}
