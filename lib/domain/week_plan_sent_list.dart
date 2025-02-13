import 'package:trailpro_planning/data/gsheets_api.dart';

class WeekPlanSentList {
  final List<Map<String, String>> weekPlanSent;
  final int yearWeek;
  String planIdInTab;

  WeekPlanSentList(this.planIdInTab, this.yearWeek, this.weekPlanSent);

  void sentPlan() {
    List<String> planList = [];
    planList.add(weekPlanSent[0]['date']!);
    planList.add(weekPlanSent[0]['label_training']!);
    planList.add(weekPlanSent[0]['description_training']!);
    planList.add(weekPlanSent[1]['date']!);
    planList.add(weekPlanSent[1]['label_training']!);
    planList.add(weekPlanSent[1]['description_training']!);
    planList.add(weekPlanSent[2]['date']!);
    planList.add(weekPlanSent[2]['label_training']!);
    planList.add(weekPlanSent[2]['description_training']!);
    planList.add(weekPlanSent[3]['date']!);
    planList.add(weekPlanSent[3]['label_training']!);
    planList.add(weekPlanSent[3]['description_training']!);
    planList.add(weekPlanSent[4]['date']!);
    planList.add(weekPlanSent[4]['label_training']!);
    planList.add(weekPlanSent[4]['description_training']!);
    planList.add(weekPlanSent[5]['date']!);
    planList.add(weekPlanSent[5]['label_training']!);
    planList.add(weekPlanSent[5]['description_training']!);
    planList.add(weekPlanSent[6]['date']!);
    planList.add(weekPlanSent[6]['label_training']!);
    planList.add(weekPlanSent[6]['description_training']!);

    ApiGSheet().sendWeekPlanList(planIdInTab, '$yearWeek', planList);
  }
}