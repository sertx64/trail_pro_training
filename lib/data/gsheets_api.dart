import 'package:gsheets/gsheets.dart';
import 'package:trailpro_planning/domain/management.dart';

class ApiGSheet {
  final Spreadsheet ss = Management.forGSheetsApi;

//test

  Future<List<String>?> getUserData(String login) async {
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

  Future<List<String>?> getGroupsList() async {
    final sheet = ss.worksheetByTitle('groups_sheet');
    final groupsList = await sheet!.values.columnByKey('groups_id');
    return groupsList;
  }

  void addGroup(List<String> groupsList) async {
    final sheet = ss.worksheetByTitle('groups_sheet');
    await sheet!.values.insertColumnByKey('groups_id', groupsList);
  }

  void changePersonalDataOrAddUser(String login, List<String> userList) async {
    final sheet = ss.worksheetByTitle('users');
    await sheet!.values.insertRowByKey(login, userList);
  }

  Future<List<String>?> getReportsList(String sheetName, String date) async {
    final sheet = ss.worksheetByTitle(sheetName);
    final reportsList = await sheet!.values.rowByKey(date);
    return reportsList;
  }

  void sendReportsList(String sheetName, String date, List<String> reportList) async {
    final sheet = ss.worksheetByTitle(sheetName);
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

  void createNewSheetPlan(String nameSheet) async{
    // Получение исходного листа
    final Worksheet sourceSheet = ss.worksheetByTitle('service')!;

    // Чтение данных с исходного листа
    final List<List<String>>data = await sourceSheet.values.allRows();

    // Создание нового листа
    final Worksheet newSheet = await ss.addWorksheet(nameSheet);

    // Запись данных в новый лист
    await newSheet.values.insertRows(1, data);
  }

  void createNewSheetGroupReports(String nameSheet) async{
    // Получение исходного листа
    final Worksheet sourceSheet = ss.worksheetByTitle('reports')!;

    // Чтение данных с исходного листа
    final List<String> data = await sourceSheet.values.column(1);

    // Создание нового листа
    final Worksheet newSheet = await ss.addWorksheet(nameSheet);

    // Запись данных в новый лист
    await newSheet.values.insertColumn(1, data);
  }

  // void changePersonalData(String login, String name, String pin, List<String> groups){
  //
  // }


}
