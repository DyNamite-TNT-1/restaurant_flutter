import 'package:flutter/material.dart';

class DrinkDetailScreen extends StatefulWidget {
  const DrinkDetailScreen({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<DrinkDetailScreen> createState() => _DrinkDetailScreenState();
}

class _DrinkDetailScreenState extends State<DrinkDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drink Detail Screen"),
      ),
      body: Center(
        child: Text(
          widget.id,
        ),
      ),
    );
  }
}
