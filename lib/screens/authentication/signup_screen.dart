import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/enum/gender.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/utils/utils.dart';
import 'package:restaurant_flutter/widgets/app_popup_menu_button.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();
  final FocusNode userNameNode = FocusNode();
  final FocusNode addressNode = FocusNode();
  DateTime birthDay = DateTime.now();
  bool isSigning = false;
  GenderEnum _selectedGender = GenderEnum.male;
  String signUpValidateText = "";
  bool isShowValidateText = false;
  bool showErrorText = false;
  String errorText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailNode.dispose();
    phoneController.dispose();
    passwordNode.dispose();
    emailController.clear();
    passwordController.clear();
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDay,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Chọn ngày',
      confirmText: 'Xác nhận',
      cancelText: 'Thoát',
    );
    if (picked != null && picked != birthDay) {
      setState(() {
        birthDay = picked;
      });
    }
  }

  Future<void> _requestSignUp(BuildContext context) async {
    setState(() {
      errorText = "";
      showErrorText = false;
    });
    if (userNameController.text.trim().isEmpty) {
      errorText = Translate.of(context).translate("VALIDATE_USERNAME_E001");
    } else if (emailController.text.trim().isEmpty) {
      errorText = Translate.of(context).translate("VALIDATE_EMAIL_E001");
    } else if (phoneController.text.trim().isEmpty) {
      errorText = Translate.of(context).translate("VALIDATE_PHONE_E001");
    } else if (passwordController.text.trim().isEmpty) {
      errorText = Translate.of(context).translate("VALIDATE_PASSWORD_E001");
    } else if (confirmPasswordController.text.trim().isEmpty) {
      errorText =
          Translate.of(context).translate("VALIDATE_CONFIRMPASSWORD_E001");
    } else if (addressController.text.trim().isEmpty) {
      errorText = Translate.of(context).translate("VALIDATE_ADDRESS_E001");
    } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
        .hasMatch(emailController.text)) {
      errorText = Translate.of(context).translate("VALIDATE_EMAIL_E002");
    } else if (!RegExp(r"^\d{10}$").hasMatch(phoneController.text)) {
      errorText = Translate.of(context).translate("VALIDATE_PHONE_E002");
    } else if (!RegExp(r"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{6,}$")
        .hasMatch(passwordController.text)) {
      errorText = Translate.of(context).translate("VALIDATE_PASSWORD_E002");
    } else if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      errorText =
          Translate.of(context).translate("VALIDATE_CONFIRMPASSWORD_E002");
    }
    if (errorText.isNotEmpty) {
      setState(() {
        showErrorText = true;
      });
      return;
    }
    setState(() {
      isSigning = true;
    });
    ResultModel result = await Api.requestSignUp(
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      phone: phoneController.text,
      address: addressController.text,
      gender: _selectedGender,
      birthDay: DateFormat("yyyy/MM/dd").format(birthDay),
      userName: userNameController.text,
    );
    if (result.isSuccess && mounted) {
      Fluttertoast.showToast(
        msg: Translate.of(context).translate(result.message),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: primaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
        webBgColor: successColorToast,
        webShowClose: true,
      );
      if (mounted) {
        context.goNamed(RouteConstants.verifyOTP,
            extra: {"email": emailController.text});
      }
    } else {
      Fluttertoast.showToast(
        msg: Translate.of(context).translate(result.message),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: primaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
        webBgColor: dangerColorToast,
      );
    }
    setState(() {
      isSigning = false;
    });
  }

  Widget _buildError(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: kPadding10 / 2,
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

  Widget buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Translate.of(context).translate("create_account"),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              Translate.of(context).translate("do_have_account"),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            InkWell(
              onTap: () {
                context.goNamed(RouteConstants.dashboard);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kPadding10 / 2,
                  vertical: kPadding10 / 2,
                ),
                child: Text(
                  " ${Translate.of(context).translate("sign_in")}",
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
    );
  }

  Widget buildTitleTextField(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        Translate.of(context).translate(text),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              AssetImages.backgroundLogin,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 120,
            top: 80,
            bottom: 80,
            child: Image.asset(
              AssetImages.logoAppDarkMode,
              height: 300,
              width: 300,
            ),
          ),
          Positioned(
            right: 200,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kPadding10,
              ),
              height: double.infinity,
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTitle(context),
                  if (showErrorText) _buildError(context),
                  buildTitleTextField(context, "first_last_name"),
                  AppInput(
                    name: "name",
                    keyboardType: TextInputType.name,
                    icon: Icons.person_outline,
                    controller: userNameController,
                    focusNode: userNameNode,
                  ),
                  buildTitleTextField(context, "email"),
                  AppInput(
                    name: "email",
                    keyboardType: TextInputType.name,
                    icon: Icons.alternate_email,
                    controller: emailController,
                    focusNode: emailNode,
                  ),
                  buildTitleTextField(context, "phone"),
                  AppInput(
                    name: "phone",
                    keyboardType: TextInputType.number,
                    icon: Icons.phone,
                    controller: phoneController,
                    focusNode: phoneNode,
                  ),
                  buildTitleTextField(context, "password"),
                  AppInput(
                    name: "password",
                    keyboardType: TextInputType.name,
                    icon: Icons.lock,
                    controller: passwordController,
                    focusNode: passwordNode,
                    isPassword: true,
                  ),
                  buildTitleTextField(context, "confirm_password"),
                  AppInput(
                    name: "confirmPassword",
                    keyboardType: TextInputType.name,
                    icon: Icons.lock_reset,
                    controller: confirmPasswordController,
                    focusNode: confirmPasswordNode,
                    isPassword: true,
                  ),
                  buildTitleTextField(context, "address"),
                  AppInput(
                    name: "address",
                    keyboardType: TextInputType.name,
                    icon: Icons.location_on,
                    controller: addressController,
                    focusNode: addressNode,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitleTextField(context, "birthday"),
                            InkWell(
                              borderRadius:
                                  BorderRadius.circular(kCornerNormal),
                              onTap: () {
                                selectDate(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(kCornerNormal),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.6,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.date_range_outlined,
                                      color: primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      DateFormat("dd/MM/yyyy").format(birthDay),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: kDefaultPadding,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitleTextField(context, "gender"),
                            AppPopupMenuButton<GenderEnum>(
                              height: 45,
                              menuDropBgColor: Colors.transparent,
                              menuDropBorderColor: primaryColor,
                              buttonBgColor: Colors.transparent,
                              buttonBorderColor: primaryColor,
                              value: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                              items: GenderEnum.allGenderEnum(),
                              filterItemBuilder: (context, label) {
                                return DropdownMenuItem<GenderEnum>(
                                  value: label,
                                  child: Text(Translate.of(context).translate(label.name)),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Text(
                                  Translate.of(context).translate(_selectedGender.name),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: kPadding10),
                    child: AppButton(
                      Translate.of(context).translate("sign_up").toUpperCase(),
                      loading: isSigning,
                      mainAxisSize: MainAxisSize.max,
                      onPressed: () {
                        _requestSignUp(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
