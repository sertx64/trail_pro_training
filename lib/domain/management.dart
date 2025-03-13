import 'package:gsheets/gsheets.dart';
import 'package:trailpro_planning/domain/models/models.dart';


class Management {
  static late Spreadsheet forGSheetsApi;
  static late User user;

  //static String userLogin = '';
  // static String userName = '';
  // static String userPin = '';
  // static String userRole = '';
  // static List userGroups = [];

  //static List<String> authUserList = [];

  static List<String> userList = [];
  static Map<String, String> authUserMap = {};
  static List<String> samplesList = [];
  static List<List<String>> samplesSlitList = [];
  //static List<String> groupsList = ['tp_week_plan'];
}
