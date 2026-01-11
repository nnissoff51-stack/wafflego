import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int selectedTab = 0; // 0=Order, 1=In Progress, 2=Completed

  // Data dummy orders
  List<Map<String, dynamic>> orders = [
    {'id': '#005', 'item': 'Blueberry x1', 'price': 'RM 5.00', 'status': 'pending'},
    {'id': '#003', 'item': 'Kaya x1', 'price': 'RM 4.50', 'status': 'in_progress'},
    {'id': '#001', 'item': 'Chocolate x2', 'price': 'RM 9.50', 'status': 'completed'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CC),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "CUSTOMER ORDERS",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF8B4513)),
            ),
            const SizedBox(height: 20),

            // 🔘 TAB BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tabButton("Pending", 0),
                _tabButton("Processing", 1),
                _tabButton("Done", 2),
              ],
            ),
            const SizedBox(height: 20),

            // 📦 ORDER LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: orders
                    .where((order) {
                      if (selectedTab == 0) return order['status'] == 'pending';
                      if (selectedTab == 1) return order['status'] == 'in_progress';
                      return order['status'] == 'completed';
                    })
                    .map((order) => _orderCard(order))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String text, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.orange.shade200,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black12, blurRadius: 4)] : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.orange.shade900,
          ),
        ),
      ),
    );
  }

  Widget _orderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Order ID: ${order['id']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(order['price'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
          const Divider(height: 20),
          Text(order['item'], style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 15),
          _statusButton(order),
        ],
      ),
    );
  }

  Widget _statusButton(Map<String, dynamic> order) {
    if (order['status'] == 'pending') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          onPressed: () => setState(() => order['status'] = 'in_progress'),
          child: const Text("Accept Order"),
        ),
      );
    }
    if (order['status'] == 'in_progress') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
          onPressed: () => setState(() => order['status'] = 'completed'),
          child: const Text("Mark as Completed"),
        ),
      );
    }
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.check_circle, color: Colors.green),
        SizedBox(width: 5),
        Text("Finished", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
      ],
    );
  }
}