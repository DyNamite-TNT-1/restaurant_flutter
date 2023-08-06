import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class NoDataFoundView extends StatelessWidget {
  const NoDataFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Center(
        child: Column(
          children: [
            Image.asset(
              Images.noDataFound,
              height: 200,
              width: 200,
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            Text(
              "Không có dữ liệu!",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
