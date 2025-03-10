import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/student_cubit.dart';
import 'package:trailpro_planning/domain/models/models.dart';

class TrainerScreen extends StatelessWidget {
  const TrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('БИЛД ЭКРАНА ТРЕНЕРА!!!');
    context
        .read<StudentScreenCubit>()
        .loadWeekPlan(context.read<StudentScreenCubit>().yearWeekIndex);
    return BlocBuilder<StudentScreenCubit, StudentDataModel>(
        builder: (context, value) {
      return Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(
                      color: Color.fromRGBO(255, 132, 26, 1), Icons.menu_book),
                  onPressed: () => context.push('/creatsamlescreen'),
                ),
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
                IconButton(
                  icon: const Icon(
                      color: Color.fromRGBO(255, 132, 26, 1),
                      Icons.exit_to_app),
                  onPressed: () => context.go('/authorization'),
                ),
              ],
              centerTitle: true,
              title: const Text(
                  style: TextStyle(fontSize: 22, color: Colors.white),
                  'План для группы'),
              backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
          body: (!value.isLoading)
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
                        DayPlanModel dayPlan = value.weekPlanGroup[index];
                        return Container(
                            decoration: BoxDecoration(
                              color: (dayPlan.date == DatePasing().dateNow())
                                  ? Colors.green[100]
                                  : (DatePasing().isAfterDay(dayPlan.date))
                                      ? Colors.grey[350]
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
                                                color: (dayPlan.label ==
                                                        '')
                                                    ? Colors.blueGrey
                                                    : const Color.fromRGBO(
                                                        1, 57, 104, 1)),
                                            shape: BoxShape.circle,
                                            color: (dayPlan.label ==
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
                                                dayPlan.day),
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
                                              dayPlan.date),
                                          Text(
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      1, 57, 104, 1),
                                                  fontSize: 18),
                                              (dayPlan.label == '')
                                                  ? 'День отдыха'
                                                  : dayPlan.label),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: (dayPlan.label == '')
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
                                            dayPlan.description),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                (dayPlan.label == '' && DatePasing().isAfterDay(dayPlan.date))
                                    ? null
                                    : context.push('/dayplantrainer', extra: [dayPlan, context.read<StudentScreenCubit>().yearWeekIndex]);
                              },
                            ));
                      },
                      itemCount: 7,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 7),
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
                                          backgroundColor: const Color.fromARGB(
                                              200, 1, 57, 104)),
                                      onPressed: () {
                                        context.read<StudentScreenCubit>().nextWeek();
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
                                        context.read<StudentScreenCubit>().previousWeek();
                                      },
                                      child: const Text(
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromRGBO(
                                                  255, 132, 26, 1)),
                                          '<<<')),
                                ]))),
                  ])));
    });
  }
}
