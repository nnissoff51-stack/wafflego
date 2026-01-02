import 'package:flutter/material.dart';

class DashboardOneContent extends StatelessWidget {
  final bool isShopOpen;

  const DashboardOneContent({super.key, required this.isShopOpen});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Sales Overview Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFDAA3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SALES OVERVIEW', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text(
                  'RM 300.00',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFF8C00)),
                ),
                const Text('TOTAL SALES', style: TextStyle(fontSize: 11, color: Color(0xFFFF8C00))),
                const SizedBox(height: 20),
                _buildInfoRow('Date:', '12/12/2025'),
                const SizedBox(height: 12),
                _buildInChargeRow(['Alin', 'Ali']),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryCard("TODAY'S FAVORITE", Icons.star, ["Chocolate", "Peanut", "Strawberry"]),
          const SizedBox(height: 16),
          _buildOrderCountCard("30"),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInChargeRow(List<String> names) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('In Charge:', style: TextStyle(fontWeight: FontWeight.w500)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: names.map((name) => Text('• $name', style: const TextStyle(fontWeight: FontWeight.bold))).toList(),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, IconData icon, List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFFFF9E6), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: Colors.orange, size: 20), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(item),
          )),
        ],
      ),
    );
  }

  Widget _buildOrderCountCard(String count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFFFF9E6), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.shopping_cart, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          const Text("TODAY'S ORDERS", style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(count, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}