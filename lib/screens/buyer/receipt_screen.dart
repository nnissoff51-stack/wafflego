import 'package:flutter/material.dart';
import '../../supabase_service.dart';
import 'tracking_order_screen.dart';

class ReceiptScreen extends StatefulWidget {
  final String orderId; // this is order_code like W1234
  const ReceiptScreen({super.key, required this.orderId});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  SupaOrder? _order;
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final o = await fetchOrderByCode(widget.orderId);
    final items = await fetchItemsByCode(widget.orderId);

    if (!mounted) return;
    setState(() {
      _order = o;
      _items = items;
      _loading = false;
    });
  }

  String _fmtDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/"
        "${dt.year}";
  }

  String _fmtTime(DateTime dt) {
    int h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = h >= 12 ? "PM" : "AM";
    h = h % 12;
    if (h == 0) h = 12;
    return "$h:$m $ampm";
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFFF5E8);

    if (_loading) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          centerTitle: true,
          title: const Text("Receipt Order"),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_order == null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          centerTitle: true,
          title: const Text("Receipt Order"),
        ),
        body: const Center(child: Text("Order not found")),
      );
    }

    // calculate totals based on stored columns
    double baseTotal = 0.0;
    double toppingTotal = 0.0;

    for (final it in _items) {
      final qty = (it['qty'] as num).toInt();
      final basePrice = (it['base_price'] as num).toDouble();
      final toppingsCount = (it['toppings_count'] as num).toInt();

      baseTotal += basePrice * qty;
      toppingTotal += (toppingsCount * 0.50);
    }

    final total = baseTotal + toppingTotal;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        title: const Text("Receipt Order"),
        actions: [
          IconButton(
            tooltip: "Refresh",
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== THANK YOU (SOFT) =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.check_circle_outline, size: 42, color: Colors.green),
                SizedBox(height: 8),
                Text(
                  "Thank you!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  "Your order has been made successfully",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ===== ORDER INFO =====
          _card(
            Column(
              children: [
                _row("Order ID", _order!.orderCode),
                _row("Date", _fmtDate(_order!.createdAt)),
                _row("Time", _fmtTime(_order!.createdAt)),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ===== ITEMS =====
          _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Item",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
                const SizedBox(height: 10),
                if (_items.isEmpty)
                  const Text(
                    "No items found.",
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
                  )
                else
                  for (final it in _items) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            (it['name'] as String),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        Text(
                          "x${(it['qty'] as num).toInt()}",
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ===== PAYMENT SUMMARY =====
          _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Payment Summary",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
                const SizedBox(height: 10),
                _row("Price", "RM${baseTotal.toStringAsFixed(2)}"),
                _row("Toppings", "+ RM${toppingTotal.toStringAsFixed(2)}"),
                const Divider(height: 18),
                _row("Total", "RM${total.toStringAsFixed(2)}", bold: true),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ===== TRACK BUTTON =====
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrackingOrderScreen(orderId: _order!.orderCode),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Tracking Order",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _row(String left, String right, {bool bold = false}) {
    final fw = bold ? FontWeight.w900 : FontWeight.w700;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: TextStyle(color: Colors.black54, fontWeight: fw)),
          Text(right, style: TextStyle(fontWeight: fw)),
        ],
      ),
    );
  }
}

