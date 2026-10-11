import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../core/theme.dart';
import '../../models/prescription_model.dart';
import '../../services/appointment_service.dart';

class MyPrescriptionsScreen extends StatelessWidget {
  const MyPrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentService = Provider.of<AppointmentService>(context);
    // Use the mock patient id 'patient_mock'
    final prescriptions = appointmentService.getPrescriptionsForPatient('patient_mock');

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'My Prescriptions',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.extrabold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        foregroundColor: ClinicalTheme.textDark,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: prescriptions.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ClinicalTheme.primaryBlue.withOpacity(0.06),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.medical_information_outlined, color: ClinicalTheme.primaryBlue, size: 48),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Prescriptions Yet',
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: ClinicalTheme.textDark),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Any digital prescriptions written by your consulting doctors will automatically appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: ClinicalTheme.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: prescriptions.length,
              itemBuilder: (context, idx) {
                final rx = prescriptions[idx];
                return _buildPrescriptionCard(context, rx);
              },
            ),
    );
  }

  Widget _buildPrescriptionCard(BuildContext context, Prescription rx) {
    final formattedDate = "${rx.date.day.toString().padLeft(2, '0')}-${rx.date.month.toString().padLeft(2, '0')}-${rx.date.year}";

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1.2),
      ),
      child: InkWell(
        onTap: () {
          // Open PDF Viewer Details screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => PrescriptionPdfViewerScreen(prescription: rx),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Doctor and Date
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.08),
                    child: const Text('🩺', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rx.doctorName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: ClinicalTheme.textDark,
                          ),
                        ),
                        Text(
                          "${rx.doctorSpecialty} • ${rx.doctorDegrees.split(",")[0]}",
                          style: const TextStyle(fontSize: 10.5, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: ClinicalTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 12),
              const SizedBox(height: 8),

              // Diagnosis summaries
              const Text(
                'DIAGNOSIS',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.extrabold, color: ClinicalTheme.textSecondary, letterSpacing: 0.8),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: rx.diagnosis.map((diag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ClinicalTheme.accentGreen.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: ClinicalTheme.accentGreen.withOpacity(0.12)),
                    ),
                    child: Text(
                      diag,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: ClinicalTheme.accentGreen,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Medicines preview
              const Text(
                'MEDICINES PREVIEW',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.extrabold, color: ClinicalTheme.textSecondary, letterSpacing: 0.8),
              ),
              const SizedBox(height: 4),
              Text(
                rx.medicines.map((m) => m['name']).join(', '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.5, color: ClinicalTheme.textDark.withOpacity(0.8), fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 14),

              // Action Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: ClinicalTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, size: 16, color: ClinicalTheme.primaryBlue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrescriptionPdfViewerScreen extends StatelessWidget {
  final Prescription prescription;

  const PrescriptionPdfViewerScreen({super.key, required this.prescription});

  Future<List<int>> _generatePdfBytes() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Doctor Letterhead
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.between,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(prescription.doctorName, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                        pw.Text(prescription.doctorDegrees, style: const pw.TextStyle(fontSize: 9.5)),
                        pw.Text(prescription.doctorSpecialty, style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.blue800)),
                        pw.Text('BMDC Reg No: ${prescription.bmdcLicense}', style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('HELLO DOCTOR CLINIC', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                        pw.Text('Digital On-Demand Telehealth', style: const pw.TextStyle(fontSize: 8.5)),
                        pw.Text('Support Hotlines: 16263', style: const pw.TextStyle(fontSize: 8.5)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Divider(thickness: 1.5, color: PdfColors.blue900),
                pw.SizedBox(height: 8),

                // Patient Details Grid Bar
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue50,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.between,
                    children: [
                      pw.Text('Patient Name: ${prescription.patientName}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                      pw.Text('Gender: ${prescription.patientGender}', style: const pw.TextStyle(fontSize: 9.5)),
                      pw.Text('Age: ${prescription.patientAge} Yrs', style: const pw.TextStyle(fontSize: 9.5)),
                      pw.Text('Weight: ${prescription.patientWeight} kg', style: const pw.TextStyle(fontSize: 9.5)),
                      pw.Text('Date: ${prescription.date.day}/${prescription.date.month}/${prescription.date.year}', style: const pw.TextStyle(fontSize: 9.5)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),

                // Rx Layout columns
                pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      pw.Expanded(
                        flex: 3,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('CHIEF COMPLAINTS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5, color: PdfColors.blue900)),
                            pw.SizedBox(height: 4),
                            ...prescription.chiefComplaints.map((comp) => pw.Bullet(text: comp, style: const pw.TextStyle(fontSize: 9))),
                            pw.SizedBox(height: 12),

                            pw.Text('ON EXAMINATION', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5, color: PdfColors.blue900)),
                            pw.SizedBox(height: 4),
                            ...prescription.onExamination.entries.map((ent) => pw.Text('${ent.key}: ${ent.value}', style: const pw.TextStyle(fontSize: 9))),
                            pw.SizedBox(height: 12),

                            pw.Text('DIAGNOSIS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5, color: PdfColors.blue900)),
                            pw.SizedBox(height: 4),
                            ...prescription.diagnosis.map((diag) => pw.Bullet(text: diag, style: const pw.TextStyle(fontSize: 9))),
                          ],
                        ),
                      ),

                      // Vertical divider line
                      pw.Container(
                        width: 1.2,
                        color: PdfColors.grey300,
                        margin: const pw.EdgeInsets.symmetric(horizontal: 16),
                      ),

                      // Right Column (Rx medications)
                      pw.Expanded(
                        flex: 5,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Rx (Medications prescribed)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: PdfColors.blue900)),
                            pw.SizedBox(height: 6),
                            ...prescription.medicines.asMap().entries.map((entry) {
                              final num = entry.key + 1;
                              final med = entry.value;
                              return pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 10),
                                child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('$num. ${med['name']}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.left(12),
                                      child: pw.Text('${med['dosage']} • ${med['duration']} • (${med['instructions']})', style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800)),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            pw.SizedBox(height: 16),

                            pw.Text('ADVICE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5, color: PdfColors.blue900)),
                            pw.SizedBox(height: 4),
                            pw.Text(prescription.advice, style: const pw.TextStyle(fontSize: 9)),
                            pw.SizedBox(height: 16),

                            if (prescription.followUpDate != null) ...[
                              pw.Text('FOLLOW UP REVIEW', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5, color: PdfColors.blue900)),
                              pw.SizedBox(height: 4),
                              pw.Text('Please review in clinic / online on or before: ${prescription.followUpDate}', style: const pw.TextStyle(fontSize: 9, color: PdfColors.red700)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                pw.Divider(thickness: 1, color: PdfColors.grey300),
                pw.SizedBox(height: 8),

                // Footer signature box
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.between,
                  children: [
                    pw.Text('This is a computer-generated digital prescription dispatched securely on Hello Doctor.', style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600)),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Container(
                          width: 90,
                          height: 32,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.blue200, width: 1.2),
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                          alignment: pw.Alignment.center,
                          child: pw.Text('VERIFIED Rx', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(prescription.doctorName, style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  void _orderMedicineFromPrescription(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.orange, size: 24),
              SizedBox(width: 8),
              Text('Order Placed!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pharmacy Order Requested',
                style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 12.5, color: ClinicalTheme.textDark),
              ),
              const SizedBox(height: 6),
              Text(
                'We have automatically extracted the prescribed medicines and forwarded your order to our nearest accredited partner pharmacy.\n\nThey will contact you at your registered phone number to confirm your shipping address and arrange delivery.',
                style: TextStyle(fontSize: 11.5, color: ClinicalTheme.textSecondary.withOpacity(0.9), height: 1.45),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Great, Thank You!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'View Prescription - ${prescription.date.day}/${prescription.date.month}',
          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.extrabold, fontSize: 15),
        ),
        backgroundColor: Colors.white,
        foregroundColor: ClinicalTheme.textDark,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // The Interactive PdfPreview Widget
          Expanded(
            child: PdfPreview(
              build: (format) => _generatePdfBytes(),
              canChangeOrientation: false,
              canChangePageFormat: false,
              pdfPreviewPageDecoration: const BoxDecoration(
                color: Colors.white,
              ),
              loadingWidget: const Center(
                child: CircularProgressIndicator(color: ClinicalTheme.primaryBlue),
              ),
            ),
          ),

          // Bottom Send to Pharmacy Ordering trigger action bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, -3)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _orderMedicineFromPrescription(context),
                    icon: const Icon(Icons.local_pharmacy_rounded, color: Colors.white, size: 16),
                    label: const Text(
                      'ORDER MEDICINE FROM Rx',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.5, letterSpacing: 0.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
