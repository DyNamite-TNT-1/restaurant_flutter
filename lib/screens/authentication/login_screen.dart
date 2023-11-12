import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/blocs/bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/utils/utils.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.onLoginDone,
  });
  final Function? onLoginDone;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode loginFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool showErrorText = false;
  String errorText = "";

  @override
  void initState() {
    super.initState();
    if (loginFocus.canRequestFocus) {
      loginFocus.requestFocus();
    }
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
    setState(() {
      errorText = "";
      showErrorText = false;
    });
    if (loginController.text.trim().isEmpty) {
      errorText = Translate.of(context).translate("VALIDATE_LOGIN_E001");
    } else if (passwordController.text.trim().isEmpty) {
      errorText = Translate.of(context).translate("VALIDATE_PASSWORD_E001");
    } else if (!RegExp(r"^(?:\d{10}|[\w-\.]+@([\w-]+\.)+[\w-]{2,4})$")
        .hasMatch(loginController.text)) {
      errorText = Translate.of(context).translate("VALIDATE_LOGIN_E002");
    } else if (!RegExp(r"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{6,}$")
        .hasMatch(passwordController.text)) {
      errorText = Translate.of(context).translate("VALIDATE_PASSWORD_E002");
    }
    if (errorText.isNotEmpty) {
      setState(() {
        showErrorText = true;
      });
    } else {
      Map<String, String> map = {
        "login": loginController.text,
        "password": passwordController.text,
      };
      context.read<AuthenticationBloc>().add(OnAuthenticate(map: map));
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Widget buildTitle(BuildContext context) {
    return Text(Translate.of(context).translate("sign_in"),
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center);
  }

  Widget _buildError(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: kPadding10,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kPadding10,
      ),
      decoration: BoxDecoration(
        color: Color(0XFFFF4444).withOpacity(0.8),
        borderRadius: BorderRadius.circular(kCornerNormal),
        border: Border.all(
          color: Color(0XFFFF4444),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                errorText,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(kCornerLarge),
              onTap: () {
                setState(() {
                  showErrorText = false;
                  errorText = "";
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(kPadding10 / 2),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var authState = context.select((AuthenticationBloc bloc) => bloc.state);
    return Row(
      children: [
        Expanded(
          child: Image.asset(
            AssetImages.logoAppNoBg,
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
                height: kDefaultPadding,
              ),
              buildTitle(context),
              if (showErrorText) _buildError(context),
              SizedBox(
                height: kDefaultPadding,
              ),
              AppInput(
                name: "login",
                keyboardType: TextInputType.name,
                icon: Icons.person_outline,
                controller: loginController,
                focusNode: loginFocus,
                placeHolder:
                    Translate.of(context).translate("enter_email_phone"),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              AppInput(
                name: "password",
                keyboardType: TextInputType.name,
                icon: Icons.lock,
                controller: passwordController,
                focusNode: passwordFocus,
                placeHolder: Translate.of(context).translate("enter_password"),
                isPassword: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _requestLogin(context);
                },
              ),
              // SizedBox(
              //   height: kDefaultPadding,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     InkWell(
              //       onTap: () {},
              //       child: Text(
              //         "${Translate.of(context).translate("enter_password")}?",
              //         style: Theme.of(context).textTheme.bodyMedium,
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: kDefaultPadding * 2,
              ),
              AppButton(
                Translate.of(context).translate("sign_in").toUpperCase(),
                loading: authState is Authenticating,
                mainAxisSize: MainAxisSize.max,
                onPressed: () {
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
                    Translate.of(context).translate("do_not_have_account"),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  InkWell(
                    onTap: () {
                      if (mounted) {
                        Navigator.pop(context);
                        context.goNamed(RouteConstants.signUp);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: kPadding10 / 2,
                        vertical: kPadding10 / 2,
                      ),
                      child: Text(
                        " ${Translate.of(context).translate("sign_up")}",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationFail) {
          String errorMessage = state.messageError.trim();
          Fluttertoast.showToast(
            msg: errorMessage.trim().isNotEmpty
                ? Translate.of(context).translate(errorMessage)
                : Translate.of(context).translate("LOGIN_E001"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            webBgColor: dangerColorToast,
            webShowClose: true,
          );
        } else if (state is AuthenticationSuccess) {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: Translate.of(context).translate("LOGIN_SUCCESS"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            webBgColor: successColorToast,
            webShowClose: true,
          );
          if (widget.onLoginDone != null) {
            widget.onLoginDone!();
          }
        }
      },
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        backgroundColor: backgroundColor,
        content: Container(
          constraints: const BoxConstraints(
            minWidth: 700,
            maxWidth: kDialogMaxWidthNormal,
            minHeight: 100,
            maxHeight: 500,
          ),
          child: _buildBody(context),
        ),
      ),
    );
  }
}
