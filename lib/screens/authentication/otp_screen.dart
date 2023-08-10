import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool isVerifyingOTP = false;

  Widget buildTitle(BuildContext context) {
    return Text("Xác thực OTP",
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Image.asset(
              Images.logoAppNoBg,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTitle(context),
                SizedBox(
                  height: kDefaultPadding,
                ),
                Container(
                  width: 300,
                  child: PinCodeTextField(
                    autoDisposeControllers: false,
                    appContext: context,
                    length: 6,
                    onChanged: (value) {},
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
                    onCompleted: (v) {},
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
                      // setState(() {
                      //   isSigning = true;
                      // });
                      // _requestSignUp(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
