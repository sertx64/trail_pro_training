import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';

void createAuthUserMap() async {
  List<String>? authUserList = await ApiGSheet().getAuthUserList();

  Map<String, String> authusermap = {};

  for (int i = 0; i < authUserList!.length; i = i + 2) {
    authusermap[authUserList[i]] = authUserList[i + 1];
  }

  Management.authUserMap = authusermap;
}
