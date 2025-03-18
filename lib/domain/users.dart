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
    List<String>? authUserList = await ApiGSheet().getUserData(login);
    List<String> groups = authUserList!.sublist(4);
    User newUser = User(authUserList[0], authUserList[1], authUserList[2],authUserList[3], groups);
    Management.user = newUser;
    return newUser;
  }

  Future<User> getUserData (String login) async {
    List<String>? authUserList = await ApiGSheet().getUserData(login);
    List<String> groups = authUserList!.sublist(4);
    User newUser = User(authUserList[0], authUserList[1], authUserList[2],authUserList[3], groups);
    return newUser;
  }



  void addUser(String login, String name, String pin, String role, List<String> groups) {
    List<String> userList = [login, name, pin, role];
    userList.addAll(groups);
    if (role == 'student') ApiGSheet().createNewSheetPlan(login);
    ApiGSheet().changePersonalDataOrAddUser(login, userList);
  }

  void changePersonalDataUser(String login, String name, String pin, String role, List<String> groups) {
    List<String> userList = [login, name, pin, role];
    userList.addAll(groups);
    ApiGSheet().changePersonalDataOrAddUser(login, userList);
  }

  void addGroup(String groupName) {
    Management.groupsList.add(groupName);
    ApiGSheet().createNewSheetPlan(groupName);
    ApiGSheet().createNewSheetGroupReports('${groupName}_reports');
    ApiGSheet().addGroup(Management.groupsList);
  }
}