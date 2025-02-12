import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:trailpro_planning/domain/management.dart';

class Authorization extends StatefulWidget {
  Authorization({super.key});

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  final Management management = GetIt.instance<Management>();

  final box = Hive.box('user');
  final TextEditingController _pinTextController = TextEditingController();
  final TextEditingController _loginTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Первичная иницализация из сохраненных значений
    String login = box.get('login', defaultValue: '');
    String pin = box.get('pin', defaultValue: '');
    _pinTextController.text = pin;
    _loginTextController.text = login;
    setState(() {});
  }

  @override
  void dispose() {
    _pinTextController.dispose();
    _loginTextController.dispose();
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
                onPressed: () => context.go('/trainerauth'),
              ),
              IconButton(
                icon: const Icon(
                    color: Color.fromRGBO(255, 132, 26, 1), Icons.info_outline),
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
                controller: _loginTextController,
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
                controller: _pinTextController,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                onPressed: authClicked,
                child: const Text(
                    style: TextStyle(fontSize: 24, color: Colors.white),
                    'Войти')),
            const SizedBox(
              height: 30,
            ),
          ],
        )));
  }

  void authClicked() {
    String login = _loginTextController.text;
    String pin = _pinTextController.text;
    Map<String, String> aum = Management.authUserMap;

    if (aum.containsKey(login) && pin == aum[login]) {
      Management.userLogin = login;
      box.put('login', login);
      box.put('pin', pin);
      management.loadWeekPlan(management.yearWeekIndex);
      context.go('/studentscreen');
    }
  }
}
