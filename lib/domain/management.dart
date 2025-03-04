import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/week_plan_map.dart';

class Management {
  static late Spreadsheet forGSheetsApi;


  static String userLogin = '';
  static List<String> authUserList = [];
  static List<String> userList = [];
  static Map<String, String> authUserMap = {};
  static List<String> samplesList = [];
  static List<List<String>> samplesSlitList = [];


  static Map<String, String> dayPlanStudentGroup1 = {};
  static Map<String, String> dayPlanStudentPersonal1 = {};
  static int yearWeekIndex1 = 0;
  static int currentDayWeekIndex1 = 0;
//костыль для экрана День Студента

  ValueNotifier<List<Map<String, String>>> weekPlanGroup =
      ValueNotifier<List<Map<String, String>>>([]);
  ValueNotifier<List<Map<String, String>>> weekPlanPersonal =
      ValueNotifier<List<Map<String, String>>>([]);

  int yearWeekIndex = int.parse(DatePasing().yearWeekNow());
  String selectedUser = '';
  int currentDayWeekIndex = 0;
  Map<String, String> dayPlanStudentGroup = {};
  Map<String, String> dayPlanStudentPersonal = {};
  bool isLoadingPlans = false;
  List<Map<String, String>> currentWeekPlanGroup = [];
  List<Map<String, String>> currentWeekPlanPersonal = [];



  void loadWeekPlanTrainerPersonal(int yWid, String selecteduser) async {
    selectedUser = selecteduser;
    isLoadingPlans = false;
    weekPlanPersonal.value = [];
    currentWeekPlanPersonal =
        await WeekPlanMap(selecteduser, yWid).weekPlanStudent();
    weekPlanPersonal.value = currentWeekPlanPersonal;
    isLoadingPlans = true;
  }

  void loadWeekPlanTrainerGroup(int yWid) async {
    isLoadingPlans = false;
    weekPlanGroup.value = [];
    currentWeekPlanGroup =
        await WeekPlanMap('tp_week_plan', yWid).weekPlanStudent();
    weekPlanGroup.value = currentWeekPlanGroup;
    isLoadingPlans = true;
  }

  void setNowYearWeek() {
    yearWeekIndex = int.parse(DatePasing().yearWeekNow());
  }

  void updateWeekPlanTrainerGroup() async {
    weekPlanGroup.value = currentWeekPlanGroup;
  }

  void updateWeekPlanTrainerPersonal() async {
    weekPlanPersonal.value = currentWeekPlanPersonal;
  }

  void nextWeek(String who) {
    ++yearWeekIndex;
    if (yearWeekIndex == 202453) yearWeekIndex = 202501;
    if (yearWeekIndex == 202553) yearWeekIndex = 202601;
    if (yearWeekIndex == 202653) yearWeekIndex = 202701;
    if (who == 'trainergroup') loadWeekPlanTrainerGroup(yearWeekIndex);
    if (who == 'trainerpersonal') {
      loadWeekPlanTrainerPersonal(yearWeekIndex, selectedUser);
    }
  }

  void previousWeek(String who) {
    --yearWeekIndex;
    if (yearWeekIndex == 202444) yearWeekIndex = 202445;
    if (yearWeekIndex == 202500) yearWeekIndex = 202452;
    if (yearWeekIndex == 202600) yearWeekIndex = 202552;
    if (yearWeekIndex == 202700) yearWeekIndex = 202652;
    if (who == 'trainergroup') loadWeekPlanTrainerGroup(yearWeekIndex);
    if (who == 'trainerpersonal') {
      loadWeekPlanTrainerPersonal(yearWeekIndex, selectedUser);
    }
  }

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
}

class WeekPlansModel {
  List<Map<String, String>> weekPlanGroup;
  List<Map<String, String>> weekPlanPersonal;
  WeekPlansModel(this.weekPlanGroup, this.weekPlanPersonal);
}
