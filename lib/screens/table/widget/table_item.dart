import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class TableItem extends StatefulWidget {
  const TableItem({super.key, required this.id});
  final String id;
  @override
  State<TableItem> createState() => _TableItemState();
}

class _TableItemState extends State<TableItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(
          kCornerNormal,
        ),
        border: Border.all(),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Center(
            child: Text(
              "Bàn ${widget.id}",
            ),
          ),
        ),
      ),
    );
  }
}
