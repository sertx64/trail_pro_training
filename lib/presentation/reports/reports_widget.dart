import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/report_cubit.dart';
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
    return BlocBuilder<ReportCubit, ReportModel>(builder: (context, value) {

      List reports = context.read<ReportCubit>().splitReports(value.reports);
      return (!value.isLoading)
          ? const Center(
              child: CircularProgressIndicator(
              color: Color.fromRGBO(255, 132, 26, 1),
              strokeWidth: 3,
            ))
          : (!value.reports.contains(Management.userLogin) &&
                  Management.userLogin != '')
              ? SentReportWidget(date)
              : SizedBox(
                  height: 300,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 20),
                              reports[index][0]),
                          Row(
                            children: [
                              Text(
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 16),
                                  'Нагрузка ${reports[index][1]}'),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                  style: const TextStyle(
                                      color: Colors.blue, fontSize: 16),
                                  'Самочуствие ${reports[index][2]}'),
                            ],
                          ),
                          Text(reports[index][3]),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: reports.length,
                  ),
                );
    });
  }
}
