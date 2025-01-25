import 'package:flutter/material.dart';
import 'package:trailpro_planning/presentation/pers_week_plan_trainer_widget.dart';
import 'package:trailpro_planning/domain/management.dart';

class PersonalPlanTrainerScreen extends StatelessWidget {
  const PersonalPlanTrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

            centerTitle: true,
            title: Column(
              children: [
                const Text('Персональный план для'),
                Text(
                    style: const TextStyle(fontSize: 26, color: Colors.white),
                    Management.selectedUser,
                ),
              ],
            ),
            backgroundColor: Colors.amber),
        body: const PersonalWeekPlanTrainerWidget());
  }
}
