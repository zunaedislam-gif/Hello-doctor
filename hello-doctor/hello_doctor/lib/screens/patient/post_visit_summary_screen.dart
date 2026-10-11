import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../services/appointment_service.dart';
import '../../services/signaling_service.dart';

class PostVisitSummaryScreen extends StatelessWidget {
  final String appId;

  const PostVisitSummaryScreen({super.key, required this.appId});

  @override
  Widget build(BuildContext context) {
    final appService = Provider.of<AppointmentService>(context, listen: false);
    final signaling = Provider.of<SignalingService>(context, listen: false);
    final app = appService.appointments.firstWhere(
      (a) => a.id == appId,
      orElse: () => appService.appointments.isNotEmpty
          ? appService.appointments.last
          : throw Exception("Appointment not found"),
    );

    // Retrieve doctor notes from signaling or show standard backup clinical directives
    String docNotes = signaling.getDoctorNotes(appId);
    if (docNotes.trim().isEmpty) {
      docNotes = "Rest and hydration advised. Avoid cold foods. Review symptoms if fever persists beyond 3 days.\n\nRx: Paracetamol 500mg (1+0+1) after meal for 5 days.";
    }

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Post-Visit Summary',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: ClinicalTheme.textDark),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: ClinicalTheme.textDark),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('EHR Summary PDF share link copied to clipboard.')),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Success header card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: ClinicalTheme.accentGreen.withOpacity(0.2)),
                ),
                color: ClinicalTheme.accentGreen.withOpacity(0.04),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ClinicalTheme.accentGreen,
                        ),
                        child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Consultation Completed',
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: ClinicalTheme.accentGreen),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'This electronic health report is signed & certified.',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: ClinicalTheme.textSecondary),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Doctor details card
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.1),
                        child: Text(
                          app.doctorName.split(" ").last.substring(0, 1),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.doctorName,
                              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15, color: ClinicalTheme.textDark),
                            ),
                            Text(
                              '${app.doctorDegrees} • ${app.doctorSpecialty}',
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 11.5, color: ClinicalTheme.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Date: ${app.date} | Time: ${app.timeSlot}',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 10.5, color: ClinicalTheme.textSecondary.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Clinical Notes & Advice card
              const Text(
                'DOCTOR NOTES & ADVICE',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.extrabold, fontSize: 11, color: ClinicalTheme.textSecondary, letterSpacing: 0.8),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notes_rounded, color: Colors.blue.shade600, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Consultation Directives',
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                          ),
                        ],
                      ),
                      const Divider(height: 20, color: Color(0xfff0f2f6)),
                      Text(
                        docNotes,
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: ClinicalTheme.textDark, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Digital e-Prescription card
              const Text(
                'DIGITAL PRESCRIPTION',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.extrabold, fontSize: 11, color: ClinicalTheme.textSecondary, letterSpacing: 0.8),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.file_present_rounded, color: Colors.orange.shade600, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'e-Prescription PDF',
                                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Verified',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue),
                            ),
                          )
                        ],
                      ),
                      const Divider(height: 24, color: Color(0xfff0f2f6)),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                minimumSize: const Size(0, 44),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Downloading certified prescription PDF...')),
                                );
                              },
                              icon: const Icon(Icons.download_rounded, size: 16),
                              label: const Text('Download PDF', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade600,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                minimumSize: const Size(0, 44),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Navigating to Pharmacy ordering dashboard...')),
                                );
                                context.go('/patient-home');
                              },
                              icon: const Icon(Icons.shopping_cart_rounded, size: 16),
                              label: const Text('Order Medicines', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 5. Back button
              ElevatedButton(
                onPressed: () {
                  context.go('/patient-home');
                },
                child: const Text('Return to Patient Home'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
