import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/week_plan_sent_list.dart';

class PersolalDayPlanTrainer extends StatelessWidget {
  final String? lable =
      Management.currentWeekPlan[Management.currentDayWeek]['label_training'];

  final String? description = Management.currentWeekPlan[Management.currentDayWeek]
      ['description_training'];

  final String? date = Management.currentWeekPlan[Management.currentDayWeek]['date'];

  final String? day = Management.currentWeekPlan[Management.currentDayWeek]['day'];

  PersolalDayPlanTrainer({super.key});




  @override
  Widget build(BuildContext context) {
    TextEditingController controllerLabelTraining =
        TextEditingController(text: lable);
    TextEditingController controllerDescriptionTraining =
        TextEditingController(text: description);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(1, 57, 104, 1),
          title: Text(
              style: const TextStyle(fontSize: 30, color: Colors.white),
              'День $day $date'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: (Management.currentWeek * 10 + Management.currentDayWeek <
                    int.parse(yearWeekNow()) * 10 + dayWeekNow())
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          lable!),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          description!),
                      const SizedBox(
                        height: 10,
                      ),

                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const Text('Название'),
                        TextField(
                          maxLength: 27,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 6),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                          ),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(1, 57, 104, 1),
                              fontSize: 16),
                          controller: controllerLabelTraining,
                        ),
                        const SizedBox(height: 8),
                        const Text('Описание'),
                        TextField(
                          maxLines: null,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                          ),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(1, 57, 104, 1),
                              fontSize: 16),
                          controller: controllerDescriptionTraining,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                //fixedSize: const Size(200, 50),
                                backgroundColor:
                                    const Color.fromRGBO(1, 57, 104, 1)),
                            onPressed: () async {
                              Management.currentWeekPlan[Management
                                      .currentDayWeek]['label_training'] =
                                  controllerLabelTraining.text;
                              Management.currentWeekPlan[Management
                                      .currentDayWeek]['description_training'] =
                                  controllerDescriptionTraining.text;

                              WeekPlanSentList(
                                      Management.selectedUser,
                                      Management.currentWeek,
                                      Management.currentWeekPlan)
                                  .sentPlan();

                              context.go(
                                  '/trainerauth/trainerscreen/userlistscreen/personalplan');
                            },
                            child: const Text(
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                                'Сохранить')),
                      ]),
          ),
        ));
  }
}
