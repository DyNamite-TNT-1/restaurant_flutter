import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    emailController.clear();
    passwordController.clear();
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
                    name: "email",
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.alternate_email,
                    controller: emailController,
                    focusNode: emailFocus,
                    placeHolder: "Email",
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
                    placeHolder: "Password",
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
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Theme.of(context).primaryColor),
                    ),
                    child: Center(
                      child: Text(
                        'Đăng nhập',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
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
