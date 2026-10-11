import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../screens/splash_screen.dart';
import '../screens/role_selection_screen.dart';
import '../screens/patient/patient_home.dart';
import '../screens/doctor/doctor_home.dart';
import '../screens/pharmacy/pharmacy_home.dart';
import '../screens/diagnostic/diagnostic_home.dart';
import '../screens/admin/admin_home.dart';
import '../screens/auth/patient_auth_screen.dart';
import '../screens/auth/doctor_register_screen.dart';
import '../screens/auth/pharmacy_register_screen.dart';
import '../screens/auth/diagnostic_register_screen.dart';
import '../screens/auth/admin_login_screen.dart';
import '../screens/auth/pending_approval_screen.dart';
import '../screens/patient/doctor_list_screen.dart';
import '../screens/patient/doctor_profile_screen.dart';
import '../screens/patient/booking_calendar_screen.dart';
import '../screens/patient/booking_summary_screen.dart';
import '../screens/patient/booking_success_screen.dart';
import '../screens/patient/my_appointments_screen.dart';
import '../screens/patient/my_prescriptions_screen.dart';
import '../screens/patient/virtual_waiting_room_screen.dart';
import '../screens/patient/video_call_screen.dart';
import '../screens/patient/post_call_rating_screen.dart';
import '../screens/patient/post_visit_summary_screen.dart';
import '../screens/patient/patient_profile_screen.dart';
import '../screens/patient/insurance_screen.dart';
import '../screens/patient/notifications_screen.dart';
import '../screens/patient/help_support_screen.dart';
import '../screens/chat/chat_list_screen.dart';
import '../screens/chat/chat_conversation_screen.dart';
import '../screens/doctor/patient_queue_screen.dart';
import '../screens/doctor/availability_scheduler_screen.dart';
import '../screens/doctor/earnings_dashboard_screen.dart';
import '../screens/doctor/prescription_screen.dart';
import '../screens/doctor/ehr_viewer_screen.dart';
import '../screens/feed/health_feed_screen.dart';
import '../screens/feed/create_post_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  
  // Homes / Dashboards
  static const String patientHome = '/patient-home';
  static const String doctorHome = '/doctor-home';
  static const String pharmacyHome = '/pharmacy-home';
  static const String diagnosticHome = '/diagnostic-home';
  static const String adminHome = '/admin-home';

  // Feed & Social Social Feeds
  static const String healthFeed = '/feed';
  static const String createPost = '/create-post';

  // Auth & Registration Screens
  static const String patientAuth = '/patient-auth';
  static const String doctorRegister = '/doctor-register';
  static const String pharmacyRegister = '/pharmacy-register';
  static const String diagnosticRegister = '/diagnostic-register';
  static const String adminLogin = '/admin-login';
  static const String pendingApproval = '/pending-approval';

  // Helper to map UserRole to Home route
  static String getRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.patient:
        return patientHome;
      case UserRole.doctor:
        return doctorHome;
      case UserRole.pharmacy:
        return pharmacyHome;
      case UserRole.diagnostic:
        return diagnosticHome;
      case UserRole.admin:
        return adminHome;
    }
  }

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: patientHome,
        builder: (context, state) => const PatientHome(),
      ),
      GoRoute(
        path: doctorHome,
        builder: (context, state) {
          final auth = Provider.of<AuthService>(context, listen: false);
          if (auth.currentUser?.status == AccountStatus.pending) {
            return const PendingApprovalScreen();
          }
          return const DoctorHome();
        },
      ),
      GoRoute(
        path: pharmacyHome,
        builder: (context, state) {
          final auth = Provider.of<AuthService>(context, listen: false);
          if (auth.currentUser?.status == AccountStatus.pending) {
            return const PendingApprovalScreen();
          }
          return const PharmacyHome();
        },
      ),
      GoRoute(
        path: diagnosticHome,
        builder: (context, state) {
          final auth = Provider.of<AuthService>(context, listen: false);
          if (auth.currentUser?.status == AccountStatus.pending) {
            return const PendingApprovalScreen();
          }
          return const DiagnosticHome();
        },
      ),
      GoRoute(
        path: adminHome,
        builder: (context, state) {
          final auth = Provider.of<AuthService>(context, listen: false);
          if (auth.currentUser?.role == UserRole.admin) {
            return const AdminHome();
          }
          return const AdminLoginScreen(); // Security fallback
        },
      ),
      GoRoute(
        path: patientAuth,
        builder: (context, state) => const PatientAuthScreen(),
      ),
      GoRoute(
        path: doctorRegister,
        builder: (context, state) => const DoctorRegisterScreen(),
      ),
      GoRoute(
        path: pharmacyRegister,
        builder: (context, state) => const PharmacyRegisterScreen(),
      ),
      GoRoute(
        path: diagnosticRegister,
        builder: (context, state) => const DiagnosticRegisterScreen(),
      ),
      GoRoute(
        path: adminLogin,
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: pendingApproval,
        builder: (context, state) => const PendingApprovalScreen(),
      ),
      GoRoute(
        path: '/doctor-list',
        builder: (context, state) {
          final specialty = state.uri.queryParameters['specialty'];
          return DoctorListScreen(initialSpecialty: specialty, showBackButton: true);
        },
      ),
      GoRoute(
        path: '/doctor-profile/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'doc_1';
          return DoctorProfileScreen(doctorId: id);
        },
      ),
      GoRoute(
        path: '/booking-calendar',
        builder: (context, state) {
          final docId = state.uri.queryParameters['docId'];
          return BookingCalendarScreen(doctorId: docId);
        },
      ),
      GoRoute(
        path: '/booking-summary',
        builder: (context, state) {
          final docId = state.uri.queryParameters['docId'] ?? '';
          final date = state.uri.queryParameters['date'] ?? '';
          final slot = state.uri.queryParameters['slot'] ?? '';
          return BookingSummaryScreen(
            doctorId: docId,
            date: Uri.decodeComponent(date),
            slot: Uri.decodeComponent(slot),
          );
        },
      ),
      GoRoute(
        path: '/booking-success',
        builder: (context, state) {
          final appId = state.uri.queryParameters['appId'];
          return BookingSuccessScreen(appId: appId);
        },
      ),
      GoRoute(
        path: '/my-appointments',
        builder: (context, state) => const MyAppointmentsScreen(),
      ),
      GoRoute(
        path: '/my-prescriptions',
        builder: (context, state) => const MyPrescriptionsScreen(),
      ),
      GoRoute(
        path: '/patient-profile',
        builder: (context, state) => const PatientProfileScreen(),
      ),
      GoRoute(
        path: '/insurance',
        builder: (context, state) => const InsuranceScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/help-support',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/virtual-waiting-room',
        builder: (context, state) {
          final appId = state.uri.queryParameters['appId'] ?? '';
          return VirtualWaitingRoomScreen(appId: appId);
        },
      ),
      GoRoute(
        path: '/video-call',
        builder: (context, state) {
          final appId = state.uri.queryParameters['appId'] ?? '';
          final role = state.uri.queryParameters['role'] ?? 'patient';
          return VideoCallScreen(appId: appId, role: role);
        },
      ),
      GoRoute(
        path: '/post-call-rating',
        builder: (context, state) {
          final appId = state.uri.queryParameters['appId'] ?? '';
          return PostCallRatingScreen(appId: appId);
        },
      ),
      GoRoute(
        path: '/post-visit-summary',
        builder: (context, state) {
          final appId = state.uri.queryParameters['appId'] ?? '';
          return PostVisitSummaryScreen(appId: appId);
        },
      ),
      GoRoute(
        path: '/chat-list',
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: '/chat-conversation',
        builder: (context, state) {
          final threadId = state.uri.queryParameters['threadId'] ?? '';
          final peerId = state.uri.queryParameters['peerId'] ?? '';
          final peerName = state.uri.queryParameters['peerName'] ?? '';
          final peerRole = state.uri.queryParameters['peerRole'] ?? '';
          return ChatConversationScreen(
            threadId: threadId,
            peerId: peerId,
            peerName: Uri.decodeComponent(peerName),
            peerRole: peerRole,
          );
        },
      ),
      GoRoute(
        path: '/doctor/patient-queue',
        builder: (context, state) => const PatientQueueScreen(),
      ),
      GoRoute(
        path: '/doctor/availability',
        builder: (context, state) => const AvailabilitySchedulerScreen(),
      ),
      GoRoute(
        path: '/doctor/earnings',
        builder: (context, state) => const EarningsDashboardScreen(),
      ),
      GoRoute(
        path: '/doctor/prescription',
        builder: (context, state) {
          final patientId = state.uri.queryParameters['patientId'] ?? '';
          final patientName = state.uri.queryParameters['patientName'] ?? '';
          return WritePrescriptionScreen(
            patientId: patientId,
            patientName: Uri.decodeComponent(patientName),
          );
        },
      ),
      GoRoute(
        path: '/doctor/ehr',
        builder: (context, state) {
          final patientId = state.uri.queryParameters['patientId'] ?? '';
          final patientName = state.uri.queryParameters['patientName'] ?? '';
          return EhrViewerScreen(
            patientId: patientId,
            patientName: Uri.decodeComponent(patientName),
          );
        },
      ),
      GoRoute(
        path: healthFeed,
        builder: (context, state) => const HealthFeedScreen(),
      ),
      GoRoute(
        path: createPost,
        builder: (context, state) => const CreatePostScreen(),
      ),
    ],
  );
}
