import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class AppPopupMenuButton<T> extends StatefulWidget {
  const AppPopupMenuButton({
    super.key,
    required this.onSelected,
    required this.filterItemBuilder,
    required this.data,
    required this.initialValue,
    this.offset,
    this.title,
    this.icon,
    this.child,
    this.position,
    this.menuConstraints,
    this.tooltip,
  });
  final void Function(T value) onSelected;
  final PopupMenuItem<T> Function(BuildContext context, T label)
      filterItemBuilder;
  final List<T> data;
  final T initialValue;
  final String? tooltip;
  final BoxConstraints? menuConstraints;
  final Offset? offset;
  final PopupMenuPosition? position;
  final String? title;
  final Widget? icon;
  final Widget? child;
  @override
  State<AppPopupMenuButton> createState() => _TPopupMenuButtonState<T>();
}

class _TPopupMenuButtonState<T> extends State<AppPopupMenuButton<T>> {
  @override
  Widget build(BuildContext context) {
    final popUpItemBuilder = (widget.data).map<PopupMenuItem<T>>(
      (filter) {
        return widget.filterItemBuilder(context, filter);
      },
    ).toList();
    //Add title for pop up menu
    if (widget.title != null) {
      popUpItemBuilder.insert(
        0,
        PopupMenuItem(
          enabled: false,
          child: Text(
            widget.title ?? "",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: subTextColor),
          ),
        ),
      );
    }
    return PopupMenuButton<T>(
      initialValue: widget.initialValue,
      constraints: widget.menuConstraints ?? BoxConstraints(maxHeight: 5 * 80),
      offset: widget.offset ?? Offset(0, 10),
      position: widget.position ?? PopupMenuPosition.under,
      elevation: 1,
      tooltip: widget.tooltip ?? "",
      itemBuilder: (_) => popUpItemBuilder,
      icon: widget.icon,
      child: widget.child,
      onSelected: (value) => widget.onSelected(value),
    );
  }
}
