import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:trailpro_planning/domain/models/models.dart';
import 'package:trailpro_planning/domain/samples.dart';
import 'package:trailpro_planning/domain/users.dart';
import 'package:trailpro_planning/presentation/theme/app_theme_export.dart';

class Authorization extends StatefulWidget {
  const Authorization({super.key});

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  final box = Hive.box('user');
  final TextEditingController _pin = TextEditingController();
  final TextEditingController _login = TextEditingController();

  void goToRoleScreen() async {
    String login = _login.text;
    String pin = _pin.text;
    User user = await Users().user(login);

    if (user.pin == pin) {
      box.put('login', login);
      box.put('pin', pin);
      if (user.role == 'student') {
        context.go('/studentscreen');
      } else {
        Samples().createSamplesSplitList();
        Users().createUserAndGroupsList();
        context.go('/trainerscreen');
      }
    } else {
      return;
    }
  }

  @override
  void initState() {
    final login = box.get('login', defaultValue: '');
    final pin = box.get('pin', defaultValue: '');
    _login.text = login;
    _pin.text = pin;
    super.initState();
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
            actions: [
              IconButton(
                icon: Icon(
                    color: AppColors.accent,
                    Icons.info_outline),
                onPressed: () => context.push('/infoscreen'),
              ),
            ],
            centerTitle: true,
            title: Text(
                style: AppTextStyles.heading1,
                'TrailPro planning'),
            backgroundColor: AppColors.primary),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.xxl * 3.75),
            const Text('логин'),
            SizedBox(
              height: 50,
              width: 250,
              child: TextField(
                textAlign: TextAlign.center,
                cursorColor: AppColors.accent,
                style: AppTextStyles.body1,
                decoration: AppTheme.roundInputDecoration,
                controller: _login,
              ),
            ),
            SizedBox(height: AppSpacing.small),
            const Text('пин'),
            SizedBox(
              height: 50,
              width: 250,
              child: TextField(
                textAlign: TextAlign.center,
                cursorColor: AppColors.accent,
                obscureText: true,
                keyboardType: TextInputType.number,
                style: AppTextStyles.body2,
                decoration: AppTheme.roundInputDecoration,
                controller: _pin,
              ),
            ),
            SizedBox(height: AppSpacing.small),
            ElevatedButton(
                style: AppTheme.elevatedButtonStyle,
                onPressed: goToRoleScreen,
                child: Text(
                    style: AppTextStyles.button,
                    'Войти')),
            SizedBox(height: AppSpacing.large),
          ],
        )));
  }
}
