import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/domain/management.dart';

class TrainerWrapper extends StatelessWidget {
  final Widget child;

  const TrainerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenCubit()..choosingPlanType(Management.user.groups[0]),
      child: child,
    );
  }
} 