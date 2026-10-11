import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../services/appointment_service.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String? appId;

  const BookingSuccessScreen({super.key, this.appId});

  @override
  Widget build(BuildContext context) {
    // Lookup the created appointment from our Provider
    final appointmentService = Provider.of<AppointmentService>(context, listen: false);
    final app = appointmentService.appointments.firstWhere(
      (a) => a.id == appId,
      orElse: () => appointmentService.appointments.isNotEmpty
          ? appointmentService.appointments.last
          : throw Exception("No appointment found"),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Animated green success badge
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ClinicalTheme.accentGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: ClinicalTheme.accentGreen,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              
              // Big header
              const Text(
                'Appointment Confirmed!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.extrabold,
                  fontSize: 20,
                  color: ClinicalTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your digital consultation slot has been reserved. The practitioner will call you on the app once your slot starts.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: ClinicalTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              
              // Appointment Summary Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: ClinicalTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.08)),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('Appointment ID', app.id, isHighlight: true),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Divider(height: 1),
                    ),
                    _buildSummaryRow('Doctor Name', app.doctorName),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Specialty', app.doctorSpecialty),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Date', app.date.split(',')[1].trim()),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Time Slot', app.timeSlot),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Amount Paid', '৳ ${app.totalAmount.toStringAsFixed(0)}', isBold: true),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Method', app.paymentMethod),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Buttons
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.go('/virtual-waiting-room?appId=${app.id}');
                  },
                  icon: const Icon(Icons.video_call_rounded, color: Colors.white),
                  label: const Text(
                    'Enter Virtual Waiting Room',
                    style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClinicalTheme.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () {
                          context.go('/my-appointments');
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: Color(0xffe0e4ec)),
                        ),
                        child: const Text(
                          'Appointments',
                          style: TextStyle(color: ClinicalTheme.textSecondary, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () {
                          context.go('/patient-home');
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: Color(0xffe0e4ec)),
                        ),
                        child: const Text(
                          'Go to Home',
                          style: TextStyle(color: ClinicalTheme.textSecondary, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.between,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: ClinicalTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11.5,
            fontWeight: (isBold || isHighlight) ? FontWeight.bold : FontWeight.w600,
            color: isHighlight
                ? ClinicalTheme.primaryBlue
                : ClinicalTheme.textDark,
          ),
        ),
      ],
    );
  }
}
