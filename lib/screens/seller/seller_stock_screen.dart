import 'package:flutter/material.dart';
import '../../models/user.dart';

class SellerStockScreen extends StatefulWidget {
  final UserModel currentUser;
  final bool isShopOpen;
  final VoidCallback onToggleShopStatus;

  const SellerStockScreen({
    super.key,
    required this.currentUser,
    required this.isShopOpen,
    required this.onToggleShopStatus,
  });

  @override
  State<SellerStockScreen> createState() => _SellerStockScreenState();
}

class _SellerStockScreenState extends State<SellerStockScreen> {
  // Data dummy topping
  final List<Map<String, dynamic>> _toppings = [
    {'name': 'Chocolate', 'desc': 'Classic chocolate drizzle.', 'price': 4.50, 'image': 'chocolate.png'},
    {'name': 'Blueberry', 'desc': 'Bursting with tangy sweetness.', 'price': 4.50, 'image': 'blueberry.png'},
    {'name': 'Kaya', 'desc': 'Authentic Malaysian kaya...', 'price': 4.50, 'image': 'kaya.png'},
    {'name': 'Butter', 'desc': 'Rich, creamy butter melted...', 'price': 4.50, 'image': 'butter.png'},
  ];

  final Map<String, bool> _stockStatus = {
    'Chocolate': true,
    'Blueberry': true,
    'Kaya': true,
    'Butter': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _toppings.length,
                itemBuilder: (context, index) => _buildStockItem(_toppings[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isShopOpen ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Text(
                  "SHOP STATUS: ${widget.isShopOpen ? 'OPEN' : 'CLOSED'}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.isShopOpen ? Colors.green.shade900 : Colors.red.shade900,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: widget.isShopOpen,
                  onChanged: (val) => widget.onToggleShopStatus(),
                  activeColor: Colors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB74D),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                "TOPPINGS AVAILABILITY",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Available", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                SizedBox(width: 25),
                Text("Out of stock", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockItem(Map<String, dynamic> topping) {
    String name = topping['name'];
    bool isAvailable = _stockStatus[name] ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ColorFiltered(
              colorFilter: isAvailable
                  ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                  : const ColorFilter.matrix(<double>[
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0, 0, 0, 1, 0,
                    ]),
              child: Image.asset(
                'assets/images/${topping['image']}',
                width: 70, height: 70, fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => const Icon(Icons.fastfood, size: 70, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(topping['desc'], style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 1),
                Text("RM ${topping['price'].toStringAsFixed(2)}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Radio<bool>(
            value: true,
            groupValue: isAvailable,
            activeColor: Colors.green,
            onChanged: (val) => setState(() => _stockStatus[name] = true),
          ),
          Radio<bool>(
            value: false,
            groupValue: isAvailable,
            activeColor: Colors.red,
            onChanged: (val) => setState(() => _stockStatus[name] = false),
          ),
        ],
      ),
    );
  }
} 