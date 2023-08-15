import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/widgets/app_button.dart';

class DishReservationItem extends StatefulWidget {
  const DishReservationItem({super.key});

  @override
  State<DishReservationItem> createState() => _DishReservationItemState();
}

class _DishReservationItemState extends State<DishReservationItem> {
  Widget _iconBtn(
    BuildContext context,
    IconData icon,
    Function onTap,
  ) {
    return InkWell(
      onTap: onTap(),
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.red,
          ),
        ),
        child: Icon(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 70,
      margin: EdgeInsets.symmetric(
        horizontal: kPadding10,
        vertical: kPadding10 / 2,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(kCornerMedium),
            child: Image.asset(
              Images.logoApp,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Tên món"),
              Text("100.000"),
            ],
          ),
          _iconBtn(
            context,
            Icons.delete_forever_outlined,
            () {},
          )
        ],
      ),
    );
  }
}
