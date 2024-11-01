import 'package:trailpro_planning/data/gsheets_api.dart';

class WeekPlanMap {
  Future<List<Map<String, String>>> weekPlan() async {
    List<String>? weekPlanList = await ApiGSheet().getWeekPlanList('w1');

    final List<Map<String, String>> weekPlan = [
      {
        'date': weekPlanList![0],
        'label_training': weekPlanList[1],
        'description_training': weekPlanList[2],
      },
      {
        'date': weekPlanList[3],
        'label_training': weekPlanList[4],
        'description_training': weekPlanList[5],
      },
      {
        'date': weekPlanList[6],
        'label_training': weekPlanList[7],
        'description_training': weekPlanList[8],
      },
      {
        'date': weekPlanList[9],
        'label_training': weekPlanList[10],
        'description_training': weekPlanList[11],
      },
      {
        'date': weekPlanList[12],
        'label_training': weekPlanList[13],
        'description_training': weekPlanList[14],
      },
      {
        'date': weekPlanList[15],
        'label_training': weekPlanList[16],
        'description_training': weekPlanList[17],
      },
      {
        'date': weekPlanList[18],
        'label_training': weekPlanList[19],
        'description_training': weekPlanList[20],
      }
    ];

    return weekPlan;
  }
}
