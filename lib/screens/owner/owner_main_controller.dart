import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'owner_home_screen.dart';
import 'owner_profile_screen.dart'; 
import '../shared/activity_logs_screen.dart';

class OwnerMainController extends StatefulWidget {
  final UserModel currentUser;

  const OwnerMainController({
    super.key,
    required this.currentUser,
  });

  @override
  State<OwnerMainController> createState() => _OwnerMainControllerState();
}

class _OwnerMainControllerState extends State<OwnerMainController> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 2. Masukkan skrin dalam list ikut turutan tab
    final List<Widget> _pages = [
      OwnerHomeScreen(currentUser: widget.currentUser),
      ActivityLogsScreen(currentUser: widget.currentUser),
      OwnerProfileScreen(currentUser: widget.currentUser), // 3. Link kan kat sini
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard', 0),
          _buildNavItem(Icons.history, Icons.history, 'Logs', 1),
          _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 2), // 4. Tab Profile
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData inactiveIcon, IconData activeIcon, String label, int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : inactiveIcon,
            color: isActive ? const Color(0xFFFF8C00) : Colors.grey,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFFFF8C00) : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}