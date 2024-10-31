import 'package:flutter/material.dart';
import 'package:trailpro_planning/presentation/authorization_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/presentation/splash_screen.dart';
import 'package:trailpro_planning/presentation/student_screen.dart';
import 'package:trailpro_planning/presentation/trainer_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splashscreen',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const Authorization(),
      routes: <RouteBase>[
        GoRoute(
            path: 'splashscreen',
            builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
            ),
        GoRoute(
            path: 'trainerscreen',
            builder: (BuildContext context, GoRouterState state) => const TrainerScreen(),
            routes: const <RouteBase>[]),
        GoRoute(
            path: 'studentscreen',
            builder: (BuildContext context, GoRouterState state) => const StudentScreen(),
            routes: const <RouteBase>[
              // GoRoute(
              //     path: 'dayplan/:day',
              //     builder: (BuildContext context, GoRouterState state) {
              //
              //       final day = state.params['day'];
              //       return DayPlan(day);
              //     },
              //     routes: <RouteBase>[]),
            ]),
      ],
    ),
  ],
);
