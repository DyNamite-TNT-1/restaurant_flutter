import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/models/service/user.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode loginFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool isSigning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    loginFocus.dispose();
    passwordFocus.dispose();
    loginController.clear();
    passwordController.clear();
  }

  Future<void> _requestLogin(BuildContext context) async {
    UserModel result = await Api.requestLogin(
        login: loginController.text, password: passwordController.text);
    if (result.isSuccess) {
      await UserPreferences.setToken(result.accessToken);

      if (context.mounted) {
        context.pop();
        // Navigator.pushNamed(
        //   context,
        //   Routes.appContainer,
        // );
      }
    } else {
      Fluttertoast.showToast(
          msg: "Đăng nhập thất bại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      isSigning = false;
    });
  }

  Widget buildTitle(BuildContext context) {
    return Text("Đăng nhập",
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      backgroundColor: backgroundColor,
      content: Container(
        constraints: const BoxConstraints(
          minWidth: 700,
          maxWidth: kDialogMaxWidthNormal,
          minHeight: 100,
          maxHeight: 500,
        ),
        child: Row(
          children: [
            Expanded(
              child: Image.asset(
                Images.logoAppNoBg,
              ),
            ),
            SizedBox(
              width: kDefaultPadding,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          context.pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: kDefaultPadding * 2,
                  ),
                  buildTitle(context),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  AppInput(
                    name: "login",
                    keyboardType: TextInputType.name,
                    icon: Icons.person_outline,
                    controller: loginController,
                    focusNode: loginFocus,
                    placeHolder: "Nhập email hoặc số điện thoại",
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  AppInput(
                    name: "password",
                    keyboardType: TextInputType.visiblePassword,
                    icon: Icons.lock,
                    controller: passwordController,
                    focusNode: passwordFocus,
                    placeHolder: "Nhập mật khẩu",
                    isPassword: true,
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "Quên mật khẩu?",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: kDefaultPadding * 2,
                  ),
                  AppButton(
                    "Đăng nhập",
                    loading: isSigning,
                    mainAxisSize: MainAxisSize.max,
                    onPressed: () {
                      setState(() {
                        isSigning = true;
                      });
                      _requestLogin(context);
                    },
                  ),
                  SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bạn chưa có tài khoản?",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: kPadding10 / 2,
                            vertical: kPadding10 / 2,
                          ),
                          child: Text(
                            " Đăng ký",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
