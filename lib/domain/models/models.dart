class DayPlanModel {
  DayPlanModel(this.day, this.date, this.label, this.description, {this.time = '', this.location = ''});
  String day;
  String date;
  String label;
  String description;
  String time;
  String location;

  // Функция для парсинга строки label и извлечения времени и места
  static DayPlanModel parseFromLabel(String day, String date, String label, String description) {
    String time = '';
    String location = '';
    String cleanLabel = label;

    // Парсим строку label для извлечения времени и места
    if (label.isNotEmpty) {
      List<String> lines = label.split('\n');
      String mainText = '';
      
      for (String line in lines) {
        line = line.trim();
        if (line.startsWith('time:')) {
          time = line.substring(5).trim();
        } else if (line.startsWith('location:')) {
          location = line.substring(9).trim();
        } else if (line.isNotEmpty) {
          mainText += (mainText.isNotEmpty ? '\n' : '') + line;
        }
      }
      
      // Если нашли время или место, используем очищенный текст
      if (time.isNotEmpty || location.isNotEmpty) {
        cleanLabel = mainText;
      }
    }

    return DayPlanModel(day, date, cleanLabel, description, time: time, location: location);
  }
}

class PlanDataModel {
  PlanDataModel(this.isDay, this.planLoaded, this.weekPlanGroup, this.weekPlanPersonal, this.planType, {this.isViewMode = false});
  bool isDay;
  bool planLoaded;
  List<DayPlanModel> weekPlanGroup;
  List<DayPlanModel> weekPlanPersonal;
  String planType;
  bool isViewMode;

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