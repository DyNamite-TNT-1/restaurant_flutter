import 'package:flutter/material.dart';
import 'package:restaurant_flutter/widgets/app_button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: AppButton(
              "Đăng xuất",
              onPressed: () {
                
              },
            ),
          ),
        ],
      ),
    );
  }
}
