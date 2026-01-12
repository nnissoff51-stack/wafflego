import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user.dart';
import '../seller/seller_home_screen.dart';
import '../seller/seller_stock_screen.dart';
import '../seller/orders_page.dart'; 
import '../shared/activity_logs_screen.dart'; 
import 'user_management_screen.dart'; // Gunakan relative import yang lebih stabil

class OwnerMainController extends StatefulWidget {
  final UserModel currentUser;
  const OwnerMainController({super.key, required this.currentUser});

  @override
  State<OwnerMainController> createState() => _OwnerMainControllerState();
}

class _OwnerMainControllerState extends State<OwnerMainController> {
  int _currentIndex = 0;
  bool _isShopOpen = true; 

  void _handleToggleShopStatus() {
    setState(() => _isShopOpen = !_isShopOpen);
  }

  // LOGOUT DENGAN LOG KE SUPABASE
  void _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Confirm Log out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              // Simpan log keluar sebelum "zass" ke login
              await Supabase.instance.client.from('activity_logs').insert({
                'user_id': widget.currentUser.id,
                'user_name': widget.currentUser.fullName,
                'role': 'owner',
                'action': 'LOGOUT',
                'details': 'Owner logged out from system',
              });

              if (!context.mounted) return;
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
    // Pastikan susunan pages ni sama dengan BottomNavigationBar di bawah
    final List<Widget> pages = [
      SellerHomeScreen(
        currentUser: widget.currentUser, 
        isShopOpen: _isShopOpen, 
        onToggleShopStatus: _handleToggleShopStatus
      ),
      const OrderPage(),
      SellerStockScreen(
        currentUser: widget.currentUser, 
        isShopOpen: _isShopOpen, 
        onToggleShopStatus: _handleToggleShopStatus
      ),
      const UserManagementScreen(), 
      _buildOwnerProfile(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blueAccent, 
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildOwnerProfile() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CC),
      appBar: AppBar(
        title: const Text("Owner Profile", style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _userInfoCard(),
            const SizedBox(height: 20),
            
            // MENU ACTIVITY LOGS
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.history, color: Colors.blueAccent),
                title: const Text("View Activity Logs", style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text("Monitor system movements"),
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
            _logoutButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _userInfoCard() {
    return Container(
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
            backgroundColor: Colors.blueAccent, 
            child: Icon(Icons.admin_panel_settings, size: 40, color: Colors.white)
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.currentUser.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("Owner ID: ${widget.currentUser.id ?? 'N/A'}", style: const TextStyle(color: Colors.grey)),
                Text("@${widget.currentUser.username}", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                Text(widget.currentUser.email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () => _handleLogout(context),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 10),
            Text("Log out System", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}