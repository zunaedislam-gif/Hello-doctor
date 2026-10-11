import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final users = authService.allUsers;

    // Split users into pending vs approved/others
    final pendingUsers = users.where((u) => u.status == AccountStatus.pending).toList();
    final approvedDoctors = users.where((u) => u.role == UserRole.doctor && u.status == AccountStatus.approved).length;
    final approvedPharmacies = users.where((u) => u.role == UserRole.pharmacy && u.status == AccountStatus.approved).length;
    final approvedDiagnostics = users.where((u) => u.role == UserRole.diagnostic && u.status == AccountStatus.approved).length;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.admin_panel_settings, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Super Admin Workspace',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: ClinicalTheme.textDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Sign Out',
            onPressed: () async {
              await authService.logout();
              if (context.mounted) {
                context.go(AppRoutes.roleSelection);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Banner
              _buildWelcomeBanner(authService.currentUser?.name ?? 'Admin'),
              const SizedBox(height: 24),

              // STATISTICS METRICS BENTO GRID
              const Text(
                'Clinical Infrastructure Status',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.count(
                    crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _buildMetricCard(
                        'Pending Approval',
                        pendingUsers.length.toString(),
                        Icons.pending_actions_rounded,
                        const Color(0xfff2994a),
                      ),
                      _buildMetricCard(
                        'Active Doctors',
                        approvedDoctors.toString(),
                        Icons.medication_rounded,
                        ClinicalTheme.primaryBlue,
                      ),
                      _buildMetricCard(
                        'Active Pharmacies',
                        approvedPharmacies.toString(),
                        Icons.storefront_rounded,
                        const Color(0xff27ae60),
                      ),
                      _buildMetricCard(
                        'Active Labs',
                        approvedDiagnostics.toString(),
                        Icons.biotech_rounded,
                        const Color(0xff8e44ad),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // PENDING APPLICATIONS LIST
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  const Text(
                    'Pending Applications Queue',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: pendingUsers.isNotEmpty ? const Color(0xfff2994a).withOpacity(0.12) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${pendingUsers.length} Action Needed',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: pendingUsers.isNotEmpty ? const Color(0xfff2994a) : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (pendingUsers.isEmpty)
                _buildEmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pendingUsers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildPendingUserCard(context, pendingUsers[index], authService);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(String adminName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ClinicalTheme.textDark.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ClinicalTheme.textDark,
            child: Text(adminName[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $adminName',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Super Admin credentials validated. You are viewing live pending registrations database.',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: ClinicalTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String count, IconData icon, Color color) {
    return Card(
      color: Colors.white,
      elevation: 0,
      side: BorderSide(color: Colors.grey.withOpacity(0.12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  count,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: Column(
          children: [
            Icon(Icons.checklist_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              'No Pending Registrations',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'All Doctors, Pharmacies, and Diagnostic Centers are fully vetted and verified at this moment.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: ClinicalTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingUserCard(BuildContext context, UserModel user, AuthService authService) {
    Color roleBadgeColor;
    switch (user.role) {
      case UserRole.doctor:
        roleBadgeColor = ClinicalTheme.primaryBlue;
        break;
      case UserRole.pharmacy:
        roleBadgeColor = const Color(0xfff2994a);
        break;
      case UserRole.diagnostic:
        roleBadgeColor = const Color(0xff8e44ad);
        break;
      default:
        roleBadgeColor = Colors.grey;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of card (Name, Role, Date)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: roleBadgeColor.withOpacity(0.12),
                  child: Text(
                    user.role == UserRole.doctor ? 'Dr' : user.role == UserRole.pharmacy ? 'Ph' : 'Dx',
                    style: TextStyle(color: roleBadgeColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: roleBadgeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              user.role.name.toUpperCase(),
                              style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, color: roleBadgeColor),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.access_time_rounded, size: 12, color: ClinicalTheme.textSecondary),
                          const SizedBox(width: 4),
                          const Text(
                            'Just now',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: ClinicalTheme.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Details section based on Role
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoLine('Email', user.email),
                _buildInfoLine('Phone', user.phone),
                
                // Doctor Details
                if (user.role == UserRole.doctor) ...[
                  _buildInfoLine('BMDC License', user.bmdcNumber ?? 'N/A'),
                  _buildInfoLine('Specialty', user.specialty ?? 'N/A'),
                  _buildInfoLine('Experience', '${user.yearsOfExperience ?? 0} Years'),
                  _buildInfoLine('Consultation Fee', 'BDT ${user.consultationFee ?? 0}'),
                  const SizedBox(height: 10),
                  const Text(
                    'Biography:',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Text(
                      user.bio ?? 'No biography specified.',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: ClinicalTheme.textSecondary, height: 1.4),
                    ),
                  ),
                ],

                // Pharmacy Details
                if (user.role == UserRole.pharmacy) ...[
                  _buildInfoLine('Owner/Manager', user.ownerName ?? 'N/A'),
                  _buildInfoLine('Trade License', user.tradeLicenseNumber ?? 'N/A'),
                  _buildInfoLine('Street Address', user.address ?? 'N/A'),
                  _buildInfoLine('City', user.city ?? 'N/A'),
                ],

                // Diagnostic Details
                if (user.role == UserRole.diagnostic) ...[
                  _buildInfoLine('Contact Person', user.contactPerson ?? 'N/A'),
                  _buildInfoLine('DGHS License', user.licenseNumber ?? 'N/A'),
                  _buildInfoLine('Centre Address', user.address ?? 'N/A'),
                  _buildInfoLine('City', user.city ?? 'N/A'),
                ],

                const SizedBox(height: 12),

                // Documents section
                if (user.licenseDocPath != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.attachment_rounded, size: 16, color: ClinicalTheme.primaryBlue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'File Attached: ${user.licenseDocPath!.split('/').last}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: ClinicalTheme.primaryBlue,
                            decoration: TextDecoration.underline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Show document preview popup
                          _showDocumentPreview(context, user);
                        },
                        icon: const Icon(Icons.visibility_outlined, size: 12),
                        label: const Text('View Document'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: Size.zero,
                          textStyle: const TextStyle(fontSize: 10, fontFamily: 'Inter'),
                          side: const BorderSide(color: ClinicalTheme.primaryBlue),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),

          // Approval & Reject Actions footer
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showRejectConfirmation(context, user, authService);
                    },
                    icon: const Icon(Icons.cancel_outlined, size: 16),
                    label: const Text('Reject & Deny'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ClinicalTheme.alertRed,
                      side: const BorderSide(color: ClinicalTheme.alertRed),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await authService.approveUser(user.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${user.name} approved successfully! User can now access their active dashboard.'),
                            backgroundColor: ClinicalTheme.accentGreen,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.verified_user_rounded, size: 16),
                    label: const Text('Approve Partner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ClinicalTheme.accentGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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

  Widget _buildInfoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: ClinicalTheme.textDark),
            ),
          ),
        ],
      ),
    );
  }

  void _showDocumentPreview(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${user.name} License Document', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  const Icon(Icons.document_scanner_rounded, size: 54, color: ClinicalTheme.textSecondary),
                  const SizedBox(height: 12),
                  Text(
                    user.licenseDocPath!.split('/').last,
                    style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Mock Certification Verification Link Active',
                    style: TextStyle(fontFamily: 'Inter', color: ClinicalTheme.accentGreen, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Government Database Verification matches BMDC / Trade license records. All metadata checks out OK.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: ClinicalTheme.textSecondary, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRejectConfirmation(BuildContext context, UserModel user, AuthService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Application', style: TextStyle(fontFamily: 'Poppins')),
        content: Text('Are you sure you want to deny and delete the registration for ${user.name}? This action is irreversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: ClinicalTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authService.rejectOrDeleteUser(user.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Application rejected and deleted from clinical queue.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: ClinicalTheme.alertRed),
            child: const Text('Confirm Reject'),
          ),
        ],
      ),
    );
  }
}
