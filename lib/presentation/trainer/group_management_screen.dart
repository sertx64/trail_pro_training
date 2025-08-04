import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/presentation/theme/app_colors.dart';

class GroupManagementScreen extends StatelessWidget {
  final VoidCallback? onNavigateToHome;
  
  const GroupManagementScreen({super.key, this.onNavigateToHome});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          // Кнопка добавления группы
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.group_add, color: AppColors.accent),
                title: const Text('Создать новую группу'),
                subtitle: const Text('Добавить новую группу для тренировок'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/addgroupscreen');
                },
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Выберите группу для составления недельного плана:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Список групп
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: Management.groupsList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.group, color: AppColors.primary),
                    title: Text(
                      Management.groupsList[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    subtitle: const Text('Группа'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final selectedGroup = Management.groupsList[index];
                      
                      // Показываем индикатор загрузки
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      
                      try {
                        // Запускаем выбор группы
                        context.read<HomeScreenCubit>().choosingPlanType(selectedGroup);
                        
                        // Даем время на начало загрузки
                        await Future.delayed(const Duration(milliseconds: 100));
                        
                        // Закрываем диалог загрузки
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          // Возвращаемся к главному экрану
                          onNavigateToHome?.call();
                        }
                      } catch (e) {
                        // Закрываем диалог в случае ошибки
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ошибка выбора группы: $e')),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
  }
} 