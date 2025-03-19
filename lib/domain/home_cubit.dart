import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';

class HomeScreenCubit extends Cubit<PlanDataModel> {
  HomeScreenCubit() : super(PlanDataModel(false, false, [], []));

  int yearWeekIndex = int.parse(DatePasing().yearWeekNow());
  int indexDay = 0;
  DayPlanModel selectDayGroup = DayPlanModel('', '', '', '');
  DayPlanModel selectDayPersonal = DayPlanModel('', '', '', '');
  List<String> weekPlanList = [];
  String planType = 'tp_week_plan';

  void choosingPlanType(String pType){
    planType =  pType;
    loadWeekPlan();
  }

  void loadWeekPlan() async {
    PlanDataModel currentPlanData = state;
    currentPlanData.planLoaded = false;
    emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal));
    List<DayPlanModel> currentWeekPlanGroup =
        await weekPlanStudent(planType, yearWeekIndex);
    currentPlanData.planLoaded = true;
    currentPlanData.weekPlanGroup = currentWeekPlanGroup;
    currentPlanData.weekPlanPersonal = List.generate(
      7,
      (index) => DayPlanModel('', '', '', ''),
    );
    emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal));
    if (Management.user.role == 'student') {
      List<DayPlanModel> currentWeekPlanPersonal =
          await weekPlanStudent(Management.user.login, yearWeekIndex);
      currentPlanData.weekPlanPersonal = currentWeekPlanPersonal;
      emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal));
    }
  }

  void openDay(int index) {
    indexDay = index;
    PlanDataModel currentPlanData = state;
    selectDayGroup = currentPlanData.weekPlanGroup[index];
    selectDayPersonal = currentPlanData.weekPlanPersonal[index];
    currentPlanData.isDay = true;
    emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal));
  }

  void backToWeek(){
    PlanDataModel currentPlanData = state;
    currentPlanData.isDay = false;
    emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal));
  }

  void applyAndBackToWeek(String label, String description) {
    PlanDataModel currentPlanData = state;
    currentPlanData.weekPlanGroup[indexDay].label = label;
    currentPlanData.weekPlanGroup[indexDay].description = description;
    currentPlanData.isDay = false;
    emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal));
    sentPlan(planType, label, description);
  }

  void sentPlan(String plan, String label, String description) async {
    int indexLabel = (indexDay*3)+1;
    int indexDescription = (indexDay*3)+2;
    weekPlanList[indexLabel] = label;
    weekPlanList[indexDescription] = description;
    ApiGSheet().sendWeekPlanList(plan, '$yearWeekIndex', weekPlanList);
  }


  void nextWeek() {
    ++yearWeekIndex;
    if (yearWeekIndex == 202453) yearWeekIndex = 202501;
    if (yearWeekIndex == 202553) yearWeekIndex = 202601;
    if (yearWeekIndex == 202653) yearWeekIndex = 202701;
    loadWeekPlan();
  }

  void previousWeek() {
    --yearWeekIndex;
    if (yearWeekIndex == 202444) yearWeekIndex = 202445;
    if (yearWeekIndex == 202500) yearWeekIndex = 202452;
    if (yearWeekIndex == 202600) yearWeekIndex = 202552;
    if (yearWeekIndex == 202700) yearWeekIndex = 202652;
    loadWeekPlan();
  }

  Future<List<DayPlanModel>> weekPlanStudent(String plan, int yearweek) async {
    weekPlanList =
        (await ApiGSheet().getWeekPlanList(plan, '$yearweek'))!;

    final List<DayPlanModel> weekPlan = [
      DayPlanModel('ПН', dateOnWeekPlan(weekPlanList[0]), weekPlanList[1], weekPlanList[2]),
      DayPlanModel('ВТ', dateOnWeekPlan(weekPlanList[3]), weekPlanList[4], weekPlanList[5]),
      DayPlanModel('СР', dateOnWeekPlan(weekPlanList[6]), weekPlanList[7], weekPlanList[8]),
      DayPlanModel('ЧТ', dateOnWeekPlan(weekPlanList[9]), weekPlanList[10], weekPlanList[11]),
      DayPlanModel('ПТ', dateOnWeekPlan(weekPlanList[12]), weekPlanList[13], weekPlanList[14]),
      DayPlanModel('СБ', dateOnWeekPlan(weekPlanList[15]), weekPlanList[16], weekPlanList[17]),
      DayPlanModel('ВС', dateOnWeekPlan(weekPlanList[18]), weekPlanList[19], weekPlanList[20]),
    ];
    return weekPlan;
  }

  String dateOnWeekPlan(String dateFromTab) {
    if (dateFromTab.startsWith('4')) {
      DateTime startDate = DateTime(1899, 12, 30);

      // Количество дней
      int days = int.parse(dateFromTab);

      // Добавляем дни к начальной дате
      DateTime resultDate = startDate.add(Duration(days: days));

      // Форматируем вывод
      String formattedDate = "${resultDate.day.toString().padLeft(2, '0')}.${resultDate.month.toString().padLeft(2, '0')}.${resultDate.year}";
      return formattedDate; // Вывод: 17.03.2025
    } else {return dateFromTab;}
  }


}
