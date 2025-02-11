import 'package:flutter/material.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/week_plan_map.dart';

class WeekPlansModel {
  List<Map<String, String>> weekPlanGroup;
  List<Map<String, String>> weekPlanPersonal;
  WeekPlansModel(this.weekPlanGroup, this.weekPlanPersonal);
}

class Management {
  ValueNotifier<WeekPlansModel> weekPlans =
      ValueNotifier<WeekPlansModel>(WeekPlansModel([], []));

  int yWeek = int.parse(yearWeekNow());

  bool isLoadingPlans = false;

  List<Map<String, String>> _weekPlanGroup = [];
  List<Map<String, String>> _weekPlanPersonal = [];

  void loadWeekPlan(yWid) async {
    isLoadingPlans = false;
    weekPlans.value = WeekPlansModel([], []);
    _weekPlanGroup =
        await WeekPlanMap('tp_week_plan', yWid).weekPlanStudent();
    _weekPlanPersonal =
        await WeekPlanMap(userLogin, yWid).weekPlanStudent();
    weekPlans.value = WeekPlansModel(_weekPlanGroup, _weekPlanPersonal);
    isLoadingPlans = true;
  }

  void nextWeek() {
    ++yWeek;
    if (yWeek == 202453) yWeek = 202501;
    if (yWeek == 202553) yWeek = 202601;
    if (yWeek == 202653) yWeek = 202701;
    loadWeekPlan(yWeek);
}

  void previousWeek() {
    --yWeek;
    if (yWeek == 202444) yWeek = 202445;
    if (yWeek == 202500) yWeek = 202452;
    if (yWeek == 202600) yWeek = 202552;
    if (yWeek == 202700) yWeek = 202652;
    loadWeekPlan(yWeek);
  }
  int currentDayWeek888 = 0;
  late Map<String, String> dayPlanStudentGroup = _weekPlanGroup[currentDayWeek888];
  late Map<String, String> dayPlanStudentPersonal = _weekPlanPersonal[currentDayWeek888];

  //static Map<String, String> dayPlanStudentGroup = {};
  //static Map<String, String> dayPlanStudentPersonal = {};

  static List<String> authUserList = [];
  static List<String> userList = [];
  static Map<String, String> authUserMap = {};

  static String userLogin = '';

  static int currentWeek = 0;

  static List<Map<String, String>> currentWeekPlan = [];

  static int currentDayWeek = 0;

  static String selectedUser = '';
}
