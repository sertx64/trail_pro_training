import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/report_cubit.dart';
import 'package:trailpro_planning/domain/sent_report.dart';

class SentReportWidget extends StatefulWidget {
  const SentReportWidget(this.date, {super.key});
  final String date;

  @override
  State<SentReportWidget> createState() => _SentReportWidgetState();
}

class _SentReportWidgetState extends State<SentReportWidget> {
  List<String>? reports;
  String textFeedback = '';
  double _load = 3.0;
  double _feeling = 3.0;
  final TextEditingController controllerFeedback = TextEditingController();

  void sentReport() {
    if (controllerFeedback.text == '') {
      controllerFeedback.text = 'нет комментария';
    }
    SentStudentReport().sentReport(widget.date, _load.toStringAsFixed(0),
        _feeling.toStringAsFixed(0), controllerFeedback.text);
    context.read<ReportCubit>().renewReportsOnWidget(_load.toStringAsFixed(0),
        _feeling.toStringAsFixed(0), controllerFeedback.text);
  }

  void sentReportSkip() {
    SentStudentReport()
        .sentReport(widget.date, '0', '0', 'Пропустил тренировку. День отдыха');
    context
        .read<ReportCubit>()
        .renewReportsOnWidget('0', '0', 'Пропустил тренировку. День отдыха');
  }

  void _showInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Справка'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    style: TextStyle(color: Colors.red, fontSize: 20),
                    'Нагрузка'),
                const Text(
                    'Воспринимаемые усилия позволяют измерить по шкале от 1 до 5 объем усилий, которые, по вашему мнению, вы приложили к занятию. Диапазон шкалы: от «Очень легко» до «Очень тяжело».'),
                const Text(
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                    '1 - Очень легко'),
                const Text(
                    style: TextStyle(color: Colors.green, fontSize: 12),
                    '2 - Легко'),
                Text(
                    style: TextStyle(color: Colors.orange[700], fontSize: 12),
                    '3 - Умеренно'),
                const Text(
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    '4 - Трудно'),
                Text(
                    style: TextStyle(color: Colors.red[700], fontSize: 12),
                    '5 - Очень тяжело'),
                const SizedBox(height: 10),
                const Text(
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                    'Самочуствие'),
                const Text(
                    'Бывают хорошие и плохие дни, нужно быть готовым к тому, что вы не будете чувствовать себя отлично во время каждого занятия. Оцените своё самочуствие по пятибалльной шкале.'),
                const Text(
                    style: TextStyle(fontSize: 14), '1 - 😞 Очень слабым'),
                const Text(style: TextStyle(fontSize: 14), '2 - ☹️ Слабым'),
                const Text(style: TextStyle(fontSize: 14), '3 - 😐 Нормально'),
                const Text(style: TextStyle(fontSize: 14), '4 - 🙂 Сильным'),
                const Text(
                    style: TextStyle(fontSize: 14), '5 - 😄 Очень сильным'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                  child:
                      Text(style: TextStyle(color: Colors.black), 'Понятно')),
            ),
          ],
        );
      },
    );
  }

  void _showSentReportModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Отправить отчёт?'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                        style: const TextStyle(color: Colors.red),
                        'Нагрузка ${_load.toStringAsFixed(0)}: '),
                    Text(
                      _load == 1
                          ? 'Очень легко'
                          : _load == 2
                              ? 'Легко'
                              : _load == 3
                                  ? 'Умеренно'
                                  : _load == 4
                                      ? 'Трудно'
                                      : _load == 5
                                          ? 'Очень тяжело'
                                          : '',
                      style: TextStyle(
                        color: _load == 1
                            ? Colors.blue
                            : _load == 2
                                ? Colors.green
                                : _load == 3
                                    ? Colors.orange[700]
                                    : _load == 4
                                        ? Colors.red
                                        : _load == 5
                                            ? Colors.red[700]
                                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                        style: TextStyle(color: Colors.blue),
                        'Ощущаете себя '),
                    Text(
                      _feeling == 1
                          ? 'Очень слабым'
                          : _feeling == 2
                              ? 'Слабым'
                              : _feeling == 3
                                  ? 'Нормально'
                                  : _feeling == 4
                                      ? 'Сильным'
                                      : _feeling == 5
                                          ? 'Очень сильным'
                                          : '',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text((controllerFeedback.text == '')
                    ? 'Без комментария'
                    : 'Комментарий: ${controllerFeedback.text}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                sentReport();
                Navigator.of(context).pop();
              },
              child: const Center(
                  child: Text(
                      style: TextStyle(color: Colors.black), 'Да, всё верно')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                  child: Text(style: TextStyle(color: Colors.black), 'Нет')),
            ),
          ],
        );
      },
    );
  }

  void _showSkipModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы пропустили тренировку?'),
          content: const Text(
              'Будет отправлен отчёт о том, что у Вас был день отдыха.'),
          actions: [
            TextButton(
              onPressed: () {
                sentReportSkip();
                Navigator.of(context).pop();
              },
              child: const Center(
                  child: Text(
                      style: TextStyle(color: Colors.red), 'Да, продолжить')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                  child: Text(
                      style: TextStyle(color: Colors.black),
                      'Нет, я тренировался')),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    controllerFeedback.text = textFeedback;
    super.initState();
  }

  @override
  void dispose() {
    controllerFeedback.dispose();
    print('DISPOSE REPORT WIDGET!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
                width: 210,
                child: Text(
                    'После тренировки оставьте пожалуйста обратную связь')),
            IconButton(
              icon: const Icon(color: Colors.blueAccent, Icons.help_outline),
              onPressed: () {
                _showInfoModal(context);
              },
            ),
          ],
        ),
        Row(
          children: [
            const Text(
                style: TextStyle(color: Colors.red, fontSize: 20),
                'Нагрузка: '),
            Text(
              _load == 1
                  ? 'Очень легко'
                  : _load == 2
                      ? 'Легко'
                      : _load == 3
                          ? 'Умеренно'
                          : _load == 4
                              ? 'Трудно'
                              : _load == 5
                                  ? 'Очень тяжело'
                                  : '',
              style: TextStyle(
                color: _load == 1
                    ? Colors.blue
                    : _load == 2
                        ? Colors.green
                        : _load == 3
                            ? Colors.orange[700]
                            : _load == 4
                                ? Colors.red
                                : _load == 5
                                    ? Colors.red[700]
                                    : Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 15.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            activeTrackColor: Colors.red,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
            overlayColor: Colors.green.withAlpha(52),
          ),
          child: Slider(
            min: 1,
            max: 5,
            divisions: 4,
            value: _load,
            //label: _load.toStringAsFixed(0),
            thumbColor: const Color.fromRGBO(255, 132, 26, 1),
            onChanged: (newValue) {
              textFeedback = controllerFeedback.text;
              _load = newValue;
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
                style: TextStyle(color: Colors.blue, fontSize: 20),
                'Самочуствие: '),
            Text(
              _feeling == 1
                  ? '😞'
                  : _feeling == 2
                      ? '☹️'
                      : _feeling == 3
                          ? '😐'
                          : _feeling == 4
                              ? '🙂'
                              : _feeling == 5
                                  ? '😄'
                                  : '',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 15.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
            overlayColor: Colors.green.withAlpha(52),
          ),
          child: Slider(
            min: 1,
            max: 5,
            divisions: 4,
            value: _feeling,
            //label: _feeling.toStringAsFixed(0),
            thumbColor: const Color.fromRGBO(255, 132, 26, 1),
            onChanged: (newValue) {
              textFeedback = controllerFeedback.text;
              _feeling = newValue;
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        const Text('Впечатления (не обязательно)'),
        TextField(
          maxLength: 200,
          maxLines: null,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(1, 57, 104, 1),
              fontSize: 16),
          controller: controllerFeedback,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 8,
                    backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                onPressed: () {
                  _showSentReportModal(context);
                },
                child: const Text(
                    style: TextStyle(
                        fontSize: 20, color: Color.fromRGBO(255, 132, 26, 1)),
                    'Отправить')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 8, backgroundColor: Colors.red),
                onPressed: () {
                  _showSkipModal(context);
                },
                child: const Text(
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    'Пропустил')),
          ],
        ),
      ],
    );
  }
}
