import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/check_pin_student.dart';

class Authorization extends StatelessWidget {
  Authorization({super.key});

  final TextEditingController _pin = TextEditingController();
  final TextEditingController _login = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(
                    color: Color.fromRGBO(255, 132, 26, 1),
                    Icons.fitness_center_rounded),
                onPressed: () => context.go('/trainerauth'),
              ),
            ],
            title: const Center(
                child: Text(
                    style: TextStyle(fontSize: 30, color: Colors.white),
                    'TrailPro planning')),
            backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 200),
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
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: TextField(
                textAlign: TextAlign.center,
                cursorColor: const Color.fromRGBO(255, 132, 26, 1),
                obscureText: true,
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
                onPressed: () async {
                  String login = _login.text;
                  String pin = _pin.text;
                  String? checkPin;
                  checkPin = null;
                  print(checkPin);
                  checkPin = (login == '' || pin == '')
                      ? null
                      : await CheckPinStudent(login).checkPin();
                  print(checkPin);

                  (pin == checkPin)
                      ? context.go('/studentscreen')
                      : print('неправильный логин или пин');
                },

                //=> context.go('/studentscreen'),
                child: const Text(
                    style: TextStyle(fontSize: 24, color: Colors.white),
                    'Войти')),
            const SizedBox(
              height: 30,
            ),
          ],
        )));
  }
}
