import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';

class HomeScreenCubit extends Cubit<PlanDataModel> {
  HomeScreenCubit() : super(PlanDataModel(false, false, [], [], 'TrailPro', isViewMode: false));

  int yearWeekIndex = int.parse(DatePasing().yearWeekNow());
  int indexDay = 0;
  DayPlanModel selectDayGroup = DayPlanModel('', '', '', '', time: '', location: '');
  DayPlanModel selectDayPersonal = DayPlanModel('', '', '', '', time: '', location: '');
  List<String> weekPlanList = [];
  String planType = 'TrailPro';

  void choosingPlanType(String pType){
    planType = pType;
    PlanDataModel currentPlanData = state;
    currentPlanData.planType = planType;
    if (!isClosed) {
      emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal, currentPlanData.planType, isViewMode: currentPlanData.isViewMode));
    }
    loadWeekPlan();
  }

  void loadWeekPlan() async {
    PlanDataModel currentPlanData = state;
    currentPlanData.planLoaded = false;
    if (!isClosed) {
      emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal, currentPlanData.planType, isViewMode: currentPlanData.isViewMode));
    }
    List<DayPlanModel> currentWeekPlanGroup =
        await weekPlanStudent(planType, yearWeekIndex);
    currentPlanData.planLoaded = true;
    currentPlanData.weekPlanGroup = currentWeekPlanGroup;
    currentPlanData.weekPlanPersonal = List.generate(
      7,
      (index) => DayPlanModel('', '', '', '', time: '', location: ''),
    );
    if (!isClosed) {
      emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal, currentPlanData.planType, isViewMode: currentPlanData.isViewMode));
    }
    if (Management.user.role == 'student') {
      List<DayPlanModel> currentWeekPlanPersonal =
          await weekPlanStudent(Management.user.login, yearWeekIndex);
      currentPlanData.weekPlanPersonal = currentWeekPlanPersonal;
      if (!isClosed) {
        emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal, currentPlanData.planType, isViewMode: currentPlanData.isViewMode));
      }
    }
  }

  void openDay(int index) {
    openDayForEdit(index);
  }

  void openDayForEdit(int index) {
    indexDay = index;
    PlanDataModel currentPlanData = state;
    selectDayGroup = currentPlanData.weekPlanGroup[index];
    selectDayPersonal = currentPlanData.weekPlanPersonal[index];
    currentPlanData.isDay = true;
    currentPlanData.isViewMode = false;
    if (!isClosed) {
      emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal, currentPlanData.planType, isViewMode: currentPlanData.isViewMode));
    }
  }

  void openDayForView(int index) {
    indexDay = index;
    PlanDataModel currentPlanData = state;
    selectDayGroup = currentPlanData.weekPlanGroup[index];
    selectDayPersonal = currentPlanData.weekPlanPersonal[index];
    currentPlanData.isDay = true;
    currentPlanData.isViewMode = true;
    if (!isClosed) {
      emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal, currentPlanData.planType, isViewMode: currentPlanData.isViewMode));
    }
  }

  void backToWeek(){
    PlanDataModel currentPlanData = state;
    currentPlanData.isDay = false;
    if (!isClosed) {
      emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal, currentPlanData.planType, isViewMode: currentPlanData.isViewMode));
    }
  }

  void applyAndBackToWeek(String label, String description, {String time = '', String location = ''}) {
    PlanDataModel currentPlanData = state;
    
    // Формируем полную строку label с временем и местом
    String fullLabel = '';
    if (time.isNotEmpty) {
      fullLabel += 'time: $time\n';
    }
    if (location.isNotEmpty) {
      fullLabel += 'location: $location\n';
    }
    fullLabel += label;
    
    currentPlanData.weekPlanGroup[indexDay].label = label;
    currentPlanData.weekPlanGroup[indexDay].description = description;
    currentPlanData.weekPlanGroup[indexDay].time = time;
    currentPlanData.weekPlanGroup[indexDay].location = location;
    
    currentPlanData.isDay = false;
    if (!isClosed) {
      emit(PlanDataModel(currentPlanData.isDay, currentPlanData.planLoaded, currentPlanData.weekPlanGroup, currentPlanData.weekPlanPersonal, currentPlanData.planType, isViewMode: currentPlanData.isViewMode));
    }
    sentPlan(planType, fullLabel, description);
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
      DayPlanModel.parseFromLabel('ПН', dateOnWeekPlan(weekPlanList[0]), weekPlanList[1], weekPlanList[2]),
      DayPlanModel.parseFromLabel('ВТ', dateOnWeekPlan(weekPlanList[3]), weekPlanList[4], weekPlanList[5]),
      DayPlanModel.parseFromLabel('СР', dateOnWeekPlan(weekPlanList[6]), weekPlanList[7], weekPlanList[8]),
      DayPlanModel.parseFromLabel('ЧТ', dateOnWeekPlan(weekPlanList[9]), weekPlanList[10], weekPlanList[11]),
      DayPlanModel.parseFromLabel('ПТ', dateOnWeekPlan(weekPlanList[12]), weekPlanList[13], weekPlanList[14]),
      DayPlanModel.parseFromLabel('СБ', dateOnWeekPlan(weekPlanList[15]), weekPlanList[16], weekPlanList[17]),
      DayPlanModel.parseFromLabel('ВС', dateOnWeekPlan(weekPlanList[18]), weekPlanList[19], weekPlanList[20]),
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
