import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});

  @override
  State<DoctorRegisterScreen> createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // Text Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bmdcController = TextEditingController();
  final _experienceController = TextEditingController();
  final _feeController = TextEditingController();
  final _bioController = TextEditingController();

  // Specialty options
  String _selectedSpecialty = 'General Medicine';
  final List<String> _specialties = [
    'General Medicine',
    'Cardiology',
    'Dermatology',
    'Pediatrics',
    'Neurology',
    'Orthopedics',
    'Gynecology',
    'Psychiatry'
  ];

  // Upload Paths
  String? _profilePhotoPath;
  String? _licenseDocPath;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bmdcController.dispose();
    _experienceController.dispose();
    _feeController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // Pick Profile Photo using image_picker
  Future<void> _pickProfilePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _profilePhotoPath = image.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile photo selected successfully.')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      // Fallback placeholder
      setState(() {
        _profilePhotoPath = 'mock_profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      });
    }
  }

  // Pick License/Degree Document using image_picker
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
            const SnackBar(content: Text('License / Degree document uploaded successfully.')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error picking license document: $e');
      // Fallback placeholder
      setState(() {
        _licenseDocPath = 'mock_degree_document_${DateTime.now().millisecondsSinceEpoch}.pdf';
      });
    }
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_profilePhotoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or upload a profile photo.')),
      );
      return;
    }

    if (_licenseDocPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or upload your Medical Degree/BMDC Certificate.')),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    final success = await authService.registerDoctor(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      bmdcNumber: _bmdcController.text.trim(),
      specialty: _selectedSpecialty,
      yearsOfExperience: int.parse(_experienceController.text.trim()),
      consultationFee: double.parse(_feeController.text.trim()),
      bio: _bioController.text.trim(),
      profilePhotoPath: _profilePhotoPath,
      licenseDocPath: _licenseDocPath,
    );

    if (success && mounted) {
      // Doctor registered successfully. Since status is "pending", we navigate to pending approval screen
      context.go(AppRoutes.pendingApproval);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email or Phone number is already registered.')),
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
          'Doctor Registration',
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
                  'Join as a Healthcare Provider',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ClinicalTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Complete the form below to apply for our medical practitioner pool. Admin vetting is required before active consultation.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: ClinicalTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),

                // 1. PROFILE PHOTO SELECTOR
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 54,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _profilePhotoPath != null && !_profilePhotoPath!.contains('mock_')
                                ? FileImage(File(_profilePhotoPath!))
                                : null,
                            child: _profilePhotoPath == null
                                ? const Icon(Icons.person_rounded, size: 54, color: Colors.grey)
                                : _profilePhotoPath!.contains('mock_')
                                    ? const Icon(Icons.check_circle_rounded, size: 54, color: ClinicalTheme.accentGreen)
                                    : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: ClinicalTheme.primaryBlue,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                                onPressed: _pickProfilePhoto,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Upload Profile Photo *',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 2. BIODATA FIELDS
                const Text(
                  'Full Name',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  validator: (v) => v == null || v.isEmpty ? 'Full name is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.badge_outlined, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. Dr. Sabina Yeasmin',
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Phone Number',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.isEmpty ? 'Phone number is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone_iphone_rounded, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. 01700000000',
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Email Address',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@') ? 'Valid email is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. doctor@hellodoctor.com',
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

                // 3. CLINICAL SPECIFICS
                const Text(
                  'BMDC / Medical Registration Number',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bmdcController,
                  validator: (v) => v == null || v.isEmpty ? 'BMDC registration number is required' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.assignment_ind_outlined, color: ClinicalTheme.textSecondary),
                    hintText: 'e.g. BMDC-A-92831',
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Specialty',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedSpecialty,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.medical_services_outlined, color: ClinicalTheme.textSecondary),
                  ),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedSpecialty = value;
                      });
                    }
                  },
                  items: _specialties.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Experience (Years)',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _experienceController,
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || int.tryParse(v) == null ? 'Required' : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.timeline, color: ClinicalTheme.textSecondary),
                              hintText: 'e.g. 5',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Consultation Fee (BDT)',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _feeController,
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || double.tryParse(v) == null ? 'Required' : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.payments_outlined, color: ClinicalTheme.textSecondary),
                              hintText: 'e.g. 500',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                const Text(
                  'Short Professional Biography',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  validator: (v) => v == null || v.isEmpty ? 'Short bio is required' : null,
                  decoration: const InputDecoration(
                    hintText: 'Summarize your clinical qualifications, special treatment experience, or associated hospital affiliations...',
                  ),
                ),
                const SizedBox(height: 24),

                // 4. CERTIFICATE/DEGREE UPLOADER
                const Text(
                  'BMDC Registration / MBBS Certificate *',
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
                          _licenseDocPath != null ? Icons.verified_rounded : Icons.cloud_upload_outlined,
                          size: 38,
                          color: _licenseDocPath != null ? ClinicalTheme.accentGreen : ClinicalTheme.textSecondary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _licenseDocPath != null 
                              ? 'Certificate Linked successfully' 
                              : 'Select MBBS Certificate or BMDC License',
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
                              : 'Supports PDF, JPEG, PNG formats (Local image_picker Mock)',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: ClinicalTheme.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                const Text(
                  '// Note: In local skeleton simulation, selected assets are mock-referenced via paths. In production, these should be securely streamed to Google Cloud storage.',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: ClinicalTheme.textSecondary, fontStyle: FontStyle.italic),
                ),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: authService.isLoading ? null : _handleSubmit,
                  child: authService.isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Submit Application'),
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
