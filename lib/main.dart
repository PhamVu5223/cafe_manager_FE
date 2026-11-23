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
      home: const StaffPage(),
    );
  }
}

class StaffPage extends StatelessWidget {
  const StaffPage({super.key});

  Future<List<Map<String, dynamic>>> _load() async {
    final rows = await Supabase.instance.client.from('Staff').select();
    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách nhân viên (Staff)')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _load(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Lỗi: ${snap.error}'));
          }
          final list = snap.data!;
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text('Kết nối thành công! (${list.length} dòng)'),
              ),
              for (final row in list)
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final e in row.entries) Text('${e.key}: ${e.value}'),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}