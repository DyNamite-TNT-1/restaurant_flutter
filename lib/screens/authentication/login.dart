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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.red),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: kDefaultPadding / 2,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Theme.of(context).primaryColor),
                        ),
                        child: Center(
                          child: Text(
                            'Đăng nhập',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
