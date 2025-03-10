import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';

class ReportCubit extends Cubit<ReportsForView> {
  ReportCubit() : super(ReportsForView([], false));

  bool isLoadReport = false;

  void loadReports(String date) async {
    if (!isLoadReport) {
      List<String> reportsList = (await getReports(date))!;
      isLoadReport = true;
      List<ReportModel> reports = splitReports(reportsList);
      final ReportsForView newReport = ReportsForView(reports, true);
      emit(newReport);
    }
  }

  void renewReportsOnWidget(String load, String feeling, String feedback) {
    List<ReportModel> reports = state.reports;
    reports.add(ReportModel(Management.userLogin, load, feeling, feedback));
    final ReportsForView newReport = ReportsForView(reports, true);
    emit(newReport);
  }

  Future<List<String>?> getReports(String dayDate) async {
    return await ApiGSheet().getReportsList(dayDate);
  }

  List<ReportModel> splitReports(List<String> reports) {
    List<ReportModel> splitList = [];
    for (var i = 0; i < reports.length; i += 4) {
      splitList.add(ReportModel(reports[i], reports[i+1], reports[i+2], reports[i+3]));
    }
    return splitList;
  }

}


