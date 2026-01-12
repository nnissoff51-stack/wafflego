import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 1. Pastikan import ini ada
import 'screens/shared/choose_screen.dart'; 

Future<void> main() async {
  // 2. Wajib ada baris ni kalau guna 'async' dalam main
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Masukkan URL dan Anon Key dari Supabase Dashboard kau
  await Supabase.initialize(
    url: 'https://meqaazsiflqbqtrthntw.supabase.co',
    anonKey: 'sb_publishable_yw5sR4N9v_eAgCXNnL1mSQ_msS1EuJK', 
  );

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const ChooseScreen(),
    );
  }
}