import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../models/prescription_model.dart';

class AppointmentService extends ChangeNotifier {
  final List<Appointment> _appointments = [];
  final List<Prescription> _prescriptions = [
    Prescription(
      id: 'rx_mock_1',
      appointmentId: 'app_mock_1',
      patientId: 'patient_mock',
      patientName: 'Karim Uddin',
      patientAge: 28,
      patientGender: 'Male',
      patientWeight: 74.0,
      doctorName: 'Dr. Sarah Rahman',
      doctorDegrees: 'MBBS, FCPS (Medicine), MD (Cardiology)',
      doctorSpecialty: 'Cardiologist',
      bmdcLicense: 'A-84291',
      chiefComplaints: ['Shortness of breath on exertion', 'Mild dry cough for 5 days', 'Fatigue'],
      diagnosis: ['Mild Bronchial Hyperreactivity', 'Exertional Dyspnea (Mild)'],
      onExamination: {'BP': '120/80 mmHg', 'Pulse': '74 bpm', 'Temp': '98.4 F', 'SPO2': '99%'},
      medicines: [
        {
          'name': 'Tab. Napa Extend 665mg',
          'dosage': '1+0+1',
          'duration': '5 Days',
          'instructions': 'After Meal'
        },
        {
          'name': 'Inhaler Seretide 125 Evohaler',
          'dosage': '2 Puffs',
          'duration': '1 Month',
          'instructions': 'Twice Daily'
        },
        {
          'name': 'Tab. Monas 10mg',
          'dosage': '0+0+1',
          'duration': '15 Days',
          'instructions': 'At Night, Before Bed'
        }
      ],
      advice: 'Avoid cold food & drinks. Use face mask in dusty environments. Avoid allergen triggers.',
      followUpDate: '2026-07-20',
      date: DateTime.now().subtract(const Duration(days: 14)),
    )
  ];

  List<Appointment> get appointments => List.unmodifiable(_appointments);
  List<Prescription> get prescriptions => List.unmodifiable(_prescriptions);

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void addPrescription(Prescription prescription) {
    _prescriptions.add(prescription);
    notifyListeners();
  }

  List<Prescription> getPrescriptionsForPatient(String patientId) {
    return _prescriptions.where((rx) => rx.patientId == patientId).toList();
  }

  void cancelAppointment(String id) {
    final idx = _appointments.indexWhere((app) => app.id == id);
    if (idx != -1) {
      final old = _appointments[idx];
      _appointments[idx] = Appointment(
        id: old.id,
        doctorId: old.doctorId,
        doctorName: old.doctorName,
        doctorDegrees: old.doctorDegrees,
        doctorSpecialty: old.doctorSpecialty,
        date: old.date,
        timeSlot: old.timeSlot,
        status: 'Cancelled',
        consultationFee: old.consultationFee,
        vat: old.vat,
        platformFee: old.platformFee,
        totalAmount: old.totalAmount,
        paymentMethod: old.paymentMethod,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }
}
