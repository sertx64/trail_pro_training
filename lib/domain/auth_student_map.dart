import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';

void createAuthUserMap() async {
  List<String>? authUserList = await ApiGSheet().getAuthUserList();
  Management.authUserList = authUserList!;
  Map<String, String> authusermap = {};

  for (int i = 0; i < authUserList.length; i = i + 2) {
    authusermap[authUserList[i]] = authUserList[i + 1];
  }

  Management.authUserMap = authusermap;
  Management.userList = Management.authUserMap.keys.toList();
}

void addUser(String login, String pin) async {
  List<String>? authUserList = await ApiGSheet().getAuthUserList();
  authUserList!.add(login);
  authUserList.add(pin);
  Management.authUserList = authUserList;
  ApiGSheet().sendAuthUserList(authUserList);
}
