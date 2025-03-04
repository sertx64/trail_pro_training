import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';

class StudentScreenCubit extends Cubit<StudentDataModel> {
  StudentScreenCubit() : super(StudentDataModel([],[], false));

  int yearWeekIndex = int.parse(DatePasing().yearWeekNow());
  Map<String, String> dayPlanStudentGroup = {};
  Map<String, String> dayPlanStudentPersonal = {};
  int currentDayWeekIndex = 0;

  void loadWeekPlan(int yWid) async {
    emit(StudentDataModel([], [], false));
    List<Map<String, String>> currentWeekPlanGroup =
    await weekPlanStudent('tp_week_plan', yWid);
    emit(StudentDataModel(currentWeekPlanGroup, [
      {'label_training': ''},
      {'label_training': ''},
      {'label_training': ''},
      {'label_training': ''},
      {'label_training': ''},
      {'label_training': ''},
      {'label_training': ''},
    ], true));
    //костыль помогающий грузить в 2 раза быстрее групповой план тренировок
    List<Map<String, String>> currentWeekPlanPersonal =
    await weekPlanStudent(Management.userLogin, yWid);
    emit(StudentDataModel(currentWeekPlanGroup, currentWeekPlanPersonal, true));
  }

  void nextWeek() {
    ++yearWeekIndex;
    if (yearWeekIndex == 202453) yearWeekIndex = 202501;
    if (yearWeekIndex == 202553) yearWeekIndex = 202601;
    if (yearWeekIndex == 202653) yearWeekIndex = 202701;
    loadWeekPlan(yearWeekIndex);
  }

  void previousWeek() {
    --yearWeekIndex;
    if (yearWeekIndex == 202444) yearWeekIndex = 202445;
    if (yearWeekIndex == 202500) yearWeekIndex = 202452;
    if (yearWeekIndex == 202600) yearWeekIndex = 202552;
    if (yearWeekIndex == 202700) yearWeekIndex = 202652;
    loadWeekPlan(yearWeekIndex);
  }



  Future<List<Map<String, String>>> weekPlanStudent(String plan, int yearweek) async {
    List<String>? weekPlanList = await ApiGSheet().getWeekPlanList(plan, '$yearweek');

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

  void newScreenDayPlan(int dayIndex) {
    Management.dayPlanStudentGroup1 = state.weekPlanGroup[dayIndex];
    Management.dayPlanStudentPersonal1 = state.weekPlanPersonal[dayIndex];
    Management.yearWeekIndex1 = yearWeekIndex;
    currentDayWeekIndex = dayIndex;
    Management.currentDayWeekIndex1 = currentDayWeekIndex;
  }

}


class StudentDataModel {
  bool isLoading;
  List<Map<String, String>> weekPlanGroup;
  List<Map<String, String>> weekPlanPersonal;
  StudentDataModel(this.weekPlanGroup, this.weekPlanPersonal, this.isLoading);
}