import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_style.dart';
import 'menu_pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idCtl = TextEditingController();
  final _pwCtl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _idCtl.dispose();
    _pwCtl.dispose();
    super.dispose();
  }

  /// Chọn trang menu theo chức vụ. Trả về null nếu chức vụ không hợp lệ.
  Widget? _menuFor(String role, Map<String, dynamic> user) {
    final r = role.toLowerCase();
    if (r.contains('admin') || r.contains('quản trị') || r.contains('quan tri')) {
      return AdminMenu(user: user);
    }
    if (r.contains('manager') || r.contains('quản lý') || r.contains('quan ly')) {
      return ManagerMenu(user: user);
    }
    if (r.contains('staff') || r.contains('nhân viên') || r.contains('nhan vien')) {
      return StaffMenu(user: user);
    }
    return null;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await Supabase.instance.client.rpc(
        'login_staff',
        params: {'p_id': _idCtl.text.trim(), 'p_password': _pwCtl.text},
      );
      if (!mounted) return;

      if (res == null) {
        setState(() => _error = 'Sai mã nhân viên hoặc mật khẩu');
        return;
      }

      final user = Map<String, dynamic>.from(res as Map);
      final role = '${user['staff_role']}'.trim().toLowerCase();
      final next = _menuFor(role, user);

      if (next == null) {
        setState(() => _error =
        'Tài khoản chưa có chức vụ hợp lệ (staff_role: ${user['staff_role']})');
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => next),
      );
    } catch (e) {
      if (mounted) setState(() => _error = 'Lỗi kết nối: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ===== XÓA hàm này và đoạn "Xem thử" bên dưới trước khi nộp bài =====
  void _demo(String role) {
    final user = <String, dynamic>{
      'id': 0,
      'staff_name': 'Tài khoản thử',
      'staff_role': role,
    };
    final next = _menuFor(role.toLowerCase(), user);
    if (next != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => next),
      );
    }
  }

  InputDecoration _field(String label, IconData icon, {Widget? suffix}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppStyle.radius),
      borderSide: const BorderSide(color: AppStyle.line),
    );
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppStyle.primary),
      suffixIcon: suffix,
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppStyle.radius),
        borderSide: const BorderSide(color: AppStyle.primary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: AppStyle.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_cafe,
                        size: 52, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cafe Manager',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Đăng nhập để quản lý nhân sự',
                    style: TextStyle(fontSize: 14, color: AppStyle.soft),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F6F4E37),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _idCtl,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration:
                            _field('Mã nhân viên', Icons.badge_outlined),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Nhập mã nhân viên'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _pwCtl,
                            obscureText: _obscure,
                            onFieldSubmitted: (_) => _login(),
                            decoration: _field(
                              'Mật khẩu',
                              Icons.lock_outline,
                              suffix: IconButton(
                                icon: Icon(_obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Nhập mật khẩu'
                                : null,
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            Text(_error!,
                                style:
                                const TextStyle(color: AppStyle.danger)),
                          ],
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 52,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppStyle.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(AppStyle.radius),
                                ),
                              ),
                              onPressed: _loading ? null : _login,
                              child: _loading
                                  ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          // ===== XÓA đoạn "Xem thử" này trước khi nộp bài =====
                          const SizedBox(height: 12),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            children: [
                              for (final r in ['Admin', 'Manager', 'Staff'])
                                OutlinedButton(
                                  onPressed: () => _demo(r),
                                  child: Text('Xem thử $r'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}