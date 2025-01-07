import 'package:flutter/material.dart';
import 'package:trailpro_planning/domain/management.dart';

class DayPlanTrainer extends StatelessWidget {

  String? lable =
      Management.currentWeekPlan[Management.currentDayWeek]['label_training'];
  String? description = Management.currentWeekPlan[Management.currentDayWeek]
      ['description_training'];
  String? date = Management.currentWeekPlan[Management.currentDayWeek]['date'];
  String? day = Management.currentWeekPlan[Management.currentDayWeek]['day'];



  @override
  Widget build(BuildContext context) {

    TextEditingController controllerLabelTraining =
    TextEditingController(
        text: lable);
    TextEditingController
    controllerDescriptionTraining = TextEditingController(
        text: description);

    return Scaffold(
        appBar: AppBar(
          title: Text('Планируем $day $date'),
        ),
        body: Column(children: [
          TextField(
            maxLength: 27,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
            ),
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(1, 57, 104, 1),
                fontSize: 16),
            controller: controllerLabelTraining,
          ),
          const SizedBox(height: 2),
          TextField(
            maxLines: null,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
            ),
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(1, 57, 104, 1),
                fontSize: 16),
            controller: controllerDescriptionTraining,
          )
        ]));
  }
}
