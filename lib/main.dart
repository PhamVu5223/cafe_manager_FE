import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo kết nối tới Supabase Backend
  await Supabase.initialize(
    url: 'https://jyjvelebxghzlnqghhwa.supabase.co', // Dán Project URL của bạn vào đây
    anonKey: 'sb_publishable_WQESTfsjp8hj1d020--OfQ_s1VeX6eF',     // Dán Anon Key vào đây
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafe Manager App',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const Scaffold(
        body: Center(
          child: Text('Đã liên kết Frontend và Supabase Backend thành công!'),
        ),
      ),
    );
  }
}