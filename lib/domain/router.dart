import 'package:flutter/material.dart';
import 'package:trailpro_planning/presentation/authorization.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/presentation/studentscreen.dart';
import 'package:trailpro_planning/presentation/trainerscreen.dart';

final GoRouter router = GoRouter(
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
            routes: <RouteBase>[

            ]),
        GoRoute(
            path: 'studentscreen',
            builder: (BuildContext context, GoRouterState state) {
              return const StudentScreen();
            },
            routes: <RouteBase>[

            ]),
      ],
    ),
  ],
);
