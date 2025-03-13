import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';

class SentStudentReport {
  void sentReport(
      String dayDate, String load, String feeling, String feedback) async {
    List<String>? reportsList = await ApiGSheet().getReportsList(dayDate);
    reportsList!.add(Management.user.login);
    reportsList.add(load);
    reportsList.add(feeling);
    reportsList.add(feedback);
    ApiGSheet().sendReportsList(dayDate, reportsList);
  }
}
