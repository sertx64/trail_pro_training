import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';

class ReportCubit extends Cubit<ReportModel> {
  ReportCubit() : super(ReportModel([], false));

  void loadReports(String date) async {
    List<String> reports = (await getReports(date))!;
    print(reports);
    final ReportModel newReport = ReportModel(reports, true);
    emit(newReport);
  }

  void renewReportsOnWidget(String load, String feeling, String feedback){
    List<String> reports = state.reports;
    reports.add(Management.userLogin);
    reports.add(load);
    reports.add(feeling);
    reports.add(feedback);
    final ReportModel newReport = ReportModel(reports, true);
    emit(newReport);
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
    print('SPLIT REPORTS!!! $splitList');
    return splitList;
  }
}

class ReportModel {
  List<String> reports;
  bool isLoading;
  ReportModel(this.reports, this.isLoading);
}
