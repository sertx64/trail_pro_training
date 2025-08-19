import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/url_utils.dart';
import 'package:trailpro_planning/presentation/reports/reports_widget.dart';

class DayPlan extends StatelessWidget {
  const DayPlan({super.key});

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
          title: Text(dayPlanGroup.date),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<HomeScreenCubit>().backToWeek();
            },
          ),
        ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: (dayPlanGroup.label == '') ? false : true,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
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
                        const SizedBox(height: 16),
                        
                        // Время и место
                        if (dayPlanGroup.time.isNotEmpty || dayPlanGroup.location.isNotEmpty) ...[
                          Row(
                            children: [
                              if (dayPlanGroup.time.isNotEmpty) ...[
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.access_time, size: 16, color: Color.fromRGBO(255, 132, 26, 1)),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            dayPlanGroup.time,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(255, 132, 26, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (dayPlanGroup.location.isNotEmpty) const SizedBox(width: 8),
                              ],
                              if (dayPlanGroup.location.isNotEmpty)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 16, color: Color.fromRGBO(255, 132, 26, 1)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            dayPlanGroup.location,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(255, 132, 26, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
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
                          padding: const EdgeInsets.all(16),
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
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
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
                        const SizedBox(height: 16),
                        
                        // Время и место
                        if (dayPlanPersonal.time.isNotEmpty || dayPlanPersonal.location.isNotEmpty) ...[
                          Row(
                            children: [
                              if (dayPlanPersonal.time.isNotEmpty) ...[
                                Flexible(
                                  child: Container(
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
                                ),
                                if (dayPlanPersonal.location.isNotEmpty) const SizedBox(width: 8),
                              ],
                              if (dayPlanPersonal.location.isNotEmpty)
                                Expanded(
                                  child: Container(
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
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
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
                          padding: const EdgeInsets.all(16),
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
              ],
            ),
          )),

      ),
    );
  }
}
