import 'package:flutter/material.dart';

class DayPlan extends StatelessWidget {
  const DayPlan(this.dayPlanMap, {super.key});

  final Map<String, String> dayPlanMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 57, 104, 1),
        title: Text(
            style: const TextStyle(color: Colors.white, fontSize: 27),
            dayPlanMap['date']!),
      ),
      body: Center(child: Text(dayPlanMap['description_training']!)),
    );
  }
}
