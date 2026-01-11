import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int selectedTab = 0; // 0=Order,1=In Progress,2=Completed

  List<Map<String, dynamic>> orders = [
    {
      'id': '#005',
      'item': 'Blueberry x1',
      'price': 'RM 5.00',
      'status': 'pending',
    },
    {
      'id': '#003',
      'item': 'Kaya x1',
      'price': 'RM 4.50',
      'status': 'in_progress',
    },
    {
      'id': '#001',
      'item': 'Chocolate x2',
      'price': 'RM 9.50',
      'status': 'completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF2CC),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 🔘 TAB BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tabButton("Order", 0),
                tabButton("In Progress", 1),
                tabButton("Completed", 2),
              ],
            ),

            const SizedBox(height: 20),

            // 📦 ORDER LIST
            Expanded(
              child: ListView(
                children: orders
                    .where((order) {
                      if (selectedTab == 0) return order['status'] == 'pending';
                      if (selectedTab == 1) return order['status'] == 'in_progress';
                      return order['status'] == 'completed';
                    })
                    .map((order) => orderCard(order))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔘 TAB UI
  Widget tabButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: selectedTab == index ? Colors.orange : Colors.orange.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // 📦 ORDER CARD
  Widget orderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order ${order['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(order['item']),
          Text(order['price']),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              statusButton(order),
              if (order['status'] == 'completed')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Completed",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔄 STATUS BUTTON LOGIC
  Widget statusButton(Map<String, dynamic> order) {
    if (order['status'] == 'pending') {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            order['status'] = 'in_progress';
          });
        },
        child: const Text("Pending"),
      );
    }

    if (order['status'] == 'in_progress') {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            order['status'] = 'completed';
          });
        },
        child: const Text("Complete"),
      );
    }

    return const SizedBox();
  }
}
