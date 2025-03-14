import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/student_cubit.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/presentation/climbing_animation.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentScreenCubit()..loadWeekPlan(),
      child: BlocBuilder<StudentScreenCubit, PlanDataModel>(
          builder: (context, state) {
        return Scaffold(
            appBar: buildAppBar(context),
            body: (!state.planLoaded)
                ? const Center(child: LottieAnimationLoadBar())
                : Stack(
                    children: [
                      buildListViewDaysWeek(state),
                      buildButtonSelectWeek(context)
                    ],
                  ));
      }),
    );
  }

  Positioned buildButtonSelectWeek(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fixedSize: const Size(90, 50),
                    backgroundColor: const Color.fromARGB(200, 1, 57, 104)),
                onPressed: () {
                  context.read<StudentScreenCubit>().nextWeek();
                },
                child:
                    const Icon(color: Colors.white, Icons.arrow_forward_sharp)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fixedSize: const Size(80, 40),
                    backgroundColor: const Color.fromARGB(200, 1, 57, 104)),
                onPressed: () {
                  context.read<StudentScreenCubit>().previousWeek();
                },
                child: const Icon(color: Colors.white, Icons.arrow_back_sharp)),
          ],
        ),
      ),
    );
  }

  ListView buildListViewDaysWeek(PlanDataModel state) {
    return ListView.separated(
      itemBuilder: (context, index) {
        DayPlanModel dayPlanGroup = state.weekPlanGroup[index];
        DayPlanModel dayPlanPersonal = state.weekPlanPersonal[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(3, 7),
                  ),
                ],
                color: (dayPlanGroup.date == DatePasing().dateNow())
                    ? Colors.green[100]
                    : (DatePasing().isAfterDay(dayPlanGroup.date))
                        ? Colors.grey[350]
                        : Colors.white,
                border: Border.all(
                    width: 3.0, color: const Color.fromRGBO(1, 57, 104, 1)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 5.0,
                              color: (dayPlanGroup.label == '')
                                  ? Colors.blueGrey
                                  : const Color.fromRGBO(1, 57, 104, 1)),
                          shape: BoxShape.circle,
                          color: (dayPlanGroup.label == '')
                              ? (dayPlanPersonal.label == '')
                                  ? Colors.blueGrey
                                  : Colors.green
                              : const Color.fromRGBO(255, 132, 26, 1),
                        ),
                        child: Center(
                          child: Text(
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 22),
                              dayPlanGroup.day),
                        )),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                                style: const TextStyle(
                                    color: Color.fromRGBO(1, 57, 104, 1),
                                    fontSize: 20),
                                dayPlanGroup.date),
                            const SizedBox(width: 10),
                            if (dayPlanGroup.date == DatePasing().dateNow())
                              const Text(
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  'Сегодня!'),
                          ],
                        ),
                        Visibility(
                          visible: (dayPlanGroup.label == '') ? false : true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(1, 57, 104, 1),
                                      fontSize: 18),
                                  dayPlanGroup.label),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: (dayPlanPersonal.label == '') ? false : true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('(персональная)'),
                              Text(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(1, 57, 104, 1),
                                      fontSize: 18),
                                  dayPlanPersonal.label),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: (dayPlanGroup.label == '' &&
                                  dayPlanPersonal.label == '')
                              ? true
                              : false,
                          child: const Text(
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(1, 57, 104, 1),
                                  fontSize: 18),
                              'День отдыха'),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  (dayPlanGroup.label == '' && dayPlanPersonal.label == '')
                      ? null
                      : {
                          context.push('/dayplan',
                              extra: [dayPlanGroup, dayPlanPersonal]),
                        };
                },
              )),
        );
      },
      itemCount: 7,
      separatorBuilder: (context, index) => const SizedBox(height: 1),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Цвет текста
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Закругленные углы
                ),
              ),
              onPressed: () {},
              child: Column(
                children: [
                  const Text('Профиль'),
                  Text(Management.user.login),
                ],
              )),
          IconButton(
            icon: const Icon(
                color: Color.fromRGBO(255, 132, 26, 1), Icons.exit_to_app),
            onPressed: () => context.go('/authorization'),
          ),
        ],
        centerTitle: true,
        title: const Text(
            style: TextStyle(fontSize: 27, color: Colors.white),
            'План тренировок'),
        backgroundColor: const Color.fromRGBO(1, 57, 104, 1));
  }
}
