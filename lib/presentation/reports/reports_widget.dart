import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/report_cubit.dart';
import 'package:trailpro_planning/presentation/reports/sent_report_widget.dart';

class ReportsWidget extends StatelessWidget {
  const ReportsWidget(this.groupName, this.date, {super.key});
  final String groupName;
  final String date;
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportCubit(),
      child: _ReportsWidget(groupName, date),
    );
  }
}

class _ReportsWidget extends StatelessWidget {
  const _ReportsWidget(this.groupName, this.date, {super.key});
  final String groupName;
  final String date;

  Color _getLoadColor(String load) {
    switch (load) {
      case '1':
        return Colors.blue.shade600;
      case '2':
        return Colors.green.shade600;
      case '3':
        return Colors.orange.shade600;
      case '4':
        return Colors.deepOrange.shade600;
      case '5':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  String _getLoadText(String load) {
    switch (load) {
      case '1':
        return 'Очень легко';
      case '2':
        return 'Легко';
      case '3':
        return 'Умеренно';
      case '4':
        return 'Трудно';
      case '5':
        return 'Очень тяжело';
      default:
        return 'Не указано';
    }
  }

  String _getFeelingText(String feeling) {
    switch (feeling) {
      case '1':
        return '😞 Очень слабым';
      case '2':
        return '☹️ Слабым';
      case '3':
        return '😐 Нормально';
      case '4':
        return '🙂 Сильным';
      case '5':
        return '😄 Очень сильным';
      default:
        return '😐 Не указано';
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<ReportCubit>().loadReports(groupName, date);
    
    return BlocBuilder<ReportCubit, ReportsForView>(
      builder: (context, value) {
        return Container(
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
          child: !value.isLoading
              ? _buildLoadingState(context)
              : (!value.reports.any((report) => report.name == Management.user.login) &&
                      Management.user.role == 'student')
                  ? SentReportWidget(groupName, date)
                  : _buildReportsContent(context, value),
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.analytics_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Отчёты',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Center(
          child: Column(
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              Text(
                'Загружаем отчёты...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportsContent(BuildContext context, ReportsForView value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок секции
        Row(
          children: [
            Icon(
              Icons.analytics_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Отчёты',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            if (value.reports.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${value.reports.length}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value.reports.isEmpty 
              ? 'Пока нет отчётов за этот день'
              : 'Отчёты участников за ${_formatDate(date)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
                 const SizedBox(height: 20),

         // Список отчётов или пустое состояние
        if (value.reports.isEmpty)
          _buildEmptyState(context)
        else
          _buildReportsList(context, value.reports),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Отчётов пока нет',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Участники ещё не оставили свои отзывы',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList(BuildContext context, List<ReportModel> reports) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final report = reports[index];
        return _buildReportCard(context, report);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: reports.length,
    );
  }

  Widget _buildReportCard(BuildContext context, ReportModel report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок с именем участника
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  report.name.isNotEmpty ? report.name[0].toUpperCase() : '?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  report.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
                     const SizedBox(height: 6),

           // Оценки в виде красивых чипов (только если не пропустил тренировку)
          if (report.feedback.trim() != 'Пропустил тренировку. День отдыха') ...[
            Row(
              children: [
                _buildMetricChip(
                  context,
                  Icons.fitness_center_rounded,
                  'Нагрузка',
                  '${report.load}/5',
                  _getLoadText(report.load),
                  _getLoadColor(report.load),
                ),
                const SizedBox(width: 12),
                _buildMetricChip(
                  context,
                  Icons.mood_rounded,
                  'Самочувствие',
                  '${report.feeling}/5',
                  _getFeelingText(report.feeling),
                  Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ],

          // Комментарий, если есть
                     if (report.feedback.trim().isNotEmpty && 
               report.feedback.trim() != 'нет комментария' &&
               report.feedback.trim() != 'Пропустил тренировку. День отдыха') ...[
             const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.comment_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Комментарий',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    report.feedback.trim(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],

          // Специальная метка для пропуска тренировки
          if (report.feedback.trim() == 'Пропустил тренировку. День отдыха') ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.orange.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.spa_rounded,
                      size: 18,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'День отдыха',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricChip(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    String description,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: color,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: color.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
            
        return '$day $monthName $year';
      }
    } catch (e) {
      // Если не удалось разобрать дату, возвращаем исходную
    }
    return date;
  }
}
