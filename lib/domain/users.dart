import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';

class Users {

  void createUserList() async {
    List<String>? authUserList = await ApiGSheet().getUserList();
    Management.userList = authUserList!;
  }

  Future<User> user (String login) async {
    List<String>? authUserList = await ApiGSheet().authUserData(login);
    List<String> groups = authUserList!.sublist(4);
    User newUser = User(authUserList[0], authUserList[1], authUserList[2],authUserList[3], groups);
    Management.user = newUser;
    return newUser;
  }

  void addUser(String login, String pin, String role, List<String> groups) async {
    List<String> authUserList = [login, login, pin, role];
    authUserList.addAll(groups);
    ApiGSheet().addUser(login, authUserList);
  }
}