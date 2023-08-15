import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          onTap();
        },
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
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: kPadding10),
              width: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kCornerLarge),
                color: primaryColor,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(kCornerMedium),
              child: Image.asset(
                Images.logoApp,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: kDefaultPadding,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tên món",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                      ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "100.000 VNĐ",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: primaryColor,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                _iconBtn(
                  context,
                  Icons.delete_forever_outlined,
                  () {},
                ),
                SizedBox(
                  width: kPadding10,
                ),
                _iconBtn(
                  context,
                  Icons.add,
                  () {},
                ),
                SizedBox(
                  width: kPadding10,
                ),
                _iconBtn(
                  context,
                  Icons.remove,
                  () {},
                ),
              ],
            ),
            SizedBox(
              width: kPadding15 * 2,
            ),
          ],
        ),
      ),
    );
  }
}
