import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(InitialLanguageState()) {
    on<OnChangeLanguage>(_onUpdate);
    on<OnChangeLanguageIfNeed>(_onUpdateIfNeed);
  }

  void _onUpdate(OnChangeLanguage event, Emitter emit) async {
    emit(LanguageUpdating());

    ///Preference save
    await UserPreferences.setLanguage(event.locale.languageCode);
    AppLanguage.currentLanguage = event.locale;

    emit(LanguageUpdated());
  }

  void _onUpdateIfNeed(OnChangeLanguageIfNeed event, Emitter emit) async {
    Locale? locale = AppLanguage.currentLanguage;
    String langCode = event.langCode;
    if (langCode.isNotEmpty) {
      if (locale == null || locale.languageCode != langCode) {
        emit(LanguageUpdating());
        await UserPreferences.setLanguage(langCode);
        AppLanguage.currentLanguage = Locale(langCode);
        emit(LanguageUpdated());
      }
    }
  }
}
