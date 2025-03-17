import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';

class Users {

  void createUserAndGroupsList() async {
    Future<List<String>?> authUserListFuture = ApiGSheet().getUserList();
    Future<List<String>?> groupsListFuture = ApiGSheet().getGroupsList();
    List<String>? authUserList = await authUserListFuture;
    List<String>? proupsList = await groupsListFuture;
    Management.userList = authUserList!;
    Management.groupsList = proupsList!;
  }




  Future<User> user (String login) async {
    List<String>? authUserList = await ApiGSheet().authUserData(login);
    List<String> groups = authUserList!.sublist(4);
    User newUser = User(authUserList[0], authUserList[1], authUserList[2],authUserList[3], groups);
    Management.user = newUser;
    return newUser;
  }

  void addUser(String login, String pin, String role, List<String> groups) {
    List<String> authUserList = [login, login, pin, role];
    authUserList.addAll(groups);
    ApiGSheet().createNewSheetPlan(login);
    ApiGSheet().addUser(login, authUserList);
  }

  void addGroup(String groupName) {
    Management.groupsList.add(groupName);
    ApiGSheet().createNewSheetPlan(groupName);
    ApiGSheet().addGroup(Management.groupsList);
  }
}