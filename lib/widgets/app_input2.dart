import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class AppInput2 extends StatefulWidget {
  final String name;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? icon;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String placeHolder;
  final FocusNode focusNode;
  final int maxLines;
  @override
  State<AppInput2> createState() => _AppInput2State();

  const AppInput2({
    required this.name,
    required this.keyboardType,
    this.isPassword = false,
    this.icon,
    required this.controller,
    this.onChanged,
    required this.placeHolder,
    required this.focusNode,
    this.maxLines = 1,
    Key? key,
  }) : super(key: key);
}

class _AppInput2State extends State<AppInput2> {
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
        border: Border(
          bottom: BorderSide(
            color:
                widget.focusNode.hasFocus ? primaryColor : Colors.transparent,
          ),
        ),
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        inputFormatters: widget.keyboardType == TextInputType.number ||
                widget.keyboardType == TextInputType.phone
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : null,
        maxLines: widget.maxLines,
        onChanged: (value) {
          if (widget.onChanged != null) widget.onChanged!(value);
        },
        keyboardType: widget.keyboardType,
        obscureText: isInvisible,
        style: TextStyle(
          color: textColor,
        ),
        decoration: InputDecoration(
          fillColor: backgroundColor,
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
              width: 1.6,
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 14,
            left: 10,
            right: 10,
          ),
          prefixIcon: widget.icon,
          hintText: widget.placeHolder,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: subTextColor,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    isInvisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  color: Colors.grey.withOpacity(0.3),
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
