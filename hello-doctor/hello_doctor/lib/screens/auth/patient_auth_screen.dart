import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

class PatientAuthScreen extends StatefulWidget {
  const PatientAuthScreen({super.key});

  @override
  State<PatientAuthScreen> createState() => _PatientAuthScreenState();
}

class _PatientAuthScreenState extends State<PatientAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Flows state
  bool _isPhoneFlow = true;
  bool _isOtpSent = false;
  bool _isSignUp = false; // Used for email fallback sign up state
  bool _biometricsEnabled = false; // Mock biometrics status

  // Controllers
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handle Send OTP
  void _handleSendOtp(AuthService authService) async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number.')),
      );
      return;
    }

    final mockOtp = await authService.sendPatientOtp(phone);
    setState(() {
      _isOtpSent = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mock OTP Sent: $mockOtp (Use any 6 digits to verify)'),
          duration: const Duration(seconds: 8),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'AUTO-FILL',
            onPressed: () {
              _otpController.text = mockOtp;
            },
          ),
        ),
      );
    }
  }

  // Handle Verify OTP
  void _handleVerifyOtp(AuthService authService) async {
    final phone = _phoneController.text.trim();
    final otp = _otpController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code must be exactly 6 digits.')),
      );
      return;
    }

    final success = await authService.verifyPatientOtp(
      phone, 
      otp,
      name: name.isNotEmpty ? name : null,
      email: email.isNotEmpty ? email : null,
    );

    if (success && mounted) {
      context.go(AppRoutes.patientHome);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid verification code. Please try again.')),
      );
    }
  }

  // Handle Email Logic (Login or Signup)
  void _handleEmailSubmit(AuthService authService) async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isSignUp) {
      // Register Patient
      final success = await authService.registerPatientWithEmail(
        name: name,
        phone: phone,
        email: email,
        password: password,
      );

      if (success && mounted) {
        context.go(AppRoutes.patientHome);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email or phone already registered.')),
        );
      }
    } else {
      // Login Patient
      final success = await authService.loginWithEmail(email, password);
      if (success && mounted) {
        if (authService.currentUser?.role == UserRole.patient) {
          context.go(AppRoutes.patientHome);
        } else {
          // If logged in user is admin, doctor, etc., redirect appropriately
          context.go(AppRoutes.getRouteForRole(authService.currentUser!.role));
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password. Please try again.')),
        );
      }
    }
  }

  // Simulate Biometrics Activation or Log In
  void _handleBiometricLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.fingerprint_rounded, size: 36, color: ClinicalTheme.primaryBlue),
            SizedBox(width: 10),
            Text('Biometric Auth', style: TextStyle(fontFamily: 'Poppins')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mock Touch ID / Face ID Authentication.',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              _biometricsEnabled 
                  ? 'Would you like to sign in immediately using your saved biometrics?'
                  : 'To enable biometric login, you must sign in with your phone or email credentials once first, then enable biometrics from your profile settings.',
              style: const TextStyle(fontFamily: 'Inter', color: ClinicalTheme.textSecondary, fontSize: 13, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: ClinicalTheme.textSecondary)),
          ),
          if (_biometricsEnabled)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Simulate biometric login
                final authService = Provider.of<AuthService>(context, listen: false);
                // Find first patient or seed standard one
                if (authService.allUsers.any((u) => u.role == UserRole.patient)) {
                  final patient = authService.allUsers.firstWhere((u) => u.role == UserRole.patient);
                  authService.loginWithEmail(patient.email, patient.password ?? '');
                  context.go(AppRoutes.patientHome);
                } else {
                  // Fallback seed
                  authService.verifyPatientOtp('01712345678', '123456');
                  context.go(AppRoutes.patientHome);
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(100, 44)),
              child: const Text('Authenticate'),
            )
          else
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _biometricsEnabled = true;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Biometrics simulated & enabled! You can now use fingerprint shortcut on next visit.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(100, 44)),
              child: const Text('Simulate Enable'),
            ),
        ],
      ),
    );
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Brand Section
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: ClinicalTheme.primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 54,
                      color: ClinicalTheme.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Patient Portal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: ClinicalTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Access your medical dashboard, consult clinical professionals, and retrieve prescriptions.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: ClinicalTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // TOGGLE TABS (Phone OTP vs Email Fallback)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isPhoneFlow = true;
                              _isOtpSent = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isPhoneFlow ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: _isPhoneFlow 
                                  ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))]
                                  : null,
                            ),
                            child: const Text(
                              'Phone OTP',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isPhoneFlow = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isPhoneFlow ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: !_isPhoneFlow 
                                  ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))]
                                  : null,
                            ),
                            child: const Text(
                              'Email Fallback',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // PHONE / OTP AUTH FLOW
                if (_isPhoneFlow) ...[
                  if (!_isOtpSent) ...[
                    // Enter Phone Form
                    const Text(
                      'Mobile Phone Number',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone_iphone_rounded, color: ClinicalTheme.textSecondary),
                        hintText: 'e.g. 01712345678',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Optional: For new registrations, enter details below before sending OTP.',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: ClinicalTheme.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_rounded, color: ClinicalTheme.textSecondary),
                        hintText: 'Full Name (For Signup)',
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: authService.isLoading ? null : () => _handleSendOtp(authService),
                      child: authService.isLoading 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Send Verification OTP'),
                    ),
                  ] else ...[
                    // Enter 6-digit OTP Code Form
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        Text(
                          'Verifying ${_phoneController.text}',
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _isOtpSent = false),
                          child: const Text('Edit Phone', style: TextStyle(color: ClinicalTheme.primaryBlue, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: const TextStyle(letterSpacing: 8, fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        counterText: '',
                        hintText: '••••••',
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: authService.isLoading ? null : () => _handleVerifyOtp(authService),
                      child: authService.isLoading 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Verify & Proceed'),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: authService.isLoading ? null : () => _handleSendOtp(authService),
                        child: const Text('Resend Code', style: TextStyle(color: ClinicalTheme.textSecondary, fontSize: 13)),
                      ),
                    ),
                  ],
                ]

                // EMAIL + PASSWORD FALLBACK FLOW
                else ...[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_isSignUp) ...[
                          const Text(
                            'Full Name',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            validator: (v) => v == null || v.isEmpty ? 'Please enter your name' : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.badge_outlined, color: ClinicalTheme.textSecondary),
                              hintText: 'e.g. John Doe',
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Phone Number',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (v) => v == null || v.length < 10 ? 'Please enter a valid phone number' : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone_rounded, color: ClinicalTheme.textSecondary),
                              hintText: 'e.g. 01712345678',
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        const Text(
                          'Email Address',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => v == null || !v.contains('@') ? 'Please enter a valid email address' : null,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined, color: ClinicalTheme.textSecondary),
                            hintText: 'e.g. name@example.com',
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Password',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (v) => v == null || v.length < 6 ? 'Password must be at least 6 characters' : null,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline_rounded, color: ClinicalTheme.textSecondary),
                            hintText: '••••••••',
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: authService.isLoading ? null : () => _handleEmailSubmit(authService),
                          child: authService.isLoading 
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(_isSignUp ? 'Create Account' : 'Log In'),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isSignUp ? 'Already have an account?' : 'Don\'t have an email account?',
                              style: const TextStyle(fontSize: 13, color: ClinicalTheme.textSecondary, fontFamily: 'Inter'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isSignUp = !_isSignUp;
                                });
                              },
                              child: Text(
                                _isSignUp ? 'Log In' : 'Sign Up',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                // OR SEPARATOR FOR BIOMETRICS
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR QUICK LOG IN',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.grey.shade400, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),

                // BIOMETRIC QUICK BUTTON (FREE local_auth placeholder style)
                OutlinedButton.icon(
                  onPressed: _handleBiometricLogin,
                  icon: const Icon(Icons.fingerprint_rounded, size: 24),
                  label: const Text('Log In with Biometrics'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    foregroundColor: ClinicalTheme.textDark,
                    textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
