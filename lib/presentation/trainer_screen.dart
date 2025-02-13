import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';

class TrainerScreen extends StatelessWidget {
  const TrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(
                    color: Color.fromRGBO(255, 132, 26, 1),
                    Icons.person_search),
                onPressed: () => context.push('/userlistscreen'),
              ),
              IconButton(
                icon: const Icon(
                    color: Color.fromRGBO(255, 132, 26, 1), Icons.person_add),
                onPressed: () => context.push('/adduserscreen'),
              ),
            ],
            centerTitle: true,
            title: const Text(
                style: TextStyle(fontSize: 22, color: Colors.white),
                'План для группы'),
            backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
        body: WeekPlanTrainerWidget());
  }
}

class WeekPlanTrainerWidget extends StatelessWidget {
  WeekPlanTrainerWidget({super.key});

  final Management management = GetIt.instance<Management>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Map<String, String>>>(
        valueListenable: management.weekPlanGroup,
        builder: (context, value, child) {
          return (!management.isLoadingPlans)
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color.fromRGBO(255, 132, 26, 1),
                  strokeWidth: 6,
                ))
              : Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
                  child: Stack(children: [
                    ListView.separated(
                      itemBuilder: (context, index) {
                        Map<String, String> dayPlan =
                            value[index];
                        return Container(
                            decoration: BoxDecoration(
                              color: (management.yearWeekIndex * 10 + index <
                                      int.parse(yearWeekNow()) * 10 +
                                          dayWeekNow() -
                                          1)
                                  ? Colors.grey[350]
                                  : (dayPlan['date'] == dateNow())
                                      ? Colors.green[100]
                                      : Colors.white,
                              border: Border.all(
                                  width: 3.0,
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
                                                color: (dayPlan[
                                                            'label_training'] ==
                                                        '')
                                                    ? Colors.blueGrey
                                                    : const Color.fromRGBO(
                                                        1, 57, 104, 1)),
                                            shape: BoxShape.circle,
                                            color: (dayPlan['label_training'] ==
                                                    '')
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                color: Color.fromRGBO(
                                                    1, 57, 104, 1),
                                                fontSize: 18),
                                            dayPlan['description_training']!),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                (dayPlan['label_training'] == '' && management.yearWeekIndex * 10 +
                                    index <
                                    int.parse(yearWeekNow()) * 10 + dayWeekNow())
                                    ? null
                                    : {
                                        management.newScreenDayPlanGroupTrainer(
                                            index),
                                        context.push('/dayplantrainer')
                                      };
                              },
                            ));
                      },
                      itemCount: 7,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 7),
                    ),
                    Positioned(
                        bottom: 16, // Отступ от нижнего края экрана
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
                                          backgroundColor: const Color.fromARGB(
                                              200, 1, 57, 104)),
                                      onPressed: () {
                                        management.nextWeek('trainergroup');
                                      },
                                      child: const Text(
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromRGBO(
                                                  255, 132, 26, 1)),
                                          '>>>')),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          fixedSize: const Size(80, 40),
                                          backgroundColor: const Color.fromARGB(
                                              200, 1, 57, 104)),
                                      onPressed: () {
                                        management.previousWeek('trainergroup');
                                      },
                                      child: const Text(
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromRGBO(
                                                  255, 132, 26, 1)),
                                          '<<<')),
                                ]))),
                  ]));
        });
  }
}
