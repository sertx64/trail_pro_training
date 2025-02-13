import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
              style: TextStyle(fontSize: 27, color: Colors.white),
              'План тренировок'),
          backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
      body: WeekPlanStudentWidget(),
    );
  }
}

class WeekPlanStudentWidget extends StatelessWidget {
  WeekPlanStudentWidget({super.key});

  final Management management = GetIt.instance<Management>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WeekPlansModel>(
        valueListenable: management.weekPlans,
        builder: (context, value, child) {
          return (!management.isLoadingPlans)
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color.fromRGBO(255, 132, 26, 1),
                  strokeWidth: 6,
                ))
              : Stack(
                  children: [
                    ListView.separated(
                      itemBuilder: (context, index) {
                        Map<String, String> dayPlanGroup =
                            value.weekPlanGroup[index];
                        Map<String, String> dayPlanPersonal =
                            value.weekPlanPersonal[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(3, 7), // Смещение тени
                                  ),
                                ],
                                color: (management.yearWeekIndex * 10 + index <
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
                                contentPadding: const EdgeInsets.fromLTRB(
                                    8.0, 0.0, 8.0, 0.0),
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 5.0,
                                              color: (dayPlanGroup[
                                                          'label_training'] ==
                                                      '')
                                                  ? Colors.blueGrey
                                                  : const Color.fromRGBO(
                                                      1, 57, 104, 1)),
                                          shape: BoxShape.circle,
                                          color: (dayPlanGroup[
                                                      'label_training'] ==
                                                  '')
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        1, 57, 104, 1),
                                                    fontSize: 20),
                                                dayPlanGroup['date']!),
                                            const SizedBox(width: 10),
                                            if (dayPlanGroup['date'] ==
                                                dateNow())
                                              const Text(
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 20,
                                                    fontWeight:
                                                    FontWeight.w800,),
                                                  'Сегодня!'),
                                          ],
                                        ),
                                        Visibility(
                                          visible:
                                              (dayPlanGroup['label_training'] ==
                                                      '')
                                                  ? false
                                                  : true,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromRGBO(
                                                          1, 57, 104, 1),
                                                      fontSize: 18),
                                                  dayPlanGroup[
                                                      'label_training']!),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: (dayPlanPersonal[
                                                      'label_training'] ==
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromRGBO(
                                                          1, 57, 104, 1),
                                                      fontSize: 18),
                                                  dayPlanPersonal[
                                                      'label_training']!),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: (dayPlanGroup[
                                                          'label_training'] ==
                                                      '' &&
                                                  dayPlanPersonal[
                                                          'label_training'] ==
                                                      '')
                                              ? true
                                              : false,
                                          child: const Text(
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      1, 57, 104, 1),
                                                  fontSize: 18),
                                              'День отдыха'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  (dayPlanGroup['label_training'] == '' &&
                                          dayPlanPersonal['label_training'] ==
                                              '')
                                      ? null
                                      : {
                                          management.newScreenDayPlan(index),
                                          context.push('/dayplan'),
                                        };
                                },
                              )),
                        );
                      },
                      itemCount: 7,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 1),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    fixedSize: const Size(90, 50),
                                    backgroundColor:
                                        const Color.fromARGB(200, 1, 57, 104)),
                                onPressed: () {
                                  management.nextWeek('student');
                                },
                                child: const Text(
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromRGBO(255, 132, 26, 1)),
                                    '>>>')),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    fixedSize: const Size(80, 40),
                                    backgroundColor:
                                        const Color.fromARGB(200, 1, 57, 104)),
                                onPressed: () {
                                  management.previousWeek('student');
                                },
                                child: const Text(
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromRGBO(255, 132, 26, 1)),
                                    '<<<')),
                          ],
                        ),
                      ),
                    )
                  ],
                );
        });
  }
}
