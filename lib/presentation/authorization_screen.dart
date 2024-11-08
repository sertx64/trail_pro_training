import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Authorization extends StatelessWidget {
  const Authorization({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(
                child: Text(
                    style: TextStyle(fontSize: 30, color: Colors.white),
                    'TrailPro planning')),
            backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            const SizedBox(
              width: 250,
              child: TextField(
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                //controller: _pin,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              width: 250,
              child: TextField(
                obscureText: true,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                //controller: _pin,
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                onPressed: () => context.go('/studentscreen'),
                child: const Text(
                    style: TextStyle(fontSize: 24, color: Colors.white),
                    'Войти')),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () => context.go('/trainerauth'),
                child: const Text('Я тренер')),
          ],
        )));
  }
}
