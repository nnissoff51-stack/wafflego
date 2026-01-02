import 'package:flutter/material.dart';
import 'dashboard_one.dart';
import 'dashboard_two.dart';

class HomeScreen extends StatefulWidget {
  final bool isShopOpen;
  final VoidCallback onToggleShopStatus;

  const HomeScreen({
    super.key,
    required this.isShopOpen,
    required this.onToggleShopStatus,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0; // 0 for Today Sales, 1 for Weekly Sales

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D6),
      body: SafeArea(
        child: Column(
          children: [
            // Header: Logo, Welcome Message, and Icons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/wafflego_logo.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.store, color: Colors.white),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  const Text('Welcome, ', style: TextStyle(fontSize: 16)),
                  const Text(
                    'Ali!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFF6B6B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  _buildHeaderIcon(Icons.notifications),
                  const SizedBox(width: 8),
                  _buildHeaderIcon(Icons.person, isProfile: true),
                ],
              ),
            ),

            // Shop Status Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text(
                    'SHOP STATUS',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  _buildStatusLabel(),
                  const SizedBox(width: 8),
                  _buildToggleButton(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tab Switcher
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB84D),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    _buildTabItem(0, 'Today Sales'),
                    _buildTabItem(1, 'Weekly Sales'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Dynamic Dashboard Content
            Expanded(
              child: _selectedTab == 0
                  ? DashboardOneContent(isShopOpen: widget.isShopOpen)
                  : DashboardTwoContent(isShopOpen: widget.isShopOpen),
            ),
          ],
        ),
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

  Widget _buildStatusLabel() {
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

  Widget _buildToggleButton() {
    return GestureDetector(
      onTap: widget.onToggleShopStatus,
      child: Container(
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: widget.isShopOpen ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: widget.isShopOpen ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF8C00) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}