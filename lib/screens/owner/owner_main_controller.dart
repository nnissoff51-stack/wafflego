import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'owner_home_screen.dart';
import 'user_management_screen.dart';
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
  bool _isShopOpen = true;

  void toggleShopStatus() {
    setState(() {
      _isShopOpen = !_isShopOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          OwnerHomeScreen(
            currentUser: widget.currentUser,
            isShopOpen: _isShopOpen,
            onToggleShopStatus: toggleShopStatus,
          ),
          UserManagementScreen(
            currentUser: widget.currentUser,
          ),
          ActivityLogsScreen(
            currentUser: widget.currentUser,
          ),
          OwnerProfileScreen(
            currentUser: widget.currentUser,
          ),
        ],
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
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF8C00),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Staff',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}