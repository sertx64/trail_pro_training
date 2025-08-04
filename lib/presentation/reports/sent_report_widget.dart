import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/report_cubit.dart';

class SentReportWidget extends StatefulWidget {
  const SentReportWidget(this.groupName, this.date, {super.key});
  final String date;
  final String groupName;

  @override
  State<SentReportWidget> createState() => _SentReportWidgetState();
}

class _SentReportWidgetState extends State<SentReportWidget>
    with TickerProviderStateMixin {
  List<String>? reports;
  String textFeedback = '';
  double _load = 3.0;
  double _feeling = 3.0;
  final TextEditingController controllerFeedback = TextEditingController();
  
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    controllerFeedback.text = textFeedback;
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    controllerFeedback.dispose();
    print('DISPOSE REPORT WIDGET!');
    super.dispose();
  }

  void _sentReport() {
    if (controllerFeedback.text == '') {
      controllerFeedback.text = 'нет комментария';
    }
    context
        .read<ReportCubit>()
        .sentReport(widget.groupName, widget.date, _load.toStringAsFixed(0),
            _feeling.toStringAsFixed(0), controllerFeedback.text);
    context.read<ReportCubit>().renewReportsOnWidget(
        _load.toStringAsFixed(0),
        _feeling.toStringAsFixed(0),
        controllerFeedback.text);
  }

  void sentReportSkip() {
    context.read<ReportCubit>().sentReport(widget.groupName, widget.date, '0',
        '0', 'Пропустил тренировку. День отдыха');
    context
        .read<ReportCubit>()
        .renewReportsOnWidget('0', '0', 'Пропустил тренировку. День отдыха');
  }

  Color _getLoadColor(double load) {
    switch (load.toInt()) {
      case 1:
        return Colors.blue.shade600;
      case 2:
        return Colors.green.shade600;
      case 3:
        return Colors.orange.shade600;
      case 4:
        return Colors.deepOrange.shade600;
      case 5:
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  String _getLoadText(double load) {
    switch (load.toInt()) {
      case 1:
        return 'Очень легко';
      case 2:
        return 'Легко';
      case 3:
        return 'Умеренно';
      case 4:
        return 'Трудно';
      case 5:
        return 'Очень тяжело';
      default:
        return '';
    }
  }

  String _getFeelingEmoji(double feeling) {
    switch (feeling.toInt()) {
      case 1:
        return '😞';
      case 2:
        return '☹️';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  String _getFeelingText(double feeling) {
    switch (feeling.toInt()) {
      case 1:
        return 'Очень слабым';
      case 2:
        return 'Слабым';
      case 3:
        return 'Нормально';
      case 4:
        return 'Сильным';
      case 5:
        return 'Очень сильным';
      default:
        return 'Нормально';
    }
  }

  void _showInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.help_outline_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Справка',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildInfoSection(
                  context,
                  'Нагрузка',
                  'Воспринимаемые усилия позволяют измерить по шкале от 1 до 5 объем усилий, которые, по вашему мнению, вы приложили к занятию.',
                  Icons.fitness_center_rounded,
                  Colors.red.shade600,
                  [
                    ('1', 'Очень легко', Colors.blue.shade600),
                    ('2', 'Легко', Colors.green.shade600),
                    ('3', 'Умеренно', Colors.orange.shade600),
                    ('4', 'Трудно', Colors.deepOrange.shade600),
                    ('5', 'Очень тяжело', Colors.red.shade600),
                  ],
                ),
                const SizedBox(height: 24),
                _buildInfoSection(
                  context,
                  'Самочувствие',
                  'Бывают хорошие и плохие дни, нужно быть готовым к тому, что вы не будете чувствовать себя отлично во время каждого занятия.',
                  Icons.mood_rounded,
                  Colors.blue.shade600,
                  [
                    ('😞', 'Очень слабым', Colors.red.shade300),
                    ('☹️', 'Слабым', Colors.orange.shade300),
                    ('😐', 'Нормально', Colors.grey.shade600),
                    ('🙂', 'Сильным', Colors.green.shade600),
                    ('😄', 'Очень сильным', Colors.blue.shade600),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Понятно'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color iconColor,
    List<(String, String, Color)> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    alignment: Alignment.center,
                    child: Text(
                      item.$1,
                      style: TextStyle(
                        fontSize: 16,
                        color: item.$3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.$2,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: item.$3,
                        ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  void _showSentReportModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.send_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Отправить отчёт?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryRow(
                        context,
                        Icons.fitness_center_rounded,
                        'Нагрузка',
                        '${_load.toStringAsFixed(0)}: ${_getLoadText(_load)}',
                        _getLoadColor(_load),
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        context,
                        Icons.mood_rounded,
                        'Самочувствие',
                        _getFeelingText(_feeling),
                        Theme.of(context).colorScheme.primary,
                      ),
                      if (controllerFeedback.text.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildSummaryRow(
                          context,
                          Icons.comment_rounded,
                          'Комментарий',
                          controllerFeedback.text,
                          Theme.of(context).colorScheme.outline,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Отменить'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          _sentReport();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Отправить'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSkipModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: Colors.orange.shade600,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Пропустили тренировку?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Будет отправлен отчёт о том, что у вас был день отдыха.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Нет'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () {
                          sentReportSkip();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Пропустил'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.orange.shade100,
                          foregroundColor: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок с иконкой справки
                Row(
                  children: [
                    Icon(
                      Icons.rate_review_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Обратная связь',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.help_outline_rounded),
                      onPressed: () => _showInfoModal(context),
                      tooltip: 'Справка по оценкам',
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Text(
                'Пожалуйста, оставьте отзыв о тренировке',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
                             const SizedBox(height: 20),

               // Секция нагрузки
              _buildSliderSection(
                context,
                'Нагрузка',
                Icons.fitness_center_rounded,
                _getLoadColor(_load),
                _load,
                _getLoadText(_load),
                (value) => setState(() => _load = value),
              ),
                             const SizedBox(height: 24),

               // Секция самочувствия
              _buildSliderSection(
                context,
                'Самочувствие',
                Icons.mood_rounded,
                Theme.of(context).colorScheme.primary,
                _feeling,
                '${_getFeelingEmoji(_feeling)} ${_getFeelingText(_feeling)}',
                (value) => setState(() => _feeling = value),
              ),
                             const SizedBox(height: 24),

               // Поле для комментариев
              Text(
                'Впечатления',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Необязательно',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controllerFeedback,
                maxLength: 200,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Поделитесь своими впечатлениями...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  prefixIcon: Icon(
                    Icons.comment_rounded,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
                             const SizedBox(height: 24),

               // Кнопки действий
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () => _showSentReportModal(context),
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Отправить отчёт'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showSkipModal(context),
                      icon: const Icon(Icons.schedule_rounded),
                      label: const Text('Пропустил'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.orange.shade700,
                        side: BorderSide(color: Colors.orange.shade300),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),);
  }

  Widget _buildSliderSection(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    double value,
    String valueText,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                valueText,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12,
                    elevation: 2,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 20,
                  ),
                  activeTrackColor: iconColor,
                  inactiveTrackColor: Theme.of(context)
                      .colorScheme
                      .outline
                      .withOpacity(0.3),
                  thumbColor: iconColor,
                  overlayColor: iconColor.withOpacity(0.2),
                  valueIndicatorColor: iconColor,
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Slider(
                  value: value,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: onChanged,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  5,
                  (index) => Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: (index + 1) == value.toInt()
                              ? iconColor
                              : Theme.of(context).colorScheme.outline,
                          fontWeight: (index + 1) == value.toInt()
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
