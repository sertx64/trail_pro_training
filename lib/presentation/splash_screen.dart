import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trailpro_planning/domain/management.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/samples.dart';
import 'package:trailpro_planning/domain/users.dart';
import 'package:hive/hive.dart';
import 'package:trailpro_planning/presentation/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final box = Hive.box('user');
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  void _startSplashSequence() {
    final login = box.get('login', defaultValue: '');
    final pin = box.get('pin', defaultValue: '');

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
      if (login == '') {
        context.go('/authorization');
      } else {
          _goToRoleScreen(login, pin);
      }
      }
    });
  }

  void _goToRoleScreen(String login, String pin) async {
    try {
    User user = await Users().user(login);
    if (user.pin == pin) {
      box.put('login', login);
      box.put('pin', pin);
      Management.user = user;
        
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
          context.go('/authorization');
        }
      }
    } catch (e) {
      if (mounted) {
      context.go('/authorization');
    }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Логотип с анимацией
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/trailpro_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 48),
            
            // Название приложения
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'TrailPro Planning',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Подзаголовок
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Планирование тренировок',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primary.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 64),
            
            // Индикатор загрузки
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      strokeWidth: 3,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Текст загрузки
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Загрузка...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary.withOpacity(0.6),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
