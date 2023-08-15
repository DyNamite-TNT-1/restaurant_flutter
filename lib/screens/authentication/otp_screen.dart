import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.email});

  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool isVerified = false;
  bool isVerifyingOTP = false;

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
  }

  Future<void> _verifyOTP(BuildContext context) async {
    if (_otpController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Bạn phải điền đủ OTP",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: primaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
        webBgColor: dangerColorToast,
      );
      return;
    }
    setState(() {
      isVerifyingOTP = true;
    });
    ResultModel result = await Api.verifyOTPSignUp(
        login: widget.email, otp: _otpController.text);
    if (result.isSuccess) {
      if (result.isSuccess) {
        Fluttertoast.showToast(
          msg: result.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: primaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
          webBgColor: successColorToast,
        );
        setState(() {
          isVerified = true;
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: result.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: primaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
        webBgColor: dangerColorToast,
      );
    }
    setState(() {
      isVerifyingOTP = false;
    });
  }

  Widget buildTitle(BuildContext context) {
    return Column(
      children: [
        Text(
          "Xác thực OTP",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
        ),
        SizedBox(
          height: 5,
        ),
        !isVerified
            ? RichText(
                text: TextSpan(
                  text: "Mã OTP đã được gửi tới ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                  children: [
                    TextSpan(
                      text: widget.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    TextSpan(
                      text: ". Vui lòng kiểm tra hòm thư!",
                    ),
                  ],
                ),
              )
            : Text("Xác thực thành công, vui lòng trở lại trang chủ!"),
      ],
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 200, vertical: 100),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
            ),
            padding: EdgeInsets.all(kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  Images.logoAppDarkModeNoBg,
                  height: 400,
                  width: 400,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTitle(context),
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    !isVerified
                        ? _buildOTP(context)
                        : AppButton("Quay về trang chủ", onPressed: () {
                            context.goNamed(RouteConstants.dashboard);
                          }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildOTP(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          child: PinCodeTextField(
            autoDisposeControllers: false,
            appContext: context,
            length: 6,
            onChanged: (value) {},
            textStyle: TextStyle(
              color: Colors.white,
            ),
            pastedTextStyle: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
            ),
            animationType: AnimationType.fade,
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            pinTheme: PinTheme(
              borderWidth: 2,
              borderRadius: BorderRadius.circular(10),
              shape: PinCodeFieldShape.box,
            ),
            controller: _otpController,
            enabled: true,
            // dialogConfig: DialogConfig(
            //   dialogTitle: "Pass code",
            //   dialogContent: "Pass code desc",
            //   affirmativeText: "Paste",
            //   negativeText: "Cancel",
            // ),
            onCompleted: (v) {
              // _verifyOTP(context);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: kDefaultPadding * 2),
          width: 200,
          child: AppButton(
            "Xác thực",
            // loading: isSigning,
            mainAxisSize: MainAxisSize.max,
            onPressed: () {
              _verifyOTP(context);
            },
          ),
        ),
      ],
    );
  }
}
