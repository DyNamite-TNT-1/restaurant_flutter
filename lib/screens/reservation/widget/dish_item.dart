import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/models/service/dish.dart';

class ReservationDetailDishItem extends StatelessWidget {
  const ReservationDetailDishItem({
    super.key, required this.item,
  });

  final DishDetailModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: kPadding10, vertical: kPadding10 / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
           item.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                ),
          ),
          Text(
            item.priceStr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          )
        ],
      ),
    );
  }
}
