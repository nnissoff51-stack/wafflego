import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/seller/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL', // Replace with your URL
    anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with your anon key
  );
  
  runApp(const WaffleGoSellerApp());
}

// Global Supabase client
final supabase = Supabase.instance.client;

class WaffleGoSellerApp extends StatelessWidget {
  const WaffleGoSellerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaffleGo Seller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}