
import 'package:flutter/material.dart';

class DishDetailScreen extends StatefulWidget {
  const DishDetailScreen({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dish Detail Screen"),
      ),
      body: Center(
        child: Text(
          widget.id,
        ),
      ),
    );
  }
}
