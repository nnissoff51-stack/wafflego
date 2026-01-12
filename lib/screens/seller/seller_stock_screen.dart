import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user.dart';

class SellerStockScreen extends StatefulWidget {
  final UserModel currentUser;
  final bool isShopOpen;
  final VoidCallback onToggleShopStatus;

  const SellerStockScreen({
    super.key,
    required this.currentUser,
    required this.isShopOpen,
    required this.onToggleShopStatus,
  });

  @override
  State<SellerStockScreen> createState() => _SellerStockScreenState();
}

class _SellerStockScreenState extends State<SellerStockScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _toppings = [];

  @override
  void initState() {
    super.initState();
    _fetchStocks();
  }

  // --- 1. AMBIL DATA DARI SUPABASE ---
  Future<void> _fetchStocks() async {
    setState(() => _isLoading = true);
    try {
      final data = await supabase.from('stocks').select().order('item_name');
      setState(() {
        _toppings = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetch stocks: $e");
      setState(() => _isLoading = false);
    }
  }

  // --- 2. UPDATE STATUS & SIMPAN LOG ---
  Future<void> _updateStockStatus(int id, String name, bool newStatus) async {
    try {
      // Update table stocks (kita guna column quantity: 1=Available, 0=Out of Stock)
      await supabase.from('stocks').update({
        'quantity': newStatus ? 1 : 0,
      }).eq('id', id);

      // Simpan Activity Log
      await supabase.from('activity_logs').insert({
        'user_id': widget.currentUser.id,
        'user_name': widget.currentUser.fullName,
        'role': widget.currentUser.role,
        'action': 'UPDATE_STOCK',
        'details': 'Changed $name status to ${newStatus ? 'Available' : 'Out of Stock'}',
      });

      _fetchStocks(); // Refresh UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _fetchStocks,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _toppings.length,
                        itemBuilder: (context, index) => _buildStockItem(_toppings[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isShopOpen ? Colors.green.shade100 : Colors.red.shade100, 
              borderRadius: BorderRadius.circular(15)
            ),
            child: Row(
              children: [
                Text(
                  "SHOP STATUS: ${widget.isShopOpen ? 'OPEN' : 'CLOSED'}", 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: widget.isShopOpen ? Colors.green.shade900 : Colors.red.shade900
                  )
                ),
                const Spacer(),
                Switch(
                  value: widget.isShopOpen,
                  onChanged: (val) => widget.onToggleShopStatus(),
                  activeThumbColor: Colors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(color: const Color(0xFFFFB74D), borderRadius: BorderRadius.circular(15)),
            child: const Center(
              child: Text(
                "TOPPINGS AVAILABILITY", 
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
              )
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Available", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                SizedBox(width: 25),
                Text("Out of stock", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockItem(Map<String, dynamic> topping) {
    final int id = topping['id'];
    final String name = topping['item_name'];
    // Kita anggap quantity > 0 adalah available
    final bool isAvailable = (topping['quantity'] ?? 0) > 0;
    // Map kan image (contoh: 'Chocolate' -> 'chocolate.png')
    final String imgFileName = name.toLowerCase().replaceAll(' ', '_') + '.png';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ColorFiltered(
              colorFilter: isAvailable 
                ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply) 
                : const ColorFilter.matrix(<double>[
                    0.2126, 0.7152, 0.0722, 0, 0, 
                    0.2126, 0.7152, 0.0722, 0, 0, 
                    0.2126, 0.7152, 0.0722, 0, 0, 
                    0, 0, 0, 1, 0
                  ]),
              child: Image.asset(
                'assets/images/$imgFileName', 
                width: 60, height: 60, 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => const Icon(Icons.cookie, size: 60, color: Colors.brown),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("RM ${topping['price'].toString()}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Radio<bool>(
            value: true, 
            groupValue: isAvailable, 
            activeColor: Colors.green, 
            onChanged: (val) => _updateStockStatus(id, name, true)
          ),
          Radio<bool>(
            value: false, 
            groupValue: isAvailable, 
            activeColor: Colors.red, 
            onChanged: (val) => _updateStockStatus(id, name, false)
          ),
        ],
      ),
    );
  }
}