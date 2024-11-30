import 'package:trailpro_planning/data/gsheets_api.dart';

class CheckPinStudent {
  CheckPinStudent(this.nameStudent);
  String nameStudent;
  Future<String?> checkPin() async {
    return await ApiGSheet().checkPinStudent(nameStudent);
  }
}