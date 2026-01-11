import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'seller_home_screen.dart';
import 'seller_stock_screen.dart';
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

  void toggleShopStatus() {
    setState(() {
      _isShopOpen = !_isShopOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SellerHomeScreen(
            currentUser: widget.currentUser,
            isShopOpen: _isShopOpen,
            onToggleShopStatus: toggleShopStatus,
          ),
          SellerStockScreen(
            currentUser: widget.currentUser,
            isShopOpen: _isShopOpen,
            onToggleShopStatus: toggleShopStatus,
          ),
          ActivityLogsScreen(
            currentUser: widget.currentUser,
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
          _buildNavItem(Icons.history, Icons.history, 'Activity', 2),
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