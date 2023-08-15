import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/models/service/table.dart';

class SeatReservationItem extends StatefulWidget {
  const SeatReservationItem({super.key, required this.item});
  final TableDetailModel item;

  @override
  State<SeatReservationItem> createState() => _SeatReservationItemState();
}

class _SeatReservationItemState extends State<SeatReservationItem> {
  Color _getColor(int available) {
    switch (available) {
      case 0:
        return Colors.grey.withOpacity(0.7);
      case 1:
        return Color(0XFF3FA9F5);
      default:
        return Colors.grey.withOpacity(0.7);
    }
  }

  @override
  Widget build(BuildContext cntext) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCornerSmall),
        // border: Border.all(
        //   color: _getColor(widget.item.available),
        // ),
        color: _getColor(widget.item.available),
      ),
      child: widget.item.available == 0
          ? Center(
              child: Icon(Icons.clear),
            )
          : null,
    );
  }
}
