

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/student_report.dart';

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

  @override
  Widget build(BuildContext context) {

    final TextEditingController controllerFeedback =
    TextEditingController(text: textFeedback);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            style: const TextStyle(
                color: Colors.red, fontSize: 20),
            'Нагрузка: ${_load.toStringAsFixed(0)}'),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 15.0,
            thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 15.0),
            overlayShape:
            const RoundSliderOverlayShape(
                overlayRadius: 20.0),
            activeTrackColor: Colors.red,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
            overlayColor: Colors.green.withAlpha(52),
          ),
          child: Slider(
            min: 1,
            max: 5,
            divisions: 4,
            value: _load,
            label: _load.toStringAsFixed(0),
            thumbColor:
            const Color.fromRGBO(255, 132, 26, 1),
            onChanged: (newValue) {
              textFeedback = controllerFeedback.text;
              _load = newValue;
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        Text(
            style: const TextStyle(
                color: Colors.blue, fontSize: 20),
            'Самочуствие: ${_feeling.toStringAsFixed(0)}'),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 15.0,
            thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 15.0),
            overlayShape:
            const RoundSliderOverlayShape(
                overlayRadius: 20.0),
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
            overlayColor: Colors.green.withAlpha(52),
          ),
          child: Slider(
            min: 1,
            max: 5,
            divisions: 4,
            value: _feeling,
            label: _feeling.toStringAsFixed(0),
            thumbColor:
            const Color.fromRGBO(255, 132, 26, 1),
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
              borderRadius: BorderRadius.all(
                  Radius.circular(16.0)),
            ),
          ),
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(1, 57, 104, 1),
              fontSize: 16),
          controller: controllerFeedback,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 8,
                fixedSize: const Size(110, 40),
                backgroundColor: const Color.fromRGBO(
                    1, 57, 104, 1)),
            onPressed: () {
              if (controllerFeedback.text == '') {
                controllerFeedback.text =
                'нет комментария';
              }
              StudentReport().sentReport(
                  widget.date,
                  _load.toStringAsFixed(0),
                  _feeling.toStringAsFixed(0),
                  controllerFeedback.text);
              context.pop;
            },
            child: const Text(
                style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(
                        255, 132, 26, 1)),
                'Отчёт')),
      ],
    );
  }

  }



