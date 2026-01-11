import 'package:flutter/material.dart';
import '../../models/user.dart';

class OwnerHomeScreen extends StatefulWidget {
  final UserModel currentUser;
  final bool isShopOpen;
  final VoidCallback onToggleShopStatus;

  const OwnerHomeScreen({
    super.key,
    required this.currentUser,
    required this.isShopOpen,
    required this.onToggleShopStatus,
  });

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  int _selectedTab = 0; // 0 for Today, 1 for Weekly, 2 for Monthly

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
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.store, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Owner Dashboard',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Welcome, ${widget.currentUser.fullName}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  _buildHeaderIcon(Icons.notifications),
                ],
              ),
            ),

            // Shop Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text('SHOP STATUS', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    _buildTabItem(0, 'Today'),
                    _buildTabItem(1, 'Weekly'),
                    _buildTabItem(2, 'Monthly'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildDashboardContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    if (_selectedTab == 0) {
      return _buildTodayView();
    } else if (_selectedTab == 1) {
      return _buildWeeklyView();
    } else {
      return _buildMonthlyView();
    }
  }

  Widget _buildTodayView() {
    return Column(
      children: [
        // Sales Overview
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
              const Text('TODAY\'S SALES', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'RM 300.00',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFF8C00)),
              ),
              const SizedBox(height: 20),
              _buildStatRow('Total Orders:', '30'),
              const SizedBox(height: 8),
              _buildStatRow('Avg. Order:', 'RM 10.00'),
              const SizedBox(height: 8),
              _buildStatRow('Top Item:', 'Chocolate'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Staff Performance
        _buildStaffPerformanceCard(),
        const SizedBox(height: 16),

        // Top Products
        _buildTopProductsCard(['Chocolate', 'Peanut', 'Strawberry']),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildWeeklyView() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDAA3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('WEEKLY SALES', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      'RM 1,500.00',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFF8C00)),
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow('Total Orders:', '150'),
                    const SizedBox(height: 8),
                    _buildStatRow('Avg/Day:', 'RM 214.29'),
                  ],
                ),
              ),
              SizedBox(
                width: 120,
                height: 100,
                child: CustomPaint(painter: SimpleChartPainter()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildStaffPerformanceCard(),
        const SizedBox(height: 16),
        _buildTopProductsCard(['Chocolate', 'Kaya', 'Butter']),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMonthlyView() {
    return Column(
      children: [
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
              const Text('MONTHLY SALES', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'RM 6,500.00',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFF8C00)),
              ),
              const SizedBox(height: 20),
              _buildStatRow('Total Orders:', '650'),
              const SizedBox(height: 8),
              _buildStatRow('Avg/Day:', 'RM 216.67'),
              const SizedBox(height: 8),
              _buildStatRow('Growth:', '+12%'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildStaffPerformanceCard(),
        const SizedBox(height: 16),
        _buildTopProductsCard(['Chocolate', 'Blueberry', 'Kaya']),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStaffPerformanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.people, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text('STAFF PERFORMANCE', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          _buildStaffRow('Ali Ahmad', '45 orders', 'RM 450.00'),
          const SizedBox(height: 8),
          _buildStaffRow('Alin Binti Hassan', '38 orders', 'RM 380.00'),
        ],
      ),
    );
  }

  Widget _buildStaffRow(String name, String orders, String sales) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(name, style: const TextStyle(fontSize: 13)),
        ),
        Text(orders, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 12),
        Text(sales, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFFF8C00))),
      ],
    );
  }

  Widget _buildTopProductsCard(List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.star, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text('TOP PRODUCTS', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ...items.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('${entry.key + 1}. ${entry.value}'),
          )),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
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
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()..color = const Color(0xFFFFB84D)..style = PaintingStyle.fill;
    final linePaint = Paint()..color = Colors.green..style = PaintingStyle.stroke..strokeWidth = 2;
    
    final barWidth = size.width / 7;
    final heights = [0.3, 0.5, 0.4, 0.6, 0.45, 0.7, 0.55];
    
    for (int i = 0; i < 7; i++) {
      final h = heights[i] * size.height;
      canvas.drawRect(Rect.fromLTWH(i * barWidth + 2, size.height - h, barWidth - 4, h), barPaint);
    }

    final path = Path()..moveTo(0, size.height * 0.7);
    for (int i = 0; i < 7; i++) {
      path.lineTo(i * barWidth + barWidth / 2, size.height - (heights[i] * size.height));
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}