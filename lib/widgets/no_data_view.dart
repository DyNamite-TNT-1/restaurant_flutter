import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/utils/translate.dart';

class NoDataFoundView extends StatelessWidget {
  const NoDataFoundView({super.key, this.message = "no_data_found"});
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
              Translate.of(context).translate(message),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
