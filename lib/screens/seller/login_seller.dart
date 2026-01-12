import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Tambah ni
import '../../models/user.dart';
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
  bool _isSubmitting = false; // Untuk loading state

  LoginRole _selectedRole = LoginRole.owner;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- LOGIC SUPABASE START ---
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      final supabase = Supabase.instance.client;
      final selectedRoleStr = _selectedRole == LoginRole.owner ? 'owner' : 'staff';

      try {
        // 1. Cari user yang match Username, Password, DAN Role
        final response = await supabase
            .from('users')
            .select()
            .eq('username', _usernameController.text.trim())
            .eq('password', _passwordController.text)
            .eq('role', selectedRoleStr)
            .maybeSingle();

        if (response != null) {
          final user = UserModel.fromMap(response);

          // 2. Simpan Activity Log Login
          await supabase.from('activity_logs').insert({
            'user_id': user.id,
            'user_name': user.fullName,
            'role': user.role,
            'action': 'LOGIN',
            'details': '${user.fullName} logged into the system',
          });

          if (!mounted) return;

          // 3. Navigate ikut role
          if (user.role == 'owner') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => OwnerMainController(currentUser: user)),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => SellerMainController(currentUser: user)),
            );
          }
        } else {
          // Jika data tak jumpa
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid $selectedRoleStr credentials")),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connection Error: $e")),
        );
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }
  // --- LOGIC SUPABASE END ---

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
                  onPressed: _isSubmitting ? null : _login, // Disable masa loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isSubmitting 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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