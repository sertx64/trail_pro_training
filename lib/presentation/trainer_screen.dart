import 'package:flutter/material.dart';
import 'package:trailpro_planning/presentation/week_plan_trainer_widget.dart';

class TrainerScreen extends StatelessWidget {
  const TrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

            title: const Text(
                style: TextStyle(fontSize: 27, color: Colors.white),
                'Составление плана'),
            backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),

        body: const WeekPlanTrainerWidget()
    );
  }
}
