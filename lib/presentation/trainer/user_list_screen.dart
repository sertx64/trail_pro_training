import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/management.dart';

class UserListScreen extends StatelessWidget {
  UserListScreen({super.key});
  final Management management = GetIt.instance<Management>();

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
                management.loadWeekPlanTrainerPersonal(management.yearWeekIndex, Management.userList[index]);
                context.push('/personalplan');
              },
            );
          },
        ));
  }
}
