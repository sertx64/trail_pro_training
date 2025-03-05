class DayPlanModel {
  DayPlanModel(this.day, this.date, this.label, this.description);
  String day;
  String date;
  String label;
  String description;
}

class StudentDataModel {
  bool isLoading;
  List<DayPlanModel> weekPlanGroup;
  List<DayPlanModel> weekPlanPersonal;
  StudentDataModel(this.weekPlanGroup, this.weekPlanPersonal, this.isLoading);
}
