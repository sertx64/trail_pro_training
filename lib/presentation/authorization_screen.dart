import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/samples.dart';
import 'package:trailpro_planning/domain/users.dart';
import 'package:trailpro_planning/presentation/theme/app_colors.dart';

class Authorization extends StatefulWidget {
  const Authorization({super.key});

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  final box = Hive.box('user');
  final TextEditingController _pin = TextEditingController();
  final TextEditingController _login = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _goToRoleScreen() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String login = _login.text.trim();
      String pin = _pin.text.trim();
    User user = await Users().user(login);

    if (user.pin == pin) {
      box.put('login', login);
      box.put('pin', pin);
        
        if (mounted) {
      if (user.role == 'student') {
        context.go('/studentscreen');
      } else {
        Samples().createSamplesSplitList();
        Users().createUserAndGroupsList();
        context.go('/trainerscreen');
          }
      }
    } else {
        if (mounted) {
          _showErrorSnackBar('Неверный логин или ПИН-код');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Ошибка авторизации. Проверьте данные.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
    }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final login = box.get('login', defaultValue: '');
    final pin = box.get('pin', defaultValue: '');
    _login.text = login;
    _pin.text = pin;
  }

  @override
  void dispose() {
    _login.dispose();
    _pin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('TrailPro Planning'),
            actions: [
              IconButton(
            icon: const Icon(Icons.info_outline),
                onPressed: () => context.push('/infoscreen'),
              ),
            ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
              const SizedBox(height: 48),
              
              // Логотип
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/trailpro_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Приветственный текст
              Text(
                'Добро пожаловать!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Войдите в свою учетную запись',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primary.withOpacity(0.7),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Форма авторизации
              Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Поле логина
                        TextFormField(
                          controller: _login,
                          decoration: const InputDecoration(
                            labelText: 'Логин',
                            hintText: 'Введите ваш логин',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Пожалуйста, введите логин';
                            }
                            return null;
                          },
            ),
                        
                        const SizedBox(height: 24),
                        
                        // Поле ПИН-кода
                        TextFormField(
                          controller: _pin,
                          decoration: InputDecoration(
                            labelText: 'ПИН-код',
                            hintText: 'Введите ваш ПИН-код',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _goToRoleScreen(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Пожалуйста, введите ПИН-код';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Кнопка входа
            SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _goToRoleScreen,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.textLight,
                                      ),
                                    ),
                                  )
                                : const Text('Войти'),
              ),
            ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Дополнительная информация
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary.withOpacity(0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                child: Text(
                        'Если у вас нет учетной записи, обратитесь к администратору',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          ),
        ),
      ),
    );
  }
}
