import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes.dart';
import 'core/theme.dart';
import 'services/auth_service.dart';
import 'services/appointment_service.dart';
import 'services/signaling_service.dart';
import 'services/chat_service.dart';
import 'services/health_feed_service.dart';
import 'services/notification_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<AppointmentService>(
          create: (_) => AppointmentService(),
        ),
        ChangeNotifierProvider<SignalingService>(
          create: (_) => SignalingService(),
        ),
        ChangeNotifierProvider<ChatService>(
          create: (_) => ChatService(),
        ),
        ChangeNotifierProvider<HealthFeedService>(
          create: (_) => HealthFeedService(),
        ),
        ChangeNotifierProvider<NotificationService>(
          create: (_) => NotificationService(),
        ),
      ],
      child: const HelloDoctorApp(),
    ),
  );
}

class HelloDoctorApp extends StatelessWidget {
  const HelloDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hello Doctor',
      debugShowCheckedModeBanner: false,
      theme: ClinicalTheme.lightTheme,
      routerConfig: AppRoutes.router,
    );
  }
}
