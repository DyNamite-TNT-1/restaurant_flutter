import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/blocs/app_bloc.dart';
import 'package:restaurant_flutter/blocs/language/language_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/utils/utils.dart';

import '../../widgets/widgets.dart';

class SettingChangeLanguage extends StatefulWidget {
  final String initLangCode;
  const SettingChangeLanguage({super.key, required this.initLangCode});

  @override
  State<SettingChangeLanguage> createState() => _SettingChangeLanguageState();
}

class _SettingChangeLanguageState extends State<SettingChangeLanguage> {
  final _supportLanguage = AppLanguage.supportLanguage;
  late String selectLang;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectLang = widget.initLangCode;
  }

  Future<void> _requestChangeLanguage() async {
    if (UserPreferences.getLanguage() != selectLang) {
      setState(() {
        isLoading = true;
      });

      AppBloc.languageBloc.add(OnChangeLanguage(Locale(selectLang)));

      if (mounted) {
        setState(() {
          isLoading = false;
        });
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AbsorbPointer(
        absorbing: isLoading,
        child: ListView.builder(
          padding: const EdgeInsets.all(kDefaultPadding * 4 / 3),
          itemCount: _supportLanguage.length + 1, // add  button
          itemBuilder: (context, index) {
            if (index == _supportLanguage.length) {
              return Container(
                margin: EdgeInsets.only(top: 50),
                child: AppButton(
                  Translate.of(context).translate(
                    'Apply',
                  ),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: () {
                    _requestChangeLanguage();
                  },
                  type: ButtonType.normal,
                  loading: isLoading,
                ),
              );
            }
            final languageCode = UtilLanguage.getGlobalLanguageName(
                _supportLanguage[index].languageCode);
            return InkWell(
              onTap: () {
                setState(() {
                  selectLang = _supportLanguage[index].languageCode;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Row(
                  children: [
                    Icon(
                      selectLang == _supportLanguage[index].languageCode
                          ? Icons.check
                          : Icons.radio_button_unchecked,
                      size: kSizeIconLarge,
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    Text(
                      Translate.of(context).translate(languageCode),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
