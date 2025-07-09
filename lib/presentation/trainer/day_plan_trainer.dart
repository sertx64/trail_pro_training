import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/date_format.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/domain/url_utils.dart';
import 'package:trailpro_planning/presentation/reports/reports_widget.dart';
import 'package:trailpro_planning/presentation/theme/app_colors.dart';

class DayPlanTrainer extends StatelessWidget {
  DayPlanTrainer({super.key});

  final TextEditingController _controllerLabelTraining =
      TextEditingController();
  final TextEditingController _controllerDescriptionTraining =
      TextEditingController();

  final List samples = Management.samplesSlitList;

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

  @override
  Widget build(BuildContext context) {
    DayPlanModel dayPlan = context.read<HomeScreenCubit>().selectDayGroup;
    _controllerLabelTraining.text = dayPlan.label;
    _controllerDescriptionTraining.text = dayPlan.description;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${getFullDayName(dayPlan.day)}, ${dayPlan.date}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: (DatePasing().isAfterDay(dayPlan.date))
            ? Column(
                children: [
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: (dayPlan.date == DatePasing().dateNow())
                            ? AppColors.completedGreen
                            : AppColors.pastGrey,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.fitness_center,
                                color: AppColors.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  dayPlan.label.isEmpty ? 'День отдыха' : dayPlan.label,
                                  style: const TextStyle(
                                    color: AppColors.text,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (dayPlan.description.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Описание:',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: UrlUtils.buildTextWithClickableLinks(dayPlan.description),
                                style: const TextStyle(
                                  color: AppColors.text,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  ReportsWidget(context.read<HomeScreenCubit>().planType, dayPlan.date),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: AppColors.primary,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Редактирование тренировки',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Поле названия
                          Row(
                            children: [
                              const Text(
                                'Название тренировки',
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  _controllerLabelTraining.text = '';
                                },
                                child: const Text(
                                  'Очистить',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            maxLength: 27,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: const BorderSide(color: AppColors.primary),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                              ),
                              counterStyle: const TextStyle(color: AppColors.primary),
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                              fontSize: 16,
                            ),
                            controller: _controllerLabelTraining,
                          ),
                          const SizedBox(height: 16),
                          
                          // Поле описания
                          Row(
                            children: [
                              const Text(
                                'Описание тренировки',
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  _controllerDescriptionTraining.text = '';
                                },
                                child: const Text(
                                  'Очистить',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            maxLines: null,
                            minLines: 3,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: const BorderSide(color: AppColors.primary),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                              ),
                              hintText: 'Введите описание тренировки...',
                              hintStyle: TextStyle(color: AppColors.text.withOpacity(0.6)),
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                              fontSize: 16,
                            ),
                            controller: _controllerDescriptionTraining,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Кнопки
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () async {
                            context
                                .read<HomeScreenCubit>()
                                .applyAndBackToWeek(
                                    _controllerLabelTraining.text,
                                    _controllerDescriptionTraining.text);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Сохранить',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            _showTemplatesBottomSheet(context);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.library_books, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Шаблоны',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40.0),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          onPressed: context.read<HomeScreenCubit>().backToWeek,
          icon: const Icon(Icons.arrow_back_rounded),
          label: const Text(
            'К неделе',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  void _showTemplatesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.text.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Заголовок
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: const Row(
                  children: [
                    Icon(
                      Icons.library_books,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Шаблоны тренировок',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // Список шаблонов
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          _controllerLabelTraining.text = samples[index][0];
                          _controllerDescriptionTraining.text = samples[index][1];
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 4,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
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
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.text,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      samples[index][1].length > 80 
                                          ? '${samples[index][1].substring(0, 80)}...' 
                                          : samples[index][1],
                                      style: TextStyle(
                                        color: AppColors.text.withOpacity(0.7),
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.accent,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: samples.length,
                ),
              ),
              
              // Кнопка закрытия
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Закрыть',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
}
