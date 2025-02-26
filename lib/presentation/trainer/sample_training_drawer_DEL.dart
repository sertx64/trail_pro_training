import 'package:flutter/material.dart';
import 'package:trailpro_planning/domain/management.dart';

class SampleTrainingDrawer extends StatelessWidget {
  SampleTrainingDrawer({super.key});

  final List samples = Management.samplesSlitList;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
                style: TextStyle(fontSize: 24, color: Colors.black),
                'Шаблоны тренировок'),
          ),
          SizedBox(
            height: 400,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(samples[index][0]),
                  onTap: () {
                    // controllerLabelTraining.text = samples[index][0];
                    // controllerDescriptionTraining.text = samples[index][1];
                    Navigator.pop(context);
                  },
                );
              },
              itemCount: samples.length,
            ),
          ),
        ],
      ),
    );
  }
}