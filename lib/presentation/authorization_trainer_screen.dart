import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/management.dart';

class TrainerAuth extends StatelessWidget {
  TrainerAuth({super.key});
  final Management management = GetIt.instance<Management>();
  final TextEditingController _pin = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Management.userLogin = '';
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
                style: TextStyle(fontSize: 26, color: Colors.white),
                'Вы тренер?'),
            backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 200),
              const Text(
                  style: TextStyle(color: Color.fromRGBO(255, 132, 26, 1)),
                  'введите ПИН'),
              SizedBox(
                width: 200,
                child: TextField(
                  textAlign: TextAlign.center,
                  cursorColor: const Color.fromRGBO(255, 132, 26, 1),
                  autofocus: true,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      color: Color.fromRGBO(255, 132, 26, 1), fontSize: 22),
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
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                  onPressed: () {
                    management
                        .loadWeekPlanTrainerGroup(management.yearWeekIndex);
                    String pinCode = _pin.text;
                    (pinCode == '1050')
                        ? context.push('/trainerscreen')
                        : () {};
                  },
                  child: const Text(
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      'Вход'))
            ],
          ),
        )));
  }
}
