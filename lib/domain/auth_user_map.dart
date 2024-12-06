import 'package:trailpro_planning/data/gsheets_api.dart';

class AuthUserMap {


  Future<List<Map<String, String>>> authUserMap() async {
    List<String>? authUserList = await ApiGSheet().getAuthUserList();
  }
}