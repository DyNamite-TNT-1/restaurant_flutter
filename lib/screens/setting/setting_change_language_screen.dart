import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_flutter/blocs/app_bloc.dart';
import 'package:restaurant_flutter/blocs/language/language_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/utils/utils.dart';

import '../../widgets/widgets.dart';

class SettingChangeLanguageScreen extends StatefulWidget {
  final String initLangCode;
  const SettingChangeLanguageScreen({super.key, required this.initLangCode});

  @override
  State<SettingChangeLanguageScreen> createState() =>
      _SettingChangeLanguageScreenState();
}

class _SettingChangeLanguageScreenState
    extends State<SettingChangeLanguageScreen> {
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Row(
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            Expanded(
              child: Text(
                Translate.of(context).translate('Change Language'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: AppTheme.currentFont,
                      color: Color(0xff3D4153),
                      fontSize: kfontSizeHeadlineSmall,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
            ),
          ],
        ),
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
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
