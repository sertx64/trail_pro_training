import 'package:flutter/material.dart';
import 'package:trailpro_planning/presentation/week_plan_student_widget.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
              style: TextStyle(fontSize: 27, color: Colors.white),
              'План тренировок'),
          backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
      body: const WeekPlanStudentWidget(),
    );
  }
}
