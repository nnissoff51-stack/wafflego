import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF5E8),
        elevation: 0,
        centerTitle: true,
        title: const Text("Orders"),
      ),
      body: const Center(
        child: Text(
          "Orders tab (nanti sambung cart)",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}