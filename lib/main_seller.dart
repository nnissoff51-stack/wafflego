import 'package:flutter/material.dart';
import 'package:wafflego/models/user.dart';
import 'screens/seller/seller_home_screen.dart';

void main() => runApp(const WaffleGoSellerApp());

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
      home: SellerHomeScreen(
        currentUser: User(
          username: 'admin',
          password: 'password123',
          fullName: 'Admin User',
          role: 'owner',
        ),
        isShopOpen: true,
        onToggleShopStatus: () {
          print("Shop status toggled");
        },
      ),
    );
  }
}