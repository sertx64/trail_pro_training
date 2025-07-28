import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/presentation/student/student_plan_screen.dart';
import 'package:trailpro_planning/presentation/student/student_groups_screen.dart';
import 'package:trailpro_planning/presentation/student/student_profile_screen.dart';
import 'package:trailpro_planning/presentation/student/day_plan_student.dart';
import 'package:trailpro_planning/presentation/theme/app_colors.dart';
import 'package:trailpro_planning/domain/models/models.dart';

class StudentMainLayout extends StatefulWidget {
  final int initialIndex;
  
  const StudentMainLayout({super.key, this.initialIndex = 0});

  @override
  State<StudentMainLayout> createState() => _StudentMainLayoutState();
}

class _StudentMainLayoutState extends State<StudentMainLayout> {
  late int _currentIndex;
  
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pages = [
      const StudentPlanScreen(),
      StudentGroupsScreen(onGroupSelected: _onGroupSelected),
      const StudentProfileScreen(),
    ];
  }

  void _onGroupSelected() {
    setState(() {
      _currentIndex = 0; // Переключаемся на план
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String _getAppBarTitle(PlanDataModel state) {
    switch (_currentIndex) {
      case 0:
        if (state.planType == 'personal') {
          return 'Персонально: ${Management.user.name}';
        } else {
          return 'Группа: ${state.planType}';
        }
      case 1:
        return 'Мои группы';
      case 2:
        return 'Профиль';
      default:
        return 'TrailPro';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, PlanDataModel>(
      builder: (context, state) {
        // If day view is open, show DayPlanStudent
        if (state.isDay) {
          return DayPlan();
        }
        
        // Otherwise show main layout with tabs
        return Scaffold(
          appBar: AppBar(
            title: Text(_getAppBarTitle(state)),
          ),
          body: _pages[_currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _onTabTapped,
            backgroundColor: AppColors.background,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.calendar_today),
                label: 'План',
              ),
              NavigationDestination(
                icon: Icon(Icons.groups),
                label: 'Группы',
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Профиль',
              ),
            ],
          ),
        );
      },
    );
  }
} 