import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';

class ReportCubit extends Cubit<ReportsForView> {
  ReportCubit() : super(ReportsForView([], false));

  bool isLoadReport = false;

  void loadReports(String sheetNameGroup, String date) async {
    if (!isLoadReport) {
      List<String> reportsList = (await getReports(sheetNameGroup, date))!;
      isLoadReport = true;
      List<ReportModel> reports = splitReports(reportsList);
      final ReportsForView newReport = ReportsForView(reports, true);
      emit(newReport);
    }
  }

  void renewReportsOnWidget(String load, String feeling, String feedback) {
    List<ReportModel> reports = state.reports;
    reports.add(ReportModel(Management.user.name, load, feeling, feedback));
    final ReportsForView newReport = ReportsForView(reports, true);
    emit(newReport);
  }

  Future<List<String>?> getReports(String sheetNameGroup, String dayDate) async {
    String sheetNameReports() {
      return (sheetNameGroup == 'tp_week_plan') ? 'reports' : '${sheetNameGroup}_reports';
    }
    return await ApiGSheet().getReportsList(sheetNameReports(), dayDate);
  }

  List<ReportModel> splitReports(List<String> reports) {
    List<ReportModel> splitList = [];
    for (var i = 0; i < reports.length; i += 4) {
      splitList.add(ReportModel(
          reports[i], reports[i + 1], reports[i + 2], reports[i + 3]));
    }
    return splitList;
  }

  void sentReport(String sheetNameGroup, String dayDate, String load, String feeling,
      String feedback) async {
    String sheetNameReports(){
      return (sheetNameGroup == 'tp_week_plan') ? 'reports' : '${sheetNameGroup}_reports';
    }
    List<String>? reportsList = await ApiGSheet().getReportsList(sheetNameReports(), dayDate);
    reportsList!.add(Management.user.name);
    reportsList.add(load);
    reportsList.add(feeling);
    reportsList.add(feedback);
    ApiGSheet().sendReportsList(sheetNameReports(), dayDate, reportsList);
  }
}
