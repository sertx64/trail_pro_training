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
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.calendar_month),
          label: 'План',
        ),
        NavigationDestination(
          icon: Icon(Icons.group),
          label: 'Группы',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_search),
          label: 'Ученики',
        ),
      ],
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