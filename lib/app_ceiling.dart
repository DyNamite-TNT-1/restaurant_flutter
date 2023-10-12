import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/blocs/bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/configs/user_repository.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/screens/authentication/login_screen.dart';
import 'package:restaurant_flutter/widgets/app_button.dart';

class AppCeiling extends StatefulWidget {
  const AppCeiling({super.key, required this.onTapReservation});
  final Function onTapReservation;

  @override
  State<AppCeiling> createState() => _AppCeilingState();
}

class _AppCeilingState extends State<AppCeiling> {
  @override
  void initState() {
    super.initState();
  }

  _openLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ct) {
        return LoginScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentLang = AppLanguage.currentLanguage?.languageCode ??
        Localizations.localeOf(context).languageCode;
    var authState = context.select((AuthenticationBloc bloc) => bloc.state);
    return Row(
      children: [
        SizedBox(
          width: kDefaultPadding,
        ),
        Image.asset(
          Images.miniLogoAppNoBg,
          height: 80,
          width: 100,
        ),
        SizedBox(
          width: kDefaultPadding,
        ),
        Expanded(
          child: Container(
            height: 50,
            // color: Colors.blue,
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              AppButton(
                "Đặt bàn",
                type: ButtonType.normal,
                onPressed: () {
                  widget.onTapReservation();
                },
              ),
              VerticalDivider(
                width: 20,
                thickness: 1,
                indent: 3,
                endIndent: 3,
                color: Colors.grey,
              ),
              (authState is! AuthenticationSuccess)
                  ? AppButton(
                      "Đăng nhập",
                      type: ButtonType.outline,
                      onPressed: () {
                        _openLoginDialog();
                      },
                    )
                  : InkWell(
                      onTap: () {
                        context.goNamed(RouteConstants.profile);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                          ),
                          Text(
                            UserRepository.userModel.userName,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
              IconButton(
                onPressed: () {
                  context.goNamed(RouteConstants.settingLanguage,
                      extra: {"initLangCode": currentLang});
                },
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        ),
        SizedBox(
          width: kDefaultPadding,
        ),
      ],
    );
  }
}
