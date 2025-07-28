import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/home_cubit.dart';
import 'package:trailpro_planning/domain/users.dart';
import 'package:trailpro_planning/presentation/theme/app_colors.dart';

class UserManagementScreen extends StatelessWidget {
  final VoidCallback? onNavigateToHome;
  
  const UserManagementScreen({super.key, this.onNavigateToHome});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          // Кнопка добавления пользователя
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.person_add, color: AppColors.accent),
                title: const Text('Регистрация нового ученика'),
                subtitle: const Text('Добавить нового пользователя в систему'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/adduserscreen');
                },
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Выберите ученика для составления индивидуального плана:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Список учеников
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: Management.userList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        Management.userList[index][0].toUpperCase(),
                        style: const TextStyle(color: AppColors.textLight),
                      ),
                    ),
                    title: Text(
                      Management.userList[index],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Ученик'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info_outline, color: AppColors.accent),
                          onPressed: () async {
                            final userName = Management.userList[index];
                            try {
                              final user = await Users().getUserData(userName);
                              if (context.mounted) {
                                context.push('/userprofile', extra: user);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ошибка загрузки данных пользователя: $e')),
                                );
                              }
                            }
                          },
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () async {
                      final selectedUser = Management.userList[index];
                      
                      // Показываем индикатор загрузки
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      
                      try {
                        // Запускаем выбор пользователя
                        context.read<HomeScreenCubit>().choosingPlanType(selectedUser);
                        
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
                            SnackBar(content: Text('Ошибка выбора пользователя: $e')),
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