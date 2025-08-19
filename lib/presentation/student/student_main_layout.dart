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
    return BlocListener<HomeScreenCubit, PlanDataModel>(
      listener: (context, state) {
        // Если план загружен и мы находимся на вкладке групп, переключаемся на план
        if (state.planLoaded &&
            _currentIndex == 1 &&
            state.planType != 'personal') {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: BlocBuilder<HomeScreenCubit, PlanDataModel>(
        builder: (context, state) {
          // If day view is open, show DayPlanStudent
          if (state.isDay) {
            return const DayPlan();
          }

          // Otherwise show main layout with tabs
          return Scaffold(
            appBar: AppBar(
              title: Text(_getAppBarTitle(state)),
              backgroundColor: Colors.white,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                side: BorderSide(
                  color: Colors.black,
                  width: 0.6,
                ),
              ),
            ),
            body: _pages[_currentIndex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border.all(
                  color: Colors.black,
                  width: 0.6,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Кнопки переключения недель (только для экрана плана и не в режиме дня)
                      if (_currentIndex == 0) ...[
                        BlocBuilder<HomeScreenCubit, PlanDataModel>(
                          builder: (context, state) {
                            // Скрываем кнопки если открыт экран дня
                            if (state.isDay) {
                              return const SizedBox();
                            }

                            return Row(
                              children: [
                                _buildWeekNavItem(
                                  onPressed: () => context
                                      .read<HomeScreenCubit>()
                                      .previousWeek(),
                                  icon: Icons.chevron_left,
                                  tooltip: 'Предыдущая неделя',
                                ),
                                const SizedBox(width: 16),
                                _buildWeekNavItem(
                                  onPressed: () => context
                                      .read<HomeScreenCubit>()
                                      .nextWeek(),
                                  icon: Icons.chevron_right,
                                  tooltip: 'Следующая неделя',
                                ),
                              ],
                            );
                          },
                        ),
                      ] else ...[
                        // Заглушка для других экранов
                        const SizedBox(),
                      ],

                      const Spacer(),

                      // Основная навигация
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildNavItem(0, Icons.calendar_today, 'План'),
                          const SizedBox(width: 16),
                          _buildNavItem(1, Icons.groups, 'Группы'),
                          const SizedBox(width: 16),
                          _buildNavItem(2, Icons.person, 'Профиль'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeekNavItem({
    required VoidCallback onPressed,
    required IconData icon,
    required String tooltip,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
