import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/provider_test.dart';

void sentReport(String dayDate, String load, String feeling) async {
  List<String>? reportsList = await ApiGSheet().getReportsList(dayDate);
  reportsList!.add(ProviderTest.userLogin);
  reportsList.add(load);
  reportsList.add(feeling);
  ApiGSheet().sendReportsList(dayDate, reportsList);
}
