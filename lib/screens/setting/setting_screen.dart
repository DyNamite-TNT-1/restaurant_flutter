import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/utils/utils.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    String currentLang = AppLanguage.currentLanguage?.languageCode ??
        Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              context.goNamed(RouteConstants.settingLanguage,
                  extra: {"initLangCode": currentLang});
            },
            child: Text(
              Translate.of(context).translate('change_language'),
            ),
          ),
        ],
      ),
    );
  }
}
