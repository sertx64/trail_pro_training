import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';

class StudentReport {
  void sentReport(
      String dayDate, String load, String feeling, String feedback) async {
    List<String>? reportsList = await ApiGSheet().getReportsList(dayDate);
    reportsList!.add(Management.userLogin);
    reportsList.add(load);
    reportsList.add(feeling);
    reportsList.add(feedback);
    ApiGSheet().sendReportsList(dayDate, reportsList);
  }

  Future<List<String>?> getReports(String dayDate) async {
    return await ApiGSheet().getReportsList(dayDate);
  }

  List<List<String>> splitReports(List<String> reports) {
    List<List<String>> splitList = [];
    for (var i = 0; i < reports.length; i += 4) {
      splitList.add(
          reports.sublist(i, i + 4 > reports.length ? reports.length : i + 4));
    }
    return splitList;
  }
}
