import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/week_plan_map.dart';

class WeekPlanStudentWidget extends StatefulWidget {
  const WeekPlanStudentWidget({super.key});

  @override
  State<WeekPlanStudentWidget> createState() => _WeekPlanStudentWidgetState();
}

class _WeekPlanStudentWidgetState extends State<WeekPlanStudentWidget> {
  List<Map<String, String>>? weekPlanGroup;
  List<Map<String, String>>? weekPlanPersonal;
  int yW = int.parse(yearWeekNow());

  @override
  void initState() {
    loadWeekPlan(yW);
    super.initState();
  }

  void loadWeekPlan(int yWid) async {
    weekPlanGroup = null;
    weekPlanPersonal = null;
    setState(() {});
    weekPlanPersonal =
        await WeekPlanMap(Management.userLogin, yWid).weekPlanStudent();
    weekPlanGroup = await WeekPlanMap('tp_week_plan', yWid).weekPlanStudent();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (weekPlanGroup == null)
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
                      Map<String, String> dayPlanGroup = weekPlanGroup![index];
                      Map<String, String> dayPlanPersonal =
                          weekPlanPersonal![index];
                      return Container(
                          decoration: BoxDecoration(
                            color: (yW * 10 + index <
                                    int.parse(yearWeekNow()) * 10 +
                                        dayWeekNow() -
                                        1)
                                ? Colors.grey[350]
                                : (dayPlanGroup['date'] == dateNow())
                                    ? Colors.green[100]
                                    : Colors.white,
                            border: Border.all(
                                width: 3.0,
                                color: const Color.fromRGBO(1, 57, 104, 1)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 5.0,
                                          color:
                                              (dayPlanGroup['label_training'] ==
                                                      '')
                                                  ? Colors.blueGrey
                                                  : const Color.fromRGBO(
                                                      1, 57, 104, 1)),
                                      shape: BoxShape.circle,
                                      color:
                                          (dayPlanGroup['label_training'] == '')
                                              ? (dayPlanPersonal[
                                                          'label_training'] ==
                                                      '')
                                                  ? Colors.blueGrey
                                                  : Colors.green
                                              : const Color.fromRGBO(
                                                  255, 132, 26, 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontSize: 22),
                                          dayPlanGroup['day']!),
                                    )),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(1, 57, 104, 1),
                                            fontSize: 20),
                                        dayPlanGroup['date']!),
                                    Visibility(
                                      visible:
                                          (dayPlanGroup['label_training'] == '')
                                              ? false
                                              : true,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('(групповая)'),
                                          Text(
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      1, 57, 104, 1),
                                                  fontSize: 18),
                                              dayPlanGroup['label_training']!),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          (dayPlanPersonal['label_training'] ==
                                                  '')
                                              ? false
                                              : true,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('(персональная)'),
                                          Text(
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      1, 57, 104, 1),
                                                  fontSize: 18),
                                              dayPlanPersonal[
                                                  'label_training']!),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          (dayPlanGroup['label_training'] ==
                                                      '' &&
                                                  dayPlanPersonal[
                                                          'label_training'] ==
                                                      '')
                                              ? true
                                              : false,
                                      child: const Text(
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Color.fromRGBO(1, 57, 104, 1),
                                              fontSize: 18),
                                          'День отдыха'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              (dayPlanGroup['label_training'] == '' &&
                                      dayPlanPersonal['label_training'] == '')
                                  ? null
                                  : {
                                      Management.dayPlanStudentGroup =
                                          dayPlanGroup,
                                      Management.dayPlanStudentPersonal =
                                          dayPlanPersonal,
                                      Management.currentDayWeek = index,
                                      Management.currentWeek = yW,
                                      context.go('/studentscreen/dayplan'),
                                      // Management.reportsList =
                                      //     (await getReports(dayPlan['date']!))!,
                                    };
                            },
                          ));
                    },
                    itemCount: weekPlanGroup!.length,
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
                        onPressed: () async {
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
