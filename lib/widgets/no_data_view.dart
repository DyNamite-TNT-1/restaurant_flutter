import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class NoDataFoundView extends StatelessWidget {
  const NoDataFoundView({super.key, this.message = "Không có dữ liệu"});
  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Center(
        child: Column(
          children: [
            Image.asset(
              AssetImages.noDataFound,
              height: 200,
              width: 200,
            ),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
