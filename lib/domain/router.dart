import 'package:flutter/material.dart';
import 'package:trailpro_planning/presentation/add_user_screen.dart';
import 'package:trailpro_planning/presentation/authorization_student_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/presentation/day_plan_student.dart';
import 'package:trailpro_planning/presentation/day_plan_trainer.dart';
import 'package:trailpro_planning/presentation/info_screen.dart';
import 'package:trailpro_planning/presentation/personal_day_plan_trainer.dart';
import 'package:trailpro_planning/presentation/personal_plan_trainer_screen.dart';
import 'package:trailpro_planning/presentation/site_trailpro.dart';
import 'package:trailpro_planning/presentation/splash_screen.dart';
import 'package:trailpro_planning/presentation/student_screen.dart';
import 'package:trailpro_planning/presentation/authorization_trainer_screen.dart';
import 'package:trailpro_planning/presentation/trainer_screen.dart';
import 'package:trailpro_planning/presentation/user_list_screen.dart';

final GoRouter router =
    GoRouter(initialLocation: '/splashscreen', routes: <RouteBase>[
  GoRoute(
    path: '/authorization',
    builder: (BuildContext context, GoRouterState state) =>
        const Authorization()),
  GoRoute(
    path: '/splashscreen',
    builder: (BuildContext context, GoRouterState state) =>
        const SplashScreen()),
  GoRoute(
    path: '/infoscreen',
    builder: (BuildContext context, GoRouterState state) => const InfoScreen()),
  GoRoute(
    path: '/sitetrailpro',
    builder: (BuildContext context, GoRouterState state) =>
        const SiteTrailpro()),
  GoRoute(
    path: '/trainerauth',
    builder: (BuildContext context, GoRouterState state) => TrainerAuth()),
  GoRoute(
    path: '/trainerscreen',
    builder: (BuildContext context, GoRouterState state) =>
        const TrainerScreen()),
  GoRoute(
    path: '/adduserscreen',
    builder: (BuildContext context, GoRouterState state) => AddUserScreen()),
  GoRoute(
    path: '/dayplantrainer',
    builder: (BuildContext context, GoRouterState state) => const DayPlanTrainer()),
  GoRoute(
    path: '/userlistscreen',
    builder: (BuildContext context, GoRouterState state) =>
        UserListScreen()),
  GoRoute(
    path: '/personalplan',
    builder: (BuildContext context, GoRouterState state) =>
        PersonalPlanTrainerScreen()),
  GoRoute(
    path: '/personaldayplantrainer',
    builder: (BuildContext context, GoRouterState state) =>
        const PersonalDayPlanTrainer()),
  GoRoute(
    path: '/studentscreen',
    builder: (BuildContext context, GoRouterState state) =>
        const StudentScreen()),
  GoRoute(
      path: '/dayplan',
      builder: (BuildContext context, GoRouterState state) => DayPlan()),
]);
