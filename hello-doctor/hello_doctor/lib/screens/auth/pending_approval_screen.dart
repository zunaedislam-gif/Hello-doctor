import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xfff2994a).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.pending_actions_rounded,
                    size: 80,
                    color: Color(0xfff2994a),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Pending Approval',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: ClinicalTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome, ${user?.name ?? "Partner"}!',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ClinicalTheme.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your account is pending Super Admin approval. You will be notified once approved. Verification typically takes up to 24-48 business hours.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: ClinicalTheme.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Account Summary Card
                Card(
                  elevation: 0,
                  side: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1.5),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registration Profile:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ClinicalTheme.textDark,
                          ),
                        ),
                        const Divider(height: 24),
                        _buildProfileField('Registered Email:', user?.email ?? ''),
                        const SizedBox(height: 8),
                        _buildProfileField('Registered Phone:', user?.phone ?? ''),
                        const SizedBox(height: 8),
                        _buildProfileField('Assigned Role:', user?.role.name.toUpperCase() ?? ''),
                        const SizedBox(height: 8),
                        _buildProfileField('Approval Status:', 'PENDING VERIFICATION', isStatus: true),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Return / Logout button
                ElevatedButton.icon(
                  onPressed: () async {
                    await authService.logout();
                    if (context.mounted) {
                      context.go(AppRoutes.roleSelection);
                    }
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Log Out & Return to Role Selection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClinicalTheme.alertRed,
                    foregroundColor: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Refresh Status button (simulates checking if approved)
                OutlinedButton.icon(
                  onPressed: () {
                    // Check state or show message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Checking status... Your current status is still: ${user?.status.name.toUpperCase()}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    
                    // Note: If the user was approved by Super Admin in the memory list, 
                    // and we check it here, it will automatically transition if the status changed.
                    if (user?.status == AccountStatus.approved) {
                      final targetRoute = AppRoutes.getRouteForRole(user!.role);
                      context.go(targetRoute);
                    }
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Refresh Status'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: ClinicalTheme.primaryBlue, width: 1.5),
                    foregroundColor: ClinicalTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value, {bool isStatus = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ClinicalTheme.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: isStatus ? FontWeight.bold : FontWeight.w500,
              color: isStatus ? const Color(0xfff2994a) : ClinicalTheme.textDark,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
