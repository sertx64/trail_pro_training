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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                style: TextStyle(
                    fontSize: 24, color: Color.fromRGBO(1, 57, 104, 1)),
                'Кто вы?'),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                onPressed: () => context.go('/trainerscreen'),
                child: const Text(
                    style: TextStyle(fontSize: 24, color: Colors.white),
                    'Тренер')),
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
                    'Ученик')),
            const SizedBox(
              height: 200,
            ),
          ],
        )));
  }
}
