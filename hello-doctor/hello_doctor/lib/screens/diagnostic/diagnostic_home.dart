import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

// ----------------------------------------------------
// Diagnostic Lab Order Model
// ----------------------------------------------------
class LabOrder {
  final String id;
  final String patientName;
  final String patientPhone;
  final int age;
  final String sex;
  final List<String> tests;
  final String location; // 'Home Collection' or 'In-Lab'
  final String address;
  String status; // 'Pending', 'Sample Collected', 'Processing', 'Report Ready', 'Delivered'
  DateTime? scheduledTime;
  String? assignedStaff;
  String? sampleId;
  String? reportFile; // Mock file path
  String? verifiedBy;
  final double testPrice;
  final double collectionFee;
  final double total;
  final String paymentType; // 'bKash', 'Cash on Delivery', 'Card'
  bool isPaid;
  final String branch;
  final String dateString;

  LabOrder({
    required this.id,
    required this.patientName,
    required this.patientPhone,
    required this.age,
    required this.sex,
    required this.tests,
    required this.location,
    required this.address,
    required this.status,
    this.scheduledTime,
    this.assignedStaff,
    this.sampleId,
    this.reportFile,
    this.verifiedBy,
    required this.testPrice,
    required this.collectionFee,
    required this.total,
    required this.paymentType,
    required this.isPaid,
    required this.branch,
    required this.dateString,
  });
}

// ----------------------------------------------------
// Dummy Staff for Assignment
// ----------------------------------------------------
const List<String> kPhlebotomyStaff = [
  'Ripon Sarker (Senior Phlebotomist)',
  'Farhana Chowdhury (Lab Executive)',
  'Sumon Ahmed (Phlebotomist)',
  'Sultana Kamal (Home Care Assistant)',
];

// ----------------------------------------------------
// Dummy Pathologists for Digital Signatures
// ----------------------------------------------------
const List<String> kPathologists = [
  'Prof. Dr. Rafiqul Alam, MD (Pathology)',
  'Dr. Nusrat Jahan, M.Phil (Microbiology)',
  'Dr. Tanvir Hossain, DCP (Clinical Pathology)',
];

class DiagnosticHome extends StatefulWidget {
  const DiagnosticHome({super.key});

  @override
  State<DiagnosticHome> createState() => _DiagnosticHomeState();
}

class _DiagnosticHomeState extends State<DiagnosticHome> {
  int _currentTab = 0; // Bottom Navigation: 0=Orders, 1=Schedule, 2=Reports, 3=Account
  String _selectedBranch = 'Main Branch';
  final List<String> _branches = ['Main Branch', 'Dhanmondi Branch', 'Uttara Branch'];

  // List of active lab orders (Simulated in-memory database)
  final List<LabOrder> _labOrders = [
    LabOrder(
      id: 'LAB-1021',
      patientName: 'Karim Uddin',
      patientPhone: '01711223344',
      age: 42,
      sex: 'Male',
      tests: ['Complete Blood Count (CBC)', 'Fasting Blood Sugar (FBS)'],
      location: 'Home Collection',
      address: 'House 42, Road 11, Dhanmondi, Dhaka',
      status: 'Pending',
      testPrice: 1200.0,
      collectionFee: 150.0,
      total: 1350.0,
      paymentType: 'bKash',
      isPaid: true,
      branch: 'Dhanmondi Branch',
      dateString: '2026-07-05',
    ),
    LabOrder(
      id: 'LAB-1022',
      patientName: 'Nusrat Jahan',
      patientPhone: '01819887766',
      age: 29,
      sex: 'Female',
      tests: ['Thyroid Panel (T3, T4, TSH)'],
      location: 'In-Lab',
      address: 'N/A (Walk-in)',
      status: 'Pending',
      testPrice: 1500.0,
      collectionFee: 0.0,
      total: 1500.0,
      paymentType: 'Card',
      isPaid: true,
      branch: 'Main Branch',
      dateString: '2026-07-05',
    ),
    LabOrder(
      id: 'LAB-1023',
      patientName: 'Kazi Rayhan',
      patientPhone: '01511224466',
      age: 63,
      sex: 'Male',
      tests: ['Lipid Profile', 'Serum Creatinine', 'ECG'],
      location: 'Home Collection',
      address: 'House 19, Sector 4, Uttara, Dhaka',
      status: 'Sample Collected',
      scheduledTime: DateTime(2026, 7, 5, 8, 30),
      assignedStaff: 'Ripon Sarker (Senior Phlebotomist)',
      sampleId: 'SMP-9302-H',
      testPrice: 2800.0,
      collectionFee: 150.0,
      total: 2950.0,
      paymentType: 'Cash on Delivery',
      isPaid: false,
      branch: 'Uttara Branch',
      dateString: '2026-07-05',
    ),
    LabOrder(
      id: 'LAB-1024',
      patientName: 'Fariha Rahman',
      patientPhone: '01611776655',
      age: 31,
      sex: 'Female',
      tests: ['HBA1C Diabetes Screening'],
      location: 'Home Collection',
      address: 'Lane 2, Mirpur 10, Dhaka',
      status: 'Processing',
      scheduledTime: DateTime(2026, 7, 5, 9, 15),
      assignedStaff: 'Sumon Ahmed (Phlebotomist)',
      sampleId: 'SMP-1049-H',
      testPrice: 900.0,
      collectionFee: 150.0,
      total: 1050.0,
      paymentType: 'bKash',
      isPaid: true,
      branch: 'Main Branch',
      dateString: '2026-07-05',
    ),
    LabOrder(
      id: 'LAB-1025',
      patientName: 'Anwar Hossain',
      patientPhone: '01911335577',
      age: 55,
      sex: 'Male',
      tests: ['Liver Function Test (LFT)', 'Urine R/E'],
      location: 'In-Lab',
      address: 'N/A (Walk-in)',
      status: 'Report Ready',
      sampleId: 'SMP-0829-L',
      reportFile: 'LFT_REPORT_1025.pdf',
      verifiedBy: 'Prof. Dr. Rafiqul Alam, MD (Pathology)',
      testPrice: 2200.0,
      collectionFee: 0.0,
      total: 2200.0,
      paymentType: 'Card',
      isPaid: true,
      branch: 'Main Branch',
      dateString: '2026-07-04',
    ),
  ];

  // Quick Stats computation
  int get _countIncoming => _filteredOrders.where((o) => o.status == 'Pending').length;
  int get _countScheduled => _filteredOrders.where((o) => o.status == 'Sample Collected' || o.scheduledTime != null).length;
  int get _countPendingUpload => _filteredOrders.where((o) => o.status == 'Processing').length;
  double get _todayRevenue => _filteredOrders.where((o) => o.isPaid).fold(0.0, (sum, o) => sum + o.total);

  // Filter orders by active branch selector
  List<LabOrder> get _filteredOrders {
    return _labOrders.where((o) => o.branch == _selectedBranch).toList();
  }

  // Local notifications trigger simulator
  void _triggerLocalNotification(String title, String body) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ClinicalTheme.primaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(Icons.notifications_active_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Poppins')),
                  Text(body, style: const TextStyle(fontSize: 11, fontFamily: 'Inter')),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final currentLab = authService.currentUser;

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentLab?.name ?? 'Popular Diagnostics',
              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: ClinicalTheme.textDark),
            ),
            const Text(
              'Diagnostic Partner Dashboard',
              style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: ClinicalTheme.textSecondary),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ClinicalTheme.textDark),
          onPressed: () => context.go(AppRoutes.roleSelection),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          // Branch selector dropdown
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple.shade100, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBranch,
                dropdownColor: Colors.white,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.purple),
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple),
                items: _branches.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedBranch = val;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _buildActiveTabContent(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple,
        unselectedItemColor: ClinicalTheme.textSecondary.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month_rounded),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description_rounded),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_outlined),
            activeIcon: Icon(Icons.business_center_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  // Router for bottom navigation tabs
  Widget _buildActiveTabContent() {
    switch (_currentTab) {
      case 0:
        return _buildOrdersTab();
      case 1:
        return _buildScheduleTab();
      case 2:
        return _buildReportsTab();
      case 3:
        return _buildAccountTab();
      default:
        return _buildOrdersTab();
    }
  }

  // ----------------------------------------------------
  // TAB 1: ORDERS DASHBOARD
  // ----------------------------------------------------
  Widget _buildOrdersTab() {
    return Column(
      children: [
        // Grid Summary Cards
        _buildStatsGrid(),
        
        // Tab header
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Incoming Lab Bookings (${_filteredOrders.where((o) => o.status == 'Pending').length})',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
              ),
              Text(
                _selectedBranch,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple),
              )
            ],
          ),
        ),

        // List of Orders
        Expanded(
          child: _filteredOrders.isEmpty
              ? _buildEmptyState('No lab orders for this branch yet.')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = _filteredOrders[index];
                    return _buildOrderCard(order);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: Colors.white,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
        children: [
          _buildStatCard('Incoming Orders', '$_countIncoming', Icons.biotech_rounded, Colors.purple),
          _buildStatCard('Schedules Set', '$_countScheduled', Icons.motorcycle_rounded, Colors.blue),
          _buildStatCard('Pending Uploads', '$_countPendingUpload', Icons.upload_file_rounded, Colors.orange),
          _buildStatCard("Today's Revenue", '৳ ${_todayRevenue.toStringAsFixed(0)}', Icons.payments_rounded, Colors.emerald),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.12), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ClinicalTheme.textSecondary, fontFamily: 'Inter')),
              Icon(icon, size: 18, color: color),
            ],
          ),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color, fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  Widget _buildOrderCard(LabOrder order) {
    bool isPending = order.status == 'Pending';
    Color statusColor = _getStatusColor(order.status);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.15)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showOrderDetailsSheet(order),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order ID & status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.id,
                    style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.primaryBlue),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, py: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor, fontFamily: 'Inter'),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              
              // Patient profile
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.purple.shade50,
                    radius: 18,
                    child: Text(
                      order.patientName[0],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.patientName,
                          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${order.sex}, ${order.age} years • ${order.patientPhone}',
                          style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Test Packages Requested
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TESTS REQUESTED:', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary, letterSpacing: 0.8)),
                    const SizedBox(height: 4),
                    Text(
                      order.tests.join(', '),
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: ClinicalTheme.textDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Location badge
              Row(
                children: [
                  Icon(
                    order.location == 'Home Collection' ? Icons.home_work_outlined : Icons.biotech_outlined,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${order.location} request',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _showOrderDetailsSheet(order),
                    child: const Text('View Ledger & Steps', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple)),
                  ),
                  const SizedBox(width: 8),
                  if (isPending)
                    ElevatedButton.icon(
                      onPressed: () => _showScheduleCollectionDialog(order),
                      icon: const Icon(Icons.alarm_add_rounded, size: 14),
                      label: const Text('Schedule Collection'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () => _showOrderDetailsSheet(order),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                      label: const Text('Manage Stepper'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade50,
                        foregroundColor: Colors.purple,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper colors
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.red.shade600;
      case 'Sample Collected':
        return Colors.blue.shade600;
      case 'Processing':
        return Colors.orange.shade600;
      case 'Report Ready':
        return Colors.purple.shade600;
      case 'Delivered':
        return Colors.emerald.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  // ----------------------------------------------------
  // TAB 2: SCHEDULES OVERVIEW
  // ----------------------------------------------------
  Widget _buildScheduleTab() {
    final scheduledOrders = _filteredOrders.where((o) => o.scheduledTime != null).toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Phlebotomy Collection Schedule',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                'Home pickups coordinated for $_selectedBranch',
                style: const TextStyle(fontSize: 12, color: ClinicalTheme.textSecondary),
              ),
            ],
          ),
        ),
        Expanded(
          child: scheduledOrders.isEmpty
              ? _buildEmptyState('No phlebotomy pickups scheduled today.')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: scheduledOrders.length,
                  itemBuilder: (context, index) {
                    final order = scheduledOrders[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: Colors.grey.withOpacity(0.12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.id,
                                  style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, py: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    order.status,
                                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blue, fontFamily: 'Inter'),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 16, color: ClinicalTheme.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  order.patientName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on_outlined, size: 16, color: ClinicalTheme.textSecondary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    order.address,
                                    style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('SCHEDULED PICKUP:', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.purple)),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${order.scheduledTime!.hour.toString().padLeft(2, '0')}:${order.scheduledTime!.minute.toString().padLeft(2, '0')} • ${order.scheduledTime!.day}/${order.scheduledTime!.month}',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('ASSIGNED STAFF:', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.purple)),
                                      const SizedBox(height: 2),
                                      Text(
                                        order.assignedStaff!.split(' ')[0],
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Sample tracking QR preview trigger
                                InkWell(
                                  onTap: () => _showSampleTrackingQRDialog(order),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.qr_code_2_rounded, size: 18, color: Colors.purple),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Barcode ID: ${order.sampleId ?? "Pending"}',
                                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.purple, decoration: TextDecoration.underline),
                                      ),
                                    ],
                                  ),
                                ),
                                if (order.status == 'Pending')
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        order.status = 'Sample Collected';
                                      });
                                      _triggerLocalNotification('Sample Collected', 'Sample ${order.sampleId} has been successfully secured and registered.');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(100, 32),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Mark Collected', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ----------------------------------------------------
  // TAB 3: REPORTS UPLOADING & DIGISIG
  // ----------------------------------------------------
  Widget _buildReportsTab() {
    final readyForReportOrders = _filteredOrders.where((o) => o.status == 'Processing' || o.status == 'Report Ready').toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reports Verification Console',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                'Upload digital results and sign with pathlogist credentials',
                style: const TextStyle(fontSize: 12, color: ClinicalTheme.textSecondary),
              ),
            ],
          ),
        ),
        Expanded(
          child: readyForReportOrders.isEmpty
              ? _buildEmptyState('No orders pending report operations.')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: readyForReportOrders.length,
                  itemBuilder: (context, index) {
                    final order = readyForReportOrders[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: Colors.grey.withOpacity(0.12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.id,
                                  style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, py: 3),
                                  decoration: BoxDecoration(
                                    color: order.status == 'Report Ready' ? Colors.purple.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    order.status,
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: order.status == 'Report Ready' ? Colors.purple : Colors.orange, fontFamily: 'Inter'),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            Text(
                              order.patientName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark, fontFamily: 'Poppins'),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Tests: ${order.tests.join(', ')}',
                              style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary),
                            ),
                            const SizedBox(height: 12),
                            if (order.status == 'Processing') ...[
                              ElevatedButton.icon(
                                onPressed: () => _showReportUploadDialog(order),
                                icon: const Icon(Icons.upload_rounded, size: 14),
                                label: const Text('Compile Report & Sign'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 38),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.purple.shade50.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    const Icon(Icons.verified_user_rounded, color: Colors.purple, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('DIGITALLY SIGNED BY:', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.purple)),
                                          const SizedBox(height: 2),
                                          Text(
                                            order.verifiedBy ?? 'Verified Pathologist',
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _simulateReportDownload(order),
                                      icon: const Icon(Icons.download_rounded, size: 14),
                                      label: const Text('Download PDF'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.purple,
                                        side: const BorderSide(color: Colors.purple),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          order.status = 'Delivered';
                                        });
                                        _triggerLocalNotification('Report Shared', 'Medical certificate successfully dispatched to ${order.patientName}\'s digital portal.');
                                      },
                                      icon: const Icon(Icons.send_rounded, size: 14),
                                      label: const Text('Dispatch Portal'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ----------------------------------------------------
  // TAB 4: ACCOUNT MANAGEMENT
  // ----------------------------------------------------
  Widget _buildAccountTab() {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Banner Info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.12)),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.biotech_rounded, size: 36, color: Colors.white),
                ),
                const SizedBox(height: 14),
                Text(
                  user?.name ?? 'Popular Pathology Lab Ltd.',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${user?.id ?? "DIAG-83921"} • APPROVED PARTNER',
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple, letterSpacing: 0.8),
                ),
                const Divider(height: 24),
                _buildAccountDetailRow('License ID:', user?.licenseNumber ?? 'DGHS-LIC-2026-9281'),
                _buildAccountDetailRow('Registered Email:', user?.email ?? 'info@popularlab.com'),
                _buildAccountDetailRow('Contact Person:', user?.contactPerson ?? 'Sayed Ahmed'),
                _buildAccountDetailRow('City Branch:', user?.city ?? 'Dhaka'),
                _buildAccountDetailRow('Primary Office:', user?.address ?? 'House 14, Road 2, Dhanmondi, Dhaka'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Portal navigation helper
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.withOpacity(0.12)),
            ),
            child: Column(
              children: [
                _buildMenuTile(Icons.medical_information_rounded, 'My Lab Results (Patient Mock)', () {
                  // Push a visual mock of what patient sees
                  _showPatientLabResultsMock();
                }),
                const Divider(height: 1),
                _buildMenuTile(Icons.logout_rounded, 'Logout Session', () async {
                  await authService.logout();
                  if (context.mounted) {
                    context.go(AppRoutes.roleSelection);
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: ClinicalTheme.textSecondary, fontFamily: 'Inter')),
          Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ClinicalTheme.textDark, fontFamily: 'Inter')),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12.5, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      onTap: onTap,
    );
  }

  // ----------------------------------------------------
  // DIALOGS & OVERLAY SHEETS
  // ----------------------------------------------------

  // Detail Ledger Sheet
  void _showOrderDetailsSheet(LabOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Color statusColor = _getStatusColor(order.status);
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Dragger bar
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                  ),
                  
                  // Title bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Ledger: ${order.id}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                  ),
                  const Divider(),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Stepper
                          const Text('DIAGNOSTIC TRACKING STEPPER:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary, letterSpacing: 0.8)),
                          const SizedBox(height: 12),
                          _buildStepperView(order.status),
                          const SizedBox(height: 24),

                          // Ledger details
                          const Text('BILLING LEDGER & PRICING:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary, letterSpacing: 0.8)),
                          const SizedBox(height: 8),
                          Card(
                            elevation: 0,
                            color: Colors.grey.shade50,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                children: [
                                  _buildBillingLine('Lab Test Package price:', '৳ ${order.testPrice.toStringAsFixed(2)}'),
                                  _buildBillingLine('Home Phlebotomy Surcharge:', '৳ ${order.collectionFee.toStringAsFixed(2)}'),
                                  const Divider(height: 20),
                                  _buildBillingLine('TOTAL BILLING AMOUNT:', '৳ ${order.total.toStringAsFixed(2)}', isBold: true),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Payment status:', style: TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, py: 3),
                                        decoration: BoxDecoration(
                                          color: order.isPaid ? Colors.emerald.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          order.isPaid ? 'PAID via ${order.paymentType}' : 'UNPAID (${order.paymentType})',
                                          style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: order.isPaid ? Colors.emerald : Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Contact details & messaging
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Simulated chat navigation
                                    context.push('/chat-conversation?threadId=T_LAB_${order.id}&peerId=P_${order.patientName}&peerName=${Uri.encodeComponent(order.patientName)}&peerRole=patient');
                                  },
                                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                                  label: const Text('Message Patient'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ClinicalTheme.primaryBlue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Status actions
                          const Text('ADVANCE DIAGNOSTIC STATUS:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary, letterSpacing: 0.8)),
                          const SizedBox(height: 8),
                          if (order.status == 'Pending') ...[
                            ElevatedButton(
                              onPressed: () {
                                setSheetState(() {
                                  order.status = 'Sample Collected';
                                  order.sampleId = 'SMP-${order.id.split('-')[1]}-H';
                                });
                                setState(() {});
                                _triggerLocalNotification('Status Advanced', 'Order ${order.id} is now registered as Sample Collected.');
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 44)),
                              child: const Text('Advance to "Sample Collected"'),
                            ),
                          ] else if (order.status == 'Sample Collected') ...[
                            ElevatedButton(
                              onPressed: () {
                                setSheetState(() {
                                  order.status = 'Processing';
                                });
                                setState(() {});
                                _triggerLocalNotification('Status Advanced', 'Order ${order.id} sample loaded into clinical processors.');
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 44)),
                              child: const Text('Advance to "Processing (In-Lab)"'),
                            ),
                          ] else if (order.status == 'Processing') ...[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _showReportUploadDialog(order);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 44)),
                              child: const Text('Compile Report & Digital Stamp'),
                            ),
                          ] else if (order.status == 'Report Ready') ...[
                            ElevatedButton(
                              onPressed: () {
                                setSheetState(() {
                                  order.status = 'Delivered';
                                });
                                setState(() {});
                                _triggerLocalNotification('Dispatched', 'Digital pathology certificate successfully dispatched.');
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.emerald, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 44)),
                              child: const Text('Dispatch / Deliver Report'),
                            ),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(color: Colors.emerald.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                child: Text(
                                  '✓ Order Complete & Report Dispatched.',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.emerald, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            };
          }
        );
      },
    );
  }

  Widget _buildBillingLine(String label, String val, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isBold ? 11.5 : 11, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: isBold ? ClinicalTheme.textDark : ClinicalTheme.textSecondary)),
          Text(val, style: TextStyle(fontSize: isBold ? 12.5 : 11, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: isBold ? Colors.purple : ClinicalTheme.textDark)),
        ],
      ),
    );
  }

  Widget _buildStepperView(String currentStatus) {
    final steps = ['Pending', 'Sample Collected', 'Processing', 'Report Ready', 'Delivered'];
    int currentIndex = steps.indexOf(currentStatus);

    return Column(
      children: List.generate(steps.length, (index) {
        bool isDone = index < currentIndex;
        bool isCurrent = index == currentIndex;
        Color circleColor = isDone ? Colors.emerald : (isCurrent ? Colors.purple : Colors.grey.shade300);
        IconData stepIcon = isDone ? Icons.check_circle : (isCurrent ? Icons.radio_button_checked : Icons.circle_outlined);

        return IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  Icon(stepIcon, color: circleColor, size: 18),
                  if (index != steps.length - 1)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: index < currentIndex ? Colors.emerald : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                          color: isCurrent ? Colors.purple : (isDone ? ClinicalTheme.textDark : ClinicalTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Schedule pickup dialog
  void _showScheduleCollectionDialog(LabOrder order) {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 30);
    String selectedStaff = kPhlebotomyStaff[0];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('Schedule Phlebotomy: ${order.id}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SELECT DATE & TIME:', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final d = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 14)),
                              );
                              if (d != null) {
                                setDlgState(() => selectedDate = d);
                              }
                            },
                            icon: const Icon(Icons.calendar_today, size: 14),
                            label: Text('${selectedDate.day}/${selectedDate.month}', style: const TextStyle(fontSize: 11)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final t = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              if (t != null) {
                                setDlgState(() => selectedTime = t);
                              }
                            },
                            icon: const Icon(Icons.access_time, size: 14),
                            label: Text(selectedTime.format(context), style: const TextStyle(fontSize: 11)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text('ASSIGN FIELD STAFF:', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedStaff,
                          isExpanded: true,
                          style: const TextStyle(fontSize: 11.5, color: ClinicalTheme.textDark),
                          items: kPhlebotomyStaff.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDlgState(() => selectedStaff = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      order.status = 'Sample Collected';
                      order.scheduledTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
                      order.assignedStaff = selectedStaff;
                      order.sampleId = 'SMP-${order.id.split('-')[1]}-H';
                    });
                    Navigator.pop(context);
                    _triggerLocalNotification(
                      'Collection Coordinated',
                      'Phlebotomist assigned. Tracking ID: ${order.sampleId}',
                    );
                    _showSampleTrackingQRDialog(order);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  child: const Text('Register & QR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Display Generated QR Code for tracking
  void _showSampleTrackingQRDialog(LabOrder order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.purple.shade50, shape: BoxShape.circle),
                child: const Icon(Icons.qr_code_scanner_rounded, size: 40, color: Colors.purple),
              ),
              const SizedBox(height: 14),
              const Text(
                'Phlebotomy Sample Tracking Barcode',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Sample ID: ${order.sampleId ?? "SMP-Pending"}',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
              const SizedBox(height: 20),
              
              // Custom painted barcode/QR grid to avoid strict dependency crashes on compile
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: CustomPaint(
                  painter: MockBarcodePainter(order.sampleId ?? 'SAMPLE-DUMMY'),
                ),
              ),
              
              const SizedBox(height: 12),
              const Text(
                'Affix printed sticker onto the EDTA blood collection tube and vacuum container.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: ClinicalTheme.textSecondary, height: 1.4),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close Workspace', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Report upload dialog with digital signatures
  void _showReportUploadDialog(LabOrder order) {
    String selectedPathologist = kPathologists[0];
    String findingsValue = 'Normal physiological counts observed. Platelet parameters and WBC sub-populations are within clinical tolerance indices.';
    bool isDigitallySigned = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setUploadState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('Compile Report: ${order.id}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CHOOSE REPORT PDF/IMAGE:', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary)),
                    const SizedBox(height: 6),
                    OutlinedButton.icon(
                      onPressed: () {
                        _triggerLocalNotification('File Picked', 'CBC_LabResult_Attached.pdf attached successfully.');
                      },
                      icon: const Icon(Icons.attach_file, size: 14),
                      label: const Text('CBC_Attached.pdf (620 KB)', style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 38)),
                    ),
                    const SizedBox(height: 16),

                    const Text('PATHOLOGY FINDINGS SUMMARY:', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: TextEditingController(text: findingsValue),
                      maxLines: 2,
                      style: const TextStyle(fontSize: 11.5),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                      onChanged: (val) => findingsValue = val,
                    ),
                    const SizedBox(height: 16),

                    const Text('AUTHORIZED PATHOLOGIST:', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedPathologist,
                          isExpanded: true,
                          style: const TextStyle(fontSize: 11.5, color: ClinicalTheme.textDark),
                          items: kPathologists.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setUploadState(() => selectedPathologist = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Checkbox(
                          value: isDigitallySigned,
                          activeColor: Colors.purple,
                          onChanged: (val) {
                            if (val != null) {
                              setUploadState(() => isDigitallySigned = val);
                            }
                          },
                        ),
                        const Expanded(
                          child: Text(
                            'Apply authorized Pathology digital signature & clinic stamp',
                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.purple),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      order.status = 'Report Ready';
                      order.verifiedBy = selectedPathologist;
                      order.reportFile = 'VERIFIED_REPORT_${order.id}.pdf';
                    });
                    Navigator.pop(context);
                    _triggerLocalNotification(
                      'Report Digitally Signed',
                      'Combined report PDF successfully generated on center letterhead.',
                    );
                    _simulateReportDownload(order);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  child: const Text('Sign & Generate PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Simulate PDF download/preview on center letterhead
  void _simulateReportDownload(LabOrder order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Letterhead
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('POPULAR LABS LTD.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple)),
                        Text('Dhanmondi Central Hub, Dhaka', style: TextStyle(fontSize: 8, color: ClinicalTheme.textSecondary)),
                      ],
                    ),
                    Icon(Icons.biotech, color: Colors.purple.shade300, size: 24),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text('CLINICAL TEST REPORT CERTIFICATE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark), textAlign: TextAlign.center),
              const Divider(),
              _buildReportDetailRow('Patient Name:', order.patientName),
              _buildReportDetailRow('Age / Gender:', '${order.age} Y / ${order.sex}'),
              _buildReportDetailRow('Sample Code:', order.sampleId ?? 'SMP-WALKIN'),
              _buildReportDetailRow('Tests:', order.tests.join(', ')),
              _buildReportDetailRow('Status:', 'CLINICALLY VERIFIED'),
              const Divider(),
              const Text('FINDINGS ANALYSIS:', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary)),
              const SizedBox(height: 4),
              const Text(
                'All hematology parameters represent normal homeostatic indicators. Metabolic indicators verify standard insulin response tolerances.',
                style: TextStyle(fontSize: 9.5, fontStyle: FontStyle.italic, color: ClinicalTheme.textDark),
              ),
              const SizedBox(height: 14),
              // Verified Stamp/Signature placeholder
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, py: 2),
                        decoration: BoxDecoration(border: Border.all(color: Colors.purple, width: 1.5), borderRadius: BorderRadius.circular(4)),
                        child: const Text('DIGITALLY SIGNED', style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.purple)),
                      ),
                      const SizedBox(height: 4),
                      Text(order.verifiedBy?.split(',')[0] ?? 'Authorized Pathologist', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                      const Text('DGHS Certificate Active', style: TextStyle(fontSize: 7, color: ClinicalTheme.textSecondary)),
                    ],
                  )
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _triggerLocalNotification('Download Complete', '${order.reportFile} downloaded to local storage.');
              },
              icon: const Icon(Icons.download, size: 14),
              label: const Text('Save PDF Document'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
          ],
        );
      },
    );
  }

  void _buildReportDetailRow(String label, String value) {
    // simple local inline widget helper
  }

  // Visual simulation of Patient-facing "My Lab Results"
  void _showPatientLabResultsMock() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.biotech_rounded, color: Colors.purple),
                    SizedBox(width: 10),
                    Text('My Lab Results (Patient Portal View)', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _labOrders.length,
                  itemBuilder: (context, index) {
                    final order = _labOrders[index];
                    Color statusColor = _getStatusColor(order.status);
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                      child: ListTile(
                        title: Text(order.tests.join(', '), style: const TextStyle(fontFamily: 'Poppins', fontSize: 12.5, fontWeight: FontWeight.bold)),
                        subtitle: Text('Ordered from ${order.branch} • ${order.dateString}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, py: 3),
                              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                              child: Text(order.status, style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: statusColor)),
                            ),
                            const SizedBox(height: 4),
                            if (order.status == 'Report Ready' || order.status == 'Delivered')
                              const Text('Tap to View Report', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.purple, decoration: TextDecoration.underline))
                          ],
                        ),
                        onTap: () {
                          if (order.status == 'Report Ready' || order.status == 'Delivered') {
                            _simulateReportDownload(order);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sample is currently: ${order.status}. Report will be shared once pathologically verified.')),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // General empty state visual
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty_rounded, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(fontSize: 12, color: ClinicalTheme.textSecondary)),
        ],
      ),
    );
  }
}

Widget _buildReportDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: ClinicalTheme.textSecondary)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark), textAlign: TextAlign.end)),
      ],
    ),
  );
}

// ----------------------------------------------------
// Custom Mock Barcode Painter
// ----------------------------------------------------
class MockBarcodePainter extends CustomPainter {
  final String content;
  MockBarcodePainter(this.content);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // Draw barcode lookalike (stripes of varying spacing)
    double currentX = 10.0;
    int step = 0;
    while (currentX < size.width - 10) {
      double width = (step % 3 == 0) ? 4.0 : ((step % 2 == 0) ? 2.0 : 1.0);
      canvas.drawRect(
        Rect.fromLTWH(currentX, 10, width, size.height - 40),
        paint,
      );
      currentX += width + ((step % 4 == 0) ? 5.0 : 2.0);
      step++;
    }

    // Draw simulated QR anchors in bottom corners
    final anchorPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(Rect.fromLTWH(size.width - 25, size.height - 25, 15, 15), anchorPaint);
    canvas.drawRect(Rect.fromLTWH(size.width - 20, size.height - 20, 5, 5), Paint()..color = Colors.purple);

    // Draw alphanumeric text
    const textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: content,
      style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, size.height - 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
