import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';

void sentReport(String dayDate, String load, String feeling, String feedback) async {
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
