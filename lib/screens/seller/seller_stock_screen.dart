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
  late Map<String, bool> availabilityMap;

  // Waffle Data List
  final List<Map<String, dynamic>> waffles = [
    {
      "name": "Chocolate",
      "desc": "Classic chocolate drizzle.",
      "price": 4.50,
      "available": true,
      "image": "assets/images/chocolate.png",
    },
    {
      "name": "Blueberry",
      "desc": "Bursting with tangy sweetness.",
      "price": 4.50,
      "available": true,
      "image": "assets/images/blueberry.png",
    },
    {
      "name": "Kaya",
      "desc": "Authentic Malaysian kaya with smooth, creamy, and fragrant goodness.",
      "price": 4.50,
      "available": true,
      "image": "assets/images/kaya.png",
    },
    {
      "name": "Butter",
      "desc": "Rich, creamy butter melted to golden perfection.",
      "price": 4.50,
      "available": true,
      "image": "assets/images/butter.png",
    },
    {
      "name": "Strawberry",
      "desc": "Sweet strawberry topping.",
      "price": 4.50,
      "available": false,
      "image": "assets/images/strawberry.png",
    },
    {
      "name": "Peanut",
      "desc": "Peanut butter flavour.",
      "price": 4.50,
      "available": true,
      "image": "assets/images/peanut.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    availabilityMap = {for (var item in waffles) item['name']: item['available']};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D6),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/wafflego_logo.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.brown[400],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.store, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('Welcome, ', style: TextStyle(fontSize: 16)),
                  Text(
                    '${widget.currentUser.fullName.split(' ')[0]}!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFF6B6B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  _buildHeaderIcon(Icons.notifications_none),
                  const SizedBox(width: 8),
                  _buildHeaderIcon(Icons.person, isProfile: true),
                ],
              ),
            ),

            // Shop Status Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text('SHOP STATUS', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  _buildStatusBadge(),
                  const SizedBox(width: 8),
                  _buildToggleSwitch(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB84D),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    'TOPPINGS AVAILABILITY',
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Table Headers - ALIGNED WITH RADIO BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: const [
                  SizedBox(width: 67), // Space for image
                  Expanded(child: SizedBox()), // Space for name and description
                  Text('Available', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(width: 30),
                  Text('Out of stock', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Toppings List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: waffles.length,
                itemBuilder: (context, index) {
                  return _buildToppingCard(waffles[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToppingCard(Map<String, dynamic> item) {
    String name = item['name'];
    bool isAvailable = availabilityMap[name] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFDAA3), width: 2),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item['image'],
              width: 55,
              height: 55,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                width: 55, height: 55, color: Colors.orange[50], child: const Icon(Icons.fastfood),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(
                  item['desc'],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'RM ${item['price'].toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          _buildCustomRadio(true, isAvailable, () => setState(() => availabilityMap[name] = true)),
          const SizedBox(width: 50),
          _buildCustomRadio(false, !isAvailable, () => setState(() => availabilityMap[name] = false)),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, {bool isProfile = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isProfile ? Colors.grey[300] : Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.isShopOpen ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        widget.isShopOpen ? 'OPEN' : 'CLOSED',
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return GestureDetector(
      onTap: widget.onToggleShopStatus,
      child: Container(
        width: 44, height: 24,
        decoration: BoxDecoration(
          color: widget.isShopOpen ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: widget.isShopOpen ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(width: 20, height: 20, margin: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
        ),
      ),
    );
  }

  Widget _buildCustomRadio(bool isGreen, bool isSelected, VoidCallback onTap) {
    Color color = isGreen ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24, height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          color: isSelected ? color : Colors.transparent,
        ),
        child: isSelected ? const Icon(Icons.circle, size: 12, color: Colors.white) : null,
      ),
    );
  }
}