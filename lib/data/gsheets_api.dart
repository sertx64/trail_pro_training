import 'package:gsheets/gsheets.dart';
import 'package:trailpro_planning/domain/management.dart';

class ApiGSheet {
  final Spreadsheet ss = Management.forGSheetsApi;

  Future<List<String>?> authUserData(String login) async {
    final sheet = ss.worksheetByTitle('users');
    final userData = await sheet!.values.rowByKey(login);
    return userData;
  }

  Future<List<String>?> getWeekPlanList(String plan, String id) async {
    final sheet = ss.worksheetByTitle(plan);
    final weekplanlist = await sheet!.values.rowByKey(id);
    return weekplanlist;
  }

  void sendWeekPlanList(String plan, String id, List<String> weekplanlist) async {
    final sheet = ss.worksheetByTitle(plan);
    await sheet!.values.insertRowByKey(id, weekplanlist);
  }

  Future<List<String>?> getUserList() async {
    final sheet = ss.worksheetByTitle('users');
    final userList = await sheet!.values.columnByKey('login_id');
    return userList;
  }

  void addUser(String login, List<String> userList) async {
    final sheet = ss.worksheetByTitle('users');
    await sheet!.values.insertRowByKey(login, userList);
  }

  Future<List<String>?> getReportsList(String date) async {
    final sheet = ss.worksheetByTitle('reports');
    final reportsList = await sheet!.values.rowByKey(date);
    return reportsList;
  }

  void sendReportsList(String date, List<String> reportList) async {
    final sheet = ss.worksheetByTitle('reports');
    await sheet!.values.insertRowByKey(date, reportList);
  }

  Future<List<String>?> getSamples() async {
    final sheet = ss.worksheetByTitle('samples');
    final authUserList = await sheet!.values.columnByKey('samples_list');
    return authUserList;
  }

  void sendSamplesList(List<String> samplesList) async {
    final sheet = ss.worksheetByTitle('samples');
    await sheet!.values.insertColumnByKey('samples_list', samplesList);
  }
}
