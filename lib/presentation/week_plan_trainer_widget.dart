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
  int yW = int.parse(yearWeekNow());

  @override
  void initState() {
    loadWeekPlan(yW);
    super.initState();
  }

  void loadWeekPlan(int yWid) async {
    weekPlan = null;
    setState(() {});
    weekPlan = await WeekPlanMap(yWid).weekPlanStudent();
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
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(190, 30),
                            backgroundColor:
                                const Color.fromRGBO(1, 57, 104, 1)),
                        onPressed: () async {
                          --yW;
                          if (yW == 202444) yW = 202445;
                          if (yW == 202500) yW = 202452;
                          if (yW == 202600) yW = 202552;
                          if (yW == 202700) yW = 202652;

                          loadWeekPlan(yW);
                        },
                        child: const Text(
                            style: TextStyle(fontSize: 24, color: Colors.white),
                            '<<')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(190, 30),
                            backgroundColor:
                                const Color.fromRGBO(1, 57, 104, 1)),
                        onPressed: () {
                          ++yW;
                          if (yW == 202453) yW = 202501;
                          if (yW == 202553) yW = 202601;
                          if (yW == 202653) yW = 202701;

                          loadWeekPlan(yW);
                        },
                        child: const Text(
                            style: TextStyle(fontSize: 24, color: Colors.white),
                            '>>')),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      Map<String, String> dayPlan = weekPlan![index];
                      final TextEditingController _controllerLabelTraining =
                          TextEditingController(
                              text: dayPlan['label_training']);
                      final TextEditingController
                          controllerDescriptionTraining =
                          TextEditingController(
                              text: dayPlan['description_training']);
                      return Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: (dayPlan['date'] == dateNow())
                              ? Colors.greenAccent
                              : Colors.white,
                          border: Border.all(
                              width: 5.0,
                              color: const Color.fromRGBO(1, 57, 104, 1)),
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
                                          color:
                                              (dayPlan['label_training'] == '')
                                                  ? Colors.blueGrey
                                                  : const Color.fromRGBO(
                                                      1, 57, 104, 1)),
                                      shape: BoxShape.circle,
                                      color: (dayPlan['label_training'] == '')
                                          ? Colors.blueGrey
                                          : const Color.fromRGBO(
                                              255, 132, 26, 1),
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
                                IconButton(
                                  color: const Color.fromRGBO(1, 57, 104, 1),
                                  iconSize: 35.0,
                                  onPressed: () {
                                    dayPlan['label_training'] =
                                        _controllerLabelTraining.text;
                                    dayPlan['description_training'] =
                                        controllerDescriptionTraining.text;
                                    setState(() {});
                                    WeekPlanSentList(yW, weekPlan!).sentPlan();
                                  },
                                  icon: const Icon(Icons.save),
                                )
                              ],
                            ),
                            const SizedBox(height: 6),
                            TextField(
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
                              controller: controllerDescriptionTraining,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: weekPlan!.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                  ),
                ),
              ],
            ));
  }
}
