// part of 'application_bloc.dart';

abstract class ApplicationEvent {}

///Event notification setup application
class OnSetupApplication extends ApplicationEvent {}

///Event notification completed preview intro
class OnCompletedIntro extends ApplicationEvent {}
