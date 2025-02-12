import 'package:flutter/material.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/student_report.dart';
import 'package:trailpro_planning/domain/week_plan_map.dart';

class Management {
  ValueNotifier<WeekPlansModel> weekPlans =
      ValueNotifier<WeekPlansModel>(WeekPlansModel([], []));

  ValueNotifier<List<String>> reportsOfDay = ValueNotifier<List<String>>([]);

  bool isLoadingPlans = false;
  List<Map<String, String>> _weekPlanGroup = [];
  List<Map<String, String>> _weekPlanPersonal = [];

  void loadWeekPlan(int yWid) async {
    isLoadingPlans = false;
    weekPlans.value = WeekPlansModel([], []);
    _weekPlanGroup = await WeekPlanMap('tp_week_plan', yWid).weekPlanStudent();
    _weekPlanPersonal = await WeekPlanMap(userLogin, yWid).weekPlanStudent();
    weekPlans.value = WeekPlansModel(_weekPlanGroup, _weekPlanPersonal);
    isLoadingPlans = true;
  }

  int yearWeekIndex = int.parse(yearWeekNow());
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

  int currentDayWeekIndex = 0;
  Map<String, String> dayPlanStudentGroup = {};
  Map<String, String> dayPlanStudentPersonal = {};

  void newScreenDayPlan(int dayIndex) {
    dayPlanStudentGroup = _weekPlanGroup[dayIndex];
    dayPlanStudentPersonal = _weekPlanPersonal[dayIndex];
    currentDayWeekIndex = dayIndex;
  }

  bool isLoadingReports = false;
  void loadReports() async {
    isLoadingReports = false;
    reportsOfDay.value = [];
    reportsOfDay.value = (await StudentReport().getReports(dayPlanStudentGroup['date']!))!;
    isLoadingReports = true;
  }

  static List<String> authUserList = [];
  static List<String> userList = [];
  static Map<String, String> authUserMap = {};
  static String userLogin = '';
  static int currentWeek = 0;
  static List<Map<String, String>> currentWeekPlan = [];
  static int currentDayWeek = 0;
  static String selectedUser = '';
}

class WeekPlansModel {
  List<Map<String, String>> weekPlanGroup;
  List<Map<String, String>> weekPlanPersonal;
  WeekPlansModel(this.weekPlanGroup, this.weekPlanPersonal);
}
