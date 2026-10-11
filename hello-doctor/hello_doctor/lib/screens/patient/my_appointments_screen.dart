import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../services/appointment_service.dart';
import '../../models/appointment_model.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Standard Seed/Mock Appointments for instant, robust visual simulation
  final List<Appointment> _seededUpcoming = [
    Appointment(
      id: 'APP-93821',
      doctorId: 'doc_1',
      doctorName: 'Dr. Sarah Rahman',
      doctorDegrees: 'MBBS, FCPS',
      doctorSpecialty: 'Cardiologist',
      date: 'Today',
      timeSlot: '04:00 PM - 04:30 PM',
      status: 'Upcoming',
      consultationFee: 500,
      vat: 25,
      platformFee: 50,
      totalAmount: 575,
      paymentMethod: 'bKash',
      createdAt: DateTime.now(),
    ),
  ];

  final List<Appointment> _seededPast = [
    Appointment(
      id: 'APP-72109',
      doctorId: 'doc_3',
      doctorName: 'Dr. Ariful Islam',
      doctorDegrees: 'MBBS, MD',
      doctorSpecialty: 'Cardiologist',
      date: '02 July 2026',
      timeSlot: '11:30 AM - 12:00 PM',
      status: 'Completed',
      consultationFee: 800,
      vat: 40,
      platformFee: 50,
      totalAmount: 890,
      paymentMethod: 'bKash',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Appointment(
      id: 'APP-62190',
      doctorId: 'doc_4',
      doctorName: 'Dr. Naila Khan',
      doctorDegrees: 'MBBS, DCH',
      doctorSpecialty: 'Pediatrics',
      date: '25 June 2026',
      timeSlot: '06:00 PM - 06:30 PM',
      status: 'Completed',
      consultationFee: 700,
      vat: 35,
      platformFee: 50,
      totalAmount: 785,
      paymentMethod: 'Nagad',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ClinicalTheme.textDark, size: 20),
          onPressed: () => context.go('/patient-home'),
        ),
        title: const Text(
          'My Appointments',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ClinicalTheme.textDark,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: ClinicalTheme.primaryBlue,
          unselectedLabelColor: ClinicalTheme.textSecondary.withOpacity(0.6),
          indicatorColor: ClinicalTheme.primaryBlue,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.medium, fontSize: 13),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past Visits'),
          ],
        ),
      ),
      body: Consumer<AppointmentService>(
        builder: (context, service, child) {
          // Combine live service appointments with our seed data for rich demo
          final List<Appointment> upcomingList = [];
          final List<Appointment> pastList = List.from(_seededPast);

          // Categorize user appointments
          for (var app in service.appointments) {
            if (app.status == 'Upcoming') {
              upcomingList.add(app);
            } else {
              pastList.insert(0, app);
            }
          }

          // If no live ones, append standard seed so the app is populated
          if (upcomingList.isEmpty) {
            upcomingList.addAll(_seededUpcoming);
          }

          return TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              // Upcoming tab
              _buildUpcomingTab(context, upcomingList),
              
              // Past tab
              _buildPastTab(context, pastList),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUpcomingTab(BuildContext context, List<Appointment> upcoming) {
    if (upcoming.isEmpty) {
      return _buildEmptyState(context, 'No Upcoming Appointments', 'Schedule a clinical video consultation with our specialists.');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: upcoming.length,
      itemBuilder: (context, index) {
        final app = upcoming[index];
        return _buildUpcomingCard(context, app);
      },
    );
  }

  Widget _buildPastTab(BuildContext context, List<Appointment> past) {
    if (past.isEmpty) {
      return _buildEmptyState(context, 'No Past Consultations', 'Your historical health checkups and visits will appear here.');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: past.length,
      itemBuilder: (context, index) {
        final app = past[index];
        return _buildPastCard(context, app);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String title, String description) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ClinicalTheme.primaryBlue.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_note_rounded,
                size: 54,
                color: ClinicalTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: ClinicalTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: ClinicalTheme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/doctor-list'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ClinicalTheme.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Find a Doctor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(BuildContext context, Appointment app) {
    final bool isCancelled = app.status == 'Cancelled';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Text(
                  'APPOINTMENT ID: ${app.id}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: ClinicalTheme.textSecondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isCancelled ? Colors.red.withOpacity(0.06) : ClinicalTheme.accentGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    app.status,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isCancelled ? ClinicalTheme.alertRed : ClinicalTheme.accentGreen,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.withOpacity(0.06), height: 1),
            const SizedBox(height: 12),
            
            // Doctor detail row
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.08),
                  child: Text(
                    app.doctorName.split(" ").last.substring(0, 1),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: ClinicalTheme.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.doctorName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: ClinicalTheme.textDark,
                        ),
                      ),
                      Text(
                        '${app.doctorDegrees} • ${app.doctorSpecialty}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: ClinicalTheme.textSecondary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ClinicalTheme.backgroundLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.videocam_rounded, size: 16, color: ClinicalTheme.primaryBlue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${app.date} at ${app.timeSlot}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 11.5,
                        color: ClinicalTheme.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            if (!isCancelled) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fee: ৳ ${app.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: ClinicalTheme.primaryBlue,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => _showRescheduleDialog(context),
                        icon: const Icon(Icons.edit_calendar_rounded, size: 14, color: ClinicalTheme.primaryBlue),
                        label: const Text('Reschedule', style: TextStyle(fontSize: 11, color: ClinicalTheme.primaryBlue, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 4),
                      TextButton.icon(
                        onPressed: () => _showCancelConfirmation(context, app.id),
                        icon: const Icon(Icons.cancel_outlined, size: 14, color: ClinicalTheme.alertRed),
                        label: const Text('Cancel', style: TextStyle(fontSize: 11, color: ClinicalTheme.alertRed, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.go('/virtual-waiting-room?appId=${app.id}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClinicalTheme.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.video_call_rounded, size: 16, color: Colors.white),
                  label: const Text(
                    'Join Live Consult Room',
                    style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 11.5),
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              const Text(
                'This appointment is cancelled. A refund has been issued.',
                style: TextStyle(fontFamily: 'Inter', fontSize: 10.5, fontStyle: FontStyle.italic, color: Colors.grey),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildPastCard(BuildContext context, Appointment app) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Text(
                  'APPOINTMENT ID: ${app.id}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: ClinicalTheme.textSecondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Completed',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ClinicalTheme.textDark,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.withOpacity(0.06), height: 1),
            const SizedBox(height: 12),
            
            // Doctor detail row
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.08),
                  child: Text(
                    app.doctorName.split(" ").last.substring(0, 1),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: ClinicalTheme.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.doctorName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: ClinicalTheme.textDark,
                        ),
                      ),
                      Text(
                        '${app.doctorDegrees} • ${app.doctorSpecialty}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: ClinicalTheme.textSecondary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ClinicalTheme.backgroundLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 16, color: ClinicalTheme.accentGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Visited on ${app.date} at ${app.timeSlot}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 11.5,
                        color: ClinicalTheme.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.push('/post-visit-summary?appId=${app.id}');
                    },
                    icon: const Icon(Icons.receipt_long_rounded, size: 14),
                    label: const Text('View Summary', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(0, 36),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go('/doctor-list');
                    },
                    icon: const Icon(Icons.repeat_rounded, size: 14, color: Colors.white),
                    label: const Text('Book Follow-up', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ClinicalTheme.primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(0, 36),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Cancel Appointment?',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15),
          ),
          content: const Text(
            'Are you sure you want to cancel this clinical consultation? A refund will be initiated immediately to your payment channel.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 12, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Keep Slot', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<AppointmentService>(context, listen: false).cancelAppointment(id);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Appointment cancelled successfully.')),
                );
              },
              child: const Text('Yes, Cancel', style: TextStyle(color: ClinicalTheme.alertRed, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showRescheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Reschedule Session', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15)),
          content: const Text('Please pick a new date/time slot from the doctor directory to reschedule your consult.', style: TextStyle(fontFamily: 'Inter', fontSize: 12, height: 1.4)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/doctor-list');
              },
              child: const Text('Select Slot', style: TextStyle(fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue)),
            ),
          ],
        );
      },
    );
  }
}
