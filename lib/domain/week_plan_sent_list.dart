import 'package:trailpro_planning/data/gsheets_api.dart';

class WeekPlanSentList {
  final String day;
  final String label;
  final String description;
  final int yearWeek;
  String planIdInTab;

  WeekPlanSentList(
      this.planIdInTab, this.yearWeek, this.day, this.label, this.description);

  void sentPlan() async {
    int indexDay = (day == 'ПН')
        ? 0
        : (day == 'ВТ')
            ? 1
            : (day =='СР')
                ? 2
                : (day == 'ЧТ')
                    ? 3
                    : (day == 'ПТ')
                        ? 4
                        : (day == 'СБ')
                            ? 5
                            : (day == 'ВС')
                                ? 6
                                : 7;
    int indexLabel = (indexDay*3)+1;
    int indexDescription = (indexDay*3)+2;
    List<String>? planList =
        await ApiGSheet().getWeekPlanList(planIdInTab, '$yearWeek');
    planList?[indexLabel] = label;
    planList?[indexDescription] = description;
    ApiGSheet().sendWeekPlanList(planIdInTab, '$yearWeek', planList!);
  }
}
