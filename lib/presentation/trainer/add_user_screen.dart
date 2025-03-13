import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/auth_student.dart';
import 'package:trailpro_planning/domain/management.dart';

class AddUserScreen extends StatelessWidget {
  AddUserScreen({super.key});

  final TextEditingController _pin = TextEditingController();
  final TextEditingController _login = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
                style: TextStyle(fontSize: 30, color: Colors.white),
                'Новый ученик'),
            backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text('логин для нового ученика'),
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
                controller: _login,
              ),
            ),
            const SizedBox(height: 10),
            const Text('пин код'),
            SizedBox(
              height: 50,
              width: 250,
              child: TextField(
                textAlign: TextAlign.center,
                cursorColor: const Color.fromRGBO(255, 132, 26, 1),
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                controller: _pin,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                onPressed: () {
                  if (Management.authUserList.contains(_login.text) || _pin.text == '' || _login.text == '') {
                    return;
                  } else {
                    Management.userList.add(_login.text);
                    Users().addUser(_login.text, _pin.text);
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
