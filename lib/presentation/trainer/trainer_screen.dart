import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/presentation/climbing_animation.dart';
import 'package:trailpro_planning/presentation/trainer/day_plan_trainer.dart';
import 'package:trailpro_planning/presentation/theme/app_colors.dart';
import 'package:trailpro_planning/presentation/theme/app_theme.dart';

class TrainerScreen extends StatelessWidget {
  const TrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, PlanDataModel>(
        builder: (context, state) {
      return (state.isDay)
                          ? const DayPlanTrainer()
          : Scaffold(
              body: (!state.planLoaded)
                  ? const Center(child: LottieAnimationLoadBar())
                  : _buildWeekPlanList(state),
            );
    });
  }



  Widget _buildWeekPlanList(PlanDataModel state) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 7,
      itemBuilder: (context, index) {
        DayPlanModel dayPlan = state.weekPlanGroup[index];
        bool isToday = dayPlan.date == DatePasing().dateNow();
        bool isPast = DatePasing().isAfterDay(dayPlan.date);
        bool hasTraining = dayPlan.label.isNotEmpty;
        
        if (hasTraining) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            color: AppTheme.getDayStatusColor(dayPlan.date, isToday, isPast, hasTraining),
            child: ExpansionTile(
              leading: _buildDayIndicator(dayPlan.day, hasTraining),
              title: _buildDayTitle(dayPlan, isToday),
              subtitle: _buildDaySubtitle(dayPlan),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Описание тренировки:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                                                     color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                        ),
                        child: Text(
                          dayPlan.description.isEmpty ? 'Описание не добавлено' : dayPlan.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: dayPlan.description.isEmpty ? AppColors.grey : AppColors.text,
                            fontStyle: dayPlan.description.isEmpty ? FontStyle.italic : FontStyle.normal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => isPast 
                                  ? context.read<HomeScreenCubit>().openDayForView(index)
                                  : context.read<HomeScreenCubit>().openDayForEdit(index),
                              icon: isPast ? const Icon(Icons.visibility) : const Icon(Icons.edit),
                              label: Text(isPast ? 'Просмотр отчетов' : 'Редактировать'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isPast ? AppColors.primary : AppColors.accent,
                                foregroundColor: AppColors.textLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isPast || isToday) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showEditWarningDialog(context, index, dayPlan, isPast, isToday, context.read<HomeScreenCubit>()),
                                icon: const Icon(Icons.edit_note),
                                label: const Text('Редактировать тренировку'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(color: AppColors.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            color: AppTheme.getDayStatusColor(dayPlan.date, isToday, isPast, hasTraining),
            child: ListTile(
              leading: _buildDayIndicator(dayPlan.day, hasTraining),
              title: _buildDayTitle(dayPlan, isToday),
              subtitle: _buildDaySubtitle(dayPlan),
              onTap: (isPast && !hasTraining) ? null : () => context.read<HomeScreenCubit>().openDay(index),
              trailing: (isPast || isToday) ? IconButton(
                icon: const Icon(Icons.edit_note, color: AppColors.primary),
                onPressed: () => _showEditWarningDialog(context, index, dayPlan, isPast, isToday, context.read<HomeScreenCubit>()),
                tooltip: 'Редактировать тренировку',
              ) : null,
            ),
          );
        }
      },
    );
  }

  Widget _buildDayIndicator(String day, bool hasTraining) {
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

  Widget _buildDayTitle(DayPlanModel dayPlan, bool isToday) {
    return Row(
      children: [
        Text(
          dayPlan.date,
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

  Widget _buildDaySubtitle(DayPlanModel dayPlan) {
    if (dayPlan.label.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          dayPlan.label,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return Container(
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
      );
    }
  }





  void _showEditWarningDialog(BuildContext context, int index, DayPlanModel dayPlan, bool isPast, bool isToday, HomeScreenCubit homeCubit) {
    String warningMessage = '';
    String dayStatus = '';
    
    if (isPast) {
      warningMessage = 'Этот день уже прошёл. Изменения могут повлиять на уже существующие отчёты студентов.';
      dayStatus = 'Прошедший день';
    } else if (isToday) {
      warningMessage = 'Этот день уже наступил. Изменения могут повлиять на текущие тренировки.';
      dayStatus = 'Текущий день';
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Внимание!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dayStatus,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                warningMessage,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.text,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Вы уверены, что хотите продолжить редактирование?',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Отмена',
                style: TextStyle(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                homeCubit.openDay(index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
              ),
              child: const Text(
                'Продолжить',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
