import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class SeatReservationItem extends StatefulWidget {
  const SeatReservationItem({super.key});

  @override
  State<SeatReservationItem> createState() => _SeatReservationItemState();
}

class _SeatReservationItemState extends State<SeatReservationItem> {
  @override
  Widget build(BuildContext cntext) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCornerSmall),
        color: Color(0XFF3FA9F5),
      ),
    );
  }
}