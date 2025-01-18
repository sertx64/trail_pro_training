import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/presentation/week_plan_trainer_widget.dart';

class TrainerScreen extends StatelessWidget {
  const TrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(
                    color: Color.fromRGBO(255, 132, 26, 1),
                    Icons.person_add),
                onPressed: () => context.go('/trainerauth/trainerscreen/adduserscreen'),
              ),
            ],
            centerTitle: true,
            title: const Text(
                style: TextStyle(fontSize: 27, color: Colors.white),
                'План на неделю'),
            backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
        body: const WeekPlanTrainerWidget());
  }
}
