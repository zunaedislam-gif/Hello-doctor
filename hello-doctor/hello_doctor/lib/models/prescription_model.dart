class Prescription {
  final String id;
  final String appointmentId;
  final String patientId;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final double patientWeight;
  final String doctorName;
  final String doctorDegrees;
  final String doctorSpecialty;
  final String bmdcLicense;
  final List<String> chiefComplaints;
  final List<String> diagnosis;
  final Map<String, String> onExamination; // e.g., {"BP": "120/80", "Pulse": "72", "Temp": "98.6", "SPO2": "98"}
  final List<Map<String, String>> medicines; // e.g., [{"name": "Tab. Napa 500mg", "dosage": "1+0+1", "duration": "5 Days", "instructions": "After Meal"}]
  final String advice;
  final String? followUpDate;
  final DateTime date;

  Prescription({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.patientWeight,
    required this.doctorName,
    required this.doctorDegrees,
    required this.doctorSpecialty,
    required this.bmdcLicense,
    required this.chiefComplaints,
    required this.diagnosis,
    required this.onExamination,
    required this.medicines,
    required this.advice,
    this.followUpDate,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'patientId': patientId,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'patientWeight': patientWeight,
      'doctorName': doctorName,
      'doctorDegrees': doctorDegrees,
      'doctorSpecialty': doctorSpecialty,
      'bmdcLicense': bmdcLicense,
      'chiefComplaints': chiefComplaints,
      'diagnosis': diagnosis,
      'onExamination': onExamination,
      'medicines': medicines,
      'advice': advice,
      'followUpDate': followUpDate,
      'date': date.toIso8601String(),
    };
  }

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] as String,
      appointmentId: json['appointmentId'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      patientAge: json['patientAge'] as int,
      patientGender: json['patientGender'] as String,
      patientWeight: (json['patientWeight'] as num).toDouble(),
      doctorName: json['doctorName'] as String,
      doctorDegrees: json['doctorDegrees'] as String,
      doctorSpecialty: json['doctorSpecialty'] as String,
      bmdcLicense: json['bmdcLicense'] as String,
      chiefComplaints: List<String>.from(json['chiefComplaints'] as List),
      diagnosis: List<String>.from(json['diagnosis'] as List),
      onExamination: Map<String, String>.from(json['onExamination'] as Map),
      medicines: (json['medicines'] as List).map((item) => Map<String, String>.from(item as Map)).toList(),
      advice: json['advice'] as String,
      followUpDate: json['followUpDate'] as String?,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
