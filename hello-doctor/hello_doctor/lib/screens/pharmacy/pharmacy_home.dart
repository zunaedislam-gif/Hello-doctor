import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

// Model for Pharmacy Orders
class PharmacyOrder {
  final String id;
  final String patientName;
  final int age;
  final String sex;
  final List<String> allergies;
  final List<String> medicines;
  String status; // 'Pending', 'Verified', 'Packing', 'Packed', 'Out for Delivery', 'Delivered'
  final String prescriptionId;
  final double subtotal;
  final double deliveryCharge;
  final double total;
  String insuranceRef;
  String paymentType; // 'Cash on Delivery', 'Paid Online'
  bool isPaid;
  final String dateString;

  PharmacyOrder({
    required this.id,
    required this.patientName,
    required this.age,
    required this.sex,
    required this.allergies,
    required this.medicines,
    required this.status,
    required this.prescriptionId,
    required this.subtotal,
    required this.deliveryCharge,
    required this.total,
    this.insuranceRef = '',
    required this.paymentType,
    this.isPaid = false,
    required this.dateString,
  });
}

// Model for Medicine Inventory
class InventoryMedicine {
  final String name;
  final String generic;
  int stock;
  final DateTime expiryDate;
  final double price;
  final int threshold;

  InventoryMedicine({
    required this.name,
    required this.generic,
    required this.stock,
    required this.expiryDate,
    required this.price,
    this.threshold = 15,
  });
}

class PharmacyHome extends StatefulWidget {
  const PharmacyHome({super.key});

  @override
  State<PharmacyHome> createState() => _PharmacyHomeState();
}

class _PharmacyHomeState extends State<PharmacyHome> {
  int _currentIndex = 0;

  // Mock Active Orders
  final List<PharmacyOrder> _orders = [
    PharmacyOrder(
      id: 'ORD-1001',
      patientName: 'Karim Uddin',
      age: 42,
      sex: 'Male',
      allergies: ['Penicillin', 'Sulfa Drugs'],
      medicines: ['Napa 500mg', 'Fexo 120mg', 'Seclo 20mg'],
      status: 'Pending',
      prescriptionId: 'Rx-93821',
      subtotal: 450.0,
      deliveryCharge: 60.0,
      total: 510.0,
      paymentType: 'Cash on Delivery',
      isPaid: false,
      dateString: '2026-07-05',
    ),
    PharmacyOrder(
      id: 'ORD-1002',
      patientName: 'Rahima Begum',
      age: 35,
      sex: 'Female',
      allergies: [],
      medicines: ['Moxacil 500mg', 'Pantix 20mg'],
      status: 'Verified',
      prescriptionId: 'Rx-10492',
      subtotal: 320.0,
      deliveryCharge: 60.0,
      total: 380.0,
      insuranceRef: 'INS-92381-RX',
      paymentType: 'Paid Online',
      isPaid: true,
      dateString: '2026-07-05',
    ),
    PharmacyOrder(
      id: 'ORD-1003',
      patientName: 'Zayan Islam',
      age: 12,
      sex: 'Male',
      allergies: ['Peanuts'],
      medicines: ['Tufnil 80mg', 'Napa 500mg'],
      status: 'Delivered',
      prescriptionId: 'Rx-08492',
      subtotal: 180.0,
      deliveryCharge: 60.0,
      total: 240.0,
      paymentType: 'Cash on Delivery',
      isPaid: true,
      dateString: '2026-07-04',
    ),
  ];

  // Mock Inventory
  final List<InventoryMedicine> _inventory = [
    InventoryMedicine(
      name: 'Napa 500mg',
      generic: 'Paracetamol',
      stock: 120,
      expiryDate: DateTime(2026, 12, 15),
      price: 1.5,
    ),
    InventoryMedicine(
      name: 'Fexo 120mg',
      generic: 'Fexofenadine',
      stock: 8, // Low Stock!
      expiryDate: DateTime(2027, 4, 12),
      price: 8.0,
    ),
    InventoryMedicine(
      name: 'Seclo 20mg',
      generic: 'Omeprazole',
      stock: 240,
      expiryDate: DateTime(2026, 7, 20), // Expiring soon (< 30 days from July 5, 2026)
      price: 5.0,
    ),
    InventoryMedicine(
      name: 'Moxacil 500mg',
      generic: 'Amoxicillin',
      stock: 5, // Low Stock!
      expiryDate: DateTime(2026, 10, 10),
      price: 7.5,
    ),
    InventoryMedicine(
      name: 'Pantix 20mg',
      generic: 'Pantoprazole',
      stock: 95,
      expiryDate: DateTime(2026, 7, 18), // Expiring soon
      price: 7.0,
    ),
    InventoryMedicine(
      name: 'Tufnil 80mg',
      generic: 'Tolfenamic Acid',
      stock: 50,
      expiryDate: DateTime(2028, 1, 15),
      price: 12.0,
    ),
  ];

  // Dummy alternative list for generics
  final Map<String, List<String>> _genericsDict = {
    'Paracetamol': ['Ace 500mg', 'Reset 500mg', 'Fast 500mg'],
    'Fexofenadine': ['Fexoral 120mg', 'Alatrol 120mg', 'Provair 120mg'],
    'Omeprazole': ['Losectil 20mg', 'Omep 20mg', 'Proseptil 20mg'],
    'Amoxicillin': ['G-Amoxin 500mg', 'Fimoxyl 500mg'],
    'Pantoprazole': ['Pantoton 20mg', 'Trupan 20mg'],
    'Tolfenamic Acid': ['Tolfen 80mg', 'Migrex 80mg'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          _getTabTitle(),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: ClinicalTheme.textDark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: ClinicalTheme.alertRed),
            onPressed: () => _handleLogout(context),
            tooltip: 'Log Out',
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: _buildTabContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: ClinicalTheme.primaryBlue,
        unselectedItemColor: ClinicalTheme.textSecondary.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_rounded),
            label: 'Billing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_rounded),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  String _getTabTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Pharmacy Orders';
      case 1:
        return 'Stock Inventory';
      case 2:
        return 'Billing Ledger';
      case 3:
        return 'Revenue Analytics';
      case 4:
        return 'Partner Profile';
      default:
        return 'Pharmacy Portal';
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to sign out from Lazz Pharmacy Portal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final auth = Provider.of<AuthService>(context, listen: false);
              await auth.logout();
              if (context.mounted) {
                context.go(AppRoutes.roleSelection);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: ClinicalTheme.alertRed),
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_currentIndex) {
      case 0:
        return _buildOrdersTab();
      case 1:
        return _buildInventoryTab();
      case 2:
        return _buildBillingTab();
      case 3:
        return _buildAnalyticsTab();
      case 4:
        return _buildAccountTab();
      default:
        return const SizedBox();
    }
  }

  // --- TAB 1: ORDERS ---
  Widget _buildOrdersTab() {
    // Computations for summary metrics
    final pendingOrders = _orders.where((o) => o.status == 'Pending').length;
    final processingOrders = _orders.where((o) => o.status != 'Pending' && o.status != 'Delivered').length;
    final deliveredToday = _orders.where((o) => o.status == 'Delivered').length;
    final double revenueToday = _orders
        .where((o) => o.status == 'Delivered')
        .fold(0.0, (sum, item) => sum + item.total);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row of Summary Metrics Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildSummaryCard(
                'Incoming Orders',
                '$pendingOrders Active',
                Icons.archive_outlined,
                Colors.orange,
              ),
              _buildSummaryCard(
                'Processing',
                '$processingOrders Orders',
                Icons.loop_rounded,
                ClinicalTheme.primaryBlue,
              ),
              _buildSummaryCard(
                'Delivered Today',
                '$deliveredToday Dispatched',
                Icons.check_circle_outline_rounded,
                ClinicalTheme.accentGreen,
              ),
              _buildSummaryCard(
                "Today's Revenue",
                '৳${revenueToday.toStringAsFixed(0)}',
                Icons.payments_outlined,
                Colors.emerald,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              const Text(
                'Incoming Prescription Orders',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: ClinicalTheme.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, py: 4),
                decoration: BoxDecoration(
                  color: ClinicalTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_orders.length} Total',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: ClinicalTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Orders List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _orders.length,
            itemBuilder: (context, index) {
              final order = _orders[index];
              return _buildOrderListItem(order);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.12), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ClinicalTheme.textSecondary.withOpacity(0.8),
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ClinicalTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderListItem(PharmacyOrder order) {
    Color statusColor;
    switch (order.status) {
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Verified':
        statusColor = Colors.purple;
        break;
      case 'Packing':
      case 'Packed':
        statusColor = ClinicalTheme.primaryBlue;
        break;
      case 'Out for Delivery':
        statusColor = Colors.teal;
        break;
      case 'Delivered':
        statusColor = ClinicalTheme.accentGreen;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID, Date and Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Row(
                  children: [
                    Text(
                      order.id,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: ClinicalTheme.textDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.dateString,
                      style: const TextStyle(
                        fontSize: 10,
                        color: ClinicalTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, py: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.extrabold,
                      color: statusColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // Patient details & PDF Thumbnail simulation
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PDF Prescr Thumbnail Mock
                GestureDetector(
                  onTap: () => _openOrderDetail(order),
                  child: Container(
                    width: 50,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade100, width: 1.2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 24),
                        const SizedBox(height: 2),
                        Text(
                          'PRESCRIPTION',
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Patient Name and items list
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.patientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: ClinicalTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Medicines Prescribed:',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: ClinicalTheme.textSecondary.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: order.medicines.map((m) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, py: 2),
                            decoration: BoxDecoration(
                              color: Colors.slate.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              m,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: ClinicalTheme.textDark,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.status == 'Pending') ...[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _orders.removeWhere((o) => o.id == order.id);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Prescription order rejected.'),
                          backgroundColor: ClinicalTheme.alertRed,
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: ClinicalTheme.alertRed,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text('Reject', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        order.status = 'Verified';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Prescription Accepted for packing! Order: ${order.id}'),
                          backgroundColor: ClinicalTheme.accentGreen,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ClinicalTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Accept', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ] else ...[
                  OutlinedButton.icon(
                    onPressed: () => _openOrderDetail(order),
                    icon: const Icon(Icons.remove_red_eye_outlined, size: 14),
                    label: const Text('View Order Details'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ClinicalTheme.primaryBlue.withOpacity(0.5)),
                      foregroundColor: ClinicalTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- ORDER DETAIL SCREEN (Modal Sheet) ---
  void _openOrderDetail(PharmacyOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Allergy warning exists in profile?
            final bool hasAllergies = order.allergies.isNotEmpty;

            // Simple status lists for stepper
            final List<String> statusSteps = ['Pending', 'Verified', 'Packing', 'Packed', 'Out for Delivery', 'Delivered'];
            final int currentStepIndex = statusSteps.indexOf(order.status);

            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: ClinicalTheme.backgroundLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Pull handler
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 8),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        Text(
                          'Order Details (${order.id})',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: ClinicalTheme.textDark,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. ALLERGY WARNING BANNER
                          if (hasAllergies)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                border: Border.all(color: Colors.red.shade200, width: 1.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'CRITICAL ALLERGY WARNING!',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Patient has allergies: ${order.allergies.join(", ")}. Verify medicine suitability before dispatching.',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // 2. PATIENT DETAIL CARD
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.1),
                                  child: const Icon(Icons.person, color: ClinicalTheme.primaryBlue),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.patientName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: ClinicalTheme.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Age: ${order.age} | Sex: ${order.sex} | Rx ID: ${order.prescriptionId}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: ClinicalTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 3. STEPPER
                          const Text(
                            'Order Fulfillment Status',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: ClinicalTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.withOpacity(0.1)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(statusSteps.length, (i) {
                                    final isDone = i <= currentStepIndex;
                                    final isActive = i == currentStepIndex;
                                    return Row(
                                      children: [
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 12,
                                              backgroundColor: isDone
                                                  ? (isActive ? Colors.orange : ClinicalTheme.accentGreen)
                                                  : Colors.grey.shade200,
                                              child: isDone
                                                  ? Icon(
                                                      isActive ? Icons.pending : Icons.check,
                                                      size: 11,
                                                      color: Colors.white,
                                                    )
                                                  : Text(
                                                      '${i + 1}',
                                                      style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                                                    ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              statusSteps[i].split(' ').first,
                                              style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                                                color: isDone ? ClinicalTheme.textDark : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (i < statusSteps.length - 1)
                                          Container(
                                            width: 14,
                                            height: 2,
                                            color: i < currentStepIndex
                                                ? ClinicalTheme.accentGreen
                                                : Colors.grey.shade200,
                                          ),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 4. PACKING CHECKLIST
                          const Text(
                            'Medicine Packing Checklist & Alternatives',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: ClinicalTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: order.medicines.length,
                            itemBuilder: (context, idx) {
                              final med = order.medicines[idx];
                              final genericName = med.contains('Napa')
                                  ? 'Paracetamol'
                                  : med.contains('Fexo')
                                      ? 'Fexofenadine'
                                      : med.contains('Seclo')
                                          ? 'Omeprazole'
                                          : med.contains('Moxacil')
                                              ? 'Amoxicillin'
                                              : med.contains('Pantix')
                                                  ? 'Pantoprazole'
                                                  : 'Tolfenamic Acid';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.withOpacity(0.08)),
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: true, // Mock checked for packing checklist
                                      onChanged: (val) {},
                                      activeColor: ClinicalTheme.accentGreen,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            med,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: ClinicalTheme.textDark,
                                            ),
                                          ),
                                          Text(
                                            'Generic: $genericName',
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: ClinicalTheme.textSecondary.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.swap_horiz_rounded, color: ClinicalTheme.primaryBlue, size: 20),
                                      onPressed: () {
                                        _showAlternativeSuggestions(genericName);
                                      },
                                      tooltip: 'Suggest Generic Brand Alternative',
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // 5. BILLING SECTION SUMMARY
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.withOpacity(0.1)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.between,
                                  children: [
                                    const Text('Subtotal:', style: TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
                                    Text('৳${order.subtotal}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.between,
                                  children: [
                                    const Text('Courier Delivery Charge:', style: TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
                                    Text('৳${order.deliveryCharge}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                if (order.insuranceRef.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.between,
                                    children: [
                                      const Text('Insurance Claim Ref:', style: TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
                                      Text(order.insuranceRef, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue)),
                                    ],
                                  ),
                                ],
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.between,
                                  children: [
                                    const Text('Total Bill:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    Text('৳${order.total}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ClinicalTheme.accentGreen)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 6. BOTTOM ACTION BUTTONS (Status Advance and Chat)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context); // Close sheet
                                    // Peer name encoded, using standard patient chat
                                    context.push('/chat-conversation?threadId=chat-p1&peerId=patient-1&peerName=${Uri.encodeComponent(order.patientName)}&peerRole=Patient');
                                  },
                                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                                  label: const Text('Chat Patient'),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(0, 48),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    foregroundColor: ClinicalTheme.primaryBlue,
                                    side: const BorderSide(color: ClinicalTheme.primaryBlue),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: currentStepIndex == statusSteps.length - 1
                                      ? null
                                      : () {
                                          setState(() {
                                            final nextStep = statusSteps[currentStepIndex + 1];
                                            order.status = nextStep;
                                            if (nextStep == 'Delivered') {
                                              order.isPaid = true;
                                            }
                                          });
                                          // Update modal state so UI updates
                                          setModalState(() {});
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Order Status Advanced to: ${order.status}'),
                                              backgroundColor: ClinicalTheme.accentGreen,
                                            ),
                                          );
                                        },
                                  icon: const Icon(Icons.local_shipping_outlined, size: 16),
                                  label: const Text('Advance Status'),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(0, 48),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    backgroundColor: ClinicalTheme.accentGreen,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAlternativeSuggestions(String genericName) {
    final alternatives = _genericsDict[genericName] ?? ['Substitute Brand Alpha', 'Substitute Brand Beta'];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.swap_horiz_rounded, color: ClinicalTheme.primaryBlue),
            const SizedBox(width: 8),
            Text('Alternatives for $genericName', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'These generic drugs contain the identical chemical formulation and strength:',
              style: TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            ...alternatives.map((alt) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade100, width: 0.8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text(
                        alt,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                      ),
                      const Text(
                        'AVAILABLE',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.extrabold, color: Colors.blue),
                      )
                    ],
                  ),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: INVENTORY ---
  Widget _buildInventoryTab() {
    // Determine low stock items & below threshold alerts
    final lowStockItems = _inventory.where((med) => med.stock < med.threshold).toList();
    final today = DateTime(2026, 7, 5); // Simulated today

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. LOW STOCK ALERTS BANNER
          if (lowStockItems.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber.shade300, width: 1.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'LOW STOCK ALERT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'The following medicines are below threshold limit (15 units): ${lowStockItems.map((i) => "${i.name} (${i.stock} units)").join(", ")}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber.shade800,
                    ),
                  ),
                ],
              ),
            ),

          // Header line and Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              const Text(
                'Medicine Catalog',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: ClinicalTheme.textDark,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddStockDialog,
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Add Stock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ClinicalTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Inventory Table / List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.12), width: 1.2),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _inventory.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _inventory[index];

                // Expiry Check
                final difference = item.expiryDate.difference(today).inDays;
                Color expiryColor;
                String expiryText;
                if (difference <= 0) {
                  expiryColor = ClinicalTheme.alertRed;
                  expiryText = 'EXPIRED!';
                } else if (difference <= 15) {
                  expiryColor = ClinicalTheme.alertRed;
                  expiryText = 'Expiring in $difference days';
                } else if (difference <= 30) {
                  expiryColor = Colors.amber.shade700;
                  expiryText = 'Expiring in $difference days';
                } else {
                  expiryColor = ClinicalTheme.textSecondary;
                  expiryText = 'Expires: ${item.expiryDate.year}-${item.expiryDate.month.toString().padLeft(2, '0')}-${item.expiryDate.day.toString().padLeft(2, '0')}';
                }

                final isLowStock = item.stock < item.threshold;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Row(
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                      ),
                      if (isLowStock) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, py: 1),
                          decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(4)),
                          child: const Text('LOW STOCK', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.amber)),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text('Generic: ${item.generic}', style: const TextStyle(fontSize: 10, color: ClinicalTheme.textSecondary)),
                      const SizedBox(height: 2),
                      Text(
                        expiryText,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: expiryColor),
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${item.stock} Units',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isLowStock ? ClinicalTheme.alertRed : ClinicalTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '৳${item.price.toStringAsFixed(2)} / unit',
                        style: const TextStyle(fontSize: 10, color: ClinicalTheme.textSecondary),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Quick add stock tapped
                    _showEditMedicineStockDialog(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddStockDialog() {
    final nameController = TextEditingController();
    final genericController = TextEditingController();
    final stockController = TextEditingController();
    final priceController = TextEditingController();
    DateTime selectedDate = DateTime(2027, 1, 1);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Stock Entry', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Medicine Name', hintText: 'e.g. Napa 500mg'),
              ),
              TextField(
                controller: genericController,
                decoration: const InputDecoration(labelText: 'Generic Drug Formula', hintText: 'e.g. Paracetamol'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity (Units)'),
              ),
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Price per Unit (৳)'),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  const Text('Expiry Date:', style: TextStyle(fontSize: 12)),
                  TextButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2026, 7, 5),
                        lastDate: DateTime(2032, 1, 1),
                      );
                      if (picked != null) {
                        selectedDate = picked;
                      }
                    },
                    icon: const Icon(Icons.calendar_month_rounded, size: 16),
                    label: Text('${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}'),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty || stockController.text.isEmpty) return;
              setState(() {
                _inventory.add(
                  InventoryMedicine(
                    name: nameController.text,
                    generic: genericController.text.isEmpty ? 'General Formulation' : genericController.text,
                    stock: int.tryParse(stockController.text) ?? 50,
                    expiryDate: selectedDate,
                    price: double.tryParse(priceController.text) ?? 5.0,
                  ),
                );
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Medicine catalog item updated.'), backgroundColor: ClinicalTheme.accentGreen),
              );
            },
            child: const Text('Save Stock'),
          ),
        ],
      ),
    );
  }

  void _showEditMedicineStockDialog(InventoryMedicine item) {
    final qtyController = TextEditingController(text: '${item.stock}');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Stock: ${item.name}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Generic Formulation: ${item.generic}', style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
            const SizedBox(height: 12),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Current On-Hand Stock (Units)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                item.stock = int.tryParse(qtyController.text) ?? item.stock;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Update'),
          )
        ],
      ),
    );
  }

  // --- TAB 3: BILLING ---
  Widget _buildBillingTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        final claimController = TextEditingController(text: order.insuranceRef);

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text(
                      order.id,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: ClinicalTheme.textDark),
                    ),
                    Text(
                      order.status == 'Delivered' ? 'Completed' : 'Pending Fulfillment',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: order.status == 'Delivered' ? ClinicalTheme.accentGreen : Colors.amber.shade700,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                _buildBillingField('Patient Name:', order.patientName),
                const SizedBox(height: 4),
                _buildBillingField('Rx Identity Code:', order.prescriptionId),
                const SizedBox(height: 4),
                _buildBillingField('Subtotal Item Costs:', '৳${order.subtotal}'),
                const SizedBox(height: 4),
                _buildBillingField('Courier Delivery Charge:', '৳${order.deliveryCharge}'),
                const Divider(height: 16),

                // Insurance Claim Code Field
                const Text(
                  'Insurance Claim Code / Reference:',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: TextField(
                          controller: claimController,
                          onChanged: (text) {
                            order.insuranceRef = text;
                          },
                          style: const TextStyle(fontSize: 11, fontFamily: 'JetBrains Mono'),
                          decoration: InputDecoration(
                            hintText: 'e.g. INS-92381-RX',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Insurance claim code verified for ${order.id}.'),
                            backgroundColor: ClinicalTheme.primaryBlue,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ClinicalTheme.primaryBlue,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Verify', style: TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Mark as Paid Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bill Total: ৳${order.total}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                        ),
                        Text(
                          order.paymentType,
                          style: const TextStyle(fontSize: 9, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          order.isPaid ? 'PAID ONLINE' : 'CASH ON DELIV',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: order.isPaid ? ClinicalTheme.accentGreen : Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Switch(
                          value: order.isPaid,
                          onChanged: (value) {
                            setState(() {
                              order.isPaid = value;
                              if (value) {
                                order.paymentType = 'Paid Online';
                              } else {
                                order.paymentType = 'Cash on Delivery';
                              }
                            });
                          },
                          activeColor: ClinicalTheme.accentGreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBillingField(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.between,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ClinicalTheme.textDark)),
      ],
    );
  }

  // --- TAB 4: ANALYTICS ---
  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weekly Income overview
          const Text(
            'Weekly Sales Volume (BDT)',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.12)),
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20000,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(days[value.toInt()], style: const TextStyle(fontSize: 9, color: ClinicalTheme.textSecondary));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        return Text('৳${(value / 1000).toStringAsFixed(0)}k', style: const TextStyle(fontSize: 9, color: ClinicalTheme.textSecondary));
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 12000, color: ClinicalTheme.primaryBlue, width: 14)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 14500, color: ClinicalTheme.primaryBlue, width: 14)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 8000, color: ClinicalTheme.primaryBlue, width: 14)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 16000, color: ClinicalTheme.primaryBlue, width: 14)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 11000, color: ClinicalTheme.primaryBlue, width: 14)]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 18500, color: ClinicalTheme.accentGreen, width: 14)]), // Highest day
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 14500, color: ClinicalTheme.primaryBlue, width: 14)]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Tax Summary & Ledger Details
          const Text(
            'Tax Ledger Summary',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    const Text('Total Weekly Sales:', style: TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
                    const Text('৳94,500.00', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    const Text('Govt drug regulatory TAX/VAT (5%):', style: TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
                    const Text('৳4,725.00', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    const Text('Total Net Earnings:', style: TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
                    const Text('৳89,775.00', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.accentGreen)),
                  ],
                ),
                const Divider(height: 24),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.emerald.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: ClinicalTheme.accentGreen, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Govt tax clearance verified for Q3. No outstanding compliance audits.',
                          style: TextStyle(fontSize: 10, color: ClinicalTheme.accentGreen, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 5: ACCOUNT ---
  Widget _buildAccountTab() {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          CircleAvatar(
            radius: 40,
            backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.1),
            child: const Icon(Icons.local_pharmacy_rounded, size: 40, color: ClinicalTheme.primaryBlue),
          ),
          const SizedBox(height: 14),
          Text(
            user?.name ?? 'Lazz Pharmacy Dhanmondi',
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, py: 3),
            decoration: BoxDecoration(
              color: ClinicalTheme.accentGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'ACTIVE DISPATCH HUB',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: ClinicalTheme.accentGreen, letterSpacing: 1),
            ),
          ),
          const SizedBox(height: 24),

          // Details Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Registry Information',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                ),
                const Divider(height: 20),
                _buildBillingField('Registered Email:', user?.email ?? 'lazz_banani@hellodoctor.com'),
                const SizedBox(height: 8),
                _buildBillingField('Registered Phone:', user?.phone ?? '01912948291'),
                const SizedBox(height: 8),
                _buildBillingField('Trade License number:', user?.tradeLicenseNumber ?? 'TR-9321-BANANI'),
                const SizedBox(height: 8),
                _buildBillingField('Franchise Owner:', user?.ownerName ?? 'Chowdhury Franchise Partner'),
                const SizedBox(height: 8),
                _buildBillingField('Outlet Location:', '${user?.address ?? "Banani Road 11"}, ${user?.city ?? "Dhaka"}'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tip section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100, width: 0.8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: ClinicalTheme.primaryBlue, size: 18),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'As an approved partner hub, your dispatch orders are backed by Hello Doctor service insurance coverage.',
                    style: TextStyle(fontSize: 10, color: ClinicalTheme.primaryBlue, fontWeight: FontWeight.w500),
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
