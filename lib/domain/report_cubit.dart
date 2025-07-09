import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';

class ReportCubit extends Cubit<ReportsForView> {
  ReportCubit() : super(ReportsForView([], false));

  bool isLoadReport = false;

  void loadReports(String sheetNameGroup, String date) async {
    if (!isLoadReport) {
      List<String>? reportsList = await getReports(sheetNameGroup, date);
      isLoadReport = true;
      
      // Проверяем на null и пустой список
      List<ReportModel> reports = [];
      if (reportsList != null && reportsList.isNotEmpty) {
        reports = splitReports(reportsList);
      }
      
      final ReportsForView newReport = ReportsForView(reports, true);
      emit(newReport);
    }
  }

  void renewReportsOnWidget(String load, String feeling, String feedback) {
    List<ReportModel> reports = state.reports;
    reports.add(ReportModel(Management.user.login, load, feeling, feedback));
    final ReportsForView newReport = ReportsForView(reports, true);
    emit(newReport);
  }

  Future<List<String>?> getReports(String sheetNameGroup, String dayDate) async {
    String sheetNameReports() {
      return (sheetNameGroup == 'TrailPro') ? 'reports' : '${sheetNameGroup}_reports';
    }
    return await ApiGSheet().getReportsList(sheetNameReports(), dayDate);
  }

  List<ReportModel> splitReports(List<String> reports) {
    List<ReportModel> splitList = [];
    
    // Проверяем, что у нас есть данные для разбора
    if (reports.isEmpty) {
      return splitList;
    }
    
    // Убеждаемся, что количество элементов кратно 4 (логин, нагрузка, самочувствие, обратная связь)
    for (var i = 0; i < reports.length; i += 4) {
      // Проверяем, что у нас есть все 4 элемента для отчета
      if (i + 3 < reports.length) {
      splitList.add(ReportModel(
          reports[i],     // логин
          reports[i + 1], // нагрузка
          reports[i + 2], // самочувствие
          reports[i + 3]  // обратная связь
        ));
    }
    }
    
    return splitList;
  }

  void sentReport(String sheetNameGroup, String dayDate, String load, String feeling,
      String feedback) async {
    String sheetNameReports(){
      return (sheetNameGroup == 'TrailPro') ? 'reports' : '${sheetNameGroup}_reports';
    }
    List<String>? reportsList = await ApiGSheet().getReportsList(sheetNameReports(), dayDate);
    
    // Если список отчетов null, создаем новый
    if (reportsList == null) {
      reportsList = [];
    }
    
    reportsList.add(Management.user.login);
    reportsList.add(load);
    reportsList.add(feeling);
    reportsList.add(feedback);
    ApiGSheet().sendReportsList(sheetNameReports(), dayDate, reportsList);
  }
}
