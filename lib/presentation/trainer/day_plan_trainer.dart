import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/week_plan_sent_list.dart';
import 'package:trailpro_planning/presentation/reports/reports_widget.dart';


class DayPlanTrainer extends StatefulWidget {
  const DayPlanTrainer({super.key});

  @override
  State<DayPlanTrainer> createState() => _DayPlanTrainerState();
}

class _DayPlanTrainerState extends State<DayPlanTrainer> {
  final Management management = GetIt.instance<Management>();

  final TextEditingController _controllerLabelTraining =
      TextEditingController();
  final TextEditingController _controllerDescriptionTraining =
      TextEditingController();

  @override
  void initState() {
    _controllerLabelTraining.text =
        management.dayPlanStudentGroup['label_training']!;
    _controllerDescriptionTraining.text =
        management.dayPlanStudentGroup['description_training']!;
    super.initState();
  }

  @override
  void dispose() {
    _controllerLabelTraining.dispose();
    _controllerDescriptionTraining.dispose();
    print('DISPOSE TR DAY!!!!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 57, 104, 1),
        title: Text(
            style: const TextStyle(fontSize: 20, color: Colors.white),
            'День ${management.dayPlanStudentGroup['day']} ${management.dayPlanStudentGroup['date']}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: (management.yearWeekIndex * 10 +
                      management.currentDayWeekIndex <
                  int.parse(DatePasing().yearWeekNow()) * 10 +
                      DatePasing().dayWeekNow())
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        management.dayPlanStudentGroup['label_training']!),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                        management
                            .dayPlanStudentGroup['description_training']!),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Обратная связь:'),
                    ReportsWidget(management.dayPlanStudentGroup['date']!),
                  ],
                )
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Название'),
                  TextField(
                    maxLength: 27,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(1, 57, 104, 1),
                        fontSize: 16),
                    controller: _controllerLabelTraining,
                  ),
                  const SizedBox(height: 8),
                  const Text('Описание'),
                  TextField(
                    maxLines: null,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(1, 57, 104, 1),
                        fontSize: 16),
                    controller: _controllerDescriptionTraining,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(1, 57, 104, 1)),
                          onPressed: () async {
                            management.currentWeekPlanGroup[management
                                    .currentDayWeekIndex]['label_training'] =
                                _controllerLabelTraining.text;
                            management.currentWeekPlanGroup[
                                        management.currentDayWeekIndex]
                                    ['description_training'] =
                                _controllerDescriptionTraining.text;

                            management.updateWeekPlanTrainerGroup();

                            WeekPlanSentList(
                                    'tp_week_plan',
                                    management.yearWeekIndex,
                                    management.currentWeekPlanGroup)
                                .sentPlan();
                            context.go('/trainerscreen');
                          },
                          child: const Text(
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                              'Сохранить')),
                      Builder(
                        builder: (context) {
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                              child: const Text(
                                  style:
                                      TextStyle(fontSize: 24, color: Colors.black),
                                  'Шаблоны'));
                        }
                      ),
                    ],
                  ),
                ]),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                  style:
                  TextStyle(fontSize: 24, color: Colors.black),
                  'Шаблоны тренировок'),
            ),
            ListTile(
              title: const Text('Интервальная'),
              onTap: () {
                _controllerLabelTraining.text = 'Интервальная';
                _controllerDescriptionTraining.text = 'Время и место: \nРазминка: 10-15 минут в лёгком темпе.\nИнтервалы: \nКоличество: \nРабота:     ';
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Длительная'),
              onTap: () {
                _controllerLabelTraining.text = 'Длительная';
                _controllerDescriptionTraining.text = 'Время и место: \nРазминка: 10-15 минут в лёгком темпе.\nВремя работы: \nЗаминка: 10-15 минут в лёгком темпе.';
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Тренировка с упражнениями'),
              onTap: () {
                _controllerLabelTraining.text = 'Тренировка с упражнениями';
                _controllerDescriptionTraining.text = 'Время и место: \nРазминка: 10-15 минут в лёгком темпе.\nУпражнения: \nЗаминка: 10-15 минут в лёгком темпе.';
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
