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
          ? DayPlanTrainer()
          : Scaffold(
              body: (!state.planLoaded)
                  ? const Center(child: LottieAnimationLoadBar())
                  : _buildWeekPlanList(state),
              floatingActionButton: _buildFloatingActionButtons(context),
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
                              onPressed: () => context.read<HomeScreenCubit>().openDay(index),
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
}
