import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/auth_student_map.dart';
import 'package:trailpro_planning/domain/management.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
                style: TextStyle(fontSize: 30, color: Colors.white),
                'Список учеников'),
            backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
        body: ListView.separated(
          itemCount: Management.userList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(Management.userList[index]),
              onTap: () {
                Management.selectedUser = Management.userList[index];
                context.go('/trainerauth/trainerscreen/userlistscreen/personalplan');
              },
            );
          },
        ));
  }
}
