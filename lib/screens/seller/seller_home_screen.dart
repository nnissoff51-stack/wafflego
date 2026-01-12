import 'package:flutter/material.dart';
import '../../models/user.dart';

class SellerHomeScreen extends StatelessWidget {
  final UserModel currentUser;
  final bool isShopOpen;
  final VoidCallback onToggleShopStatus;

  const SellerHomeScreen({
    super.key,
    required this.currentUser,
    required this.isShopOpen,
    required this.onToggleShopStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello, ${currentUser.fullName}!", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const Text("Let's sell some waffles!"),
                    ],
                  ),
                  const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isShopOpen ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(isShopOpen ? Icons.store : Icons.store_mall_directory, color: isShopOpen ? Colors.green : Colors.red, size: 40),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        isShopOpen ? "SHOP STATUS: OPEN" : "SHOP STATUS: CLOSED",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isShopOpen ? Colors.green.shade900 : Colors.red.shade900),
                      ),
                    ),
                    Switch(
                      value: isShopOpen, 
                      // CUMA OWNER BOLEH TEKAN
                      onChanged: currentUser.role == 'Owner' ? (_) => onToggleShopStatus() : null,
                      activeThumbColor: Colors.green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text("Today's Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                children: [
                  _buildStatCard("Orders", "25", Colors.blue),
                  const SizedBox(width: 15),
                  _buildStatCard("Sales", "RM 450", Colors.orange),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}