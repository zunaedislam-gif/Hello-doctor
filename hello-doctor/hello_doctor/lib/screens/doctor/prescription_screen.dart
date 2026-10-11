import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../core/theme.dart';
import '../../models/prescription_model.dart';
import '../../services/appointment_service.dart';

class WritePrescriptionScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const WritePrescriptionScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<WritePrescriptionScreen> createState() => _WritePrescriptionScreenState();
}

class _WritePrescriptionScreenState extends State<WritePrescriptionScreen> {
  // Section Controllers
  final _complaintInputController = TextEditingController();
  final _diagnosisInputController = TextEditingController();
  final _adviceController = TextEditingController();

  // On Examination controllers
  final _bpController = TextEditingController();
  final _pulseController = TextEditingController();
  final _tempController = TextEditingController();
  final _weightController = TextEditingController();
  final _spo2Controller = TextEditingController();

  // Selected tag chips lists
  final List<String> _selectedComplaints = [];
  final List<String> _selectedDiagnoses = [];

  // Medications list
  final List<Map<String, String>> _medicines = [];

  // Follow-up
  DateTime? _followUpDate;

  // Search/suggestion visibilities
  bool _showComplaintSuggestions = false;
  bool _showDiagnosisSuggestions = false;

  // Auto-complete suggestion lists
  final List<String> _commonComplaints = [
    "High fever",
    "Sore throat",
    "Dry cough",
    "Productive cough",
    "Runny nose",
    "Body aches",
    "Fatigue",
    "Headache",
    "Chest congestion",
    "Shortness of breath",
    "Nausea",
    "Vomiting",
    "Diarrhea",
    "Abdominal pain",
    "Loss of appetite",
    "Dizziness",
    "Chest tightness",
    "Palpitations",
  ];

  final List<String> _commonDiagnoses = [
    "Acute Viral Fever",
    "Acute Pharyngitis",
    "Common Cold",
    "Acute Bronchitis",
    "Gastroenteritis",
    "Essential Hypertension",
    "Mild Bronchial Hyperreactivity",
    "Migraine",
    "Urinary Tract Infection (UTI)",
    "Allergic Rhinitis",
    "Acid Peptic Disease (APD)",
    "Generalized Weakness",
    "Anemia",
  ];

  final List<String> _medicineAutocompleteList = [
    "Tab. Napa 500mg",
    "Tab. Napa Extend 665mg",
    "Tab. Paracetamol 500mg",
    "Syp. Napa 60ml",
    "Tab. Ace 500mg",
    "Tab. Ace Plus",
    "Tab. Fexo 120mg",
    "Tab. Fexo 180mg",
    "Tab. Montene 10mg",
    "Tab. Monas 10mg",
    "Tab. Sergel 20mg",
    "Cap. Seclo 20mg",
    "Tab. Maxpro 20mg",
    "Tab. Neoflam 50mg",
    "Tab. Alatrol 10mg",
    "Syp. Adryl 100ml",
    "Syp. Tuz 100ml",
    "Syp. Jofol 100ml",
    "Tab. Ceevit 250mg",
    "Tab. Zinc 20mg",
    "Cap. Provit",
    "Tab. Azithrocin 500mg",
    "Tab. Zimax 500mg",
    "Cap. Amoxicillin 500mg",
    "Tab. Ciprocin 500mg",
    "Inhaler Seretide 125 Evohaler",
    "Nasal Spray Antazol 0.1%",
    "Eye Drop Moxiflox",
    "Ointment Neomycin",
    "Syp. Antacid 200ml",
  ];

  @override
  void initState() {
    super.initState();
    // Default exam values
    _weightController.text = "74";
  }

  @override
  void dispose() {
    _complaintInputController.dispose();
    _diagnosisInputController.dispose();
    _adviceController.dispose();
    _bpController.dispose();
    _pulseController.dispose();
    _tempController.dispose();
    _weightController.dispose();
    _spo2Controller.dispose();
    super.dispose();
  }

  // Tags adding helpers
  void _addComplaintTag(String val) {
    final complaint = val.trim();
    if (complaint.isNotEmpty && !_selectedComplaints.contains(complaint)) {
      setState(() {
        _selectedComplaints.add(complaint);
        _complaintInputController.clear();
        _showComplaintSuggestions = false;
      });
    }
  }

  void _addDiagnosisTag(String val) {
    final diagnosis = val.trim();
    if (diagnosis.isNotEmpty && !_selectedDiagnoses.contains(diagnosis)) {
      setState(() {
        _selectedDiagnoses.add(diagnosis);
        _diagnosisInputController.clear();
        _showDiagnosisSuggestions = false;
      });
    }
  }

  // Medications Modal Form Sheet
  void _showAddMedicineDialog({Map<String, String>? editMed, int? editIndex}) {
    final nameController = TextEditingController(text: editMed?['name'] ?? '');
    String selectedDosage = editMed?['dosage'] ?? '1+0+1';
    String selectedDuration = editMed?['duration'] ?? '5 Days';
    String selectedTiming = editMed?['instructions'] ?? 'After Meal';

    final List<String> dosageOptions = ["1+0+0", "0+0+1", "1+0+1", "1+1+1", "2 tsp", "1 tsp", "As needed", "Apply thinly"];
    final List<String> durationOptions = ["3 Days", "5 Days", "7 Days", "10 Days", "2 Weeks", "1 Month", "Continue"];
    final List<String> timingOptions = ["After Meal", "Before Meal", "With Meal", "Empty Stomach"];

    bool showSuggestions = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Get matching medicines
            final query = nameController.text.toLowerCase();
            final matches = _medicineAutocompleteList
                .where((med) => med.toLowerCase().contains(query))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        Text(
                          editMed == null ? 'Add Medication' : 'Edit Medication',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: ClinicalTheme.textDark,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const Divider(height: 12),
                    const SizedBox(height: 8),

                    // Medicine Name Input with Autocomplete
                    const Text(
                      'Medicine Name',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: ClinicalTheme.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'e.g., Tab. Napa Extend 665mg',
                        hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                        prefixIcon: const Icon(Icons.medication_outlined, size: 18, color: ClinicalTheme.primaryBlue),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: ClinicalTheme.primaryBlue, width: 1.2),
                        ),
                      ),
                      onChanged: (val) {
                        setModalState(() {
                          showSuggestions = val.isNotEmpty && matches.isNotEmpty;
                        });
                      },
                    ),

                    // Suggestions Overlay
                    if (showSuggestions) ...[
                      const SizedBox(height: 4),
                      Container(
                        maxHeight: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: matches.length > 5 ? 5 : matches.length,
                          itemBuilder: (mCtx, mIdx) {
                            final match = matches[mIdx];
                            return ListTile(
                              dense: true,
                              title: Text(match, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              onTap: () {
                                setModalState(() {
                                  nameController.text = match;
                                  showSuggestions = false;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Dosage & Duration options row
                    Row(
                      children: [
                        // Dosage
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Dosage / Frequency',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: ClinicalTheme.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedDosage,
                                    isExpanded: true,
                                    style: const TextStyle(fontSize: 12, color: ClinicalTheme.textDark, fontWeight: FontWeight.bold),
                                    items: dosageOptions.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                                    onChanged: (v) => setModalState(() => selectedDosage = v!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Duration
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Duration',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: ClinicalTheme.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedDuration,
                                    isExpanded: true,
                                    style: const TextStyle(fontSize: 12, color: ClinicalTheme.textDark, fontWeight: FontWeight.bold),
                                    items: durationOptions.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                                    onChanged: (v) => setModalState(() => selectedDuration = v!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Timing Instruction Options
                    const Text(
                      'Timing Instruction',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: ClinicalTheme.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: timingOptions.map((opt) {
                        final isSelected = selectedTiming == opt;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setModalState(() => selectedTiming = opt),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? ClinicalTheme.primaryBlue.withOpacity(0.08) : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? ClinicalTheme.primaryBlue : Colors.grey.shade200,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                opt,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? ClinicalTheme.primaryBlue : ClinicalTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Save / Add action Button
                    ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter medicine name')),
                          );
                          return;
                        }

                        Navigator.pop(ctx); // Close sheet

                        setState(() {
                          final medData = {
                            'name': name,
                            'dosage': selectedDosage,
                            'duration': selectedDuration,
                            'instructions': selectedTiming,
                          };

                          if (editIndex == null) {
                            _medicines.add(medData);
                          } else {
                            _medicines[editIndex] = medData;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ClinicalTheme.primaryBlue,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        editMed == null ? 'Add to Prescription' : 'Update Medication',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Date Picker
  Future<void> _selectFollowUpDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _followUpDate ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ClinicalTheme.primaryBlue,
              onPrimary: Colors.white,
              onSurface: ClinicalTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _followUpDate = picked;
      });
    }
  }

  // Send & Generate eRx
  void _submitAndGeneratePrescription() {
    if (_selectedDiagnoses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one Diagnosis tag.')),
      );
      return;
    }

    if (_medicines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one Medication.')),
      );
      return;
    }

    final newRx = Prescription(
      id: 'rx_${DateTime.now().millisecondsSinceEpoch}',
      appointmentId: 'app_active',
      patientId: widget.patientId,
      patientName: widget.patientName,
      patientAge: 28, // Mocked patient age
      patientGender: 'Male', // Mocked patient gender
      patientWeight: double.tryParse(_weightController.text) ?? 74.0,
      doctorName: 'Dr. Sarah Rahman',
      doctorDegrees: 'MBBS, FCPS (Medicine), MD (Cardiology)',
      doctorSpecialty: 'Cardiologist',
      bmdcLicense: 'A-84291',
      chiefComplaints: _selectedComplaints.isNotEmpty ? _selectedComplaints : ["Fever for 2 days"],
      diagnosis: _selectedDiagnoses,
      onExamination: {
        if (_bpController.text.isNotEmpty) 'BP': '${_bpController.text} mmHg',
        if (_pulseController.text.isNotEmpty) 'Pulse': '${_pulseController.text} bpm',
        if (_tempController.text.isNotEmpty) 'Temp': '${_tempController.text} F',
        if (_spo2Controller.text.isNotEmpty) 'SPO2': '${_spo2Controller.text}%',
        if (_weightController.text.isNotEmpty) 'Weight': '${_weightController.text} kg',
      },
      medicines: _medicines,
      advice: _adviceController.text.trim().isNotEmpty
          ? _adviceController.text.trim()
          : 'Drink warm water. Avoid cold drinks. Complete the full course of medications.',
      followUpDate: _followUpDate != null
          ? "${_followUpDate!.year}-${_followUpDate!.month.toString().padLeft(2, '0')}-${_followUpDate!.day.toString().padLeft(2, '0')}"
          : null,
      date: DateTime.now(),
    );

    // Save in shared service
    Provider.of<AppointmentService>(context, listen: false).addPrescription(newRx);

    // Show success options dialog
    _showSuccessOptionsDialog(newRx);
  }

  // PDF rendering function
  Future<void> _generateAndPrintPdf(Prescription rx) async {
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
                        pw.Text(rx.doctorName, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                        pw.Text(rx.doctorDegrees, style: const pw.TextStyle(fontSize: 9.5)),
                        pw.Text(rx.doctorSpecialty, style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.blue800)),
                        pw.Text('BMDC Reg No: ${rx.bmdcLicense}', style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700)),
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
                      pw.Text('Patient Name: ${rx.patientName}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                      pw.Text('Gender: ${rx.patientGender}', style: const pw.TextStyle(fontSize: 9.5)),
                      pw.Text('Age: ${rx.patientAge} Yrs', style: const pw.TextStyle(fontSize: 9.5)),
                      pw.Text('Weight: ${rx.patientWeight} kg', style: const pw.TextStyle(fontSize: 9.5)),
                      pw.Text('Date: ${rx.date.day}/${rx.date.month}/${rx.date.year}', style: const pw.TextStyle(fontSize: 9.5)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),

                // Layout divided into Left column (Chief complaints, examination, diagnosis) and Right column (Rx)
                pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Left Column (Symptom specs)
                      pw.Expanded(
                        flex: 3,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('CHIEF COMPLAINTS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5, color: PdfColors.blue900)),
                            pw.SizedBox(height: 4),
                            ...rx.chiefComplaints.map((comp) => pw.Bullet(text: comp, style: const pw.TextStyle(fontSize: 9))),
                            pw.SizedBox(height: 12),

                            pw.Text('ON EXAMINATION', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5, color: PdfColors.blue900)),
                            pw.SizedBox(height: 4),
                            ...rx.onExamination.entries.map((ent) => pw.Text('${ent.key}: ${ent.value}', style: const pw.TextStyle(fontSize: 9))),
                            pw.SizedBox(height: 12),

                            pw.Text('DIAGNOSIS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5, color: PdfColors.blue900)),
                            pw.SizedBox(height: 4),
                            ...rx.diagnosis.map((diag) => pw.Bullet(text: diag, style: const pw.TextStyle(fontSize: 9))),
                          ],
                        ),
                      ),

                      // Vertical divider line
                      pw.Container(
                        width: 1.2,
                        color: PdfColors.grey300,
                        margin: const pw.EdgeInsets.symmetric(horizontal: 16),
                      ),

                      // Right Column (Rx medications & advice)
                      pw.Expanded(
                        flex: 5,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Rx (Medications prescribed)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: PdfColors.blue900)),
                            pw.SizedBox(height: 6),
                            ...rx.medicines.asMap().entries.map((entry) {
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
                            pw.Text(rx.advice, style: const pw.TextStyle(fontSize: 9)),
                            pw.SizedBox(height: 16),

                            if (rx.followUpDate != null) ...[
                              pw.Text('FOLLOW UP REVIEW', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5, color: PdfColors.blue900)),
                              pw.SizedBox(height: 4),
                              pw.Text('Please review in clinic / online on or before: ${rx.followUpDate}', style: const pw.TextStyle(fontSize: 9, color: PdfColors.red700)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                pw.Divider(thickness: 1, color: PdfColors.grey300),
                pw.SizedBox(height: 8),

                // Footer section with digital seal
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
                        pw.Text(rx.doctorName, style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
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

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // Dialog showing options after eRx submission
  void _showSuccessOptionsDialog(Prescription rx) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: ClinicalTheme.accentGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'Prescription Sent!',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: ClinicalTheme.textDark),
              ),
              const SizedBox(height: 6),
              Text(
                'ePrescription for ${widget.patientName} has been saved and compiled successfully.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11.5, color: ClinicalTheme.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 20),

              // Option 1: PDF view & Print
              OutlinedButton.icon(
                onPressed: () {
                  _generateAndPrintPdf(rx);
                },
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 16, color: ClinicalTheme.primaryBlue),
                label: const Text('View / Print PDF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  foregroundColor: ClinicalTheme.primaryBlue,
                  side: const BorderSide(color: ClinicalTheme.primaryBlue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 8),

              // Option 2: Send to pharmacy queue
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sent to pharmacy fulfillment queue! Order created successfully.')),
                  );
                },
                icon: const Icon(Icons.local_pharmacy_rounded, size: 16, color: Colors.white),
                label: const Text('Send to Pharmacy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  minimumSize: const Size(double.infinity, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 10),
              const SizedBox(height: 10),

              // Option 3: Go back
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  context.pop(); // Close prescription screen
                },
                child: const Text(
                  'Return to Dashboard',
                  style: TextStyle(fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tag matching
    final cQuery = _complaintInputController.text.toLowerCase();
    final matchingComplaints = _commonComplaints
        .where((comp) => comp.toLowerCase().contains(cQuery) && !_selectedComplaints.contains(comp))
        .toList();

    final dQuery = _diagnosisInputController.text.toLowerCase();
    final matchingDiagnoses = _commonDiagnoses
        .where((diag) => diag.toLowerCase().contains(dQuery) && !_selectedDiagnoses.contains(diag))
        .toList();

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Create e-Prescription',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.extrabold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        foregroundColor: ClinicalTheme.textDark,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A. Patient Info Header Block
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.08),
                    child: const Text('👨‍⚕️', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PRESCRIBING PATIENT',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.extrabold, color: ClinicalTheme.primaryBlue, letterSpacing: 0.8),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.patientName,
                          style: const TextStyle(fontWeight: FontWeight.extrabold, fontSize: 14, color: ClinicalTheme.textDark),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'ID: ${widget.patientId} • Male • 28 Years • Weight: ${_weightController.text} kg',
                          style: const TextStyle(fontSize: 10.5, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // B. Chief Complaints tag input section
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.sick_outlined, size: 18, color: ClinicalTheme.primaryBlue),
                        SizedBox(width: 8),
                        Text(
                          'Chief Complaints',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Chip tag field
                    if (_selectedComplaints.isNotEmpty) ...[
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _selectedComplaints.map((comp) {
                          return InputChip(
                            label: Text(comp, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.06),
                            labelStyle: const TextStyle(color: ClinicalTheme.primaryBlue),
                            deleteIconColor: ClinicalTheme.primaryBlue,
                            onDeleted: () {
                              setState(() {
                                _selectedComplaints.remove(comp);
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                    ],

                    TextField(
                      controller: _complaintInputController,
                      decoration: InputDecoration(
                        hintText: 'Search or type chief symptom complaints...',
                        hintStyle: TextStyle(fontSize: 11.5, color: Colors.grey.shade400),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: ClinicalTheme.primaryBlue, width: 1.2),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: ClinicalTheme.primaryBlue, size: 20),
                          onPressed: () {
                            _addComplaintTag(_complaintInputController.text);
                          },
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _showComplaintSuggestions = val.isNotEmpty && matchingComplaints.isNotEmpty;
                        });
                      },
                    ),

                    // Suggestions row
                    if (_showComplaintSuggestions) ...[
                      const SizedBox(height: 4),
                      Container(
                        maxHeight: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: matchingComplaints.length > 4 ? 4 : matchingComplaints.length,
                          itemBuilder: (context, idx) {
                            final suggest = matchingComplaints[idx];
                            return ListTile(
                              dense: true,
                              title: Text(suggest, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                              onTap: () => _addComplaintTag(suggest),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // C. On Examination (Quick Add Metrics)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.analytics_outlined, size: 18, color: ClinicalTheme.primaryBlue),
                        SizedBox(width: 8),
                        Text(
                          'On Examination (Vitals)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Quick inputs row
                    Row(
                      children: [
                        // BP
                        Expanded(
                          child: _buildVitalsInput(
                            _bpController,
                            'BP',
                            'mmHg',
                            '120/80',
                            onQuickPrefill: () => setState(() => _bpController.text = "120/80"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Pulse
                        Expanded(
                          child: _buildVitalsInput(
                            _pulseController,
                            'Pulse',
                            'bpm',
                            '72',
                            onQuickPrefill: () => setState(() => _pulseController.text = "72"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Temp
                        Expanded(
                          child: _buildVitalsInput(
                            _tempController,
                            'Temp',
                            'F',
                            '98.6',
                            onQuickPrefill: () => setState(() => _tempController.text = "98.6"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        // SPO2
                        Expanded(
                          child: _buildVitalsInput(
                            _spo2Controller,
                            'SPO2',
                            '%',
                            '98',
                            onQuickPrefill: () => setState(() => _spo2Controller.text = "98"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Weight
                        Expanded(
                          child: _buildVitalsInput(
                            _weightController,
                            'Weight',
                            'kg',
                            '74',
                            onQuickPrefill: () => setState(() => _weightController.text = "74"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // D. Diagnosis Chips
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.assignment_turned_in_outlined, size: 18, color: ClinicalTheme.primaryBlue),
                        SizedBox(width: 8),
                        Text(
                          'Diagnosis',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Chip tag list
                    if (_selectedDiagnoses.isNotEmpty) ...[
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _selectedDiagnoses.map((diag) {
                          return InputChip(
                            label: Text(diag, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            backgroundColor: ClinicalTheme.accentGreen.withOpacity(0.06),
                            labelStyle: const TextStyle(color: ClinicalTheme.accentGreen),
                            deleteIconColor: ClinicalTheme.accentGreen,
                            onDeleted: () {
                              setState(() {
                                _selectedDiagnoses.remove(diag);
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                    ],

                    TextField(
                      controller: _diagnosisInputController,
                      decoration: InputDecoration(
                        hintText: 'Search or type patient diagnosis...',
                        hintStyle: TextStyle(fontSize: 11.5, color: Colors.grey.shade400),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: ClinicalTheme.primaryBlue, width: 1.2),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: ClinicalTheme.primaryBlue, size: 20),
                          onPressed: () {
                            _addDiagnosisTag(_diagnosisInputController.text);
                          },
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _showDiagnosisSuggestions = val.isNotEmpty && matchingDiagnoses.isNotEmpty;
                        });
                      },
                    ),

                    // Suggestions Overlay
                    if (_showDiagnosisSuggestions) ...[
                      const SizedBox(height: 4),
                      Container(
                        maxHeight: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: matchingDiagnoses.length > 4 ? 4 : matchingDiagnoses.length,
                          itemBuilder: (context, idx) {
                            final suggest = matchingDiagnoses[idx];
                            return ListTile(
                              dense: true,
                              title: Text(suggest, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                              onTap: () => _addDiagnosisTag(suggest),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // E. Medications (Rx list with add medication form button)
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                const Row(
                  children: [
                    Icon(Icons.medication_rounded, size: 18, color: ClinicalTheme.primaryBlue),
                    SizedBox(width: 8),
                    Text(
                      'Medications (Rx list)',
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _showAddMedicineDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('+ Add Medicine', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(foregroundColor: ClinicalTheme.primaryBlue),
                ),
              ],
            ),
            const SizedBox(height: 4),

            if (_medicines.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(Icons.healing_outlined, color: Colors.grey.shade300, size: 32),
                    const SizedBox(height: 6),
                    Text(
                      'No medicines added yet to Rx list.',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey.shade400, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _medicines.length,
                itemBuilder: (context, idx) {
                  final med = _medicines[idx];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 12,
                        backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.08),
                        child: Text('${idx + 1}', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue)),
                      ),
                      title: Text(med['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: ClinicalTheme.textDark)),
                      subtitle: Text('${med['dosage']} • ${med['duration']} • (${med['instructions']})', style: const TextStyle(fontSize: 10, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.w500)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: ClinicalTheme.primaryBlue, size: 16),
                            onPressed: () => _showAddMedicineDialog(editMed: med, editIndex: idx),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: ClinicalTheme.alertRed, size: 16),
                            onPressed: () {
                              setState(() {
                                _medicines.removeAt(idx);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),

            // F. Advice Free text
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 18, color: ClinicalTheme.primaryBlue),
                        SizedBox(width: 8),
                        Text(
                          'Advices / Special Instructions',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _adviceController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'e.g., Avoid cold foods. Review BP in 3 days. Drink warm liquids.',
                        hintStyle: TextStyle(fontSize: 11.5, color: Colors.grey.shade400),
                        contentPadding: const EdgeInsets.all(12),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: ClinicalTheme.primaryBlue, width: 1.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // G. Follow Up Review (Optional Date Picker)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: InkWell(
                onTap: _selectFollowUpDate,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 18, color: ClinicalTheme.primaryBlue),
                          SizedBox(width: 8),
                          Text(
                            'Follow-up Review (Optional)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            _followUpDate == null
                                ? 'Not set'
                                : "${_followUpDate!.day}/${_followUpDate!.month}/${_followUpDate!.year}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _followUpDate == null ? Colors.grey : ClinicalTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // H. Send Prescription Submission Button
            ElevatedButton(
              onPressed: _submitAndGeneratePrescription,
              style: ElevatedButton.styleFrom(
                backgroundColor: ClinicalTheme.primaryBlue,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 2,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'SEND e-PRESCRIPTION',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Vitals field widget builder
  Widget _buildVitalsInput(
    TextEditingController ctrl,
    String label,
    String suffix,
    String mockNormal, {
    required VoidCallback onQuickPrefill,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.between,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
            ),
            GestureDetector(
              onTap: onQuickPrefill,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Normal',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.black, color: ClinicalTheme.primaryBlue),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
          decoration: InputDecoration(
            hintText: 'e.g., $mockNormal',
            hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.normal),
            suffixText: suffix,
            suffixStyle: const TextStyle(fontSize: 10, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.bold),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            filled: true,
            fillColor: Colors.grey.shade50,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: ClinicalTheme.primaryBlue, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
