import 'package:flutter/material.dart';

import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/users.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/presentation/theme/app_colors.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;
  
  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.role == 'student' ? 'Профиль ученика' : 'Профиль тренера'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with avatar
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 28,
                  child: Text(
                    user.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : user.login[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.role == 'student' ? 'Профиль ученика' : 'Профиль тренера',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Информация о пользователе
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Информация о пользователе',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Логин', user.login),
                    const SizedBox(height: 12),
                    _buildInfoRow('Имя', user.name),
                    const SizedBox(height: 12),
                    _buildInfoRow('Роль', user.role == 'student' ? 'Ученик' : 'Тренер'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            if (user.role == 'student') ...[
              // Groups section header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Группы ученика:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showGroupSelectionBottomSheet(context, user);
                    },
                    icon: const Icon(Icons.group_add),
                    label: const Text('Добавить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.textLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Список групп ученика
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: user.groups.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.group, color: AppColors.primary),
                      ),
                      title: Text(
                        user.groups[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      subtitle: const Text(
                        'Групповые тренировки',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: AppColors.text),
          ),
        ),
      ],
    );
  }

  void _showGroupSelectionBottomSheet(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Заголовок
              Text(
                'Добавить в группу',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'Выберите группу для добавления ученика ${user.login}:',
                style: const TextStyle(fontSize: 16),
              ),
              
              const SizedBox(height: 16),
              
              // Список групп
              Expanded(
                child: ListView.builder(
                  itemCount: Management.groupsList.length,
                  itemBuilder: (context, index) {
                    bool isAlreadyInGroup = user.groups.contains(Management.groupsList[index]);
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        leading: Icon(
                          isAlreadyInGroup ? Icons.check_circle : Icons.group,
                          color: isAlreadyInGroup ? AppColors.success : AppColors.primary,
                        ),
                        title: Text(
                          Management.groupsList[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isAlreadyInGroup ? AppColors.success : AppColors.primary,
                          ),
                        ),
                        subtitle: Text(
                          isAlreadyInGroup ? 'Уже в группе' : 'Добавить в группу',
                          style: TextStyle(
                            color: isAlreadyInGroup ? AppColors.success : AppColors.text,
                          ),
                        ),
                        trailing: isAlreadyInGroup ? null : const Icon(Icons.add),
                        onTap: isAlreadyInGroup ? null : () {
                          user.groups.add(Management.groupsList[index]);
                          Users().changePersonalDataUser(
                            user.login,
                            user.name,
                            user.pin,
                            user.role,
                            user.groups,
                          );
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ученик добавлен в группу ${Management.groupsList[index]}'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 