class DayPlanModel {
  DayPlanModel(this.day, this.date, this.label, this.description);
  String day;
  String date;
  String label;
  String description;
}

class PlanDataModel {
  PlanDataModel(this.isDay, this.planLoaded, this.weekPlanGroup, this.weekPlanPersonal, this.planType);
  bool isDay;
  bool planLoaded;
  List<DayPlanModel> weekPlanGroup;
  List<DayPlanModel> weekPlanPersonal;
  String planType;

}

class ReportModel {
  ReportModel(this.name, this.load, this.feeling, this.feedback);
  String name;
  String load;
  String feeling;
  String feedback;
}

class ReportsForView {
  List<ReportModel> reports;
  bool isLoading;
  ReportsForView(this.reports, this.isLoading);
}

class User {
  User(this.login, this.name, this.pin, this.role, this.groups);
  String login;
  String name;
  String pin;
  String role;
  List<String> groups;
}