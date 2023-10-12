part of 'language_bloc.dart';

abstract class LanguageState {}

class InitialLanguageState extends LanguageState {}

class LanguageUpdating extends LanguageState {}

class LanguageUpdated extends LanguageState {}
