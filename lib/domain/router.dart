import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/samples_cubit.dart';
import 'package:trailpro_planning/domain/student_cubit.dart';
import 'package:trailpro_planning/presentation/trainer/add_samples_screen.dart';
import 'package:trailpro_planning/presentation/trainer/add_user_screen.dart';
import 'package:trailpro_planning/presentation/authorization_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/presentation/student/day_plan_student.dart';
import 'package:trailpro_planning/presentation/info_screen.dart';
import 'package:trailpro_planning/presentation/site_trailpro.dart';
import 'package:trailpro_planning/presentation/splash_screen.dart';
import 'package:trailpro_planning/presentation/student/student_screen.dart';
import 'package:trailpro_planning/presentation/trainer/trainer_screen.dart';

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
      path: '/trainerscreen',
      builder: (BuildContext context, GoRouterState state) => BlocProvider(
          create: (context) => StudentScreenCubit(),
          child: const TrainerScreen())),
  GoRoute(
      path: '/adduserscreen',
      builder: (BuildContext context, GoRouterState state) => AddUserScreen()),
  GoRoute(
      path: '/creatsamlescreen',
      builder: (BuildContext context, GoRouterState state) => BlocProvider(
          create: (context) => AddSamplesCubit(),
          child: const AddSamplesScreen())),
  GoRoute(
      path: '/studentscreen',
      builder: (BuildContext context, GoRouterState state) =>
          BlocProvider(
              create: (context) => StudentScreenCubit(),
              child: const StudentScreen())
  ),
  GoRoute(
      path: '/dayplan',
      builder: (BuildContext context, GoRouterState state) => const DayPlan()),
]);
