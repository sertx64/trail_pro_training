import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/presentation/week_plan_trainer_widget.dart';
import 'package:trailpro_planning/domain/management.dart';

class PersonalPlanTrainerScreen extends StatelessWidget {
  const PersonalPlanTrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

            centerTitle: true,
            title: Text(
                style: const TextStyle(fontSize: 22, color: Colors.white),
                Management.plan,
            ),
            backgroundColor: Colors.amber),
        body: const WeekPlanTrainerWidget());
  }
}
