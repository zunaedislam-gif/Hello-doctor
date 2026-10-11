import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/routes.dart';
import '../core/theme.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Welcome to',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: ClinicalTheme.textSecondary,
                ),
              ),
              const Text(
                'Hello Doctor',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: ClinicalTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please select your portal to proceed with telemedicine, medicine ordering, or laboratory diagnosis.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: ClinicalTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  children: [
                    _buildRoleCard(
                      context,
                      title: 'Patient Portal',
                      subtitle: 'Consult doctors, book health packages & order tests',
                      icon: Icons.person_rounded,
                      color: ClinicalTheme.primaryBlue,
                      route: AppRoutes.patientAuth,
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context,
                      title: 'Doctor Portal',
                      subtitle: 'Manage appointments, write e-prescriptions & video call',
                      icon: Icons.medical_services_rounded,
                      color: const Color(0xff27ae60),
                      route: AppRoutes.doctorRegister,
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context,
                      title: 'Pharmacy Portal',
                      subtitle: 'Process orders, track deliveries & manage inventory',
                      icon: Icons.local_pharmacy_rounded,
                      color: const Color(0xfff2994a),
                      route: AppRoutes.pharmacyRegister,
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context,
                      title: 'Diagnostic Centre',
                      subtitle: 'Upload medical reports & manage home test requests',
                      icon: Icons.biotech_rounded,
                      color: const Color(0xff9b51e0),
                      route: AppRoutes.diagnosticRegister,
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => context.go(AppRoutes.adminLogin),
                        icon: const Icon(Icons.admin_panel_settings_outlined, size: 18, color: ClinicalTheme.textSecondary),
                        label: const Text(
                          'Super Admin Access Portal',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: ClinicalTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1.5),
      ),
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ClinicalTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: ClinicalTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
