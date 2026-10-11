import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, String>> _faqs = [
    {
      "q": "How do I book a video consultation?",
      "a": "Go to the Home tab, find a doctor under 'Popular Doctors' or tap 'Book Appt'. Select a specialty, choose your doctor, select a date and time slot, and proceed to pay. You will receive an instant appointment ID."
    },
    {
      "q": "Can I cancel or reschedule my appointment?",
      "a": "Yes! Navigate to 'My Appointments' from the menu, select your upcoming appointment, and click 'Cancel Booking'. You will receive a full refund within 24 hours."
    },
    {
      "q": "How does home sample collection work?",
      "a": "When booking a pathology lab package, select 'Home Collection'. A verified diagnostic technician will be scheduled to visit your home at the chosen time slot to collect samples safely."
    },
    {
      "q": "Are the doctors on Hello Doctor verified?",
      "a": "Absolutely. Every medical practitioner registering on Hello Doctor goes through manual BMDC registration and license verification by our Super Admin panel before being allowed to provide consultations."
    },
    {
      "q": "How do I download my e-prescription?",
      "a": "Once your video consult concludes, go to 'My Prescriptions' or select the appointment in 'Consultation History'. Click 'Download PDF' to save your signed clinical e-prescription."
    }
  ];

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ClinicalTheme.textDark, size: 20),
          onPressed: () => context.go('/patient-home'),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ClinicalTheme.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Support Banner Callout
              Card(
                elevation: 0,
                color: ClinicalTheme.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 40),
                      const SizedBox(height: 12),
                      const Text(
                        'Need Immediate Help?',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Our clinical support team and technical desk are online 24/7 to resolve appointment, booking, or prescription issues.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.5,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Reuse chat component - opens conversation with support desk
                          final peerNameEncoded = Uri.encodeComponent('Hello Doctor Helpdesk');
                          context.push('/chat-conversation?threadId=support_thread&peerId=support_team&peerName=$peerNameEncoded&peerRole=support');
                        },
                        icon: const Icon(Icons.forum_rounded, color: ClinicalTheme.primaryBlue, size: 16),
                        label: const Text(
                          'Contact Support Chat',
                          style: TextStyle(color: ClinicalTheme.primaryBlue, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(200, 42),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // FAQ Section
              const Text(
                'FREQUENTLY ASKED QUESTIONS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.extrabold,
                  fontSize: 11,
                  color: ClinicalTheme.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _faqs.length,
                itemBuilder: (context, index) {
                  final faq = _faqs[index];
                  final isExpanded = _expandedIndex == index;

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.withOpacity(0.08)),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            faq["q"]!,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                              color: ClinicalTheme.textDark,
                            ),
                          ),
                          trailing: Icon(
                            isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            color: ClinicalTheme.primaryBlue,
                            size: 18,
                          ),
                          dense: true,
                          onTap: () {
                            setState(() {
                              _expandedIndex = isExpanded ? null : index;
                            });
                          },
                        ),
                        if (isExpanded) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(height: 1, color: Color(0xfff0f2f6)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              faq["a"]!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.5,
                                color: ClinicalTheme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
