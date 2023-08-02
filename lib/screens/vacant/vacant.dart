import 'package:flutter/material.dart';

class VacantScreen extends StatefulWidget {
  const VacantScreen({super.key});

  @override
  State<VacantScreen> createState() => _VacantScreenState();
}

class _VacantScreenState extends State<VacantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VacantScreen"),
      ),
      body: Center(
        child: Text("VacantScreen"),
      ),
    );
  }
}
