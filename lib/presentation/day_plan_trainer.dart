import 'package:flutter/material.dart';
import 'package:trailpro_planning/domain/week_plan_map.dart';

class DayPlanTrainer extends StatefulWidget {
  const DayPlanTrainer({super.key});

  @override
  State<DayPlanTrainer> createState() => _DayPlanTrainerState();
}

class _DayPlanTrainerState extends State<DayPlanTrainer> {

  //final Map<String, String> dayPlanMap;

  // List<Map<String, String>>? weekPlan;

  // @override
  // void initState() {
  //   loadWeekPlan();
  //   super.initState();
  // }
  //
  // void loadWeekPlan() async {
  //   weekPlan = await WeekPlanMap().weekPlanStudent();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 57, 104, 1),
        title: Text(
            style: const TextStyle(color: Colors.white, fontSize: 27),
            'дата'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              style: const TextStyle(color: Color.fromRGBO(1, 57, 104, 1), fontSize: 25),
              'треня')),
    );
  }
}