import 'package:flutter/material.dart';
import 'package:wafflego/models/user.dart';
import 'package:wafflego/screens/seller/seller_dashboard_one.dart';
// import '../../models/user.dart'; // Pastikan import model User awak di sini jika perlu

enum LoginRole { owner, staff }

class LoginStaffScreen extends StatefulWidget {
  const LoginStaffScreen({super.key});

  @override
  State<LoginStaffScreen> createState() => _LoginStaffScreenState();
}

class _LoginStaffScreenState extends State<LoginStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final staffNameController = TextEditingController();
  final passwordController = TextEditingController();

  LoginRole _selectedRole = LoginRole.owner;

  @override
  void dispose() {
    staffNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final role = _selectedRole == LoginRole.owner ? "Owner" : "Staff";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login as $role success")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SellerDashboardOne(
            isShopOpen: true,
            // Jika SellerDashboardOne minta currentUser yang tak boleh null:
            // currentUser: User(name: staffNameController.text), 
            currentUser: User(username: staffNameController.text, password: passwordController.text, fullName: staffNameController.text, role: role),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Column(
                children: [
                  Image.asset(
                    'assets/images/wafflego_logo.png',
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  const Icon(Icons.breakfast_dining, size: 90),
                  const SizedBox(height: 8),
                  const Text(
                    "WAFFLEGO",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const Text("CRISPY AND CRUNCHY"),
                ],
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(
                      label: "Staff Name",
                      hint: "Enter staff name",
                      controller: staffNameController,
                      validator: (v) => v == null || v.isEmpty ? "Staff name required" : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: "Password",
                      hint: "Enter your password",
                      controller: passwordController,
                      obscure: true,
                      validator: (v) => v == null || v.isEmpty ? "Password required" : null,
                    ),
                    const SizedBox(height: 20),

                    // ✅ FIX: Guna Column biasa, bukan RadioGroup
                    Column(
                      children: [
                        RadioListTile<LoginRole>(
                          title: const Text("Owner"),
                          value: LoginRole.owner,
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() => _selectedRole = value!);
                          },
                        ),
                        RadioListTile<LoginRole>(
                          title: const Text("Staff"),
                          value: LoginRole.staff,
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() => _selectedRole = value!);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text("Login", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}