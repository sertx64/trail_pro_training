import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrainerAuth extends StatelessWidget {
  TrainerAuth({super.key});

  final TextEditingController _pin = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //const SizedBox(height: 150),
          const Text('введите ПИН'),
          TextField(
            obscureText: true,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 22),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
            ),
            controller: _pin,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 50),
                  backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
              onPressed: () {
                String pinCode = _pin.text;
                (pinCode == '1050')
                    ? context.go('/trainerauth/trainerscreen')
                    : () {};
              },
              child: const Text(
                  style: TextStyle(fontSize: 24, color: Colors.white),
                  'Вперёд!'))
        ],
      ),
    )));
  }
}
