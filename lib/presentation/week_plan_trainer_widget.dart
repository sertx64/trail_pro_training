import 'package:flutter/material.dart';
import 'package:trailpro_planning/domain/date_fomat.dart';
import 'package:trailpro_planning/domain/week_plan_map.dart';
import 'package:trailpro_planning/domain/week_plan_sent_list.dart';
import 'package:trailpro_planning/presentation/day_plan_trainer.dart';

class WeekPlanTrainerWidget extends StatefulWidget {
  const WeekPlanTrainerWidget({super.key});

  @override
  State<WeekPlanTrainerWidget> createState() => _WeekPlanTrainerWidgetState();
}

class _WeekPlanTrainerWidgetState extends State<WeekPlanTrainerWidget> {
  List<Map<String, String>>? weekPlan;

  @override
  void initState() {
    loadWeekPlan();
    super.initState();
  }

  void loadWeekPlan() async {
    String yW = yearWeekNow();
    weekPlan = await WeekPlanMap(yW).weekPlanStudent();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (weekPlan == null)
        ? const Center(
            child: CircularProgressIndicator(
            color: Color.fromRGBO(255, 132, 26, 1),
            strokeWidth: 6,
          ))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemBuilder: (context, index) {
                Map<String, String> dayPlan = weekPlan![index];
                final TextEditingController _controllerLabelTraining =
                    TextEditingController(text: dayPlan['label_training']);
                final TextEditingController _controllerDescriptionTraining =
                    TextEditingController(
                        text: dayPlan['description_training']);
                return Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 5.0, color: const Color.fromRGBO(1, 57, 104, 1)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 5.0,
                                    color: (dayPlan['label_training'] == '')
                                        ? Colors.blueGrey
                                        : const Color.fromRGBO(1, 57, 104, 1)),
                                shape: BoxShape.circle,
                                color: (dayPlan['label_training'] == '')
                                    ? Colors.blueGrey
                                    : const Color.fromRGBO(255, 132, 26, 1),
                              ),
                              child: Center(
                                child: Text(
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 12),
                                    dayPlan['day']!),
                              )),
                          //const SizedBox(width: 6),
                          Text(
                              style: const TextStyle(
                                  color: Color.fromRGBO(1, 57, 104, 1),
                                  fontSize: 16),
                              dayPlan['date']!),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0))),
                            onPressed: () {
                              dayPlan['label_training'] = _controllerLabelTraining.text;
                              dayPlan['description_training'] = _controllerDescriptionTraining.text;
                              setState(() {});
                              WeekPlanSentList(weekPlan!).sentPlan();
                            },
                            child: const Text('Ok'),
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 6),
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
                        controller: _controllerLabelTraining,
                      ),
                      const SizedBox(height: 6),
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
                        controller: _controllerDescriptionTraining,
                      ),
                    ],
                  ),
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => DayPlanTrainer(),
                  //     ),
                  //   );
                  // },
                );
              },
              itemCount: weekPlan!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ));
  }
}
