import 'package:flutter/material.dart';
import 'package:trailpro_planning/domain/week_plan_map.dart';
import 'package:trailpro_planning/presentation/day_plan_screen.dart';

class WeekPlanWidget extends StatefulWidget {
  const WeekPlanWidget({super.key});

  @override
  State<WeekPlanWidget> createState() => _WeekPlanWidgetState();
}

class _WeekPlanWidgetState extends State<WeekPlanWidget> {
  List<Map<String, String>>? weekPlan;

  @override
  void initState() {
    loadWeekPlan();
    super.initState();
  }

  void loadWeekPlan() async {
    weekPlan = await WeekPlanMap().weekPlan();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (weekPlan == null)
        ? const SizedBox(child: Text('Идёт загрузка'))
        : Padding(
            padding: const EdgeInsets.all(8.0),
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
                      title: Text(
                          style: TextStyle(
                              color: (dayPlan['label_training'] == '')
                                  ? Colors.blueGrey
                                  : const Color.fromRGBO(255, 132, 26, 1),
                              fontSize: 22),
                          dayPlan['date']!),
                      subtitle: Text(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          (dayPlan['label_training'] == '')
                              ? 'День отдыха'
                              : dayPlan['label_training']!),
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
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ));
  }
}
