import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class EhrViewerScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const EhrViewerScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<EhrViewerScreen> createState() => _EhrViewerScreenState();
}

class _EhrViewerScreenState extends State<EhrViewerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Electronic Health Record (EHR)',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        foregroundColor: ClinicalTheme.textDark,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: ClinicalTheme.primaryBlue,
          unselectedLabelColor: ClinicalTheme.textSecondary,
          indicatorColor: ClinicalTheme.primaryBlue,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          tabs: const [
            Tab(text: "Visit History", icon: Icon(Icons.history_rounded, size: 18)),
            Tab(text: "Allergies & Risk", icon: Icon(Icons.warning_amber_rounded, size: 18)),
            Tab(text: "Past Prescriptions", icon: Icon(Icons.receipt_long_rounded, size: 18)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildVisitHistoryTab(),
          _buildAllergiesTab(),
          _buildPastRxTab(),
        ],
      ),
    );
  }

  // Tab 1: Visit History
  Widget _buildVisitHistoryTab() {
    final history = [
      {
        "date": "24 Jun 2026",
        "doctor": "Dr. Sarah Rahman (Cardiologist)",
        "reason": "Hyperlipidemia review & BP checkup",
        "notes": "Patient reports minor muscle stiffness. BP was 134/85 mmHg. Advice: Reduce dietary sodium intake and continue light cardiovascular exercises.",
        "vital": "BP: 134/85 | Pulse: 72 | Temp: 98.4°F",
      },
      {
        "date": "10 Apr 2026",
        "doctor": "Dr. Sarah Rahman (Cardiologist)",
        "reason": "Annual health assessment",
        "notes": "General wellness visit. Routine lab tests indicate lipid profile slightly above normal. Started low-dose Statin.",
        "vital": "BP: 120/80 | Pulse: 68 | Temp: 98.6°F",
      }
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item['date']!,
                        style: const TextStyle(color: ClinicalTheme.primaryBlue, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text('Tele-Consultation', style: TextStyle(fontSize: 10.5, color: Colors.indigo, fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item['reason']!,
                  style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                ),
                const SizedBox(height: 4),
                Text(
                  'Consulted with: ${item['doctor']}',
                  style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
                const Divider(height: 24, color: Color(0xfff0f2f5)),
                const Text(
                  'Doctor Notes & Advice:',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                ),
                const SizedBox(height: 4),
                Text(
                  item['notes']!,
                  style: const TextStyle(fontSize: 11.5, height: 1.4, color: ClinicalTheme.textSecondary),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_rounded, color: Colors.red, size: 14),
                      const SizedBox(width: 8),
                      Text(
                        'Recorded Vitals: ${item['vital']}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Tab 2: Allergies & Risks
  Widget _buildAllergiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Allergies list Card
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: ClinicalTheme.alertRed, size: 18),
              SizedBox(width: 8),
              Text(
                'Known Drug Allergies',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: ClinicalTheme.textDark),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  _buildAllergyItem("Penicillin", "Severe hives, facial swelling", "High Risk"),
                  const Divider(height: 20),
                  _buildAllergyItem("Sulfa Drugs", "Mild rashes", "Medium Risk"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Chronic Medical Conditions
          const Row(
            children: [
              Icon(Icons.monitor_heart_rounded, color: Colors.indigo, size: 18),
              SizedBox(width: 8),
              Text(
                'Chronic Conditions / Risk Factors',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: ClinicalTheme.textDark),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  _buildConditionItem("Essential Hypertension", "Diagnosed 2024", "Active"),
                  const Divider(height: 20),
                  _buildConditionItem("Mild Hyperlipidemia", "Diagnosed 2026", "Under Control"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Immunization Records
          const Row(
            children: [
              Icon(Icons.vaccines_rounded, color: Colors.teal, size: 18),
              SizedBox(width: 8),
              Text(
                'Immunization Status',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: ClinicalTheme.textDark),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: const Padding(
              padding: EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text('Covid-19 Booster (Moderna)', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark)),
                      Text('Fully Vaccinated', style: TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text('Hepatitis B vaccine', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark)),
                      Text('Completed 2022', style: TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergyItem(String drug, String reaction, String severity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.between,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(drug, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark)),
              const SizedBox(height: 2),
              Text('Reaction: $reaction', style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: severity == "High Risk" ? ClinicalTheme.alertRed.withOpacity(0.1) : Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            severity,
            style: TextStyle(
              color: severity == "High Risk" ? ClinicalTheme.alertRed : Colors.orange,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildConditionItem(String condition, String diagnosed, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.between,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(condition, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark)),
              const SizedBox(height: 2),
              Text(diagnosed, style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: status == "Active" ? Colors.blue.withOpacity(0.1) : Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: status == "Active" ? Colors.blue : Colors.teal,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  // Tab 3: Past Prescriptions
  Widget _buildPastRxTab() {
    final prescriptions = [
      {
        "id": "Rx_88421",
        "doctor": "Dr. Sarah Rahman",
        "date": "24 Jun 2026",
        "diagnosis": "BP review, Hyperlipidemia",
        "medicines": [
          "Tab. Atorvastatin 10mg - 0+0+1 (1 Month, After Meal)",
          "Tab. Amlodipine 5mg - 1+0+0 (1 Month, Before Meal)"
        ],
      },
      {
        "id": "Rx_87541",
        "doctor": "Dr. Sarah Rahman",
        "date": "10 Apr 2026",
        "diagnosis": "Initial Lipid panel assessment",
        "medicines": [
          "Tab. Atorvastatin 10mg - 0+0+1 (3 Months, After Meal)"
        ],
      }
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: prescriptions.length,
      itemBuilder: (context, index) {
        final rx = prescriptions[index];
        final medicinesList = rx['medicines'] as List<String>;

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_long_rounded, color: ClinicalTheme.primaryBlue, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          rx['id'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                        ),
                      ],
                    ),
                    Text(rx['date'] as String, style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Diagnosis: ${rx['diagnosis']}',
                  style: const TextStyle(fontSize: 11.5, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 24, color: Color(0xfff0f2f5)),
                const Text(
                  'Prescribed Medicines:',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                ),
                const SizedBox(height: 6),
                ...medicinesList.map((m) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue)),
                      Expanded(
                        child: Text(
                          m,
                          style: const TextStyle(fontSize: 11.5, color: ClinicalTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}
