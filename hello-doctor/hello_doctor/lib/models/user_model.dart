import 'dart:convert';

enum UserRole {
  patient,
  doctor,
  pharmacy,
  diagnostic,
  admin,
}

enum AccountStatus {
  approved,
  pending,
}

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? password; // Stored securely for mock local verification
  final UserRole role;
  final AccountStatus status;

  // Doctor Specific Fields
  final String? bmdcNumber;
  final String? specialty;
  final int? yearsOfExperience;
  final double? consultationFee;
  final String? bio;
  final String? profilePhotoPath; // Base64 or local filepath

  // Pharmacy Specific Fields
  final String? ownerName;
  final String? tradeLicenseNumber;

  // Diagnostic Specific Fields
  final String? contactPerson;
  final String? licenseNumber;

  // Shared Pharmacy & Diagnostic Fields
  final String? address;
  final String? city;
  final String? licenseDocPath; // Base64 or local filepath

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.password,
    required this.role,
    required this.status,
    this.bmdcNumber,
    this.specialty,
    this.yearsOfExperience,
    this.consultationFee,
    this.bio,
    this.profilePhotoPath,
    this.ownerName,
    this.tradeLicenseNumber,
    this.contactPerson,
    this.licenseNumber,
    this.address,
    this.city,
    this.licenseDocPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'role': role.name,
      'status': status.name,
      'bmdcNumber': bmdcNumber,
      'specialty': specialty,
      'yearsOfExperience': yearsOfExperience,
      'consultationFee': consultationFee,
      'bio': bio,
      'profilePhotoPath': profilePhotoPath,
      'ownerName': ownerName,
      'tradeLicenseNumber': tradeLicenseNumber,
      'contactPerson': contactPerson,
      'licenseNumber': licenseNumber,
      'address': address,
      'city': city,
      'licenseDocPath': licenseDocPath,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      password: map['password'],
      role: UserRole.values.byName(map['role'] ?? 'patient'),
      status: AccountStatus.values.byName(map['status'] ?? 'approved'),
      bmdcNumber: map['bmdcNumber'],
      specialty: map['specialty'],
      yearsOfExperience: map['yearsOfExperience'] != null ? (map['yearsOfExperience'] as num).toInt() : null,
      consultationFee: map['consultationFee'] != null ? (map['consultationFee'] as num).toDouble() : null,
      bio: map['bio'],
      profilePhotoPath: map['profilePhotoPath'],
      ownerName: map['ownerName'],
      tradeLicenseNumber: map['tradeLicenseNumber'],
      contactPerson: map['contactPerson'],
      licenseNumber: map['licenseNumber'],
      address: map['address'],
      city: map['city'],
      licenseDocPath: map['licenseDocPath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? password,
    UserRole? role,
    AccountStatus? status,
    String? bmdcNumber,
    String? specialty,
    int? yearsOfExperience,
    double? consultationFee,
    String? bio,
    String? profilePhotoPath,
    String? ownerName,
    String? tradeLicenseNumber,
    String? contactPerson,
    String? licenseNumber,
    String? address,
    String? city,
    String? licenseDocPath,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      status: status ?? this.status,
      bmdcNumber: bmdcNumber ?? this.bmdcNumber,
      specialty: specialty ?? this.specialty,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      consultationFee: consultationFee ?? this.consultationFee,
      bio: bio ?? this.bio,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      ownerName: ownerName ?? this.ownerName,
      tradeLicenseNumber: tradeLicenseNumber ?? this.tradeLicenseNumber,
      contactPerson: contactPerson ?? this.contactPerson,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      licenseDocPath: licenseDocPath ?? this.licenseDocPath,
    );
  }
}
