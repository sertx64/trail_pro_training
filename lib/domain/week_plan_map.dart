import 'package:trailpro_planning/data/gsheets_api.dart';

class WeekPlanMap {
  WeekPlanMap(this.yearweek);
  String yearweek;
  Future<List<Map<String, String>>> weekPlanStudent() async {
    List<String>? weekPlanList = await ApiGSheet().getWeekPlanList(yearweek);

    final List<Map<String, String>> weekPlan = [
      {
        'day': 'ПН',
        'date': weekPlanList![0],
        'label_training': weekPlanList[1],
        'description_training': weekPlanList[2],
      },
      {
        'day': 'ВТ',
        'date': weekPlanList[3],
        'label_training': weekPlanList[4],
        'description_training': weekPlanList[5],
      },
      {
        'day': 'СР',
        'date': weekPlanList[6],
        'label_training': weekPlanList[7],
        'description_training': weekPlanList[8],
      },
      {
        'day': 'ЧТ',
        'date': weekPlanList[9],
        'label_training': weekPlanList[10],
        'description_training': weekPlanList[11],
      },
      {
        'day': 'ПТ',
        'date': weekPlanList[12],
        'label_training': weekPlanList[13],
        'description_training': weekPlanList[14],
      },
      {
        'day': 'СБ',
        'date': weekPlanList[15],
        'label_training': weekPlanList[16],
        'description_training': weekPlanList[17],
      },
      {
        'day': 'ВС',
        'date': weekPlanList[18],
        'label_training': weekPlanList[19],
        'description_training': weekPlanList[20],
      }
    ];

    return weekPlan;
  }


}
