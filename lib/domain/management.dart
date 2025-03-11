import 'package:gsheets/gsheets.dart';


class Management {
  static late Spreadsheet forGSheetsApi;
  static String userLogin = '';
  static List<String> authUserList = [];
  static List<String> userList = [];
  static Map<String, String> authUserMap = {};
  static List<String> samplesList = [];
  static List<List<String>> samplesSlitList = [];
  static List<String> groupsList = ['tp_week_plan'];
}
