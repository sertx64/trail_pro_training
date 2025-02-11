import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:trailpro_planning/domain/management.dart';

class Authorization extends StatelessWidget {
  Authorization({super.key});

  final Management management = GetIt.instance<Management>();

  @override
  Widget build(BuildContext context) {

    final box = Hive.box('user');
    final login = box.get('login', defaultValue: '');
    final pin = box.get('pin', defaultValue: '');

    final TextEditingController _pin = TextEditingController(text: pin);
    final TextEditingController _login = TextEditingController(text: login);

    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(
                    color: Color.fromRGBO(255, 132, 26, 1),
                    Icons.fitness_center_rounded),
                onPressed: () => context.go('/trainerauth'),
              ),
              IconButton(
                icon: const Icon(
                    color: Color.fromRGBO(255, 132, 26, 1),
                    Icons.info_outline),
                onPressed: () => context.go('/infoscreen'),
              ),
            ],
            centerTitle: true,
            title: const Text(
                style: TextStyle(fontSize: 30, color: Colors.white),
                'TrailPro planning'),
            backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 150),
            const Text('логин'),
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
            const Text('пин'),
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
                onPressed: () {
                  String login = _login.text;
                  String pin = _pin.text;
                  Map<String, String> aum = Management.authUserMap;
                  if (aum.containsKey(login)) {
                    if (pin == aum[login]) {
                      Management.userLogin = login;
                      box.put('login', login);
                      box.put('pin', pin);
                      management.loadWeekPlan(management.yWeek);
                      context.go('/studentscreen');
                    } else {
                      return;
                    }
                  } else {
                    return;
                  }
                },
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
