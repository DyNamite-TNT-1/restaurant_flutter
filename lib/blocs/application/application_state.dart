// part of 'application_bloc.dart';

abstract class ApplicationState {}

class InitialApplicationState extends ApplicationState {}

class ApplicationWaiting extends ApplicationState {}

class ApplicationSetupCompleted extends ApplicationState {}

class ApplicationIntroView extends ApplicationState {}
