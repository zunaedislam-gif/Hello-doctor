import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class PatientQueueScreen extends StatefulWidget {
  const PatientQueueScreen({super.key});

  @override
  State<PatientQueueScreen> createState() => _PatientQueueScreenState();
}

class _PatientQueueScreenState extends State<PatientQueueScreen> {
  // Simulated patient queue data
  final List<Map<String, dynamic>> _queue = [
    {
      "pos": 1,
      "id": "patient_mock",
      "name": "Karim Uddin",
      "gender": "Male",
      "age": 28,
      "weight": "74 kg",
      "time": "10:30 AM",
      "type": "General Consultation",
      "symptoms": "Fever (102°F) accompanied by severe throat irritation, body aches, and persistent dry cough for the last 2 days.",
      "photo": "assets/fever_rash.png",
      "photoLabel": "Throat inflammation photo",
      "isExpanded": true,
    },
    {
      "pos": 2,
      "id": "patient_2",
      "name": "Sultana Yasmin",
      "gender": "Female",
      "age": 42,
      "weight": "63 kg",
      "time": "11:15 AM",
      "type": "Follow-up Visit",
      "symptoms": "Checking on BP readings. Has experienced mild dizziness in the morning after starting the new medication.",
      "photo": null,
      "isExpanded": false,
    },
    {
      "pos": 3,
      "id": "patient_3",
      "name": "Asif Iqbal",
      "gender": "Male",
      "age": 35,
      "weight": "80 kg",
      "time": "12:00 PM",
      "type": "General Consultation",
      "symptoms": "Dry cough and chest tightness for a week. No fever, but coughing increases at night.",
      "photo": "assets/cough_syrup.png",
      "photoLabel": "Current medication label",
      "isExpanded": false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Live Patient Queue',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: ClinicalTheme.textDark,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _queue.length,
        itemBuilder: (context, index) {
          final patient = _queue[index];
          final isExpanded = patient['isExpanded'] as bool;

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            elevation: isExpanded ? 4 : 1,
            shadowColor: Colors.black.withOpacity(0.04),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isExpanded ? ClinicalTheme.primaryBlue.withOpacity(0.3) : Colors.grey.shade200,
                width: isExpanded ? 1.5 : 1,
              ),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _queue[index]['isExpanded'] = !isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Queue Item Header
                    Row(
                      children: [
                        // Queue position badge
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isExpanded ? ClinicalTheme.primaryBlue : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '#${patient['pos']}',
                            style: TextStyle(
                              color: isExpanded ? Colors.white : ClinicalTheme.textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Patient Meta info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patient['name']!,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: ClinicalTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${patient['gender']} • ${patient['age']} Yrs • ${patient['weight']}',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: ClinicalTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Expand Icon
                        Icon(
                          isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                          color: ClinicalTheme.textSecondary,
                        ),
                      ],
                    ),

                    // Expandable Section
                    if (isExpanded) ...[
                      const Divider(height: 24, color: Color(0xfff0f2f5)),
                      const Text(
                        'Reported Symptoms / Problems:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ClinicalTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        patient['symptoms']!,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: ClinicalTheme.textSecondary,
                        ),
                      ),
                      if (patient['photo'] != null) ...[
                        const SizedBox(height: 14),
                        const Text(
                          'Patient Attachments:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: ClinicalTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.image_rounded, color: Colors.amber, size: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patient['photoLabel'] ?? 'Attachment.png',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: ClinicalTheme.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'File Size: 1.4 MB • JPG Image',
                                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.visibility_outlined, size: 20, color: ClinicalTheme.primaryBlue),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Simulating Attachment Preview')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      const Divider(height: 28, color: Color(0xfff0f2f5)),
                      // Workflow Buttons row
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.end,
                        children: [
                          // 1. EHR Viewer Button
                          OutlinedButton.icon(
                            onPressed: () {
                              context.push('/doctor/ehr?patientId=${patient['id']}&patientName=${Uri.encodeComponent(patient['name']!)}');
                            },
                            icon: const Icon(Icons.medical_information_rounded, size: 14),
                            label: const Text('Patient EHR', style: TextStyle(fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.indigo,
                              side: const BorderSide(color: Colors.indigo, width: 1.2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                          ),
                          // 2. Chat Button
                          OutlinedButton.icon(
                            onPressed: () {
                              final threadId = "patient_doc_1"; // Mock Thread
                              context.push(
                                '/chat-conversation?threadId=$threadId&peerId=${patient['id']}&peerName=${Uri.encodeComponent(patient['name']!)}&peerRole=patient',
                              );
                            },
                            icon: const Icon(Icons.forum_outlined, size: 14),
                            label: const Text('Chat', style: TextStyle(fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ClinicalTheme.primaryBlue,
                              side: const BorderSide(color: ClinicalTheme.primaryBlue, width: 1.2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                          ),
                          // 3. Call Button
                          ElevatedButton.icon(
                            onPressed: () {
                              context.push('/video-call?appId=app_queue_1&role=doctor');
                            },
                            icon: const Icon(Icons.video_call_rounded, size: 14),
                            label: const Text('Call', style: TextStyle(fontSize: 11)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff27ae60),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              minimumSize: const Size(60, 34),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                          // 4. Prescription Button
                          ElevatedButton.icon(
                            onPressed: () {
                              context.push(
                                '/doctor/prescription?patientId=${patient['id']}&patientName=${Uri.encodeComponent(patient['name']!)}',
                              );
                            },
                            icon: const Icon(Icons.note_alt_rounded, size: 14),
                            label: const Text('Write Rx', style: TextStyle(fontSize: 11)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ClinicalTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              minimumSize: const Size(60, 34),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ],
                      )
                    ]
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
