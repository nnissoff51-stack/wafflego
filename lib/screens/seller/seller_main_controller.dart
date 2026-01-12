import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Tambah ni
import '../../models/user.dart';
import 'seller_home_screen.dart';
import 'seller_stock_screen.dart';
import 'orders_page.dart';
import '../shared/activity_logs_screen.dart'; 

class SellerMainController extends StatefulWidget {
  final UserModel currentUser;
  const SellerMainController({super.key, required this.currentUser});

  @override
  State<SellerMainController> createState() => _SellerMainControllerState();
}

class _SellerMainControllerState extends State<SellerMainController> {
  int _currentIndex = 0;
  bool _isShopOpen = true; 

  // POP-UP CONFIRMATION LOGOUT DENGAN SUPABASE LOG
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              // Simpan log keluar staff ke Supabase
              await Supabase.instance.client.from('activity_logs').insert({
                'user_id': widget.currentUser.id,
                'user_name': widget.currentUser.fullName,
                'role': 'staff',
                'action': 'LOGOUT',
                'details': 'Staff ${widget.currentUser.fullName} logged out',
              });

              if (!context.mounted) return;
              // Patah balik ke skrin login (paling root)
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text("Yes, Log out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      SellerHomeScreen(
        currentUser: widget.currentUser, 
        isShopOpen: _isShopOpen, 
        onToggleShopStatus: () => setState(() => _isShopOpen = !_isShopOpen)
      ),
      const OrderPage(),
      // Pastikan currentUser dihantar ke skrin stok untuk log audit
      SellerStockScreen(
        currentUser: widget.currentUser, 
        isShopOpen: _isShopOpen, 
        onToggleShopStatus: () {} 
      ),
      _buildStaffProfileTab(), 
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildStaffProfileTab() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CC),
      appBar: AppBar(
        title: const Text("Staff Profile", style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // KAD MAKLUMAT STAFF (TARIK DARI SUPABASE)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35, 
                    backgroundColor: Colors.orange, 
                    child: Icon(Icons.person, size: 40, color: Colors.white)
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.currentUser.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Staff ID: ${widget.currentUser.id ?? 'N/A'}", style: const TextStyle(color: Colors.grey)),
                        Text("@${widget.currentUser.username}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ACTIVITY LOGS UNTUK STAFF (DIA BOLEH TENGOK LOG SENDIRI/SEMUA)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.history, color: Colors.brown),
                title: const Text("My Activity Logs", style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text("Review your past actions"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => ActivityLogsScreen(currentUser: widget.currentUser))
                  );
                },
              ),
            ),

            const Spacer(),

            // BUTTON LOGOUT
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => _showLogoutDialog(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Log out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}