import 'package:flutter/material.dart';
import '../../models/user.dart';

class UserManagementScreen extends StatefulWidget {
  final UserModel currentUser;
  const UserManagementScreen({super.key, required this.currentUser});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  // Contoh data staff
  final List<Map<String, String>> staffList = [
    {"name": "Ahmad Ali", "role": "Staff", "status": "Active"},
    {"name": "Siti Sarah", "role": "Staff", "status": "Inactive"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Staff Management"),
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Nanti buat fungsi tambah staff
        backgroundColor: const Color(0xFF8B4513),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: staffList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final staff = staffList[index];
          return ListTile(
            tileColor: Colors.grey.shade100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
            title: Text(staff['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Role: ${staff['role']}"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: staff['status'] == 'Active' ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(staff['status']!, style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
          );
        },
      ),
    );
  }
}