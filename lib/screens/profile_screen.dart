import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF5E8),
        elevation: 0,
        centerTitle: true,
        title: const Text("Profile"),
      ),
      body: const Center(
        child: Text(
          "Profile tab",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}