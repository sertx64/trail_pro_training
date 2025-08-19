import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/presentation/climbing_animation.dart';
import 'package:trailpro_planning/presentation/theme/app_colors.dart';
import 'package:trailpro_planning/presentation/theme/app_theme.dart';

class StudentPlanScreen extends StatelessWidget {
  const StudentPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, PlanDataModel>(
      builder: (context, state) {
        return Scaffold(
          body: (!state.planLoaded)
              ? const Center(child: LottieAnimationLoadBar())
              : _buildWeekPlanList(state, context),
        );
      },
    );
  }

  Widget _buildWeekPlanList(PlanDataModel state, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 7,
      itemBuilder: (context, index) {
              DayPlanModel dayPlanGroup = state.weekPlanGroup[index];
              DayPlanModel dayPlanPersonal = state.weekPlanPersonal[index];
              
              bool isToday = dayPlanGroup.date == DatePasing().dateNow();
              bool isPast = DatePasing().isAfterDay(dayPlanGroup.date);
              bool hasTraining = dayPlanGroup.label.isNotEmpty || dayPlanPersonal.label.isNotEmpty;
              
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                elevation: 2,
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
      List<Widget> groupInfo = [];
      
      // Добавляем время и место, если они есть
      if (dayPlanGroup.time.isNotEmpty || dayPlanGroup.location.isNotEmpty) {
        if (dayPlanGroup.time.isNotEmpty) {
          groupInfo.add(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time, size: 12, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  dayPlanGroup.time,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        
        if (dayPlanGroup.location.isNotEmpty) {
          groupInfo.add(
            Row(
              children: [
                const Icon(Icons.location_on, size: 12, color: AppColors.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    dayPlanGroup.location,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }
        
        if (groupInfo.isNotEmpty) {
          subtitleWidgets.add(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: groupInfo,
              ),
            ),
          );
        }
      }
      
      // Добавляем название тренировки
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
      List<Widget> personalInfo = [];
      
      // Добавляем время и место для персонального плана, если они есть
      if (dayPlanPersonal.time.isNotEmpty || dayPlanPersonal.location.isNotEmpty) {
        if (dayPlanPersonal.time.isNotEmpty) {
          personalInfo.add(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time, size: 12, color: AppColors.success),
                const SizedBox(width: 4),
                Text(
                  dayPlanPersonal.time,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        
        if (dayPlanPersonal.location.isNotEmpty) {
          personalInfo.add(
            Row(
              children: [
                const Icon(Icons.location_on, size: 12, color: AppColors.success),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    dayPlanPersonal.location,
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }
        
        if (personalInfo.isNotEmpty) {
          subtitleWidgets.add(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: personalInfo,
              ),
            ),
          );
        }
      }
      
      // Добавляем название персональной тренировки
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


} 