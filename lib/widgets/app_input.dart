import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class AppInput extends StatefulWidget {
  final String name;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData icon;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String placeHolder;
  final FocusNode focusNode;

  @override
  State<AppInput> createState() => _AppInputState();

  const AppInput({
    required this.name,
    required this.keyboardType,
    this.isPassword = false,
    required this.icon,
    required this.controller,
    this.onChanged,
    required this.placeHolder,
    required this.focusNode,
    Key? key,
  }) : super(key: key);
}

class _AppInputState extends State<AppInput> {
  bool isInvisible = false;
  @override
  void initState() {
    isInvisible = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCornerNormal),
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: (value) {
          if (widget.onChanged != null) widget.onChanged!(value);
        },
        keyboardType: widget.keyboardType,
        obscureText: isInvisible,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          fillColor: inputBackgroundColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kCornerNormal),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1.6,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kCornerNormal),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              // color: Colors.transparent,
              width: 1.6,
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 14),
          prefixIcon: Icon(
            widget.icon,
            color: Theme.of(context).primaryColor,
          ),
          hintText: widget.placeHolder,
          hintStyle: const TextStyle(
            color: Color(0xffB3B3B3),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    isInvisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  color: Colors.grey.withOpacity(0.5),
                  onPressed: () => {
                    setState(() {
                      isInvisible = !isInvisible;
                    })
                  },
                )
              : null,
        ),
        validator: (String? value) {
          // if (value!.isEmpty) {
          //   return "${widget.placeHolder} không được rỗng";
          // }
          // switch (widget.name) {
          //   case "password":
          //   case "repeat_password":
          //     if (value.length < 6 || value.length > 16) {
          //       return "Mật khẩu tối thiểu 6 ký tự, tối đa 16";
          //     }
          //     break;
          //   case "phone":
          //     if (value.length != 10) {
          //       return "Số điện thoại phải có 10 chữ số";
          //     }
          //     if (!RegExp(
          //             r"^(0?)(3[2-9]|5[6|8|9]|7[0|6-9]|8[0-6|8|9]|9[0-4|6-9])[0-9]{7}$")
          //         .hasMatch(value)) {
          //       return "Số điện thoại không phù hợp";
          //     }
          //     break;
          //   default:
          // }
          return null;
        },
      ),
    );
  }
}
