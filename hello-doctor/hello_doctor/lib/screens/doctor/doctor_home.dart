import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../models/chat_message_model.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  int _currentIndex = 0;
  bool _isOnline = true; // Accepting live patient toggle
  bool _showNotifications = false;

  // Mock Notification lists
  final List<String> _notifications = [
    "New patient Karim Uddin joined the active queue.",
    "Emergency callback requested from Room 3A.",
    "Prescription Rx_88421 dispatched successfully."
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final chatService = Provider.of<ChatService>(context);
    final currentUser = auth.currentUser;

    final List<Widget> tabs = [
      _buildHomeTab(context, currentUser),
      _buildAppointmentsTab(),
      _buildReportsTab(),
      _buildAccountTab(context, currentUser, auth),
    ];

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.healing_rounded, color: ClinicalTheme.primaryBlue, size: 22),
            const SizedBox(width: 8),
            Text(
              _currentIndex == 0 ? 'Clinical Workspace' :
              _currentIndex == 1 ? 'Calendar & Schedule' :
              _currentIndex == 2 ? 'Consultation Reports' : 'Physician Profile',
              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: ClinicalTheme.textDark,
        elevation: 0.5,
        actions: [
          // Standing Message Shortcut
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.forum_outlined, color: ClinicalTheme.textDark),
                StreamBuilder<List<ChatThread>>(
                  stream: chatService.listenToThreads(currentUser?.id ?? 'doctor-mock', 'doctor'),
                  builder: (context, snapshot) {
                    final threads = snapshot.data ?? [];
                    int totalUnread = 0;
                    for (var t in threads) {
                      totalUnread += t.unreadCount;
                    }
                    if (totalUnread == 0) return const SizedBox.shrink();

                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
                        child: Text(
                          '$totalUnread',
                          style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            tooltip: 'Inbox Messages',
            onPressed: () => context.push('/chat-list'),
          ),

          // Portal role selection
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, color: ClinicalTheme.primaryBlue),
            tooltip: 'Switch Portal Role',
            onPressed: () => context.go(AppRoutes.roleSelection),
          ),
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ClinicalTheme.primaryBlue,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 10.5),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_rounded),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: HOME WORKSPACE ---
  Widget _buildHomeTab(BuildContext context, dynamic currentUser) {
    final docName = currentUser?.name ?? "Sarah Rahman";

    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. GREETING HEADER WITH PHOTO & BELL
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.1),
                  child: const Text('👩‍⚕️', style: TextStyle(fontSize: 26)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Good Morning,",
                        style: TextStyle(fontSize: 11.5, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Dr. $docName",
                        style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: ClinicalTheme.textDark),
                      ),
                    ],
                  ),
                ),
                // Notification Bell icon with count
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, color: ClinicalTheme.textDark, size: 26),
                      onPressed: () {
                        setState(() {
                          _showNotifications = !_showNotifications;
                        });
                      },
                    ),
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                        alignment: Alignment.center,
                        child: const Text(
                          '3',
                          style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),

            if (_showNotifications) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        GestureDetector(
                          onTap: () => setState(() => _showNotifications = false),
                          child: const Icon(Icons.close, size: 16, color: Colors.grey),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._notifications.map((n) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 6, color: ClinicalTheme.primaryBlue),
                          const SizedBox(width: 8),
                          Expanded(child: Text(n, style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary))),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 18),

            // 2. ONLINE/OFFLINE TOGGLE CARD
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: _isOnline ? Colors.emerald.withOpacity(0.3) : Colors.grey.shade300,
                  width: 1.2,
                ),
              ),
              color: _isOnline ? Colors.emerald.withOpacity(0.04) : Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _isOnline ? Colors.emerald.withOpacity(0.1) : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isOnline ? Icons.power_rounded : Icons.power_off_rounded,
                        color: _isOnline ? Colors.emerald : Colors.grey,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isOnline ? "You're accepting live patients" : "You're offline",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _isOnline ? Colors.emerald.shade900 : ClinicalTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isOnline ? "Patients can book instant video consults" : "Instant consultations are paused",
                            style: TextStyle(fontSize: 10.5, color: _isOnline ? Colors.emerald.shade700 : Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _isOnline,
                      activeColor: Colors.emerald,
                      onChanged: (val) {
                        setState(() {
                          _isOnline = val;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(val ? "Consultations active!" : "Consultations paused."),
                            backgroundColor: val ? Colors.emerald : Colors.grey,
                            duration: const Duration(milliseconds: 800),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // 3. ACTIVITY OVERVIEW CARDS (SCROLLABLE ROW)
            const Text(
              'Activity Overview',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: ClinicalTheme.textDark),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildOverviewCard(
                    'Ongoing', '2', 'Consults',
                    Icons.online_prediction_rounded, Colors.blue,
                    () => context.push('/doctor/patient-queue'),
                  ),
                  _buildOverviewCard(
                    'Completed Today', '5', 'Patients',
                    Icons.check_circle_outline_rounded, Colors.teal,
                    () {},
                  ),
                  _buildOverviewCard(
                    'Today\'s Earnings', '৳ 3.2k', 'Tap for details',
                    Icons.payments_outlined, Colors.emerald,
                    () => context.push('/doctor/earnings'),
                  ),
                  _buildOverviewCard(
                    'Total Patients', '182', 'Lifetime',
                    Icons.folder_shared_outlined, Colors.indigo,
                    () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 4. EMERGENCY/URGENT BANNER CARD WITH COUNT BADGE
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 10),
                              const Text('Emergency Callbacks (1)', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: ClinicalTheme.textDark)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: CircleAvatar(backgroundColor: Colors.red.withOpacity(0.1), child: const Text('🚨')),
                            title: const Text('Rahima Begum', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('Post-operative chest pain reported. Requested callback immediately.', style: TextStyle(fontSize: 11.5)),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: EdgeInsets.zero, minimumSize: const Size(60, 30)),
                              onPressed: () {
                                Navigator.pop(context);
                                context.push('/video-call?appId=emergency_callback&role=doctor');
                              },
                              child: const Text('CALL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Card(
                elevation: 0,
                color: ClinicalTheme.alertRed.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: ClinicalTheme.alertRed, width: 1.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: ClinicalTheme.alertRed, shape: BoxShape.circle),
                        child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Emergency / Urgent Request',
                              style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 13, color: ClinicalTheme.alertRed),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '1 patient requires immediate callback loops',
                              style: TextStyle(fontSize: 10.5, color: ClinicalTheme.textDark),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: const BoxDecoration(
                          color: ClinicalTheme.alertRed,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: const Text(
                          '1 Urgent',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 5. TODAY'S APPOINTMENTS LIST Below
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                const Text(
                  'Today\'s Appointments',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: ClinicalTheme.textDark),
                ),
                TextButton(
                  onPressed: () => context.push('/doctor/patient-queue'),
                  child: const Text('View Queue', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue)),
                )
              ],
            ),

            _buildAppointmentItem(
              'Karim Uddin',
              '10:30 AM (Now)',
              'General Consultation',
              true, // CALL Active!
              () {
                context.push('/video-call?appId=app_active_1&role=doctor');
              },
            ),
            const SizedBox(height: 10),
            _buildAppointmentItem(
              'Sultana Yasmin',
              '02:15 PM (In 4 hrs)',
              'Follow-up Visit',
              false, // CALL Disabled till scheduled time!
              () {},
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String count, String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 114,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Icon(icon, size: 18, color: color),
                const Icon(Icons.chevron_right_rounded, size: 14, color: Colors.grey),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.extrabold, color: color),
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 8.5, color: Colors.grey.shade400),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentItem(String name, String time, String type, bool isCallActive, VoidCallback onCall) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isCallActive ? ClinicalTheme.primaryBlue.withOpacity(0.3) : Colors.grey.shade200, width: isCallActive ? 1.5 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCallActive ? ClinicalTheme.primaryBlue.withOpacity(0.1) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.calendar_today_rounded, size: 16, color: isCallActive ? ClinicalTheme.primaryBlue : Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: ClinicalTheme.textDark),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$type • $time',
                    style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: isCallActive ? onCall : null,
              icon: const Icon(Icons.videocam_rounded, size: 14),
              label: const Text('Call', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff27ae60),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade100,
                disabledForegroundColor: Colors.grey.shade400,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- TAB 2: APPOINTMENTS CALENDAR ---
  Widget _buildAppointmentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Calendar Row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCalendarDay('Mon', '04', true),
                _buildCalendarDay('Tue', '05', false),
                _buildCalendarDay('Wed', '06', false),
                _buildCalendarDay('Thu', '07', false),
                _buildCalendarDay('Fri', '08', false),
                _buildCalendarDay('Sat', '09', false),
                _buildCalendarDay('Sun', '10', false),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Scheduled Slots Today',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: ClinicalTheme.textDark),
          ),
          const SizedBox(height: 10),

          _buildCalendarAppointment('Karim Uddin', '10:30 AM - 11:00 AM', 'Confirmed', Colors.teal),
          const SizedBox(height: 8),
          _buildCalendarAppointment('Sultana Yasmin', '02:15 PM - 02:45 PM', 'Confirmed', Colors.teal),
          const SizedBox(height: 8),
          _buildCalendarAppointment('Asif Iqbal', '03:30 PM - 04:00 PM', 'Pending', Colors.orange),
          const SizedBox(height: 8),
          _buildCalendarAppointment('Anisur Rahman', '04:15 PM - 04:45 PM', 'Completed', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(String day, String num, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? ClinicalTheme.primaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(day, style: TextStyle(fontSize: 10, color: selected ? Colors.white70 : Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(num, style: TextStyle(fontSize: 13, color: selected ? Colors.white : ClinicalTheme.textDark, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCalendarAppointment(String name, String time, String status, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark)),
        subtitle: Text(time, style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // --- TAB 3: REPORTS LOG ---
  Widget _buildReportsTab() {
    final reportsList = [
      {"name": "Karim Uddin", "bmdc": "BMDC-8421", "date": "Today, 11:30 AM", "type": "Acute Pharyngitis", "prescribed": true},
      {"name": "Asif Iqbal", "bmdc": "BMDC-9840", "date": "02 Jul 2026", "type": "Persistent Bronchitis", "prescribed": true},
      {"name": "Maliha Chowdhury", "bmdc": "BMDC-4210", "date": "01 Jul 2026", "type": "Mild Hyperlipidemia review", "prescribed": true},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search patients or diagnostic files...',
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Past Consultations Histories',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: ClinicalTheme.textDark),
          ),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reportsList.length,
            itemBuilder: (context, idx) {
              final r = reportsList[idx];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  title: Text(r['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark)),
                  subtitle: Text('${r['type']} • ${r['date']}', style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
                  trailing: TextButton(
                    onPressed: () {
                      context.push('/doctor/ehr?patientId=${r['name']}&patientName=${Uri.encodeComponent(r['name'] as String)}');
                    },
                    child: const Text('View EHR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.indigo)),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // --- TAB 4: ACCOUNT PROFILE ---
  Widget _buildAccountTab(BuildContext context, dynamic currentUser, AuthService auth) {
    final docName = currentUser?.name ?? "Sarah Rahman";
    final docSpecialty = currentUser?.specialty ?? "General Physician";
    final docBmdc = currentUser?.bmdcNumber ?? "BMDC/Reg-847291";

    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        // Profile Card header
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.1),
                  child: const Text('👩‍⚕️', style: TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. $docName',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ClinicalTheme.textDark),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        docSpecialty,
                        style: const TextStyle(fontSize: 11, color: ClinicalTheme.primaryBlue, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        docBmdc,
                        style: TextStyle(fontSize: 10.5, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        const Text(
          'Clinical Services & Settings',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
        ),
        const SizedBox(height: 10),

        _buildMenuTile(
          Icons.calendar_month_rounded, 'Availability & Shifts', 'Set daily availability blocks',
          () => context.push('/doctor/availability'),
        ),
        _buildMenuTile(
          Icons.payments_outlined, 'Earnings & Billing', 'Revenue sheets & bar chart',
          () => context.push('/doctor/earnings'),
        ),
        _buildMenuTile(
          Icons.people_outline_rounded, 'Live Waiting Queue', 'Expandable diagnostics queue',
          () => context.push('/doctor/patient-queue'),
        ),
        _buildMenuTile(
          Icons.settings_suggest_rounded, 'Practice Settings', 'Set standard consult fee (৳ 500)',
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fee defaults to ৳ 500 for on-demand consults.')),
            );
          },
        ),
        _buildMenuTile(
          Icons.dynamic_feed_rounded, 'Health Feed', 'Create social posts & connect with patients',
          () => context.push(AppRoutes.healthFeed),
        ),

        const Divider(height: 32, thickness: 1),

        // Logout
        ElevatedButton.icon(
          onPressed: () async {
            await auth.logout();
            context.go(AppRoutes.roleSelection);
          },
          icon: const Icon(Icons.logout_rounded, size: 16, color: Colors.white),
          label: const Text('Sign Out of Workspace'),
          style: ElevatedButton.styleFrom(
            backgroundColor: ClinicalTheme.alertRed,
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        )
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: ClinicalTheme.primaryBlue, size: 20),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
        trailing: const Icon(Icons.chevron_right_rounded, size: 18),
        onTap: onTap,
      ),
    );
  }
}
