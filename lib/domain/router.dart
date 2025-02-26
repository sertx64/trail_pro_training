import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/samples_cubit.dart';
import 'package:trailpro_planning/presentation/trainer/add_samples_screen.dart';
import 'package:trailpro_planning/presentation/trainer/add_user_screen.dart';
import 'package:trailpro_planning/presentation/student/authorization_student_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/presentation/student/day_plan_student.dart';
import 'package:trailpro_planning/presentation/trainer/day_plan_trainer.dart';
import 'package:trailpro_planning/presentation/info_screen.dart';
import 'package:trailpro_planning/presentation/trainer/personal_day_plan_trainer.dart';
import 'package:trailpro_planning/presentation/trainer/personal_plan_trainer_screen.dart';
import 'package:trailpro_planning/presentation/site_trailpro.dart';
import 'package:trailpro_planning/presentation/splash_screen.dart';
import 'package:trailpro_planning/presentation/student/student_screen.dart';
import 'package:trailpro_planning/presentation/trainer/authorization_trainer_screen.dart';
import 'package:trailpro_planning/presentation/trainer/trainer_screen.dart';
import 'package:trailpro_planning/presentation/trainer/user_list_screen.dart';

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
      builder: (BuildContext context, GoRouterState state) =>
          const InfoScreen()),
  GoRoute(
      path: '/sitetrailpro',
      builder: (BuildContext context, GoRouterState state) =>
          const SiteTrailpro()),
  GoRoute(
      path: '/trainerauth',
      builder: (BuildContext context, GoRouterState state) => TrainerAuth()),
  GoRoute(
      path: '/trainerscreen',
      builder: (BuildContext context, GoRouterState state) => TrainerScreen()),
  GoRoute(
      path: '/adduserscreen',
      builder: (BuildContext context, GoRouterState state) => AddUserScreen()),
  GoRoute(
      path: '/dayplantrainer',
      builder: (BuildContext context, GoRouterState state) =>
          const DayPlanTrainer()),
  GoRoute(
      path: '/userlistscreen',
      builder: (BuildContext context, GoRouterState state) => UserListScreen()),
  GoRoute(
      path: '/creatsamlescreen',
      builder: (BuildContext context, GoRouterState state) => BlocProvider(
          create: (context) => AddSamplesCubit(),
          child: AddSamplesScreen())),
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
