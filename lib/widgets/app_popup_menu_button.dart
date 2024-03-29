import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class AppPopupMenuButton<T> extends StatefulWidget {
  const AppPopupMenuButton({
    super.key,
    required this.onChanged,
    required this.filterItemBuilder,
    required this.items,
    required this.value,
    required this.child,
    this.height = 40,
    this.menuDropBorderColor = Colors.transparent,
    this.menuDropBgColor = Colors.grey,
    this.buttonBorderColor = Colors.transparent,
    this.buttonBgColor = Colors.grey,
  });
  final void Function(T value) onChanged;
  final DropdownMenuItem<T> Function(BuildContext context, T label)
      filterItemBuilder;
  final List<T> items;
  final T value;
  final Widget child;
  final double height;
  final Color menuDropBorderColor;
  final Color menuDropBgColor;
  final Color buttonBorderColor;
  final Color buttonBgColor;
  @override
  State<AppPopupMenuButton> createState() => _TPopupMenuButtonState<T>();
}

class _TPopupMenuButtonState<T> extends State<AppPopupMenuButton<T>> {
  late List<DropdownMenuItem<T>> popUpItemBuilder;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    popUpItemBuilder = (widget.items).map<DropdownMenuItem<T>>(
      (filter) {
        return widget.filterItemBuilder(context, filter);
      },
    ).toList();
    return SizedBox(
      height: widget.height,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: Colors.white,
              ),
          onChanged: (value) {
            widget.onChanged(value as T);
          },
          value: widget.value,
          items: popUpItemBuilder,
          hint: widget.child,
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kCornerSmall),
              border: Border.all(color: widget.buttonBorderColor),
              color: widget.buttonBgColor,
            ),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            iconSize: 16,
            iconEnabledColor: Colors.white,
          ),
          dropdownStyleData: DropdownStyleData(
            // maxHeight: 200,
            // width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: widget.menuDropBorderColor,
              ),
              color: widget.menuDropBgColor,
            ),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
        ),
      ),
    );
  }
}
