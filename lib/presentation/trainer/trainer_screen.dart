import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/student_cubit.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/presentation/climbing_animation.dart';
import 'package:trailpro_planning/presentation/trainer/day_plan_trainer.dart';

class TrainerScreen extends StatelessWidget {
  const TrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<StudentScreenCubit>().loadWeekPlan();
    return BlocBuilder<StudentScreenCubit, PlanDataModel>(
        builder: (context, value) {
      return (value.isDay)
          ? DayPlanTrainer()
          : Scaffold(
              backgroundColor: Colors.grey[300],
              appBar: AppBar(
                  actions: [
                    IconButton(
                      icon: const Icon(
                          color: Color.fromRGBO(255, 132, 26, 1),
                          Icons.exit_to_app),
                      onPressed: () => context.go('/authorization'),
                    ),
                  ],
                  centerTitle: true,
                  title: Text(
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                      context.read<StudentScreenCubit>().planType),
                  backgroundColor: const Color.fromRGBO(1, 57, 104, 1)
          ),
          bottomNavigationBar: BottomAppBar(
                padding:  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                height: 68,
                  color: const Color.fromRGBO(1, 57, 104, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(
                            size: 30,
                              color: Color.fromRGBO(255, 132, 26, 1),
                              Icons.menu_book),
                          onPressed: () => context.push('/creatsamlescreen'),
                        ),
                        const Text(
                            style: const TextStyle(color: Colors.white),
                            'Шаблоны'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(
                              size: 30,
                              color: Color.fromRGBO(255, 132, 26, 1), Icons.group),
                          onPressed: () => _showGroupsListModal(context),
                        ),
                        const Text(
                            style: const TextStyle(color: Colors.white),
                            'Группы'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(
                              size: 30,
                              color: Color.fromRGBO(255, 132, 26, 1),
                              Icons.person_search),
                          onPressed: () => _showUserListModal(context),
                        ),
                        const Text(
                            style: const TextStyle(color: Colors.white),
                            'Ученики'),
                      ],
                    ),


                  ],
                ),
              ),
              body: (!value.planLoaded)
                  ? const Center(
                  child: LottieAnimationLoadBar())
                  : Stack(children: [
                    ListView.separated(
                      itemBuilder: (context, index) {
                        DayPlanModel dayPlan = value.weekPlanGroup[index];
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
                                color: (dayPlan.date ==
                                        DatePasing().dateNow())
                                    ? Colors.green[100]
                                    : (DatePasing().isAfterDay(dayPlan.date))
                                        ? Colors.grey[350]
                                        : Colors.white,
                                border: Border.all(
                                    width: 3.0,
                                    color:
                                        const Color.fromRGBO(1, 57, 104, 1)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    8.0, 1.0, 8.0, 1.0),
                                title: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 5.0,
                                                  color: (dayPlan.label == '')
                                                      ? Colors.blueGrey
                                                      : const Color.fromRGBO(
                                                          1, 57, 104, 1)),
                                              shape: BoxShape.circle,
                                              color: (dayPlan.label == '')
                                                  ? Colors.blueGrey
                                                  : const Color.fromRGBO(
                                                      255, 132, 26, 1),
                                            ),
                                            child: Center(
                                              child: Text(
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                                    fontWeight:
                                                        FontWeight.w600,
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
                                  (dayPlan.label == '' &&
                                          DatePasing()
                                              .isAfterDay(dayPlan.date))
                                      ? null
                                      : {
                                          context
                                              .read<StudentScreenCubit>()
                                              .openDay(index)
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
                        bottom: 0,
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10)),
                                          fixedSize: const Size(90, 50),
                                          backgroundColor:
                                              const Color.fromARGB(
                                                  200, 1, 57, 104)),
                                      onPressed: () {
                                        context
                                            .read<StudentScreenCubit>()
                                            .nextWeek();
                                      },
                                      child: const Icon(
                                          color: Colors.white,
                                          Icons.arrow_forward_sharp)),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10)),
                                          fixedSize: const Size(80, 40),
                                          backgroundColor:
                                              const Color.fromARGB(
                                                  200, 1, 57, 104)),
                                      onPressed: () {
                                        context
                                            .read<StudentScreenCubit>()
                                            .previousWeek();
                                      },
                                      child: const Icon(
                                          color: Colors.white,
                                          Icons.arrow_back_sharp)),
                                ]))),
                  ]));
    });
  }

  void _showUserListModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            height: MediaQuery.of(dialogContext).size.height,
            width: MediaQuery.of(dialogContext).size.width,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Пользователи',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Text(
                      'Регистрация пользователя',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(
                          color: Color.fromRGBO(255, 132, 26, 1),
                          Icons.person_add),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.push('/adduserscreen');
                      }
                    ),
                  ],
                ),
                const Text('Выберете ученика для составления индивидуального плана'),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: Management.userList.length,
                    separatorBuilder: (dialogContext, index) =>
                    const SizedBox(height: 8),
                    itemBuilder: (dialogContext, index) {
                      return TextButton(
                        child: Text(
                          Management.userList[index],
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          context
                              .read<StudentScreenCubit>()
                              .choosingPlanType(Management.userList[index]);
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 50),
                        backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                    onPressed: () {Navigator.of(dialogContext).pop();},
                    child: const Text(
                        style: TextStyle(fontSize: 24, color: Colors.white),
                        'Закрыть')),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGroupsListModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            height: MediaQuery.of(dialogContext).size.height,
            width: MediaQuery.of(dialogContext).size.width,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Группы',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Text(
                      'Добавить группу',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(
                          color: Color.fromRGBO(255, 132, 26, 1),
                          Icons.group_add),
                      onPressed: () {},
                    ),
                  ],
                ),
                const Text('Выберете группу для составления недельного плана'),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: Management.groupsList.length,
                    separatorBuilder: (dialogContext, index) =>
                    const SizedBox(height: 8),
                    itemBuilder: (dialogContext, index) {
                      return TextButton(
                        child: Text(
                          style: const TextStyle(fontSize: 20, color: Colors.black),
                          Management.groupsList[index],
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          context
                              .read<StudentScreenCubit>()
                              .choosingPlanType(Management.groupsList[index]);
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 50),
                        backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                    onPressed: () {Navigator.of(dialogContext).pop();},
                    child: const Text(
                        style: TextStyle(fontSize: 24, color: Colors.white),
                        'Закрыть')),
              ],
            ),
          ),
        );
      },
    );
  }
}
