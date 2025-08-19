import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/url_utils.dart';
import 'package:trailpro_planning/presentation/reports/reports_widget.dart';

class DayPlan extends StatelessWidget {
  const DayPlan({super.key});

  String getFullDayName(String shortDay) {
    switch (shortDay) {
      case 'ПН':
        return 'Понедельник';
      case 'ВТ':
        return 'Вторник';
      case 'СР':
        return 'Среда';
      case 'ЧТ':
        return 'Четверг';
      case 'ПТ':
        return 'Пятница';
      case 'СБ':
        return 'Суббота';
      case 'ВС':
        return 'Воскресенье';
      default:
        return shortDay;
    }
  }

  String _formatDate(String date) {
    try {
      final parts = date.split('.');
      if (parts.length == 3) {
        final day = parts[0];
        final month = parts[1];
        final year = parts[2];
        
        final monthNames = [
          '', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
          'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
        ];
        
        final monthName = int.tryParse(month) != null && 
                         int.parse(month) > 0 && 
                         int.parse(month) <= 12
            ? monthNames[int.parse(month)]
            : month;
            
        return '$day $monthName $year г.';
      }
    } catch (e) {
      return date;
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    final DayPlanModel dayPlanGroup = context.read<HomeScreenCubit>().selectDayGroup;
    final DayPlanModel dayPlanPersonal = context.read<HomeScreenCubit>().selectDayPersonal;
    return WillPopScope(
      onWillPop: () async {
        context.read<HomeScreenCubit>().backToWeek();
        return false; // Предотвращаем стандартное поведение
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
          title: Column(
            children: [
              Text(
                getFullDayName(dayPlanGroup.day),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                _formatDate(dayPlanGroup.date),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<HomeScreenCubit>().backToWeek();
            },
          ),
        ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Visibility(
                  visible: (dayPlanGroup.label == '') ? false : true,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Заголовок блока
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 132, 26, 1).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.groups_rounded,
                                color: Color.fromRGBO(255, 132, 26, 1),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Групповая тренировка',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(255, 132, 26, 1),
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Время и место
                        if (dayPlanGroup.time.isNotEmpty || dayPlanGroup.location.isNotEmpty) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (dayPlanGroup.time.isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.access_time, size: 20, color: Colors.black),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          dayPlanGroup.time,
                                          style: const TextStyle(
                                            color: Color.fromRGBO(255, 132, 26, 1),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (dayPlanGroup.location.isNotEmpty) const SizedBox(height: 8),
                              ],
                              if (dayPlanGroup.location.isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 20, color: Colors.black),
                                      const SizedBox(width: 8),
                                                                              Expanded(
                                          child: Text(
                                            dayPlanGroup.location,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(255, 132, 26, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                        
                        // Название тренировки
                        Text(
                          dayPlanGroup.label,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: const Color.fromRGBO(255, 132, 26, 1),
                                fontWeight: FontWeight.w600,
                              ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        const SizedBox(height: 12),
                        
                        // Описание тренировки
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    height: 1.5,
                                  ),
                              children: UrlUtils.buildTextWithClickableLinks(dayPlanGroup.description),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (dayPlanPersonal.label == '') ? false : true,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Заголовок блока
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Персональная',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Время и место
                        if (dayPlanPersonal.time.isNotEmpty || dayPlanPersonal.location.isNotEmpty) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (dayPlanPersonal.time.isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.access_time, size: 16, color: Colors.green),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          dayPlanPersonal.time,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (dayPlanPersonal.location.isNotEmpty) const SizedBox(height: 8),
                              ],
                              if (dayPlanPersonal.location.isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 16, color: Colors.green),
                                      const SizedBox(width: 8),
                                                                              Expanded(
                                          child: Text(
                                            dayPlanPersonal.location,
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                        
                        // Название тренировки
                        Text(
                          dayPlanPersonal.label,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        const SizedBox(height: 12),
                        
                        // Описание тренировки
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    height: 1.5,
                                  ),
                              children: UrlUtils.buildTextWithClickableLinks(dayPlanPersonal.description),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (DatePasing().isAfterDay(dayPlanGroup.date) &&
                          dayPlanGroup.label != '')
                      ? true
                      : false,
                  child: ReportsWidget(context.read<HomeScreenCubit>().planType, dayPlanGroup.date),
                ),
                const SizedBox(height: 16)
              ],
            ),
          )),

      ),
    );
  }
}
