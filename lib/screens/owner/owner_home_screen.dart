import 'package:flutter/material.dart';
import '../../models/user.dart';

class OwnerHomeScreen extends StatefulWidget {
  final UserModel currentUser;

  const OwnerHomeScreen({
    super.key,
    required this.currentUser,
  });

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics, size: 80, color: Color(0xFF8B4513)),
            const SizedBox(height: 16),
            Text(
              'Welcome, ${widget.currentUser.fullName}!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Sales Overview & Reports'),
          ],
        ),
      ),
    );
  }
}