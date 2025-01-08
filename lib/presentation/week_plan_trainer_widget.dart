import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/week_plan_map.dart';

class WeekPlanTrainerWidget extends StatefulWidget {
  const WeekPlanTrainerWidget({super.key});

  @override
  State<WeekPlanTrainerWidget> createState() => _WeekPlanStudentWidgetState();
}

class _WeekPlanStudentWidgetState extends State<WeekPlanTrainerWidget> {
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      Map<String, String> dayPlan = weekPlan![index];
                      return Container(
                          decoration: BoxDecoration(
                            color: (dayPlan['date'] == dateNow())
                                ? Colors.green[100]
                                : Colors.white,
                            border: Border.all(
                                width: 5.0,
                                color: const Color.fromRGBO(1, 57, 104, 1)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 5.0,
                                              color:
                                                  (dayPlan['label_training'] ==
                                                          '')
                                                      ? Colors.blueGrey
                                                      : const Color.fromRGBO(
                                                          1, 57, 104, 1)),
                                          shape: BoxShape.circle,
                                          color:
                                              (dayPlan['label_training'] == '')
                                                  ? Colors.blueGrey
                                                  : const Color.fromRGBO(
                                                      255, 132, 26, 1),
                                        ),
                                        child: Center(
                                          child: Text(
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  fontSize: 22),
                                              dayPlan['day']!),
                                        )),
                                    const SizedBox(width: 8),
                                    Column(
                                      children: [
                                        Text(
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    1, 57, 104, 1),
                                                fontSize: 22),
                                            dayPlan['date']!),
                                        Text(
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(
                                                    1, 57, 104, 1),
                                                fontSize: 18),
                                            (dayPlan['label_training'] == '')
                                                ? 'День отдыха'
                                                : dayPlan['label_training']!),
                                      ],
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: (dayPlan['label_training'] == '')
                                      ? false
                                      : true,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      const Text('описание:'),
                                      Text(
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Color.fromRGBO(1, 57, 104, 1),
                                              fontSize: 18),
                                          dayPlan['description_training']!),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Management.currentDayWeek = index;
                              Management.currentWeekPlan = weekPlan!;
                              Management.currentWeek = yW;

                              context.go(
                                  '/trainerauth/trainerscreen/dayplantrainer');
                            },
                          ));
                    },
                    itemCount: weekPlan!.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(110, 40),
                            backgroundColor:
                                const Color.fromRGBO(1, 57, 104, 1)),
                        onPressed: () {
                          --yW;
                          if (yW == 202444) yW = 202445;
                          if (yW == 202500) yW = 202452;
                          if (yW == 202600) yW = 202552;
                          if (yW == 202700) yW = 202652;

                          loadWeekPlan(yW);
                        },
                        child: const Text(
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(255, 132, 26, 1)),
                            '<<<')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(80, 40),
                            backgroundColor:
                            Colors.green),
                        onPressed: () {
                          loadWeekPlan(yW);
                        },
                        child: const Icon(
                            color: Colors.white,
                            Icons.refresh)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(110, 40),
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
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(255, 132, 26, 1)),
                            '>>>')),
                  ],
                )
              ],
            ),
          );
  }
}
