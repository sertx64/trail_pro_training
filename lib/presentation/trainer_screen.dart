import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/presentation/week_plan_trainer_widget.dart';

class TrainerScreen extends StatelessWidget {
  const TrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
        appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(
                    color: Color.fromRGBO(255, 132, 26, 1),
                    Icons.person_search),
                onPressed: () => context.go('/trainerauth/trainerscreen/userlistscreen'),
              ),
              IconButton(
                icon: const Icon(
                    color: Color.fromRGBO(255, 132, 26, 1),
                    Icons.person_add),
                onPressed: () => context.go('/trainerauth/trainerscreen/adduserscreen'),
              ),
            ],
            centerTitle: true,
            title: const Text(
                style: TextStyle(fontSize: 22, color: Colors.white),
                'План для группы'),
            backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
        body: const WeekPlanTrainerWidget());
  }
}
