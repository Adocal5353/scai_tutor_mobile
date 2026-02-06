import 'package:flutter/material.dart';

class LoginUserCard extends StatelessWidget {
  final IconData icon;
  final String userType;

  LoginUserCard({super.key, required this.icon, required this.userType});
  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [Icon(icon), Text(userType)]));
  }
}
