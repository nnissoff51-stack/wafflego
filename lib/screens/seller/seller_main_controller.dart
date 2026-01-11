import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'seller_home_screen.dart';
import 'seller_stock_screen.dart';
import 'orders_page.dart'; 
import '../shared/activity_logs_screen.dart';

class SellerMainController extends StatefulWidget {
  final UserModel currentUser;

  const SellerMainController({
    super.key,
    required this.currentUser,
  });

  @override
  State<SellerMainController> createState() => _SellerMainControllerState();
}

class _SellerMainControllerState extends State<SellerMainController> {
  int _currentIndex = 0;
  bool _isShopOpen = true;

  void _toggleShopStatus() {
    setState(() {
      _isShopOpen = !_isShopOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List skrin ikut turutan Tab
    final List<Widget> _pages = [
      SellerHomeScreen(
        currentUser: widget.currentUser,
        isShopOpen: _isShopOpen,
        onToggleShopStatus: _toggleShopStatus,
      ),
      const OrderPage(), // Tab ke-2
      SellerStockScreen(
        currentUser: widget.currentUser,
        isShopOpen: _isShopOpen,
        onToggleShopStatus: _toggleShopStatus,
      ),
      ActivityLogsScreen(
        currentUser: widget.currentUser,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
          _buildNavItem(Icons.receipt_long_outlined, Icons.receipt_long, 'Orders', 1),
          _buildNavItem(Icons.inventory_2_outlined, Icons.inventory_2, 'Stock', 2),
          _buildNavItem(Icons.history, Icons.history, 'Activity', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData inactiveIcon, IconData activeIcon, String label, int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : inactiveIcon,
            color: isActive ? Colors.orange : Colors.grey,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.orange : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}