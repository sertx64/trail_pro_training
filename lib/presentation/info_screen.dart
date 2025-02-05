import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(1, 57, 104, 1),
          title: const Text(
              style: TextStyle(fontSize: 30, color: Colors.white),
              'Информация'),
          centerTitle: true,
        ),
        backgroundColor: Colors.blue[100],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  'Данное приложение разрабатывается для планнирования тренеровок по скайраннингу и трейлраннингу командой TrailPro Team.'),
              const SizedBox(height: 10),
              const Text(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  'Подробнее на нашем сайте:'),
              TextButton(
                onPressed: () => context.go('/infoscreen/sitetrailpro'),
                child: const Text(
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        decoration: TextDecoration.underline),
                    'TrailPro.ru'),
              ),
              const SizedBox(height: 10),
              const Text(
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  'Для регистрации в приложении нужно обратится к Лаптеву Сергею.'),
              const SizedBox(height: 10),
            ],
          ),
        ));
  }
}
