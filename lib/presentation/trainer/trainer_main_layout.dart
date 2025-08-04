import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/presentation/trainer/trainer_screen.dart';
import 'package:trailpro_planning/presentation/trainer/group_management_screen.dart';
import 'package:trailpro_planning/presentation/trainer/user_management_screen.dart';

class TrainerMainLayout extends StatefulWidget {
  final int initialIndex;
  
  const TrainerMainLayout({super.key, this.initialIndex = 0});

  @override
  State<TrainerMainLayout> createState() => _TrainerMainLayoutState();
}

class _TrainerMainLayoutState extends State<TrainerMainLayout> {
  late int _currentIndex;
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: _currentIndex == 0
          ? BlocBuilder<HomeScreenCubit, PlanDataModel>(
              builder: (context, state) {
                final cubit = context.read<HomeScreenCubit>();
                return Text(_getPlanTitle(cubit.planType));
              },
            )
          : Text(_getTitle()),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'templates':
                context.push('/creatsamlescreen');
                break;
              case 'logout':
                context.go('/authorization');
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'templates',
              child: Row(
                children: [
                  Icon(Icons.menu_book),
                  SizedBox(width: 8),
                  Text('Управление шаблонами'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Выйти'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const TrainerScreen();
      case 1:
        return GroupManagementScreen(
          onNavigateToHome: () => setState(() => _currentIndex = 0),
        );
      case 2:
        return UserManagementScreen(
          onNavigateToHome: () => setState(() => _currentIndex = 0),
        );
      default:
        return const TrainerScreen();
    }
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Кнопки переключения недель (только для экрана плана и не в режиме дня)
              if (_currentIndex == 0) ...[
                BlocBuilder<HomeScreenCubit, PlanDataModel>(
                  builder: (context, state) {
                    // Скрываем кнопки если открыт экран дня
                    if (state.isDay) {
                      return const Expanded(child: SizedBox());
                    }
                    
                    return Expanded(
                      child: Row(
                        children: [
                          _buildWeekNavItem(
                            onPressed: () => context.read<HomeScreenCubit>().previousWeek(),
                            icon: Icons.chevron_left,
                            tooltip: 'Предыдущая неделя',
                          ),
                          const SizedBox(width: 16),
                          _buildWeekNavItem(
                            onPressed: () => context.read<HomeScreenCubit>().nextWeek(),
                            icon: Icons.chevron_right,
                            tooltip: 'Следующая неделя',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ] else ...[
                // Заглушка для других экранов
                const Expanded(child: SizedBox()),
              ],
              
              // Основная навигация
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavItem(0, Icons.calendar_month, 'План'),
                  const SizedBox(width: 16),
                  _buildNavItem(1, Icons.group, 'Группы'),
                  const SizedBox(width: 16),
                  _buildNavItem(2, Icons.person_search, 'Ученики'),
                ],
              ),
            ],
          ),
        ),
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
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'План тренировок';
      case 1:
        return 'Управление группами';
      case 2:
        return 'Управление учениками';
      default:
        return 'План тренировок';
    }
  }

  String _getPlanTitle(String planType) {
    // Проверяем является ли planType группой
    if (Management.groupsList.contains(planType)) {
      return 'Группа: $planType';
    }
    // Проверяем является ли planType пользователем
    else if (Management.userList.contains(planType)) {
      return 'Персонально: $planType';
    }
    // Если не найдено, возвращаем дефолтное название
    else {
      return 'План тренировок';
    }
  }
} 