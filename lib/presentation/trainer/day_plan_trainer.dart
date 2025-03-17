import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/student_cubit.dart';
import 'package:trailpro_planning/presentation/reports/reports_widget.dart';

class DayPlanTrainer extends StatelessWidget {
  DayPlanTrainer({super.key});

  final TextEditingController _controllerLabelTraining =
      TextEditingController();
  final TextEditingController _controllerDescriptionTraining =
      TextEditingController();

  final List samples = Management.samplesSlitList;

  @override
  Widget build(BuildContext context) {
    DayPlanModel dayPlan = context.read<StudentScreenCubit>().selectDay;
    _controllerLabelTraining.text = dayPlan.label;
    _controllerDescriptionTraining.text = dayPlan.description;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => context.read<StudentScreenCubit>().backToWeek(),
            child: const Text(
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(255, 132, 26, 1)),
                'Назад'),
          ),
        ],
        backgroundColor: const Color.fromRGBO(1, 57, 104, 1),
        title: Text(
            style: const TextStyle(fontSize: 20, color: Colors.white),
            'День ${dayPlan.day} ${dayPlan.date}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: (DatePasing().isAfterDay(dayPlan.date))
              ? Column(
                children: [
                  Container(
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                style:
                                    const TextStyle(color: Colors.black, fontSize: 20),
                                dayPlan.label),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                style:
                                    const TextStyle(color: Colors.black, fontSize: 16),
                                dayPlan.description),
                            const SizedBox(
                              height: 10,
                            ),

                          ],
                        ),
                    ),
                  ),
                  ReportsWidget(context.read<StudentScreenCubit>().planType, dayPlan.date),
                ],
              )
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      const Text(
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          'Название'),
                      TextButton(
                          onPressed: () {
                            _controllerLabelTraining.text = '';
                          },
                          child: const Text(
                              style: TextStyle(color: Colors.black, fontSize: 14),
                              '(очистить)'))
                    ],
                  ),
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
                  Row(
                    children: [
                      const Text(
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          'Описание'),
                      TextButton(
                          onPressed: () {
                            _controllerDescriptionTraining.text = '';
                          },
                          child: const Text(
                              style:
                              TextStyle(color: Colors.black, fontSize: 14),
                              '(очистить)'))
                    ],
                  ),
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
                            context
                                .read<StudentScreenCubit>()
                                .applyAndBackToWeek(
                                    _controllerLabelTraining.text,
                                    _controllerDescriptionTraining.text);
                          },
                          child: const Text(
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                              'Сохранить')),
                      Builder(builder: (context) {
                        return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: const Text(
                                style: TextStyle(
                                    fontSize: 24, color: Colors.black),
                                'Шаблоны'));
                      }),
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
                  style: TextStyle(fontSize: 24, color: Colors.black),
                  'Шаблоны тренировок'),
            ),
            SizedBox(
              height: 400,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(samples[index][0]),
                    onTap: () {
                      _controllerLabelTraining.text = samples[index][0];
                      _controllerDescriptionTraining.text = samples[index][1];
                      Navigator.pop(context);
                    },
                  );
                },
                itemCount: samples.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
