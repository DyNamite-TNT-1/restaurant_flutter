import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';

class DrinkScreen extends StatefulWidget {
  const DrinkScreen({super.key});

  @override
  State<DrinkScreen> createState() => _DrinkScreenState();
}

class _DrinkScreenState extends State<DrinkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("DrinkScreen"),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      context.goNamed(
                        RouteConstants.drinkDetail,
                        pathParameters: {
                          "id": index.toString(),
                        },
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      margin: EdgeInsets.all(20),
                      child: Text("drink $index"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
