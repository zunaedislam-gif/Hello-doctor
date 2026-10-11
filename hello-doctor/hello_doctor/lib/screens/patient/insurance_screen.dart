import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _providerController;
  late TextEditingController _policyNumberController;
  late TextEditingController _coverageController;
  
  String? _cardFrontPath;
  String? _cardBackPath;
  bool _isVerified = false; // Dummy toggle for verification state

  @override
  void initState() {
    super.initState();
    _providerController = TextEditingController(text: 'MetLife Bangladesh');
    _policyNumberController = TextEditingController(text: 'ML-9382-PAT');
    _coverageController = TextEditingController(text: '৳ 200,000 OPD / Inpatient');
    _loadInsuranceData();
  }

  Future<void> _loadInsuranceData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _providerController.text = prefs.getString('insurance_provider') ?? 'MetLife Bangladesh';
      _policyNumberController.text = prefs.getString('insurance_policy') ?? 'ML-9382-PAT';
      _coverageController.text = prefs.getString('insurance_coverage') ?? '৳ 200,000 OPD / Inpatient';
      _cardFrontPath = prefs.getString('insurance_front_path');
      _cardBackPath = prefs.getString('insurance_back_path');
      _isVerified = prefs.getBool('insurance_verified') ?? false;
    });
  }

  Future<void> _saveInsuranceData() async {
    if (!_formKey.currentState!.validate()) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('insurance_provider', _providerController.text);
    await prefs.setString('insurance_policy', _policyNumberController.text);
    await prefs.setString('insurance_coverage', _coverageController.text);
    await prefs.setBool('insurance_verified', _isVerified);
    if (_cardFrontPath != null) {
      await prefs.setString('insurance_front_path', _cardFrontPath!);
    }
    if (_cardBackPath != null) {
      await prefs.setString('insurance_back_path', _cardBackPath!);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Insurance information saved successfully!'),
        backgroundColor: ClinicalTheme.accentGreen,
      ),
    );
  }

  Future<void> _pickCardSide(bool isFront) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image != null) {
        setState(() {
          if (isFront) {
            _cardFrontPath = image.path;
          } else {
            _cardBackPath = image.path;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${isFront ? "Front" : "Back"} of insurance card selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  void dispose() {
    _providerController.dispose();
    _policyNumberController.dispose();
    _coverageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ClinicalTheme.textDark, size: 20),
          onPressed: () => context.go('/patient-home'),
        ),
        title: const Text(
          'Health Insurance',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ClinicalTheme.textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline_rounded, color: ClinicalTheme.primaryBlue),
            onPressed: _saveInsuranceData,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Verification Badge Card
                Card(
                  elevation: 0,
                  color: _isVerified ? ClinicalTheme.accentGreen.withOpacity(0.06) : Colors.orange.withOpacity(0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: _isVerified ? ClinicalTheme.accentGreen.withOpacity(0.15) : Colors.orange.withOpacity(0.15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isVerified ? ClinicalTheme.accentGreen : Colors.orange,
                          ),
                          child: Icon(
                            _isVerified ? Icons.verified_rounded : Icons.pending_actions_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isVerified ? 'Verification Active' : 'Verification Pending',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: _isVerified ? ClinicalTheme.accentGreen : Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'MetLife e-Health Desk is validating benefits.',
                                style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: ClinicalTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        // Mini Simulator Toggle
                        Column(
                          children: [
                            const Text('MOCK APPROVE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey)),
                            Switch(
                              value: _isVerified,
                              activeColor: ClinicalTheme.accentGreen,
                              onChanged: (val) {
                                setState(() => _isVerified = val);
                                _saveInsuranceData();
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Policy details
                const Text(
                  'POLICY DETAILS',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.extrabold,
                    fontSize: 11,
                    color: ClinicalTheme.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),

                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildInputField(
                          controller: _providerController,
                          label: 'Insurance Provider Name',
                          icon: Icons.business_rounded,
                        ),
                        const SizedBox(height: 14),
                        _buildInputField(
                          controller: _policyNumberController,
                          label: 'Policy / Member Number',
                          icon: Icons.badge_rounded,
                        ),
                        const SizedBox(height: 14),
                        _buildInputField(
                          controller: _coverageController,
                          label: 'Coverage Limit & Directives',
                          icon: Icons.monetization_on_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Document uploads (Front / Back cards)
                const Text(
                  'UPLOAD INSURANCE CARD PHOTO',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.extrabold,
                    fontSize: 11,
                    color: ClinicalTheme.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _buildDocUploadCard(
                        title: 'Card Front Side',
                        filePath: _cardFrontPath,
                        onTap: () => _pickCardSide(true),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildDocUploadCard(
                        title: 'Card Back Side',
                        filePath: _cardBackPath,
                        onTap: () => _pickCardSide(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _saveInsuranceData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ClinicalTheme.primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Save Policy Details',
                      style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: ClinicalTheme.textDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: ClinicalTheme.textSecondary),
        prefixIcon: Icon(icon, color: ClinicalTheme.primaryBlue, size: 18),
        filled: true,
        fillColor: ClinicalTheme.backgroundLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ClinicalTheme.primaryBlue, width: 1.2),
        ),
      ),
    );
  }

  Widget _buildDocUploadCard({
    required String title,
    required String? filePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.08)),
        ),
        child: filePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(filePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_photo_alternate_rounded, color: ClinicalTheme.primaryBlue, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 11, color: ClinicalTheme.textDark),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Tap to select',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 9, color: ClinicalTheme.textSecondary),
                  ),
                ],
              ),
      ),
    );
  }
}
