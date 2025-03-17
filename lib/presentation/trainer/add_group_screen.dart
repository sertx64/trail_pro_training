import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/users.dart';
import 'package:trailpro_planning/domain/management.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {

  final TextEditingController _groupName = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
                style: TextStyle(fontSize: 30, color: Colors.white),
                'Новая группа'),
            backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text('название для новой группы'),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: TextField(
                    textAlign: TextAlign.center,
                    cursorColor: const Color.fromRGBO(255, 132, 26, 1),
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                    ),
                    controller: _groupName,
                  ),
                ),
                const SizedBox(height: 10),


                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 50),
                        backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                    onPressed: () {
                      if (Management.userList.contains(_groupName.text.trim()) || Management.groupsList.contains(_groupName.text.trim()) || _groupName.text.trim() == '') {
                        return;
                      } else {

                        Users().addGroup(_groupName.text.trim());
                        context.go('/trainerscreen');
                      }
                    },
                    child: const Text(
                        style: TextStyle(fontSize: 24, color: Colors.white),
                        'Добавить')),
                const SizedBox(
                  height: 30,
                ),
              ],
            )));
  }
}
