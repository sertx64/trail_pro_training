import 'package:flutter/material.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/student_report.dart';
import 'package:trailpro_planning/domain/week_plan_map.dart';

class Management {
  ValueNotifier<WeekPlansModel> weekPlans =
      ValueNotifier<WeekPlansModel>(WeekPlansModel([], []));

  ValueNotifier<WeekPlanModelGroup> weekPlanGroup =
  ValueNotifier<WeekPlanModelGroup>(WeekPlanModelGroup([]));

  ValueNotifier<WeekPlanModelPersonal> weekPlanPersonal =
  ValueNotifier<WeekPlanModelPersonal>(WeekPlanModelPersonal([]));

  ValueNotifier<List<String>> reportsOfDay = ValueNotifier<List<String>>([]);

String selUser = '';
  static String selectedUser = '';
  static String userLogin = '';

  bool isLoadingPlans = false;
  List<Map<String, String>> currentWeekPlanGroup = [];
  List<Map<String, String>> currentWeekPlanPersonal = [];

  void loadWeekPlan(int yWid) async {
    isLoadingPlans = false;
    weekPlans.value = WeekPlansModel([], []);
    currentWeekPlanGroup = await WeekPlanMap('tp_week_plan', yWid).weekPlanStudent();
    currentWeekPlanPersonal = await WeekPlanMap(userLogin, yWid).weekPlanStudent();
    weekPlans.value = WeekPlansModel(currentWeekPlanGroup, currentWeekPlanPersonal);
    isLoadingPlans = true;
  }

  void loadWeekPlanTrainerPersonal(int yWid, String selecteduser) async {
    isLoadingPlans = false;
    weekPlanPersonal.value = WeekPlanModelPersonal([]);
    currentWeekPlanPersonal = await WeekPlanMap(selecteduser, yWid).weekPlanStudent();
    weekPlanPersonal.value = WeekPlanModelPersonal(currentWeekPlanPersonal);
    isLoadingPlans = true;
    selUser = selecteduser;
  }

  void loadWeekPlanTrainerGroup(int yWid) async {
    isLoadingPlans = false;
    weekPlanGroup.value = WeekPlanModelGroup([]);
    currentWeekPlanGroup = await WeekPlanMap('tp_week_plan', yWid).weekPlanStudent();
    weekPlanGroup.value = WeekPlanModelGroup(currentWeekPlanGroup);
    isLoadingPlans = true;
  }

  void updateWeekPlanTrainerGroup() async {
    weekPlanGroup.value = WeekPlanModelGroup(currentWeekPlanGroup);
  }

  void updateWeekPlanTrainerPersonal() async {
    weekPlanPersonal.value = WeekPlanModelPersonal(currentWeekPlanPersonal);
  }

  int yearWeekIndex = int.parse(yearWeekNow());
  void nextWeek(String who) {
    ++yearWeekIndex;
    if (yearWeekIndex == 202453) yearWeekIndex = 202501;
    if (yearWeekIndex == 202553) yearWeekIndex = 202601;
    if (yearWeekIndex == 202653) yearWeekIndex = 202701;
    if (who == 'student') loadWeekPlan(yearWeekIndex);
    if (who == 'trainergroup') loadWeekPlanTrainerGroup(yearWeekIndex);
    if (who == 'trainerpersonal') loadWeekPlanTrainerPersonal(yearWeekIndex, selUser);
  }

  void previousWeek(String who) {
    --yearWeekIndex;
    if (yearWeekIndex == 202444) yearWeekIndex = 202445;
    if (yearWeekIndex == 202500) yearWeekIndex = 202452;
    if (yearWeekIndex == 202600) yearWeekIndex = 202552;
    if (yearWeekIndex == 202700) yearWeekIndex = 202652;
    if (who == 'student') loadWeekPlan(yearWeekIndex);
    if (who == 'trainergroup') loadWeekPlanTrainerGroup(yearWeekIndex);
    if (who == 'trainerpersonal') loadWeekPlanTrainerPersonal(yearWeekIndex, selUser);
  }

  int currentDayWeekIndex = 0;
  Map<String, String> dayPlanStudentGroup = {};
  Map<String, String> dayPlanStudentPersonal = {};

  void newScreenDayPlan(int dayIndex) {
    dayPlanStudentGroup = currentWeekPlanGroup[dayIndex];
    dayPlanStudentPersonal = currentWeekPlanPersonal[dayIndex];
    currentDayWeekIndex = dayIndex;
  }

  void newScreenDayPlanGroupTrainer(int dayIndex) {
    dayPlanStudentGroup = currentWeekPlanGroup[dayIndex];
    currentDayWeekIndex = dayIndex;
  }

  void newScreenDayPlanPersonalTrainer(int dayIndex) {
    dayPlanStudentPersonal = currentWeekPlanPersonal[dayIndex];
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

  static int currentWeek = 0;
  static List<Map<String, String>> currentWeekPlan = [];
  static int currentDayWeek = 0;

}

class WeekPlansModel {
  List<Map<String, String>> weekPlanGroup;
  List<Map<String, String>> weekPlanPersonal;
  WeekPlansModel(this.weekPlanGroup, this.weekPlanPersonal);
}

class WeekPlanModelGroup {
  List<Map<String, String>> weekPlanGroup;
  WeekPlanModelGroup(this.weekPlanGroup);
}

class WeekPlanModelPersonal {
  List<Map<String, String>> weekPlanPersonal;
  WeekPlanModelPersonal(this.weekPlanPersonal);
}