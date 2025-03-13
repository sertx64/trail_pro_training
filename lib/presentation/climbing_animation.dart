import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationLoadBar extends StatelessWidget {
  const LottieAnimationLoadBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(
          'assets/animations/anim2.json', // Путь к вашему JSON-файлу с анимацией
          height: 200,
          fit: BoxFit.fill,
        ));
  }
}