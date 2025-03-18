import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/samples.dart';
import 'package:trailpro_planning/domain/users.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final box = Hive.box('user');

  @override
  Widget build(BuildContext context) {
    final login = box.get('login', defaultValue: '');
    final pin = box.get('pin', defaultValue: '');

    Future.delayed(const Duration(seconds: 4), () {
      if (login == '') {
        context.go('/authorization');
      } else {
        goToRoleScreen(context, login, pin);
      }
    });

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset('assets/images/trailpro_logo.png'),
        ),
      ),
    );
  }

  void goToRoleScreen(BuildContext context, String login, String pin) async {

    User user = await Users().user(login);
    if (user.pin == pin) {
      box.put('login', login);
      box.put('pin', pin);
      Management.user = user;
      if (user.role == 'student') {
        context.go('/studentscreen');
      } else {
        Samples().createSamplesSplitList();
        Users().createUserAndGroupsList();
        context.go('/trainerscreen');
      }
    } else {
      context.go('/authorization');
    }

  }
}
