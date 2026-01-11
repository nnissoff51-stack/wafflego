import 'package:flutter/material.dart';
import '../../models/user.dart';
// Import controller ikut folder dalam screenshot kau
import '../owner/owner_main_controller.dart';
import '../seller/seller_main_controller.dart';

enum LoginRole { owner, staff }

class LoginSellerScreen extends StatefulWidget {
  const LoginSellerScreen({super.key});

  @override
  State<LoginSellerScreen> createState() => _LoginSellerScreenState();
}

class _LoginSellerScreenState extends State<LoginSellerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginRole _selectedRole = LoginRole.owner;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Tentukan role dalam string
      final role = _selectedRole == LoginRole.owner ? 'owner' : 'staff';

      final user = UserModel(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        fullName: _usernameController.text.trim(),
        email: '${_usernameController.text.trim()}@wafflego.com',
        role: role,
      );

      // --- LOGIC INTEGRASI IKUT ROLE ---
      if (_selectedRole == LoginRole.owner) {
        // Hantar ke folder owner
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OwnerMainController(currentUser: user),
          ),
        );
      } else {
        // Hantar ke folder seller
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SellerMainController(currentUser: user),
          ),
        );
      }
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
              Image.asset('assets/images/wafflego_logo.png', 
                width: 120, 
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.store, size: 80, color: Colors.orange),
              ),
              const SizedBox(height: 16),
              const Text(
                "WaffleGo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(label: 'Username', controller: _usernameController),
                    const SizedBox(height: 16),
                    _buildField(label: 'Password', controller: _passwordController, obscure: true),
                    const SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildRadioButton('Owner', LoginRole.owner),
                        const SizedBox(width: 32),
                        _buildRadioButton('Staff', LoginRole.staff),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton(String label, LoginRole role) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<LoginRole>(
          value: role,
          groupValue: _selectedRole,
          activeColor: Colors.orange,
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: (value) => setState(() => _selectedRole = value!),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: (v) => v == null || v.isEmpty ? '$label is required' : null,
          decoration: InputDecoration(
            hintText: label,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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