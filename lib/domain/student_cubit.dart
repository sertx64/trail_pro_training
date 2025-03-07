import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/presentation/models/models.dart';

class StudentScreenCubit extends Cubit<StudentDataModel> {
  StudentScreenCubit() : super(StudentDataModel([],[], false));

  int yearWeekIndex = int.parse(DatePasing().yearWeekNow());


  void loadWeekPlan(int yWid) async {
    emit(StudentDataModel([], [], false));
    List<DayPlanModel> currentWeekPlanGroup =
    await weekPlanStudent('tp_week_plan', yWid);
    emit(StudentDataModel(currentWeekPlanGroup, [
      DayPlanModel('','','',''),
      DayPlanModel('','','',''),
      DayPlanModel('','','',''),
      DayPlanModel('','','',''),
      DayPlanModel('','','',''),
      DayPlanModel('','','',''),
      DayPlanModel('','','',''),
    ], true));
    //костыль помогающий грузить в 2 раза быстрее групповой план тренировок
    if (Management.userLogin != '')  {
      List<DayPlanModel> currentWeekPlanPersonal =
          await weekPlanStudent(Management.userLogin, yWid);
      emit(StudentDataModel(
          currentWeekPlanGroup, currentWeekPlanPersonal, true));
    }
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



  Future<List<DayPlanModel>> weekPlanStudent(String plan, int yearweek) async {
    List<String>? weekPlanList = await ApiGSheet().getWeekPlanList(plan, '$yearweek');

    final List<DayPlanModel> weekPlan = [
      DayPlanModel('ПН', weekPlanList![0],weekPlanList[1],weekPlanList[2]),
      DayPlanModel('ВТ', weekPlanList[3],weekPlanList[4],weekPlanList[5]),
      DayPlanModel('СР', weekPlanList[6],weekPlanList[7],weekPlanList[8]),
      DayPlanModel('ЧТ', weekPlanList[9],weekPlanList[10],weekPlanList[11]),
      DayPlanModel('ПТ', weekPlanList[12],weekPlanList[13],weekPlanList[14]),
      DayPlanModel('СБ', weekPlanList[15],weekPlanList[16],weekPlanList[17]),
      DayPlanModel('ВС', weekPlanList[18],weekPlanList[19],weekPlanList[20]),
    ];
    return weekPlan;
  }


}



