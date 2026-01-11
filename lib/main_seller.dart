import 'package:flutter/material.dart';
// Pastikan path ke choose_screen ni betul ikut susunan folder kau
import 'screens/shared/choose_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waffle Go Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Guna warna oren sebagai tema utama Waffle Go
        primarySwatch: Colors.orange,
        useMaterial3: true,
        // Set font atau gaya button secara global jika perlu
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      // Kita hantar terus ke ChooseScreen sebagai pintu masuk utama
      home: const ChooseScreen(),
    );
  }
}