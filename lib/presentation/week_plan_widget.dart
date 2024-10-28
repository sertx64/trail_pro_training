import 'package:flutter/material.dart';
import 'package:trailpro_planning/domain/week_plan_map.dart';
import 'package:trailpro_planning/presentation/day_plan_screen.dart';

class WeekPlanWidget extends StatelessWidget {
  WeekPlanWidget({super.key});

  List<Map<String, String>> weekPlan = WeekPlanMap.weekPlan;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 5.0, color: const Color.fromRGBO(1, 57, 104, 1)),
                borderRadius: BorderRadius.circular(16),
                //color: Colors.orange,
              ),
              //padding: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                    style: TextStyle(
                        color: (weekPlan[index]['label_training'] == '')
                            ?Colors.blueGrey
                            :const Color.fromRGBO(255, 132, 26, 1),
                        fontSize: 22),
                    weekPlan[index]['date']!),
                subtitle: Text(
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    (weekPlan[index]['label_training'] == '')
                        ?'День отдыха'
                        :weekPlan[index]['label_training']!
                ),
                onTap: () {
                  (weekPlan[index]['label_training'] == '')
                      ? null
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DayPlan(weekPlan[index]),
                          ),
                        );
                },
              )),
          itemCount: weekPlan.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ));
  }
}
