import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Dashboard"),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      context.goNamed(
                        RouteConstants.dishDetail,
                        pathParameters: {
                          "id": index.toString(),
                        },
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      margin: EdgeInsets.all(20),
                      child: Text("item $index"),
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
