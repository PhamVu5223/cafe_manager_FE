import 'package:flutter/material.dart';

import 'app_style.dart';
import 'login_page.dart';

class MenuItem {
  final IconData icon;
  final String label;
  const MenuItem(this.icon, this.label);
}

/// Khung chung của mọi trang menu.
class _MenuShell extends StatelessWidget {
  final String title;
  final Map<String, dynamic> user;
  final List<MenuItem> items;
  final Widget? top;

  const _MenuShell({
    required this.title,
    required this.user,
    required this.items,
    this.top,
  });

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = '${user['staff_name'] ?? user['id']}';

    return Scaffold(
      backgroundColor: AppStyle.background,
      appBar: AppBar(
        backgroundColor: AppStyle.primary,
        foregroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Xin chào,',
              style: TextStyle(fontSize: 14, color: AppStyle.soft)),
          Text(name,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.primary)),
          const SizedBox(height: 20),
          if (top != null) ...[top!, const SizedBox(height: 16)],
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              for (final it in items) _Tile(item: it),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final MenuItem item;
  const _Tile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Chức năng "${item.label}" sẽ làm sau')),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 36, color: AppStyle.primary),
            const SizedBox(height: 8),
            Text(item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppStyle.ink)),
          ],
        ),
      ),
    );
  }
}

/// Nút quét mã chấm công (camera sẽ làm sau).
class _ScanButton extends StatelessWidget {
  const _ScanButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppStyle.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quét mã bằng camera sẽ làm sau')),
          );
        },
        icon: const Icon(Icons.qr_code_scanner, size: 26),
        label: const Text('Quét mã chấm công',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class StaffMenu extends StatelessWidget {
  final Map<String, dynamic> user;
  const StaffMenu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return _MenuShell(
      title: 'Nhân viên',
      user: user,
      top: const _ScanButton(),
      items: const [
        MenuItem(Icons.calendar_month, 'Lịch làm của tôi'),
        MenuItem(Icons.description_outlined, 'Xin nghỉ phép'),
        MenuItem(Icons.account_balance_wallet_outlined, 'Phiếu lương'),
        MenuItem(Icons.folder_open, 'Tài liệu nhân sự'),
      ],
    );
  }
}

class ManagerMenu extends StatelessWidget {
  final Map<String, dynamic> user;
  const ManagerMenu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return _MenuShell(
      title: 'Quản lý',
      user: user,
      items: const [
        MenuItem(Icons.people_outline, 'Nhân viên'),
        MenuItem(Icons.calendar_month, 'Phân công ca'),
        MenuItem(Icons.access_time, 'Chấm công'),
        MenuItem(Icons.description_outlined, 'Duyệt nghỉ phép'),
        MenuItem(Icons.account_balance_wallet_outlined, 'Bảng lương'),
        MenuItem(Icons.folder_open, 'Tài liệu nhân sự'),
      ],
    );
  }
}

class AdminMenu extends StatelessWidget {
  final Map<String, dynamic> user;
  const AdminMenu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return _MenuShell(
      title: 'Quản trị',
      user: user,
      items: const [
        MenuItem(Icons.manage_accounts_outlined, 'Quản lý tài khoản'),
        MenuItem(Icons.people_outline, 'Nhân viên'),
        MenuItem(Icons.bar_chart, 'Báo cáo'),
        MenuItem(Icons.folder_open, 'Tài liệu nhân sự'),
      ],
    );
  }
}