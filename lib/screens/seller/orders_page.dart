import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user.dart';

class OrderPage extends StatefulWidget {
  final UserModel? currentUser;
  const OrderPage({super.key, this.currentUser});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final supabase = Supabase.instance.client;
  int selectedTab = 0; 
  bool _isLoading = true;
  List<dynamic> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // --- AMBIL DATA ORDERS + JOIN DENGAN ITEMS ---
  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    try {
      // Kita tarik data dari 'orders' dan join 'order_items' guna uuid
      final data = await supabase
          .from('orders')
          .select('*, order_items(*)') 
          .order('created_at', ascending: false);
          
      setState(() {
        _orders = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching orders: $e");
      setState(() => _isLoading = false);
    }
  }

  // --- UPDATE STATUS & LOG ---
  Future<void> _updateOrderStatus(String id, String orderCode, String newStatus) async {
    try {
      await supabase.from('orders').update({'status': newStatus}).eq('id', id);

      // Simpan log aktiviti
      if (widget.currentUser != null) {
        await supabase.from('activity_logs').insert({
          'user_id': widget.currentUser!.id,
          'user_name': widget.currentUser!.fullName,
          'role': widget.currentUser!.role,
          'action': 'ORDER_UPDATE',
          'details': 'Order $orderCode updated to $newStatus',
        });
      }

      _fetchOrders(); // Refresh senarai
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CC),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "CUSTOMER ORDERS",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF8B4513)),
            ),
            const SizedBox(height: 20),

            // TAB BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tabButton("Pending", 0),
                _tabButton("Processing", 1),
                _tabButton("Done", 2),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                : RefreshIndicator(
                    onRefresh: _fetchOrders,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: _orders
                          .where((order) {
                            String s = (order['status'] ?? '').toLowerCase();
                            if (selectedTab == 0) return s == 'pending';
                            if (selectedTab == 1) return s == 'processing' || s == 'in_progress';
                            return s == 'completed' || s == 'done';
                          })
                          .map((order) => _orderCard(order))
                          .toList(),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String text, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.orange.shade200,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.orange.shade900,
          ),
        ),
      ),
    );
  }

  Widget _orderCard(Map<String, dynamic> order) {
    // Ambil list item dari join query tadi
    List items = order['order_items'] ?? [];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${order['order_code'] ?? 'N/A'}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(order['buyer_name'] ?? 'Guest', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
            ],
          ),
          const Divider(height: 20),
          
          // Listkan item yang dibeli
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text("• ${item['name']} x${item['qty']}", style: const TextStyle(fontSize: 15)),
          )),
          
          const SizedBox(height: 15),
          _statusButton(order),
        ],
      ),
    );
  }

  Widget _statusButton(Map<String, dynamic> order) {
    String status = (order['status'] ?? '').toLowerCase();
    
    if (status == 'pending') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          onPressed: () => _updateOrderStatus(order['id'], order['order_code'], 'processing'),
          child: const Text("Accept Order"),
        ),
      );
    }
    if (status == 'processing' || status == 'in_progress') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
          onPressed: () => _updateOrderStatus(order['id'], order['order_code'], 'completed'),
          child: const Text("Mark as Done"),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.check_circle, color: Colors.green),
        const SizedBox(width: 5),
        Text("Finished (${order['buyer_phone'] ?? ''})", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
      ],
    );
  }
}