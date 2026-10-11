import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  List<UserModel> _allUsers = [];
  bool _isLoading = false;
  String? _sentOtpCode; // Stores mock sent OTP code

  UserModel? get currentUser => _currentUser;
  List<UserModel> get allUsers => _allUsers;
  bool get isLoading => _isLoading;
  String? get sentOtpCode => _sentOtpCode;

  // Key names for SharedPreferences
  static const String _usersKey = 'hello_doctor_registered_users';
  static const String _currentUserKey = 'hello_doctor_current_user_id';

  AuthService() {
    _init();
  }

  // Initialize and load saved state from Shared Preferences
  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load all registered users
      final usersJson = prefs.getString(_usersKey);
      if (usersJson != null) {
        final List<dynamic> decoded = json.decode(usersJson);
        _allUsers = decoded.map((u) => UserModel.fromMap(u)).toList();
      } else {
        // Seed default Super Admin and standard mock users if empty
        _allUsers = [
          UserModel(
            id: 'admin-001',
            name: 'Super Admin',
            phone: '01700000000',
            email: 'admin@hellodoctor.com',
            password: 'admin123',
            role: UserRole.admin,
            status: AccountStatus.approved,
          ),
          UserModel(
            id: 'doctor-mock',
            name: 'Dr. Sarah Rahman',
            phone: '01811111111',
            email: 'sarah.rahman@hellodoctor.com',
            password: 'doctor123',
            role: UserRole.doctor,
            status: AccountStatus.pending,
            bmdcNumber: 'BMDC-83921',
            specialty: 'Cardiology',
            yearsOfExperience: 8,
            consultationFee: 800.0,
            bio: 'Senior consultant of Cardiology at Evercare Hospital.',
          )
        ];
        await _saveAllUsers();
      }

      // Load active user session
      final currentUserId = prefs.getString(_currentUserKey);
      if (currentUserId != null) {
        _currentUser = _allUsers.firstWhere(
          (user) => user.id == currentUserId,
          orElse: () => _allUsers.first, // fallback if admin is seeded or deleted
        );
        // If current user is not found in loaded users list, clear session
        if (!_allUsers.any((user) => user.id == currentUserId)) {
          _currentUser = null;
          await prefs.remove(_currentUserKey);
        }
      }
    } catch (e) {
      debugPrint('Error initializing AuthService: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save all users to local persistence
  Future<void> _saveAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _allUsers.map((u) => u.toMap()).toList();
    await prefs.setString(_usersKey, json.encode(encoded));
  }

  // Set the current active session
  Future<void> _setCurrentUser(UserModel? user) async {
    final prefs = await SharedPreferences.getInstance();
    _currentUser = user;
    if (user != null) {
      await prefs.setString(_currentUserKey, user.id);
    } else {
      await prefs.remove(_currentUserKey);
    }
    notifyListeners();
  }

  // Send Patient OTP (Generates and simulates sending a 6-digit code)
  Future<String> sendPatientOtp(String phone) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network latency

    // Generate a fixed or simple randomized 6-digit OTP for testing
    // To make it easy to remember, we can use 123456 as standard, but we'll print it to logs too
    _sentOtpCode = '123456'; 

    _isLoading = false;
    notifyListeners();
    return _sentOtpCode!;
  }

  // Verify Patient OTP and Sign In / Register
  Future<bool> verifyPatientOtp(String phone, String code, {String? name, String? email}) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    // Accept any 6-digit code as valid (per user requirement)
    if (code.length == 6) {
      // Find user by phone number
      UserModel? existingUser = _allUsers.firstWhere(
        (u) => u.phone == phone && u.role == UserRole.patient,
        orElse: () => UserModel(id: '', name: '', phone: '', email: '', role: UserRole.patient, status: AccountStatus.approved),
      );

      if (existingUser.id.isEmpty) {
        // Create new patient since user doesn't exist
        final newPatient = UserModel(
          id: 'patient-${DateTime.now().millisecondsSinceEpoch}',
          name: name ?? 'Patient ${phone.substring(phone.length - 4)}',
          phone: phone,
          email: email ?? '${phone}@hellodoctor-patient.com',
          role: UserRole.patient,
          status: AccountStatus.approved, // Patients bypass admin approval
        );
        _allUsers.add(newPatient);
        await _saveAllUsers();
        await _setCurrentUser(newPatient);
      } else {
        // User exists, log them in
        await _setCurrentUser(existingUser);
      }

      _sentOtpCode = null;
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Patient Email + Password Signup (Fallback Option)
  Future<bool> registerPatientWithEmail({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    // Check if email or phone already registered
    bool exists = _allUsers.any((u) => u.email.toLowerCase() == email.toLowerCase() || u.phone == phone);
    if (exists) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newPatient = UserModel(
      id: 'patient-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      email: email,
      password: password,
      role: UserRole.patient,
      status: AccountStatus.approved,
    );

    _allUsers.add(newPatient);
    await _saveAllUsers();
    await _setCurrentUser(newPatient);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Doctor Registration
  Future<bool> registerDoctor({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String bmdcNumber,
    required String specialty,
    required int yearsOfExperience,
    required double consultationFee,
    required String bio,
    String? profilePhotoPath,
    String? licenseDocPath,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    bool exists = _allUsers.any((u) => u.email.toLowerCase() == email.toLowerCase() || u.phone == phone);
    if (exists) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newDoctor = UserModel(
      id: 'doctor-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      email: email,
      password: password,
      role: UserRole.doctor,
      status: AccountStatus.pending, // Pending Admin Approval
      bmdcNumber: bmdcNumber,
      specialty: specialty,
      yearsOfExperience: yearsOfExperience,
      consultationFee: consultationFee,
      bio: bio,
      profilePhotoPath: profilePhotoPath,
      licenseDocPath: licenseDocPath,
    );

    _allUsers.add(newDoctor);
    await _saveAllUsers();
    
    // Set current session but since status is pending, UI router will show "Pending Approval"
    await _setCurrentUser(newDoctor);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Pharmacy Registration
  Future<bool> registerPharmacy({
    required String pharmacyName,
    required String ownerName,
    required String phone,
    required String email,
    required String password,
    required String tradeLicenseNumber,
    required String address,
    required String city,
    String? licenseDocPath,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    bool exists = _allUsers.any((u) => u.email.toLowerCase() == email.toLowerCase() || u.phone == phone);
    if (exists) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newPharmacy = UserModel(
      id: 'pharmacy-${DateTime.now().millisecondsSinceEpoch}',
      name: pharmacyName,
      phone: phone,
      email: email,
      password: password,
      role: UserRole.pharmacy,
      status: AccountStatus.pending, // Pending Admin Approval
      ownerName: ownerName,
      tradeLicenseNumber: tradeLicenseNumber,
      address: address,
      city: city,
      licenseDocPath: licenseDocPath,
    );

    _allUsers.add(newPharmacy);
    await _saveAllUsers();
    
    // Set current session (will intercept on pending status)
    await _setCurrentUser(newPharmacy);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Diagnostic Centre Registration
  Future<bool> registerDiagnostic({
    required String centerName,
    required String contactPerson,
    required String phone,
    required String email,
    required String password,
    required String licenseNumber,
    required String address,
    required String city,
    String? licenseDocPath,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    bool exists = _allUsers.any((u) => u.email.toLowerCase() == email.toLowerCase() || u.phone == phone);
    if (exists) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newDiagnostic = UserModel(
      id: 'diagnostic-${DateTime.now().millisecondsSinceEpoch}',
      name: centerName,
      phone: phone,
      email: email,
      password: password,
      role: UserRole.diagnostic,
      status: AccountStatus.pending, // Pending Admin Approval
      contactPerson: contactPerson,
      licenseNumber: licenseNumber,
      address: address,
      city: city,
      licenseDocPath: licenseDocPath,
    );

    _allUsers.add(newDiagnostic);
    await _saveAllUsers();
    
    // Set current session (will intercept on pending status)
    await _setCurrentUser(newDiagnostic);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Login with Email + Password (For fallback patient, or any other role, or admin)
  Future<bool> loginWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final user = _allUsers.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
      );

      await _setCurrentUser(user);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      // User not found or incorrect credentials
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Super Admin Action: Approve a user (e.g. Doctor, Pharmacy, Diagnostic)
  Future<void> approveUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    final index = _allUsers.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _allUsers[index] = _allUsers[index].copyWith(status: AccountStatus.approved);
      await _saveAllUsers();
      
      // If the currently logged in user is the one being approved (for instant simulation purposes)
      if (_currentUser?.id == userId) {
        _currentUser = _allUsers[index];
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Super Admin Action: Deny or reject a user (can delete or suspend them)
  Future<void> rejectOrDeleteUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    _allUsers.removeWhere((u) => u.id == userId);
    await _saveAllUsers();

    if (_currentUser?.id == userId) {
      _currentUser = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
    }

    _isLoading = false;
    notifyListeners();
  }

  // Log out the current user session
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _setCurrentUser(null);
    _isLoading = false;
    notifyListeners();
  }
}
