part of 'language_bloc.dart';

abstract class LanguageEvent {}

class OnChangeLanguage extends LanguageEvent {
  final Locale locale;

  OnChangeLanguage(this.locale);
}

class OnChangeLanguageIfNeed extends LanguageEvent {
  final String langCode;

  OnChangeLanguageIfNeed(this.langCode);
}
