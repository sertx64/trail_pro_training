import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/url_utils.dart';
import 'package:trailpro_planning/presentation/reports/reports_widget.dart';

class DayPlan extends StatelessWidget {
  const DayPlan({super.key});

  @override
  Widget build(BuildContext context) {
    final DayPlanModel dayPlanGroup = context.read<HomeScreenCubit>().selectDayGroup;
    final DayPlanModel dayPlanPersonal = context.read<HomeScreenCubit>().selectDayPersonal;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(1, 57, 104, 1),
        title: Text(
            style: const TextStyle(color: Colors.white, fontSize: 27),
            dayPlanGroup.date),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: (dayPlanGroup.label == '') ? false : true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Групповая тренировка'),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(255, 132, 26, 1),
                              fontSize: 19),
                          dayPlanGroup.label),
                      RichText(
                        text: TextSpan(
                          children: UrlUtils.buildTextWithClickableLinks(dayPlanGroup.description),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: (dayPlanPersonal.label == '') ? false : true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('персональная'),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(255, 132, 26, 1),
                              fontSize: 19),
                          dayPlanPersonal.label),
                      RichText(
                        text: TextSpan(
                          children: UrlUtils.buildTextWithClickableLinks(dayPlanPersonal.description),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
                Visibility(
                  visible: (DatePasing().isAfterDay(dayPlanGroup.date) &&
                          dayPlanGroup.label != '')
                      ? true
                      : false,
                  child: ReportsWidget(context.read<HomeScreenCubit>().planType, dayPlanGroup.date),
                ),
              ],
            ),
          )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40.0),
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(200, 1, 57, 104),
          onPressed: context.read<HomeScreenCubit>().backToWeek,
          child: const Icon(color: Colors.white, Icons.arrow_back_sharp),
        ),
      ),
    );
  }
}
