import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

class PharmacyRegisterScreen extends StatefulWidget {
  const PharmacyRegisterScreen({super.key});

  @override
  State<PharmacyRegisterScreen> createState() => _PharmacyRegisterScreenState();
}

class _PharmacyRegisterScreenState extends State<PharmacyRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // Controllers
  final _pharmacyNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _licenseController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  String? _licenseDocPath;

  @override
  void dispose() {
    _pharmacyNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _licenseController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  // Pick trade license document
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
            const SnackBar(content: Text('Trade License document linked successfully.')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error picking license: $e');
      setState(() {
        _licenseDocPath = 'mock_trade_license_${DateTime.now().millisecondsSinceEpoch}.jpg';
      });
    }
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_licenseDocPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or upload your Trade License certificate.')),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    final success = await authService.registerPharmacy(
      pharmacyName: _pharmacyNameController.text.trim(),
      ownerName: _ownerNameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      tradeLicenseNumber: _licenseController.text.trim(),
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
          'Pharmacy Onboarding',
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
                  'Onboard your Medicine Outlet',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ClinicalTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Join our verified pharmacy partner net to receive e-prescription dispatch requests and digital drug order fulfillments.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: ClinicalTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),

                const Text(
                  'Pharmacy Outlet Name',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pharmacyNameController,
                  validator: (v) => v == null || v.isEmpty ? 'Pharmacy name is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.storefront_outlined, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. Lazz Pharma (Dhanmondi)',
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Owner / Manager Name',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ownerNameController,
                  validator: (v) => v == null || v.isEmpty ? 'Owner name is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. Mohammad Harunur Rashid',
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
                    hintText: 'e.g. 01800000000',
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Pharmacy Email Address',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@') ? 'Valid email is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. info@lazzpharma.com',
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
                  'Trade License / Drug License Number',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _licenseController,
                  validator: (v) => v == null || v.isEmpty ? 'Trade/Drug license is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.receipt_long_outlined, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. DL-93821-DH',
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
                            'Street Address',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _addressController,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_on_outlined, color: ClinicalTheme.textSecondary),
                              hintText: 'e.g. House 24, Road 4/A',
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
                  'Drug / Trade License Document *',
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
                          _licenseDocPath != null ? Icons.verified_rounded : Icons.file_present_rounded,
                          size: 38,
                          color: _licenseDocPath != null ? ClinicalTheme.accentGreen : ClinicalTheme.textSecondary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _licenseDocPath != null 
                              ? 'License Certificate Linked' 
                              : 'Select Pharmacy Trade/Drug License File',
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
                      : const Text('Register Pharmacy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfff2994a),
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
