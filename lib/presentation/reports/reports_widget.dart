import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/report_cubit.dart';
import 'package:trailpro_planning/presentation/models/models.dart';
import 'package:trailpro_planning/presentation/reports/sent_report_widget.dart';

class ReportsWidget extends StatelessWidget {
  const ReportsWidget(this.date, {super.key});
  final String date;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportCubit(),
      child: _ReportsWidget(date),
    );
  }
}

class _ReportsWidget extends StatelessWidget {
  const _ReportsWidget(this.date, {super.key});
  final String date;
  @override
  Widget build(BuildContext context) {
    context.read<ReportCubit>().loadReports(date);
    return BlocBuilder<ReportCubit, ReportsForView>(builder: (context, value) {
      return (!value.isLoading)
          ? const Center(
              child: CircularProgressIndicator(
              color: Color.fromRGBO(255, 132, 26, 1),
              strokeWidth: 3,
            ))
          : (!value.reports.any((report) => report.name == Management.userLogin) &&
                  Management.userLogin != '')
              ? SentReportWidget(date)
              : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      style: TextStyle(
                          color: Colors.black, fontSize: 20),
                      'Отчёты:'),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      ReportModel report = value.reports[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 20),
                              report.name),
                          if (report.load != '0') Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Row(
                                children: [
                                  Text(
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 16),
                                      'Нагрузка ${report.load} '),
                                  Text(
                                    report.load == '1'
                                        ? 'Очень легко'
                                        : report.load == '2'
                                            ? 'Легко'
                                            : report.load == '3'
                                                ? 'Умеренно'
                                                : report.load == '4'
                                                    ? 'Трудно'
                                                    : report.load == '5'
                                                        ? 'Очень тяжело'
                                                        : '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: report.load == '1'
                                          ? Colors.blue
                                          : report.load == '2'
                                              ? Colors.green
                                              : report.load == '3'
                                                  ? Colors.orange[700]
                                                  : report.load == '4'
                                                      ? Colors.red
                                                      : report.load == '5'
                                                          ? Colors.red[700]
                                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 16),
                                      'Самочуствие ${report.feeling} '),
                                  Text(
                                    report.feeling == '1'
                                        ? 'Очень слабым'
                                        : report.feeling == '2'
                                            ? 'Слабым'
                                            : report.feeling == '3'
                                                ? 'Нормально'
                                                : report.feeling == '4'
                                                    ? 'Сильным'
                                                    : report.feeling == '5'
                                                        ? 'Очень сильным'
                                                        : '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                              style: const TextStyle(
                                  color: Colors.black),
                              report.feedback),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: value.reports.length,
                  ),
                ],
              );
    });
  }
}
