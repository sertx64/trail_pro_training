import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/week_plan_sent_list.dart';

class PersonalDayPlanTrainer extends StatefulWidget {
  const PersonalDayPlanTrainer({super.key});

  @override
  State<PersonalDayPlanTrainer> createState() => _PersonalDayPlanTrainerState();
}

class _PersonalDayPlanTrainerState extends State<PersonalDayPlanTrainer> {
  final Management management = GetIt.instance<Management>();

  void savePlanDay() {
    // management.currentWeekPlanPersonal[management.currentDayWeekIndex]
    //     ['label_training'] = _controllerLabelTraining.text;
    // management.currentWeekPlanPersonal[management.currentDayWeekIndex]
    //     ['description_training'] = _controllerDescriptionTraining.text;
    //
    // management.updateWeekPlanTrainerPersonal();
    //
    // WeekPlanSentList(management.selectedUser, management.yearWeekIndex,
    //         management.currentWeekPlanPersonal)
    //     .sentPlan();
    context.pop();
  }

  final TextEditingController _controllerLabelTraining =
      TextEditingController();
  final TextEditingController _controllerDescriptionTraining =
      TextEditingController();

  @override
  void initState() {
    _controllerLabelTraining.text =
        management.dayPlanStudentPersonal['label_training']!;
    _controllerDescriptionTraining.text =
        management.dayPlanStudentPersonal['description_training']!;
    super.initState();
  }

  @override
  void dispose() {
    _controllerLabelTraining.dispose();
    _controllerDescriptionTraining.dispose();
    print('DISPOSE PERS DAY!!!!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(1, 57, 104, 1),
          title: Text(
              style: const TextStyle(fontSize: 30, color: Colors.white),
              'День ${management.dayPlanStudentPersonal['day']} ${management.dayPlanStudentPersonal['date']}'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: (management.yearWeekIndex * 10 +
                        management.currentDayWeekIndex <
                    int.parse(DatePasing().yearWeekNow()) * 10 + DatePasing().dayWeekNow())
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          management.dayPlanStudentPersonal['label_training']!),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          management
                              .dayPlanStudentPersonal['description_training']!),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const Text('Название'),
                        TextField(
                          maxLength: 27,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 6),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                          ),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(1, 57, 104, 1),
                              fontSize: 16),
                          controller: _controllerDescriptionTraining,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                //fixedSize: const Size(200, 50),
                                backgroundColor:
                                    const Color.fromRGBO(1, 57, 104, 1)),
                            onPressed: savePlanDay,
                            child: const Text(
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                                'Сохранить')),
                      ]),
          ),
        ));
  }
}
