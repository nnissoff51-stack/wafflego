import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wafflego/data/order_store.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderStore>().orders;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF5E8),
        elevation: 0,
        centerTitle: true,
        title: const Text("Orders"),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                "No orders yet",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, i) {
                final o = orders[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        o.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        o.summary,
                        style: const TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Qty: ${o.qty}  •  RM${o.total.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
