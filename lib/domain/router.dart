import 'package:trailpro_planning/presentation/authorization_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/presentation/day_plan_screen.dart';
import 'package:trailpro_planning/presentation/splash_screen.dart';
import 'package:trailpro_planning/presentation/student_screen.dart';
import 'package:trailpro_planning/presentation/trainer_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splashscreen',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (_, __) => const Authorization(),
      routes: <RouteBase>[
        GoRoute(
            path: 'splashscreen',
            builder: (_, __) => const SplashScreen(),
            ),
        GoRoute(
            path: 'trainerscreen',
            builder: (_, __) => const TrainerScreen(),
            routes: <RouteBase>[]),
        GoRoute(
            path: 'studentscreen',
            builder: (_, __) => const StudentScreen(),
            routes: <RouteBase>[
              // GoRoute(
              //     path: 'dayplan',
              //     builder: (_, __) => const DayPlan(),
              //     routes: <RouteBase>[]),
            ]),
      ],
    ),
  ],
);
