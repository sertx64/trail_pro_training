import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/users.dart';
import 'package:trailpro_planning/presentation/climbing_animation.dart';
import 'package:trailpro_planning/presentation/student/day_plan_student.dart';
import 'package:trailpro_planning/presentation/theme/app_colors.dart';
import 'package:trailpro_planning/presentation/theme/app_theme.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeScreenCubit()..choosingPlanType(Management.user.groups[0]),
      child: BlocBuilder<HomeScreenCubit, PlanDataModel>(
          builder: (context, state) {
        return (state.isDay)
            ? DayPlan()
            : Scaffold(
                appBar: _buildAppBar(context),
                body: (!state.planLoaded)
                    ? const Center(child: LottieAnimationLoadBar())
                    : _buildWeekPlanList(state),
                floatingActionButton: _buildFloatingActionButtons(context),
              );
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('План тренировок'),
      actions: [
        // Профиль пользователя
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                _showProfileModal(context);
              } else if (value == 'logout') {
                context.go('/authorization');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person_outline),
                    const SizedBox(width: 8),
                    Text('Профиль (${Management.user.login})'),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 16,
                    child: Text(
                      Management.user.name.isNotEmpty
                          ? Management.user.name[0].toUpperCase()
                          : Management.user.login[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekPlanList(PlanDataModel state) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 7,
      itemBuilder: (context, index) {
        DayPlanModel dayPlanGroup = state.weekPlanGroup[index];
        DayPlanModel dayPlanPersonal = state.weekPlanPersonal[index];
        
        bool isToday = dayPlanGroup.date == DatePasing().dateNow();
        bool isPast = DatePasing().isAfterDay(dayPlanGroup.date);
        bool hasTraining = dayPlanGroup.label.isNotEmpty || dayPlanPersonal.label.isNotEmpty;
        
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          color: AppTheme.getDayStatusColor(dayPlanGroup.date, isToday, isPast, hasTraining),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: _buildDayIndicator(dayPlanGroup.day, hasTraining, dayPlanPersonal.label.isNotEmpty),
            title: _buildDayTitle(dayPlanGroup, dayPlanPersonal, isToday),
            subtitle: _buildDaySubtitle(dayPlanGroup, dayPlanPersonal),
            trailing: hasTraining
                ? const Icon(Icons.chevron_right, color: AppColors.primary)
                : null,
            onTap: hasTraining
                ? () => context.read<HomeScreenCubit>().openDay(index)
                : null,
          ),
        );
      },
    );
  }

  Widget _buildDayIndicator(String day, bool hasTraining, bool hasPersonal) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasTraining ? AppColors.accent : AppColors.grey,
        border: Border.all(
          color: hasTraining ? AppColors.primary : AppColors.grey,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          day,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDayTitle(DayPlanModel dayPlanGroup, DayPlanModel dayPlanPersonal, bool isToday) {
    return Row(
      children: [
        Text(
          dayPlanGroup.date,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        if (isToday) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Сегодня',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDaySubtitle(DayPlanModel dayPlanGroup, DayPlanModel dayPlanPersonal) {
    List<Widget> subtitleWidgets = [];
    
    if (dayPlanGroup.label.isNotEmpty) {
      subtitleWidgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            dayPlanGroup.label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    
    if (dayPlanPersonal.label.isNotEmpty) {
      subtitleWidgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.person, size: 14, color: AppColors.success),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  dayPlanPersonal.label,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    if (subtitleWidgets.isEmpty) {
      subtitleWidgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: AppColors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.free_breakfast, size: 14, color: AppColors.grey),
              SizedBox(width: 4),
              Text(
                'День отдыха',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: subtitleWidgets,
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'prevWeek',
            onPressed: context.read<HomeScreenCubit>().previousWeek,
            child: const Icon(Icons.chevron_left),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'nextWeek',
            onPressed: context.read<HomeScreenCubit>().nextWeek,
            child: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  void _showProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Title
                  const Text(
                    'Профиль',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Profile info
                  _buildProfileInfo(),
                  const SizedBox(height: 24),
                  
                  // Groups section
                  const Text(
                    'Ваши группы:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Groups list
                  Expanded(
                    child: _buildGroupsList(sheetContext),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showChangeNameModal(context),
                          icon: const Icon(Icons.edit),
                          label: const Text('Изменить имя'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textLight,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showChangePinModal(context),
                          icon: const Icon(Icons.lock),
                          label: const Text('Изменить ПИН'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.textLight,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Close button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.grey),
                      ),
                      child: const Text('Закрыть'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfileInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 24,
                  child: Text(
                    Management.user.name.isNotEmpty
                        ? Management.user.name[0].toUpperCase()
                        : Management.user.login[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Management.user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Логин: ${Management.user.login}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.text.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsList(BuildContext sheetContext) {
    return ListView.builder(
      itemCount: Management.user.groups.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.group, color: AppColors.primary),
            ),
            title: Text(
              Management.user.groups[index],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
            onTap: () {
              Navigator.of(sheetContext).pop();
              context.read<HomeScreenCubit>()
                  .choosingPlanType(Management.user.groups[index]);
            },
          ),
        );
      },
    );
  }

  void _showChangePinModal(BuildContext context) {
    final TextEditingController oldPin = TextEditingController();
    final TextEditingController newPin = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Изменить ПИН-код'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: oldPin,
                  decoration: const InputDecoration(
                    labelText: 'Текущий ПИН-код',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите текущий ПИН-код';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newPin,
                  decoration: const InputDecoration(
                    labelText: 'Новый ПИН-код',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите новый ПИН-код';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (oldPin.text == Management.user.pin) {
                    Management.user.pin = newPin.text;
                    Users().changePersonalDataUser(
                      Management.user.login,
                      Management.user.name,
                      newPin.text,
                      Management.user.role,
                      Management.user.groups,
                    );
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ПИН-код успешно изменен')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Неверный текущий ПИН-код')),
                    );
                  }
                }
              },
              child: const Text('Изменить'),
            ),
          ],
        );
      },
    );
  }

  void _showChangeNameModal(BuildContext context) {
    final TextEditingController newName = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    newName.text = Management.user.name;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Изменить имя'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: newName,
              decoration: const InputDecoration(
                labelText: 'Новое имя',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите новое имя';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Management.user.name = newName.text.trim();
                  Users().changePersonalDataUser(
                    Management.user.login,
                    newName.text.trim(),
                    Management.user.pin,
                    Management.user.role,
                    Management.user.groups,
                  );
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Имя успешно изменено')),
                  );
                }
              },
              child: const Text('Изменить'),
            ),
          ],
        );
      },
    );
  }
}
