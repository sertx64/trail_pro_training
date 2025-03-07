import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/presentation/models/models.dart';
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
    DayPlanModel dayPlan = GoRouterState.of(context).extra as DayPlanModel;
    _controllerLabelTraining.text = dayPlan.label;
    _controllerDescriptionTraining.text = dayPlan.description;
    return Scaffold(
      appBar: AppBar(
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
                    ReportsWidget(dayPlan.date),
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
                            // management.currentWeekPlanGroup[management
                            //         .currentDayWeekIndex]['label_training'] =
                            //     _controllerLabelTraining.text;
                            // management.currentWeekPlanGroup[
                            //             management.currentDayWeekIndex]
                            //         ['description_training'] =
                            //     _controllerDescriptionTraining.text;
                            //
                            // management.updateWeekPlanTrainerGroup();
                            //
                            // WeekPlanSentList(
                            //         'tp_week_plan',
                            //         management.yearWeekIndex,
                            //         management.currentWeekPlanGroup)
                            //     .sentPlan();
                            context.go('/trainerscreen');
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
