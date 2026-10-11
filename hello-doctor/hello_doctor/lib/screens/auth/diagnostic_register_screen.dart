import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

class DiagnosticRegisterScreen extends StatefulWidget {
  const DiagnosticRegisterScreen({super.key});

  @override
  State<DiagnosticRegisterScreen> createState() => _DiagnosticRegisterScreenState();
}

class _DiagnosticRegisterScreenState extends State<DiagnosticRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // Controllers
  final _centerNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _licenseController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  String? _licenseDocPath;

  @override
  void dispose() {
    _centerNameController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _licenseController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  // Pick regulatory certificate document
  Future<void> _pickLicenseDoc() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
      );
      if (file != null) {
        setState(() {
          _licenseDocPath = file.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Regulatory License document linked successfully.')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error picking license: $e');
      setState(() {
        _licenseDocPath = 'mock_regulatory_license_${DateTime.now().millisecondsSinceEpoch}.jpg';
      });
    }
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_licenseDocPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or upload your Regulatory/Diagnostic Center License.')),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    final success = await authService.registerDiagnostic(
      centerName: _centerNameController.text.trim(),
      contactPerson: _contactPersonController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      licenseDocPath: _licenseDocPath,
    );

    if (success && mounted) {
      context.go(AppRoutes.pendingApproval);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email or Phone is already registered.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Diagnostic Onboarding',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go(AppRoutes.roleSelection),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Onboard your Diagnostic Lab',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ClinicalTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Join our medical diagnostics platform to list test catalogs, process digital sample pickup, and upload patient lab reports securely.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: ClinicalTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),

                const Text(
                  'Diagnostic Centre Name',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _centerNameController,
                  validator: (v) => v == null || v.isEmpty ? 'Center name is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.biotech_outlined, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. Popular Diagnostic (Dhanmondi)',
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Contact Person (Lab Manager / Director)',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _contactPersonController,
                  validator: (v) => v == null || v.isEmpty ? 'Contact person is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.badge_outlined, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. Professor Dr. Mustafizur Rahman',
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Contact Phone Number',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.isEmpty ? 'Phone number is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone_iphone_rounded, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. 01722222222',
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Diagnostic Email Address',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@') ? 'Valid email is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. contact@populardiagnostic.com',
                  ),
                ),
                const SizedBox(height: 18),

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
                const SizedBox(height: 18),

                const Text(
                  'DGHS Registration / Diagnostic License Number',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _licenseController,
                  validator: (v) => v == null || v.isEmpty ? 'License number is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.assignment_turned_in_outlined, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. DGHS-DL-48293',
                  ),
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Full Address',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _addressController,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_on_outlined, color: ClinicalTheme.textSecondary),
                              hintText: 'e.g. House 12, Road 2, Dhanmondi',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'City',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _cityController,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                            decoration: const InputDecoration(
                              hintText: 'e.g. Dhaka',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  'DGHS Regulatory License Document *',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _pickLicenseDoc,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _licenseDocPath != null ? ClinicalTheme.accentGreen : const Color(0xffe0e4ec),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _licenseDocPath != null ? Icons.verified_rounded : Icons.folder_zip_outlined,
                          size: 38,
                          color: _licenseDocPath != null ? ClinicalTheme.accentGreen : ClinicalTheme.textSecondary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _licenseDocPath != null 
                              ? 'DGHS Certificate Linked' 
                              : 'Select DGHS Diagnostic License Certificate',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _licenseDocPath != null ? ClinicalTheme.accentGreen : ClinicalTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _licenseDocPath != null
                              ? _licenseDocPath!.split('/').last
                              : 'Supports PDF, JPG, PNG (Local Mock Device Link)',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: ClinicalTheme.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: authService.isLoading ? null : _handleSubmit,
                  child: authService.isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Register Diagnostic Centre'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClinicalTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
