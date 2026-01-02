import 'package:flutter/material.dart';
import 'home_screen_seller.dart'; 
import 'stock.dart';      

void main() => runApp(const WaffleGoSellerApp());

class WaffleGoSellerApp extends StatelessWidget {
  const WaffleGoSellerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaffleGo Seller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
      ),
      home: const SellerMainController(),
    );
  }
}

class SellerMainController extends StatefulWidget {
  const SellerMainController({super.key});

  @override
  State<SellerMainController> createState() => _SellerMainControllerState();
}

class _SellerMainControllerState extends State<SellerMainController> {
  int _currentIndex = 0;
  bool _isShopOpen = true;

  void toggleShopStatus() {
    setState(() {
      _isShopOpen = !_isShopOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The IndexedStack preserves the scroll state of screens when switching tabs
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            isShopOpen: _isShopOpen,
            onToggleShopStatus: toggleShopStatus,
          ),
          StockScreen(
            isShopOpen: _isShopOpen,
            onToggleShopStatus: toggleShopStatus,
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
          _buildNavItem(Icons.inventory_2_outlined, Icons.inventory_2, 'Stock', 1),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData inactiveIcon, IconData activeIcon, String label, int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : inactiveIcon,
            color: isActive ? const Color(0xFFFF8C00) : Colors.grey,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFFFF8C00) : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}