import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/users.dart';
import 'package:trailpro_planning/domain/management.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _pin = TextEditingController();

  final TextEditingController _login = TextEditingController();

  bool _isTrainer = false;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isTrainer,
                  onChanged: (bool? value) {
                    setState(() {
                      _isTrainer = value ?? false; // Обновляем состояние
                    });
                  },
                ),
                const Text('Роль "тренер"'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                onPressed: () {
                  if (Management.userList.contains(_login.text.trim()) || Management.groupsList.contains(_login.text.trim()) || _pin.text.trim() == '' || _login.text.trim() == '') {
                    return;
                  } else {
                    Management.userList.add(_login.text.trim());
                    String role = _isTrainer ? 'trainer' : 'student';
                    Users().addUser(_login.text.trim(),_login.text.trim(), _pin.text.trim(), role, ['TrailPro']);
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
