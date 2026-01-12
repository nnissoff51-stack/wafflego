import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final supabase = Supabase.instance.client;

  // --- 1. SIMPAN ATAU UPDATE USER ---
  Future<void> _saveUser({UserModel? existingUser, required Map<String, dynamic> rawData}) async {
    try {
      if (existingUser != null) {
        // Update user sedia ada
        await supabase.from('users').update(rawData).eq('id', existingUser.id!);
        _logAction("UPDATED STAFF", "Updated info for ${rawData['full_name']}");
      } else {
        // Tambah user baru (guna toMap logic)
        final newUser = UserModel(
          username: rawData['username'],
          password: rawData['password'],
          fullName: rawData['full_name'],
          email: rawData['email'],
          role: 'staff',
          isActive: true,
        );
        
        await supabase.from('users').insert(newUser.toMap());
        _logAction("ADDED STAFF", "Registered new staff: ${rawData['username']}");
      }
    } catch (e) {
      _showErrorSnackBar("Save failed: $e");
    }
  }

  // --- 2. TOGGLE STATUS AKTIF/TIDAK ---
  Future<void> _toggleStaffStatus(UserModel user) async {
    try {
      final newStatus = !user.isActive;
      await supabase.from('users').update({'is_active': newStatus}).eq('id', user.id!);
      
      _logAction("STATUS CHANGE", "${user.username} is now ${newStatus ? 'ACTIVE' : 'INACTIVE'}");
    } catch (e) {
      _showErrorSnackBar("Update status failed: $e");
    }
  }

  // --- 3. LOG AKTIVITI KE DATABASE ---
  Future<void> _logAction(String action, String details) async {
    await supabase.from('activity_logs').insert({
      'user_id': supabase.auth.currentUser?.id,
      'user_name': 'Owner',
      'role': 'owner',
      'action': action,
      'details': details,
    });
  }

  void _showErrorSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // --- DIALOG FORM (TAMBAH/EDIT) ---
  void _showUserForm({UserModel? user}) {
    final isEditing = user != null;
    final nameController = TextEditingController(text: user?.fullName);
    final usernameController = TextEditingController(text: user?.username);
    final emailController = TextEditingController(text: user?.email);
    final passwordController = TextEditingController(text: user?.password);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEditing ? "Edit Staff Details" : "Register New Staff"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: usernameController, decoration: const InputDecoration(labelText: "Username")),
              TextField(
                controller: passwordController, 
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              _saveUser(
                existingUser: user,
                rawData: {
                  'full_name': nameController.text,
                  'username': usernameController.text,
                  'email': emailController.text,
                  'password': passwordController.text,
                }
              );
              Navigator.pop(context);
            },
            child: Text(isEditing ? "Update" : "Register", style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CC),
      appBar: AppBar(
        title: const Text("Staff Management", style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserForm(),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        // Filter: Hanya tunjuk staff sahaja
        stream: supabase.from('users').stream(primaryKey: ['id']).eq('role', 'staff'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final staffData = snapshot.data ?? [];
          if (staffData.isEmpty) return const Center(child: Text("No staff found."));

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: staffData.length,
            itemBuilder: (context, index) {
              // GUNA .fromMap() IKUT MODEL KAU
              final staff = UserModel.fromMap(staffData[index]);
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: staff.isActive ? Colors.blueAccent : Colors.grey, 
                    child: const Icon(Icons.person, color: Colors.white)
                  ),
                  title: Text(staff.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("@${staff.username}\nStatus: ${staff.isActive ? 'Active' : 'Suspended'}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Switch untuk Aktif/Tidak
                      Switch(
                        value: staff.isActive, 
                        onChanged: (_) => _toggleStaffStatus(staff),
                        activeColor: Colors.green,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showUserForm(user: staff),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}