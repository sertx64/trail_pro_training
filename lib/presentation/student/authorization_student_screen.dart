import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:trailpro_planning/domain/management.dart';

class Authorization extends StatefulWidget {
  const Authorization({super.key});

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  final Management management = GetIt.instance<Management>();
  final box = Hive.box('user');
  final TextEditingController _pin = TextEditingController();
  final TextEditingController _login = TextEditingController();

  void goToStudentScreen() {
    String login = _login.text;
    String pin = _pin.text;
    Map<String, String> aum = Management.authUserMap;
    if (aum.containsKey(login)) {
      if (pin == aum[login]) {
        management.setNowYearWeek();
        Management.userLogin = login;
        box.put('login', login);
        box.put('pin', pin);
        //management.loadWeekPlan(management.yearWeekIndex);
        context.go('/studentscreen');

      } else {
        return;
      }
    } else {
      return;
    }
  }

  @override
  void initState() {
    final login = box.get('login', defaultValue: '');
    final pin = box.get('pin', defaultValue: '');
    _login.text = login;
    _pin.text = pin;
    //Future.delayed(const Duration(seconds: 4), () => goToStudentScreen);
    super.initState();
  }

  @override
  void dispose() {
    _login.dispose();
    _pin.dispose();
    print('DESPOSE AUTHSCREEN!!!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(
                    color: Color.fromRGBO(255, 132, 26, 1),
                    Icons.fitness_center_rounded),
                onPressed: () => context.push('/trainerauth'),
              ),
              IconButton(
                icon: const Icon(
                    color: Color.fromRGBO(255, 132, 26, 1), Icons.info_outline),
                onPressed: () => context.push('/infoscreen'),
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
                    elevation: 8,
                    fixedSize: const Size(200, 50),
                    backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                onPressed: goToStudentScreen,
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
