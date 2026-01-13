import 'package:flutter/material.dart';
import '../../supabase_service.dart';

class TrackingOrderScreen extends StatefulWidget {
  final String orderId; // order_code like W1234
  const TrackingOrderScreen({super.key, required this.orderId});

  @override
  State<TrackingOrderScreen> createState() => _TrackingOrderScreenState();
}

class _TrackingOrderScreenState extends State<TrackingOrderScreen> {
  SupaOrder? order;
  bool loading = true;

  // ✅ 3 step sahaja
  static const _steps = ["pending", "processing", "done"];

  // ✅ map status lama -> 3 status baru
  String _normalizeStatus(String s) {
    final x = s.toLowerCase().trim();

    // dah betul
    if (x == "pending" || x == "processing" || x == "done") return x;

    // status lama (awak punya 4-step)
    if (x == "preparing" || x == "ready") return "processing";
    if (x == "completed") return "done";

    // fallback
    return "pending";
  }

  int _indexFromStatus(String status) {
    final s = _normalizeStatus(status);
    final i = _steps.indexOf(s);
    return i == -1 ? 0 : i;
  }

  String _pretty(String status) {
    switch (_normalizeStatus(status)) {
      case "pending":
        return "Pending";
      case "processing":
        return "Processing";
      case "done":
        return "Done";
      default:
        return status;
    }
  }

  String _desc(String status) {
    switch (_normalizeStatus(status)) {
      case "pending":
        return "We received your order. Please wait a moment.";
      case "processing":
        return "Your order is being prepared. Please wait.";
      case "done":
        return "Order completed. Thank you!";
      default:
        return "";
    }
  }

  IconData _icon(String status) {
    switch (_normalizeStatus(status)) {
      case "pending":
        return Icons.receipt_long_rounded;
      case "processing":
        return Icons.local_fire_department_rounded;
      case "done":
        return Icons.check_circle_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    final o = await fetchOrderByCode(widget.orderId);
    if (!mounted) return;
    setState(() {
      order = o;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFFF5E8);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        title: const Text("Tracking Order"),
        actions: [
          IconButton(
            tooltip: "Refresh",
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : (order == null)
              ? const Center(child: Text("Order not found."))
              : _body(context),
    );
  }

  Widget _body(BuildContext context) {
    final rawStatus = (order!.status).toLowerCase();
    final status = _normalizeStatus(rawStatus);
    final activeIndex = _indexFromStatus(status);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        _card(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE7C6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.qr_code_2_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order ID",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order!.orderCode,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: "Copy",
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order ID copied (demo)")),
                  );
                },
                icon: const Icon(Icons.copy_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        _card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE7C6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_icon(status)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Status",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _pretty(status),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _desc(status),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Progress", style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              _stepBar(activeIndex: activeIndex),
              const SizedBox(height: 12),
              _stepLabels(activeIndex: activeIndex),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _card(
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Payment is made at the kiosk. Please show your Order ID during pickup.",
                  style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  // ✅ ikut bilangan step (3)
  Widget _stepBar({required int activeIndex}) {
    return Row(
      children: List.generate(_steps.length, (i) {
        final done = i <= activeIndex;
        return Expanded(
          child: Container(
            height: 10,
            margin: EdgeInsets.only(right: i == _steps.length - 1 ? 0 : 8),
            decoration: BoxDecoration(
              color: done ? Colors.orange : Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }

  // ✅ label 3 step
  Widget _stepLabels({required int activeIndex}) {
    const labels = ["Pending", "Processing", "Done"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(labels.length, (i) {
        final isActive = i == activeIndex;
        final passed = i < activeIndex;
        return Text(
          labels[i],
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
            color: (isActive || passed) ? Colors.black : Colors.black54,
          ),
        );
      }),
    );
  }
}
