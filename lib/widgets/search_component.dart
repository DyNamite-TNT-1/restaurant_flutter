import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class SearchComponent extends StatefulWidget {
  final Function callBackTextInput;
  final Function? callbackSaveText;
  final TextEditingController? textEditingController;
  final String? keyHintText;
  final bool enable;
  final bool autoFocus;
  final bool showButtonSaveText;

  const SearchComponent({
    Key? key,
    required this.callBackTextInput,
    this.textEditingController,
    this.callbackSaveText,
    this.keyHintText,
    this.enable = true,
    this.autoFocus = false,
    this.showButtonSaveText = false,
  }) : super(key: key);

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  @override
  void initState() {
    super.initState();
    if (widget.textEditingController != null) {
      widget.textEditingController!.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  TextField build(BuildContext context) {
    return TextField(
      enabled: widget.enable,
      controller: widget.textEditingController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        prefixIcon: SvgPicture.asset(
          AssetImages.icSearch,
          width: 30,
          height: 30,
          fit: BoxFit.scaleDown,
          colorFilter: ColorFilter.mode(
            textColor,
            BlendMode.srcIn,
          ),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Visibility(
              visible: widget.textEditingController!.text.isNotEmpty,
              child: IconButton(
                splashRadius: 24,
                icon: SvgPicture.asset(
                  AssetImages.icClear,
                  width: 24,
                  height: 24,
                  fit: BoxFit.scaleDown,
                  colorFilter: ColorFilter.mode(
                    textColor,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  if (widget.textEditingController?.text != '') {
                    widget.textEditingController?.clear();
                    widget.callBackTextInput('');
                  }
                },
              ),
            ),
            Visibility(
              visible: widget.showButtonSaveText,
              child: IconButton(
                splashRadius: 24,
                icon: SvgPicture.asset(
                  AssetImages.icChecked,
                  width: 24,
                  height: 24,
                  fit: BoxFit.scaleDown,
                  colorFilter: ColorFilter.mode(
                    textColor,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  if (widget.callbackSaveText != null) {
                    widget
                        .callbackSaveText!(widget.textEditingController?.text);
                    widget.textEditingController?.clear();
                  }
                },
              ),
            ),
          ],
        ),
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        hintText: "Search",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Color(0xffE5E8EC),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Color(0xffE5E8EC), width: 1),
        ),
      ),
      minLines: 1,
      maxLines: 1,
      onChanged: (value) {
        print(value);
        widget.callBackTextInput(value);
      },
      autofocus: widget.autoFocus,
    );
  }
}
