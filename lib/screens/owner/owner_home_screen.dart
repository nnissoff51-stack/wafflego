import 'package:flutter/material.dart';
import '../../models/user.dart';

class OwnerHomeScreen extends StatefulWidget {
  final UserModel currentUser;
  const OwnerHomeScreen({super.key, required this.currentUser});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  bool isShopOpen = true; // Ini nanti link ke Supabase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D6),
      appBar: AppBar(
        title: const Text("Owner Dashboard"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MASTER SHOP STATUS CONTROL
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isShopOpen ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isShopOpen ? Colors.green : Colors.red, width: 2),
              ),
              child: Row(
                children: [
                  Icon(isShopOpen ? Icons.store : Icons.store_mall_directory, 
                       color: isShopOpen ? Colors.green : Colors.red, size: 40),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isShopOpen ? "SHOP IS OPEN" : "SHOP IS CLOSED",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isShopOpen ? Colors.green.shade900 : Colors.red.shade900)),
                        const Text("Control shop visibility for all staff", style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  Switch(
                    value: isShopOpen, 
                    onChanged: (val) => setState(() => isShopOpen = val),
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            
            const Text("TODAY'S SUMMARY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatCard("Total Orders", "25", Colors.blue),
                const SizedBox(width: 15),
                _buildStatCard("Total Sales", "RM 450", Colors.orange),
              ],
            ),
            const SizedBox(height: 25),
            
            // Placeholder for Chart
            const Text("WEEKLY SALES ANALYTICS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
            const SizedBox(height: 10),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: const Center(child: Icon(Icons.bar_chart, size: 50, color: Colors.grey)),
            )
          ],
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
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}