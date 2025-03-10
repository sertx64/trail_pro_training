class DayPlanModel {
  DayPlanModel(this.day, this.date, this.label, this.description);
  String day;
  String date;
  String label;
  String description;
}

class StudentDataModel {
  StudentDataModel(this.weekPlanGroup, this.weekPlanPersonal, this.isLoading);
  bool isLoading;
  List<DayPlanModel> weekPlanGroup;
  List<DayPlanModel> weekPlanPersonal;

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