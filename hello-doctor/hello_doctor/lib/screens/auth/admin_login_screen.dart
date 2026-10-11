import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await authService.loginWithEmail(email, password);

    if (success && mounted) {
      final user = authService.currentUser;
      if (user?.role == UserRole.admin) {
        context.go(AppRoutes.adminHome);
      } else {
        // If they managed to log in but aren't admin
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access Denied: This portal is exclusively for Super Administrators.')),
        );
        await authService.logout();
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Admin Credentials. Please check and retry.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ClinicalTheme.textDark),
          onPressed: () => context.go(AppRoutes.roleSelection),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ClinicalTheme.textDark.withOpacity(0.06),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 64,
                        color: ClinicalTheme.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Super Admin Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ClinicalTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Secure administrator access portal. Verification, database curation, and partner vetting activities.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: ClinicalTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // EMAIL
                  const Text(
                    'Administrator Email',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v == null || !v.contains('@') ? 'Enter a valid admin email address' : null,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined, color: ClinicalTheme.textSecondary),
                      hintText: 'admin@hellodoctor.com',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // PASSWORD
                  const Text(
                    'Admin Password',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (v) => v == null || v.isEmpty ? 'Admin password is required' : null,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: ClinicalTheme.textSecondary),
                      hintText: '••••••••',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Demo Reminder text
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ClinicalTheme.primaryBlue.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline_rounded, size: 18, color: ClinicalTheme.primaryBlue),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Demo Login Credentials:\nEmail: admin@hellodoctor.com\nPass: admin123',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: ClinicalTheme.textDark, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: authService.isLoading ? null : _handleLogin,
                    child: authService.isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Authenticate & Unlock'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ClinicalTheme.textDark,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
