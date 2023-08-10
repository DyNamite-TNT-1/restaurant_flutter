import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/configs/user_repository.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/screens/authentication/login.dart';
import 'package:restaurant_flutter/screens/authentication/signup.dart';
import 'package:restaurant_flutter/widgets/app_button.dart';

class AppCeiling extends StatefulWidget {
  const AppCeiling({super.key});

  @override
  State<AppCeiling> createState() => _AppCeilingState();
}

class _AppCeilingState extends State<AppCeiling> {
  bool isHasToken = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() {
    final token = UserPreferences.getToken();
    if (token != null) {
      setState(() {
        isHasToken = true;
      });
    }
  }

  _openLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ct) {
        return LoginScreen(
          onLogin: () {
            checkLogin();
          },
         
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
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
            color: Colors.blue,
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              AppButton(
                "Đặt bàn",
                type: ButtonType.normal,
                onPressed: () {
                  context.goNamed(RouteConstants.reservation);
                },
              ),
              VerticalDivider(
                width: 20,
                thickness: 1,
                indent: 3,
                endIndent: 3,
                color: Colors.grey,
              ),
              !isHasToken
                  ? AppButton(
                      "Đăng nhập",
                      type: ButtonType.outline,
                      onPressed: () {
                        _openLoginDialog();
                      },
                    )
                  : InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                          ),
                          Text(UserRepository.userModel.userName),
                        ],
                      ),
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
