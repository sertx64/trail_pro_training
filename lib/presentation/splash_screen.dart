import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/auth_student_map.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    createAuthUserMap();
    Future.delayed(const Duration(seconds: 4), () => context.go('/'));
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset('assets/images/trailpro_logo.png'),
        ),
      ),
    );
  }
}
