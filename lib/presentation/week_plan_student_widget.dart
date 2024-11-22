import 'package:flutter/material.dart';
import 'package:trailpro_planning/domain/date_fomat.dart';
import 'package:trailpro_planning/domain/week_plan_map.dart';
import 'package:trailpro_planning/presentation/day_plan_student.dart';

class WeekPlanStudentWidget extends StatefulWidget {
  const WeekPlanStudentWidget({super.key});

  @override
  State<WeekPlanStudentWidget> createState() => _WeekPlanStudentWidgetState();
}

class _WeekPlanStudentWidgetState extends State<WeekPlanStudentWidget> {
  List<Map<String, String>>? weekPlan;
  int yW = int.parse(yearWeekNow());

  @override
  void initState() {
    loadWeekPlan(yW);
    super.initState();


  }



  void loadWeekPlan(int yWid) async {
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
                            border: Border.all(
                                width: 5.0,
                                color: const Color.fromRGBO(1, 57, 104, 1)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
                            title: Row(
                              children: [
                                Container(
                                    height: 60,
                                    width: 60,
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
                                              fontSize: 22),
                                          dayPlan['day']!),
                                    )),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(1, 57, 104, 1),
                                            fontSize: 22),
                                        dayPlan['date']!),
                                    Text(
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Color.fromRGBO(1, 57, 104, 1),
                                            fontSize: 18),
                                        (dayPlan['label_training'] == '')
                                            ? 'День отдыха'
                                            : dayPlan['label_training']!),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              (dayPlan['label_training'] == '')
                                  ? null
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DayPlan(dayPlan),
                                      ),
                                    );
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
                            fixedSize: const Size(190, 50),
                            backgroundColor:
                                const Color.fromRGBO(1, 57, 104, 1)),
                        onPressed: () async {
                          --yW;
                          if (yW == 202444) yW = 202445;
                          if (yW == 202500) yW = 202452;
                          if (yW == 202600) yW = 202552;
                          if (yW == 202700) yW = 202652;
                          print(yW);

                          loadWeekPlan(yW);
                        },
                        child: const Text(
                            style: TextStyle(fontSize: 24, color: Colors.white),
                            'прошлая')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(190, 50),
                            backgroundColor:
                                const Color.fromRGBO(1, 57, 104, 1)),
                        onPressed: () {
                          ++yW;
                          if (yW == 202453) yW = 202501;
                          if (yW == 202553) yW = 202601;
                          if (yW == 202653) yW = 202701;
                          print(yW);
                          loadWeekPlan(yW);
                        },
                        child: const Text(
                            style: TextStyle(fontSize: 24, color: Colors.white),
                            'следующая')),
                  ],
                )
              ],
            ),
          );
  }
}
