import 'package:flutter/material.dart';
import 'package:trailpro_planning/presentation/add_user_screen.dart';
import 'package:trailpro_planning/presentation/authorization_student_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/presentation/day_plan_student.dart';
import 'package:trailpro_planning/presentation/day_plan_trainer.dart';
import 'package:trailpro_planning/presentation/info_screen.dart';
import 'package:trailpro_planning/presentation/site_trailpro.dart';
import 'package:trailpro_planning/presentation/splash_screen.dart';
import 'package:trailpro_planning/presentation/student_screen.dart';
import 'package:trailpro_planning/presentation/trainer_auth_screen.dart';
import 'package:trailpro_planning/presentation/trainer_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splashscreen',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => Authorization(),
      routes: <RouteBase>[
        GoRoute(
          path: 'splashscreen',
          builder: (BuildContext context, GoRouterState state) =>
              const SplashScreen(),
        ),
        GoRoute(
            path: 'infoscreen',
            builder: (BuildContext context, GoRouterState state) =>
                const InfoScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: 'sitetrailpro',
                builder: (BuildContext context, GoRouterState state) =>
                    const SiteTrailpro(),
              ),
            ]),
        GoRoute(
            path: 'trainerauth',
            builder: (BuildContext context, GoRouterState state) =>
                TrainerAuth(),
            routes: <RouteBase>[
              GoRoute(
                  path: 'trainerscreen',
                  builder: (BuildContext context, GoRouterState state) =>
                      const TrainerScreen(),
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'adduserscreen',
                      builder: (BuildContext context, GoRouterState state) =>
                          AddUserScreen(),
                    ),
                    GoRoute(
                      path: 'dayplantrainer',
                      builder: (BuildContext context, GoRouterState state) =>
                          DayPlanTrainer(),
                    ),
                  ]),
            ]),
        GoRoute(
            path: 'studentscreen',
            builder: (BuildContext context, GoRouterState state) =>
                const StudentScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: 'dayplan',
                builder: (BuildContext context, GoRouterState state) {
                  return DayPlan();
                },
              ),
            ]),
      ],
    ),
  ],
);
