import 'package:flutter/material.dart';
import 'customize_order_screen.dart'; 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // BUYER ONLY: change this to false to simulate shop closed
  final bool isShopOpen = true;

  @override
  Widget build(BuildContext context) {
    final waffles = <Map<String, dynamic>>[
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

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF5E8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Waffle Go',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            // OPEN/CLOSED banner (buyer view)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isShopOpen ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    isShopOpen ? Icons.storefront : Icons.store_mall_directory,
                    color: isShopOpen ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isShopOpen ? "Shop is OPEN" : "Shop is CLOSED",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isShopOpen ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Welcome 👋",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              "What waffle would you like today?",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 14),

            // Search bar (UI only)
            TextField(
              decoration: InputDecoration(
                hintText: "Search waffle...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Category chips (UI only)
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _CategoryChip(text: "All", selected: true),
                  _CategoryChip(text: "Chocolate"),
                  _CategoryChip(text: "Fruits"),
                  _CategoryChip(text: "Special"),
                ],
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              "Menu",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),

            for (final w in waffles) ...[
              _WaffleCard(
                name: (w["name"] as String),
                desc: (w["desc"] as String),
                price: (w["price"] as num).toDouble(),
                available: (w["available"] as bool),
                shopOpen: isShopOpen,
                image: (w["image"] as String),
                onAdd: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomizeOrderScreen(item: w),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String text;
  final bool selected;
  const _CategoryChip({required this.text, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _WaffleCard extends StatelessWidget {
  final String name;
  final String desc;
  final double price;
  final bool available;
  final bool shopOpen;
  final String image;
  final VoidCallback onAdd;

  const _WaffleCard({
    required this.name,
    required this.desc,
    required this.price,
    required this.available,
    required this.shopOpen,
    required this.image,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final bool canOrder = available && shopOpen;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              image,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (!available)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE7E7),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          "Not available",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "RM ${price.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: canOrder ? onAdd : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}