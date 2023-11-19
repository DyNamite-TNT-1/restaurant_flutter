import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCornerSmall),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }
}
