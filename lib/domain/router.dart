import 'package:flutter/material.dart';
import 'package:trailpro_planning/presentation/trainer/add_group_screen.dart';
import 'package:trailpro_planning/presentation/trainer/add_samples_screen.dart';
import 'package:trailpro_planning/presentation/trainer/add_user_screen.dart';
import 'package:trailpro_planning/presentation/trainer/user_profile_screen.dart';
import 'package:trailpro_planning/presentation/trainer/trainer_wrapper.dart';
import 'package:trailpro_planning/presentation/trainer/trainer_main_layout.dart';
import 'package:trailpro_planning/presentation/authorization_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:trailpro_planning/presentation/info_screen.dart';
import 'package:trailpro_planning/presentation/site_trailpro.dart';
import 'package:trailpro_planning/presentation/splash_screen.dart';

import 'package:trailpro_planning/presentation/student/student_wrapper.dart';
import 'package:trailpro_planning/presentation/student/student_main_layout.dart';
import 'package:trailpro_planning/domain/models/models.dart';

final GoRouter router =
    GoRouter(initialLocation: '/splashscreen', routes: <RouteBase>[
  GoRoute(
      path: '/authorization',
      builder: (BuildContext context, GoRouterState state) =>
          const Authorization()),
  GoRoute(
      path: '/splashscreen',
      builder: (BuildContext context, GoRouterState state) => const SplashScreen()),
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
      builder: (BuildContext context, GoRouterState state) =>
          const TrainerWrapper(child: TrainerMainLayout())),
  GoRoute(
      path: '/groupmanagement',
      builder: (BuildContext context, GoRouterState state) =>
          const TrainerWrapper(child: TrainerMainLayout(initialIndex: 1))),
  GoRoute(
      path: '/usermanagement',
      builder: (BuildContext context, GoRouterState state) =>
          const TrainerWrapper(child: TrainerMainLayout(initialIndex: 2))),
  GoRoute(
      path: '/adduserscreen',
      builder: (BuildContext context, GoRouterState state) =>
          const TrainerWrapper(child: AddUserScreen())),
  GoRoute(
      path: '/addgroupscreen',
      builder: (BuildContext context, GoRouterState state) =>
          const TrainerWrapper(child: AddGroupScreen())),
  GoRoute(
      path: '/creatsamlescreen',
      builder: (BuildContext context, GoRouterState state) =>
          const TrainerWrapper(child: AddSamplesScreen())),
  GoRoute(
      path: '/studentscreen',
      builder: (BuildContext context, GoRouterState state) =>
          const StudentWrapper(child: StudentMainLayout())),
  GoRoute(
      path: '/studentplan',
      builder: (BuildContext context, GoRouterState state) =>
          const StudentWrapper(child: StudentMainLayout(initialIndex: 0))),
  GoRoute(
      path: '/studentgroups',
      builder: (BuildContext context, GoRouterState state) =>
          const StudentWrapper(child: StudentMainLayout(initialIndex: 1))),
  GoRoute(
      path: '/studentprofile',
      builder: (BuildContext context, GoRouterState state) =>
          const StudentWrapper(child: StudentMainLayout(initialIndex: 2))),
  GoRoute(
      path: '/userprofile',
      builder: (BuildContext context, GoRouterState state) {
        final user = state.extra as User;
        return TrainerWrapper(child: UserProfileScreen(user: user));
      }),
]);
