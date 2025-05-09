import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/users.dart';
import 'package:trailpro_planning/domain/url_utils.dart';
import 'package:trailpro_planning/presentation/climbing_animation.dart';
import 'package:trailpro_planning/presentation/trainer/day_plan_trainer.dart';

class TrainerScreen extends StatelessWidget {
  const TrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenCubit()..loadWeekPlan(),
      child: BlocBuilder<HomeScreenCubit, PlanDataModel>(
          builder: (context, state) {
        return (state.isDay)
            ? DayPlanTrainer()
            : Scaffold(
                backgroundColor: Colors.grey[300],
                appBar: buildAppBar(context),
                bottomNavigationBar: buildBottomAppBar(context),
                body: (!state.planLoaded)
                    ? const Center(child: LottieAnimationLoadBar())
                    : buildListViewDaysWeek(state),
                floatingActionButton: buildFloatingActionButton(context),
              );
      }),
    );
  }

  Padding buildFloatingActionButton(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      backgroundColor: const Color.fromARGB(200, 1, 57, 104),
                      onPressed: context.read<HomeScreenCubit>().previousWeek,
                      heroTag: 'prevWeek',
                      child: const Icon(
                          color: Colors.white, Icons.arrow_back_sharp),
                    ),
                    const SizedBox(width: 11),
                    FloatingActionButton(
                        backgroundColor:
                            const Color.fromARGB(200, 1, 57, 104),
                        onPressed: context.read<HomeScreenCubit>().nextWeek,
                        heroTag: 'nextWeek',
                        child: const Icon(
                            color: Colors.white, Icons.arrow_forward_sharp)),
                  ],
                ),
              );
  }

  ListView buildListViewDaysWeek(PlanDataModel state) {
    return ListView.separated(
      itemBuilder: (context, index) {
        DayPlanModel dayPlan = state.weekPlanGroup[index];
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
                color: (dayPlan.date == DatePasing().dateNow())
                    ? Colors.green[100]
                    : (DatePasing().isAfterDay(dayPlan.date))
                        ? Colors.grey[350]
                        : Colors.white,
                border: Border.all(
                    width: 3.0, color: const Color.fromRGBO(1, 57, 104, 1)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
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
                                  color: (dayPlan.label == '')
                                      ? Colors.blueGrey
                                      : const Color.fromRGBO(1, 57, 104, 1)),
                              shape: BoxShape.circle,
                              color: (dayPlan.label == '')
                                  ? Colors.blueGrey
                                  : const Color.fromRGBO(255, 132, 26, 1),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                style: const TextStyle(
                                    color: Color.fromRGBO(1, 57, 104, 1),
                                    fontSize: 22),
                                dayPlan.date),
                            Text(
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(1, 57, 104, 1),
                                    fontSize: 18),
                                (dayPlan.label == '')
                                    ? 'День отдыха'
                                    : dayPlan.label),
                          ],
                        ),
                      ],
                    ),
                    Visibility(
                      visible: (dayPlan.label == '') ? false : true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text('описание:'),
                          RichText(
                            text: TextSpan(
                              children: UrlUtils.buildTextWithClickableLinks(dayPlan.description),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  (dayPlan.label == '' && DatePasing().isAfterDay(dayPlan.date))
                      ? null
                      : {context.read<HomeScreenCubit>().openDay(index)};
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
          IconButton(
            icon: const Icon(
                color: Color.fromRGBO(255, 132, 26, 1), Icons.exit_to_app),
            onPressed: () => context.go('/authorization'),
          ),
        ],
        centerTitle: true,
        title: Text(
            style: const TextStyle(fontSize: 30, color: Colors.white),
            context.read<HomeScreenCubit>().planType),
        backgroundColor: const Color.fromRGBO(1, 57, 104, 1));
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      //height: 68,
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
                  style: const TextStyle(color: Colors.white), 'Шаблоны'),
            ],
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(
                    size: 30,
                    color: Color.fromRGBO(255, 132, 26, 1),
                    Icons.group),
                onPressed: () => _showGroupsListModal(context),
              ),
              const Text(style: const TextStyle(color: Colors.white), 'Группы'),
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
                  style: const TextStyle(color: Colors.white), 'Ученики'),
            ],
          ),
        ],
      ),
    );
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        icon: const Icon(
                            color: Color.fromRGBO(255, 132, 26, 1),
                            Icons.person_add),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          context.push('/adduserscreen');
                        }),
                  ],
                ),
                const Text(
                    'Выберете ученика для составления индивидуального плана'),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: Management.userList.length,
                    separatorBuilder: (dialogContext, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (dialogContext, index) {
                      return Row(
                        children: [
                          TextButton(
                            child: Text(
                              Management.userList[index],
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              context
                                  .read<HomeScreenCubit>()
                                  .choosingPlanType(Management.userList[index]);
                            },
                          ),
                          IconButton(
                              icon: const Icon(
                                  color: Color.fromRGBO(255, 132, 26, 1),
                                  Icons.info_outline),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                _showProfileSelectUserModal(
                                    context, Management.userList[index]);
                              }),
                        ],
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 50),
                        backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(
                          color: Color.fromRGBO(255, 132, 26, 1),
                          Icons.group_add),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.push('/addgroupscreen');
                      },
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
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          Management.groupsList[index],
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          context
                              .read<HomeScreenCubit>()
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
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
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

  void _showProfileSelectUserModal(BuildContext context, String loginSelectUser) async {
    User selectUser = await Users().getUserData(loginSelectUser);
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
                Text(
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                  (selectUser.role == 'student')
                      ? 'Профиль ученика'
                      : 'Это тренер',
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Text(
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        'Логин: ${selectUser.login}'),
                    const SizedBox(height: 8),
                    Text(
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        'Имя: ${selectUser.name}'),
                  ],
                ),
                const SizedBox(height: 8),
                if (selectUser.role == 'student')
                  Row(
                    children: [
                      const Text(
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          'Группы ученика'),
                      IconButton(
                          icon: const Icon(
                              color: Color.fromRGBO(255, 132, 26, 1),
                              Icons.group_add),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            _showGroupsSelectUserModal(context, selectUser);
                          }),
                    ],
                  ),
                const SizedBox(height: 16),
                if (selectUser.role == 'student')
                  Expanded(
                    child: ListView.separated(
                      itemCount: selectUser.groups.length,
                      separatorBuilder: (dialogContext, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (dialogContext, index) {
                        return Text(
                          style: const TextStyle(
                              fontSize: 24,
                              color: Color.fromRGBO(1, 57, 104, 1),
                              fontWeight: FontWeight.bold),
                          selectUser.groups[index],
                        );
                      },
                    ),
                  ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 50),
                        backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
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

  void _showGroupsSelectUserModal(BuildContext context, User selectUser) {
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
                Text('В какую группу добавить ученика ${selectUser.login}'),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: Management.groupsList.length,
                    separatorBuilder: (dialogContext, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (dialogContext, index) {
                      return TextButton(
                        child: Text(
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          Management.groupsList[index],
                        ),
                        onPressed: () {
                          if (!selectUser.groups
                              .contains(Management.groupsList[index])) {
                            selectUser.groups.add(Management.groupsList[index]);
                            Users().changePersonalDataUser(
                                selectUser.login,
                                selectUser.name,
                                selectUser.pin,
                                selectUser.role,
                                selectUser.groups);
                          }
                          Navigator.of(dialogContext).pop();
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 50),
                        backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
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
