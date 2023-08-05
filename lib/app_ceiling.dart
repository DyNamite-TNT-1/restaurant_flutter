import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/screens/authentication/login.dart';
import 'package:restaurant_flutter/widgets/app_button.dart';

class AppCeiling extends StatefulWidget {
  const AppCeiling({super.key});

  @override
  State<AppCeiling> createState() => _AppCeilingState();
}

class _AppCeilingState extends State<AppCeiling> {
  _openDoneDialog() {
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
        InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kPadding10,
              vertical: kPadding10 / 2,
            ),
            child: Text("Chưa có tài khoản?"),
          ),
        ),
        AppButton(
          "Đăng nhập",
          type: ButtonType.outline,
          onPressed: () {
            _openDoneDialog();
          },
        ),
        SizedBox(
          width: kDefaultPadding,
        ),
      ],
    );
  }
}
