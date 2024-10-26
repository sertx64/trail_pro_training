import 'package:flutter/material.dart';
import 'package:trailpro_planning/presentation/authorization.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/presentation/studentscreen.dart';
import 'package:trailpro_planning/presentation/trainerscreen.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Authorization();
      },
      routes: <RouteBase>[
        GoRoute(

          path: 'trainerscreen',
          builder: (BuildContext context, GoRouterState state) {
            return const TrainerScreen();
          },
        ),
        GoRoute(

          path: 'studentscreen',
          builder: (BuildContext context, GoRouterState state) {
            return const StudentScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TrailPro planning',
      routerConfig: _router,
    );
  }
}
