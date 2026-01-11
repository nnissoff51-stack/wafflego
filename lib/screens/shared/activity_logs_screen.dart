import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'choose_screen.dart'; // Import skrin mula

class ActivityLogsScreen extends StatefulWidget {
  final UserModel currentUser;

  const ActivityLogsScreen({
    super.key,
    required this.currentUser,
  });

  @override
  State<ActivityLogsScreen> createState() => _ActivityLogsScreenState();
}

class _ActivityLogsScreenState extends State<ActivityLogsScreen> {
  
  // Fungsi Logout
  void _logout(BuildContext context) {
    // Navigator ni akan buang semua skrin lama dan balik ke ChooseScreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ChooseScreen()),
      (route) => false, // Ini yang buat user tak boleh tekan 'Back' masuk balik
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Logs'),
        backgroundColor: widget.currentUser.role == 'owner' 
            ? const Color(0xFF8B4513) 
            : const Color(0xFFFF8C00),
        foregroundColor: Colors.white,
        actions: [
          // Butang Logout kat hujung App Bar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Logged in as: ${widget.currentUser.fullName}'),
            const SizedBox(height: 20),
            const Text('Activity history will appear here.'),
          ],
        ),
      ),
    );
  }

  // Dialog pengesahan sebelum logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _logout(context),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}