import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/enum/gender.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
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
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode userNameNode = FocusNode();
  final FocusNode addressNode = FocusNode();
  DateTime birthDay = DateTime.now();
  bool isSigning = false;
  GenderEnum _selectedGender = GenderEnum.male;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailNode.dispose();
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
    // CommonResponse result = await Api.requestSignUp(
    //   email: emailController.text,
    //   password: passwordController.text,
    //   phone: phoneController.text,
    //   address: addressController.text,
    //   gender: _selectedGender,
    //   birthDay: DateFormat("yyyy/MM/dd").format(birthDay),
    //   userName: userNameController.text,
    // );
    // if (result.isSuccess) {
    //   Fluttertoast.showToast(
    //     msg: result.msg,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 5,
    //     backgroundColor: primaryColor,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //     webBgColor: successColorToast,
    //   );
    if (context.mounted) {
      context.goNamed(RouteConstants.verifyOTP,
          extra: {"email": "tdhuaco372001@gmail.com"} );
    }
    // } else {
    //   Fluttertoast.showToast(
    //     msg: result.msg,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 5,
    //     backgroundColor: primaryColor,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //     webBgColor: dangerColorToast,
    //   );
    // }
    // setState(() {
    //   isSigning = false;
    // });
  }

  Widget buildTitle(BuildContext context) {
    return Text(
      "Tạo tài khoản",
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontSize: 24,
          ),
    );
  }

  Widget buildTitleTextField(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        text,
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
              Images.backgroundLogin,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 120,
            top: 80,
            bottom: 80,
            child: Image.asset(
              Images.logoAppDarkMode,
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
              padding: EdgeInsets.all(kDefaultPadding),
              height: double.infinity,
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTitle(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Đã có tài khoản?",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      InkWell(
                        onTap: () {
                          if (mounted) {
                            context.pop();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: kPadding10 / 2,
                            vertical: kPadding10 / 2,
                          ),
                          child: Text(
                            " Đăng nhập",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildTitleTextField(context, "Họ và tên"),
                  AppInput(
                    name: "name",
                    keyboardType: TextInputType.name,
                    icon: Icons.person_outline,
                    controller: userNameController,
                    focusNode: userNameNode,
                    // placeHolder: "Nhập tên",
                  ),
                  buildTitleTextField(context, "Email"),
                  AppInput(
                    name: "email",
                    keyboardType: TextInputType.name,
                    icon: Icons.alternate_email,
                    controller: emailController,
                    focusNode: emailNode,
                    // placeHolder: "Email",
                  ),
                  buildTitleTextField(context, "Số điện thoại"),
                  AppInput(
                    name: "phone",
                    keyboardType: TextInputType.number,
                    icon: Icons.phone,
                    controller: phoneController,
                    focusNode: phoneNode,
                    // placeHolder: "Nhập số điện thoại",
                  ),
                  buildTitleTextField(context, "Mật khẩu"),
                  AppInput(
                    name: "password",
                    keyboardType: TextInputType.name,
                    icon: Icons.lock,
                    controller: passwordController,
                    focusNode: passwordNode,
                    // placeHolder: "Nhập mật khẩu",
                    isPassword: true,
                  ),
                  buildTitleTextField(context, "Địa chỉ"),
                  AppInput(
                    name: "address",
                    keyboardType: TextInputType.name,
                    icon: Icons.location_on,
                    controller: addressController,
                    focusNode: addressNode,
                    // placeHolder: "Nhập địa chỉ",
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitleTextField(context, "Ngày sinh"),
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
                                      DateFormat("yyyy/MM/dd").format(birthDay),
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
                            buildTitleTextField(context, "Giới tính"),
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
                                  child: Text(label.name),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Text(
                                  _selectedGender.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 14,
                                        // color: Colors.white,
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
                    margin: EdgeInsets.only(top: kDefaultPadding * 2),
                    child: AppButton(
                      "Đăng ký",
                      loading: isSigning,
                      mainAxisSize: MainAxisSize.max,
                      onPressed: () {
                        setState(() {
                          isSigning = true;
                        });
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
