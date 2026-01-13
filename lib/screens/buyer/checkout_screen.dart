import 'package:flutter/material.dart';
import 'order_store.dart';
import '../../supabase_service.dart';
import 'receipt_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _submitting = false;

  String _unitText(UnitSelection u) {
    final top = u.toppings.isEmpty ? "-" : u.toppings.join(", ");
    final mix = u.mix ?? "-";
    return "Topping: $top | Mix: $mix";
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
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
        title: const Text("Checkout", style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: AnimatedBuilder(
        animation: orderStore,
        builder: (context, _) {
          final cart = orderStore.cart;

          if (cart.isEmpty) {
            return const Center(child: Text("Cart is empty."));
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              const Text(
                "Order Summary",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),

              _card(
                child: Column(
                  children: [
                    for (final line in cart) ...[
                      _summaryLine(line),
                      const SizedBox(height: 10),
                    ],
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(fontWeight: FontWeight.w900)),
                        Text(
                          "RM${orderStore.cartTotal.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Pickup Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),

              _card(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: "Name (optional)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Phone (optional)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0D8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.storefront_rounded),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Payment: Pay at kiosk.\nUse your Order ID during pickup.",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitting ? null : () => _placeOrder(cart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Confirm Order",
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _summaryLine(OrderLine line) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "${line.name} (x${line.qty})",
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            Text(
              "RM${line.total.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 6),
        for (int i = 0; i < line.units.length; i++) ...[
          Text(
            "Item ${i + 1}: ${_unitText(line.units[i])}",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 2),
        ],
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

  Future<void> _placeOrder(List<OrderLine> cart) async {
    setState(() => _submitting = true);

    try {
      // snapshot cart BEFORE clear
      final snapshot = List<OrderLine>.from(cart);

      final res = await createOrderInSupabase(
        cart: snapshot,
        buyerName: _nameCtrl.text,
        buyerPhone: _phoneCtrl.text,
      );

      // ✅ add to local history for OrdersScreen display
      orderStore.addToHistory(
        Order(
          orderId: res.orderCode,
          status: "pending",
          items: snapshot,
          createdAt: res.createdAt, // ✅ server time (local)
        ),
      );

      // clear cart
      orderStore.clearCart();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReceiptScreen(orderId: res.orderCode),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order: $e")),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
