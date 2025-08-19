import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';

import 'package:trailpro_planning/presentation/reports/reports_widget.dart';

class DayPlanTrainer extends StatefulWidget {
  const DayPlanTrainer({super.key});

  @override
  State<DayPlanTrainer> createState() => _DayPlanTrainerState();
}

class _DayPlanTrainerState extends State<DayPlanTrainer>
    with TickerProviderStateMixin {
  final TextEditingController _controllerLabelTraining = TextEditingController();
  final TextEditingController _controllerDescriptionTraining = TextEditingController();
  final TextEditingController _controllerTimeTraining = TextEditingController();
  final TextEditingController _controllerLocationTraining = TextEditingController();
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final List samples = Management.samplesSlitList;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _controllerLabelTraining.dispose();
    _controllerDescriptionTraining.dispose();
    _controllerTimeTraining.dispose();
    _controllerLocationTraining.dispose();
    super.dispose();
  }

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
            
        return '$day $monthName $year';
      }
    } catch (e) {
      return date;
    }
    return date;
  }

  Color _getStatusColor(String date) {
    if (date == DatePasing().dateNow()) {
      return Theme.of(context).colorScheme.primary;
    } else if (DatePasing().isAfterDay(date)) {
      return Theme.of(context).colorScheme.tertiary;
    } else {
      return Theme.of(context).colorScheme.outline;
    }
  }

  IconData _getStatusIcon(String date) {
    if (date == DatePasing().dateNow()) {
      return Icons.today_rounded;
    } else if (DatePasing().isAfterDay(date)) {
      return Icons.check_circle_rounded;
    } else {
      return Icons.schedule_rounded;
    }
  }

  String _getStatusText(String date) {
    if (date == DatePasing().dateNow()) {
      return 'Сегодня';
    } else if (DatePasing().isAfterDay(date)) {
      return 'Завершено';
    } else {
      return 'Запланировано';
    }
  }

  @override
  Widget build(BuildContext context) {
    final DayPlanModel dayPlan = context.read<HomeScreenCubit>().selectDayGroup;
    _controllerLabelTraining.text = dayPlan.label;
    _controllerDescriptionTraining.text = dayPlan.description;
    _controllerTimeTraining.text = dayPlan.time;
    _controllerLocationTraining.text = dayPlan.location;
    
    // Определяем, является ли день прошедшим или текущим (используется в _buildMainContent)
    // bool isPast = DatePasing().isAfterDay(dayPlan.date);
    // bool isToday = dayPlan.date == DatePasing().dateNow();
    
    return WillPopScope(
      onWillPop: () async {
        context.read<HomeScreenCubit>().backToWeek();
        return false; // Предотвращаем стандартное поведение
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: context.read<HomeScreenCubit>().backToWeek,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getFullDayName(dayPlan.day),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              _formatDate(dayPlan.date),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(dayPlan.date).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getStatusColor(dayPlan.date).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(dayPlan.date),
                  size: 16,
                  color: _getStatusColor(dayPlan.date),
                ),
                const SizedBox(width: 6),
                Text(
                  _getStatusText(dayPlan.date),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: _getStatusColor(dayPlan.date),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: context.read<HomeScreenCubit>().state.isViewMode 
                ? _buildViewMode(context, dayPlan)
                : _buildMainContent(context, dayPlan),
          ),
        ),
      ),
      ),
    );
  }



  Widget _buildViewMode(BuildContext context, DayPlanModel dayPlan) {
    return Column(
      children: [
        // Карточка тренировки для просмотра
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      dayPlan.label.isEmpty 
                          ? Icons.spa_rounded
                          : Icons.fitness_center_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayPlan.label.isEmpty ? 'День отдыха' : dayPlan.label,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        // Отображаем время и место, если они есть
                        if (dayPlan.label.isNotEmpty && (dayPlan.time.isNotEmpty || dayPlan.location.isNotEmpty)) ...[
                          const SizedBox(height: 8),
                          if (dayPlan.time.isNotEmpty)
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  dayPlan.time,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          if (dayPlan.location.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  dayPlan.location,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ],
                        if (dayPlan.label.isNotEmpty)
                          Text(
                            'Тренировка завершена',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              
              if (dayPlan.description.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
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
                            Icons.description_rounded,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Описание',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        dayPlan.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Виджет отчётов
        ReportsWidget(context.read<HomeScreenCubit>().planType, dayPlan.date),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context, DayPlanModel dayPlan) {
    bool isPast = DatePasing().isAfterDay(dayPlan.date);
    bool isToday = dayPlan.date == DatePasing().dateNow();
    
    return Column(
      children: [
        // Показываем режим редактирования для всех дней
        _buildEditingView(context, dayPlan),
        
        // Если день прошедший или текущий, показываем предупреждение
        if (isPast || isToday) ...[
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.error.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPast ? 'Прошедший день' : 'Текущий день',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isPast 
                            ? 'Этот день уже прошёл. Изменения могут повлиять на существующие отчёты.'
                            : 'Этот день уже наступил. Изменения могут повлиять на текущие тренировки.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        
        const SizedBox(height: 24),
        
        // Показываем отчёты для прошедших дней
        if (isPast) ...[
          ReportsWidget(context.read<HomeScreenCubit>().planType, dayPlan.date),
        ],
      ],
    );
  }

  Widget _buildEditingView(BuildContext context, DayPlanModel dayPlan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок редактирования
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Редактирование тренировки',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    Text(
                      DatePasing().isAfterDay(dayPlan.date) || dayPlan.date == DatePasing().dateNow()
                          ? 'Редактирование тренировки (день уже наступил)'
                          : 'Создайте план тренировки для этого дня',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Форма редактирования
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Поле названия
              _buildInputSection(
                context,
                'Название',
                'Введите название тренировки',
                Icons.fitness_center_rounded,
                _controllerLabelTraining,
                maxLength: 27,
              ),
              
              const SizedBox(height: 24),
              
              // Поле времени
              _buildInputSection(
                context,
                'Время',
                'Например: 19:00',
                Icons.access_time,
                _controllerTimeTraining,
                maxLength: 10,
              ),
              
              const SizedBox(height: 24),
              
              // Поле места
              _buildInputSection(
                context,
                'Место',
                'Например: Спортивная площадка',
                Icons.location_on,
                _controllerLocationTraining,
                maxLength: 50,
              ),
              
              const SizedBox(height: 24),
              
              // Поле описания
              _buildInputSection(
                context,
                'Описание',
                'Опишите упражнения, подходы, время...',
                Icons.description_rounded,
                _controllerDescriptionTraining,
                maxLines: 5,
              ),
              
              const SizedBox(height: 32),
              
              // Кнопки действий
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () async {
                        context.read<HomeScreenCubit>().applyAndBackToWeek(
                              _controllerLabelTraining.text,
                              _controllerDescriptionTraining.text,
                              time: _controllerTimeTraining.text,
                              location: _controllerLocationTraining.text,
                            );
                      },
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Сохранить'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showTemplatesBottomSheet(context),
                      icon: const Icon(Icons.library_books_rounded),
                      label: const Text('Шаблоны'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection(
    BuildContext context,
    String label,
    String hint,
    IconData icon,
    TextEditingController controller, {
    int? maxLength,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => controller.clear(),
              icon: const Icon(Icons.clear_rounded, size: 16),
              label: const Text('Очистить'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).colorScheme.outline,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  void _showTemplatesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Заголовок
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.library_books_rounded,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Шаблоны тренировок',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            'Выберите готовый шаблон',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // Список шаблонов
              Expanded(
                child: samples.isEmpty
                    ? _buildEmptyTemplatesState(context)
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _buildTemplateCard(context, index),
                        itemCount: samples.length,
                      ),
              ),
              
              // Кнопка закрытия
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Закрыть'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyTemplatesState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'Нет доступных шаблонов',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Шаблоны тренировок пока не добавлены',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          _controllerLabelTraining.text = samples[index][0];
          _controllerDescriptionTraining.text = samples[index][1];
          // Очищаем поля времени и места при применении шаблона
          _controllerTimeTraining.text = '';
          _controllerLocationTraining.text = '';
          Navigator.pop(context);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Шаблон "${samples[index][0]}" применен'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      samples[index][0],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      samples[index][1].length > 120 
                          ? '${samples[index][1].substring(0, 120)}...' 
                          : samples[index][1],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
