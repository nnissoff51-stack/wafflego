import 'package:flutter/material.dart';

class DashboardTwoContent extends StatelessWidget {
  final bool isShopOpen;

  const DashboardTwoContent({super.key, required this.isShopOpen});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Weekly Sales Card with Chart
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFFFFDAA3), borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SALES OVERVIEW', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('RM 1500.00', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFF8C00))),
                      Text('TOTAL SALES', style: TextStyle(fontSize: 11, color: Color(0xFFFF8C00))),
                    ],
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 80,
                  child: CustomPaint(painter: SimpleChartPainter()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryCard("WEEKLY FAVORITE", Icons.star, ["Chocolate", "Peanut", "Strawberry"]),
          const SizedBox(height: 20),
        ],
      ),
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
          ...items.map((item) => Text(item)),
        ],
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