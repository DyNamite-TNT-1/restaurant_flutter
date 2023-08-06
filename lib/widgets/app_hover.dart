import 'package:flutter/material.dart';

class HoverComponent extends StatefulWidget {
  const HoverComponent({
    super.key,
    required this.child,
    this.onEnter,
    this.onExit,
    this.onHover,
    this.hoverToUpdateBackground = true,
    this.updateStateHover,
    this.imageHover = false,
  });
  final void Function()? onEnter;
  final void Function()? onHover;
  final void Function()? onExit;
  final void Function(bool)? updateStateHover;
  final bool hoverToUpdateBackground;
  final bool imageHover;
  final Widget child;
  @override
  State<HoverComponent> createState() => _HoverComponentState();
}

class _HoverComponentState extends State<HoverComponent> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.hoverToUpdateBackground
            ? (isHovering ? Colors.grey.withOpacity(0.2) : Colors.transparent)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: MouseRegion(
          cursor: widget.imageHover
              ? (isHovering
                  ? SystemMouseCursors.zoomIn
                  : SystemMouseCursors.basic)
              : SystemMouseCursors.basic,
          onEnter: (p) {
            setState(() => isHovering = true);
            if (widget.onEnter != null) {
              widget.onEnter!();
            }
            if (widget.updateStateHover != null) {
              widget.updateStateHover!(true);
            }
          },
          onExit: (p) {
            setState(() => isHovering = false);
            if (widget.onExit != null) {
              widget.onExit!();
            }
            if (widget.updateStateHover != null) {
              widget.updateStateHover!(false);
            }
          },
          onHover: (p) {
            if (widget.onHover != null) {
              widget.onHover!();
            }
          },
          child: widget.child),
    );
  }
}
