import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _addressController;
  
  String _selectedGender = 'Male';
  String _selectedBloodType = 'O+';
  String? _profilePhotoPath;
  
  // Medical history tags
  final List<String> _allergies = ['Penicillin', 'Peanuts'];
  final List<String> _chronicConditions = ['Hypertension'];
  final List<String> _pastSurgeries = ['Appendectomy (2019)'];
  
  final TextEditingController _allergyInputController = TextEditingController();
  final TextEditingController _chronicInputController = TextEditingController();
  final TextEditingController _surgeryInputController = TextEditingController();

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    
    _nameController = TextEditingController(text: user?.name ?? 'Karim Uddin');
    _phoneController = TextEditingController(text: user?.phone ?? '01712345678');
    _emailController = TextEditingController(text: user?.email ?? 'karim@gmail.com');
    _addressController = TextEditingController(text: user?.address ?? 'House 42, Road 11, Banani, Dhaka');
    _dobController = TextEditingController(text: '12/10/1992');
    
    _loadLocalProfileData();
  }

  Future<void> _loadLocalProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dobController.text = prefs.getString('patient_dob') ?? '12/10/1992';
      _selectedGender = prefs.getString('patient_gender') ?? 'Male';
      _selectedBloodType = prefs.getString('patient_blood') ?? 'O+';
      _profilePhotoPath = prefs.getString('patient_photo_path');
      _addressController.text = prefs.getString('patient_address') ?? 'House 42, Road 11, Banani, Dhaka';
      
      final savedAllergies = prefs.getStringList('patient_allergies');
      if (savedAllergies != null) {
        _allergies.clear();
        _allergies.addAll(savedAllergies);
      }
      final savedChronic = prefs.getStringList('patient_chronic');
      if (savedChronic != null) {
        _chronicConditions.clear();
        _chronicConditions.addAll(savedChronic);
      }
      final savedSurgeries = prefs.getStringList('patient_surgeries');
      if (savedSurgeries != null) {
        _pastSurgeries.clear();
        _pastSurgeries.addAll(savedSurgeries);
      }
    });
  }

  Future<void> _saveProfileData() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('patient_dob', _dobController.text);
    await prefs.setString('patient_gender', _selectedGender);
    await prefs.setString('patient_blood', _selectedBloodType);
    await prefs.setString('patient_address', _addressController.text);
    if (_profilePhotoPath != null) {
      await prefs.setString('patient_photo_path', _profilePhotoPath!);
    }
    await prefs.setStringList('patient_allergies', _allergies);
    await prefs.setStringList('patient_chronic', _chronicConditions);
    await prefs.setStringList('patient_surgeries', _pastSurgeries);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile and medical history saved successfully!'),
        backgroundColor: ClinicalTheme.accentGreen,
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image != null) {
        setState(() {
          _profilePhotoPath = image.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture selected successfully.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _allergyInputController.dispose();
    _chronicInputController.dispose();
    _surgeryInputController.dispose();
    super.dispose();
  }

  void _addTag(List<String> list, TextEditingController controller, String key) async {
    final text = controller.text.trim();
    if (text.isNotEmpty && !list.contains(text)) {
      setState(() {
        list.add(text);
        controller.clear();
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(key, list);
    }
  }

  void _removeTag(List<String> list, String value, String key) async {
    setState(() {
      list.remove(value);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, list);
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
          'Patient Profile',
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
            icon: const Icon(Icons.save_rounded, color: ClinicalTheme.primaryBlue),
            onPressed: _saveProfileData,
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
                // Profile Photo Upload Card
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 54,
                          backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.1),
                          backgroundImage: _profilePhotoPath != null ? FileImage(File(_profilePhotoPath!)) : null,
                          child: _profilePhotoPath == null
                              ? const Text(
                                  'KU',
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: ClinicalTheme.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section Title: Personal Info
                const Text(
                  'PERSONAL INFORMATION',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.extrabold,
                    fontSize: 11,
                    color: ClinicalTheme.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),

                // Personal Info Inputs
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Icons.person_rounded,
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone_android_rounded,
                          readOnly: true,
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          icon: Icons.email_rounded,
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _dobController,
                          label: 'Date of Birth (DD/MM/YYYY)',
                          icon: Icons.calendar_today_rounded,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdownField(
                                label: 'Gender',
                                value: _selectedGender,
                                items: _genders,
                                onChanged: (val) {
                                  setState(() => _selectedGender = val!);
                                },
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildDropdownField(
                                label: 'Blood Group',
                                value: _selectedBloodType,
                                items: _bloodTypes,
                                onChanged: (val) {
                                  setState(() => _selectedBloodType = val!);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _addressController,
                          label: 'Residential Address',
                          icon: Icons.home_rounded,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Section Title: Digital Medical History
                const Text(
                  'DIGITAL MEDICAL HISTORY',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Allergies Section
                        _buildTagInputSection(
                          title: 'Drug & Food Allergies',
                          controller: _allergyInputController,
                          list: _allergies,
                          prefsKey: 'patient_allergies',
                          placeholder: 'Add allergy (e.g., Penicillin)',
                        ),
                        const SizedBox(height: 20),
                        // Chronic Conditions Section
                        _buildTagInputSection(
                          title: 'Chronic Illnesses / Conditions',
                          controller: _chronicInputController,
                          list: _chronicConditions,
                          prefsKey: 'patient_chronic',
                          placeholder: 'Add condition (e.g., Asthma)',
                        ),
                        const SizedBox(height: 20),
                        // Past Surgeries Section
                        _buildTagInputSection(
                          title: 'Past Surgeries',
                          controller: _surgeryInputController,
                          list: _pastSurgeries,
                          prefsKey: 'patient_surgeries',
                          placeholder: 'Add surgery (e.g., Hernia 2021)',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _saveProfileData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ClinicalTheme.primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Save Complete Profile',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: ClinicalTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: items.contains(value) ? value : items.first,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: ClinicalTheme.textDark)),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: ClinicalTheme.textSecondary),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildTagInputSection({
    required String title,
    required TextEditingController controller,
    required List<String> list,
    required String prefsKey,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: ClinicalTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 38,
                child: TextField(
                  controller: controller,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 12),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    filled: true,
                    fillColor: ClinicalTheme.backgroundLight,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.08)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: ClinicalTheme.primaryBlue, width: 1),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 38,
              child: ElevatedButton(
                onPressed: () => _addTag(list, controller, prefsKey),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ClinicalTheme.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            )
          ],
        ),
        if (list.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: list.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: ClinicalTheme.primaryBlue.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ClinicalTheme.primaryBlue.withOpacity(0.12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 11.5, color: ClinicalTheme.primaryBlue, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _removeTag(list, tag, prefsKey),
                      child: const Icon(Icons.cancel_rounded, size: 14, color: ClinicalTheme.primaryBlue),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ] else ...[
          const SizedBox(height: 6),
          Text(
            'None declared.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey.shade400),
          ),
        ]
      ],
    );
  }
}
