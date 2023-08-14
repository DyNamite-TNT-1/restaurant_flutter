import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/blocs/app_bloc.dart';
import 'package:restaurant_flutter/blocs/bloc.dart';
import 'package:restaurant_flutter/configs/application.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  Application? application; // = Application();
  ApplicationBloc() : super(InitialApplicationState()) {
    application = Application();

    on<OnSetupApplication>(_onSetup);
    // on<OnCompletedIntro>(_onCompleteIntro);
  }

  Future<void> _onSetup(OnSetupApplication event, Emitter emit) async {
    // await UtilDevice.loadDeviceInfo();

    ///Setup SharedPreferences
    await Preferences.setPreferences();

    ///Get old Theme & Font & Language
    // final oldTheme = UserPreferences.getTheme() ?? AppTheme.currentTheme;
    // final oldFont = UserPreferences.getFont() ?? AppTheme.currentFont;
    // final oldLanguage = UserPreferences.getLanguage();
    // final oldDarkOption =
    //     UserPreferences.getDarkOptions() ?? DarkOption.alwaysOff;

    ///Setup Language
    // if (oldLanguage != null) {
    //   AppBloc.languageBloc.add(
    //     OnChangeLanguage(Locale(oldLanguage)),
    //   );
    // }

    // DarkOption darkOption;

    ///Find font support available
    // String font = AppTheme.fontSupport.firstWhere((item) {
    //   return item == oldFont;
    // }, orElse: () {
    //   return '';
    // });

    // ///Find theme support available
    // ThemeModel theme = AppTheme.themeSupport.firstWhere((item) {
    //   return item.name == oldTheme;
    // }, orElse: () {
    //   return AppTheme.themeSupport.first;
    // });

    // ///check old dark option
    // switch (oldDarkOption) {
    //   case DARK_ALWAYS_OFF:
    //     darkOption = DarkOption.alwaysOff;
    //     break;
    //   case DARK_DYNAMIC:
    //     darkOption = DarkOption.dynamic;
    //     break;
    //   case DARK_ALWAYS_ON:
    //     darkOption = DarkOption.alwaysOn;
    //     break;
    //   default:
    //     darkOption = DarkOption.alwaysOff;
    // }

    // ///Setup Theme & Font with dark Option
    // AppBloc.themeBloc.add(
    //   OnChangeTheme(
    //     theme: theme,
    //     font: font,
    //     darkOption: darkOption,
    //   ),
    // );

    // ///First or After upgrade version show intro preview app

    // final hasReview =
    //     UserPreferences.hasNewIntroUpgradeVersion(Application.versionIntro);

    // await Future.delayed(Duration(milliseconds: 300));

    emit(ApplicationSetupCompleted());

    // if (!hasReview) {
    //   emit(ApplicationIntroView());
    // } else {
    AppBloc.authenticationBloc.add(OnAuthenticationCheck());
    // }
  }

  // Future<void> _onCompleteIntro(OnCompletedIntro event, Emitter emit) async {
  //   await UserPreferences.setViewedIntroVersion(Application.versionIntro);
  //   AppBloc.authenticationBloc.add(OnAuthenticationCheck());
  //   emit(ApplicationSetupCompleted());
  // }
}
