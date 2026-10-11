import { useState, useEffect } from 'react';
import { 
  Folder, 
  FileCode, 
  FileText, 
  ChevronRight, 
  ChevronDown, 
  Copy, 
  Check, 
  Laptop, 
  Smartphone, 
  ShieldCheck, 
  ArrowLeft, 
  Hospital, 
  User, 
  Stethoscope, 
  Pill, 
  FlaskConical, 
  HelpCircle,
  PlusCircle,
  PhoneCall,
  ChevronRight as ChevronRightIcon,
  Maximize2,
  RefreshCw,
  Bell,
  CheckCircle,
  Clock,
  Battery,
  Wifi,
  ExternalLink,
  Code,
  Lock,
  Shield,
  Eye,
  LogOut,
  Upload,
  Fingerprint,
  File,
  Search,
  Heart,
  Star,
  Video,
  Phone,
  Calendar,
  X,
  MessageSquare,
  Plus,
  BookOpen,
  TrendingUp,
  Sparkles,
  Mic,
  MicOff,
  VideoOff,
  Download,
  ShoppingCart,
  Send,
  Activity,
  MoreHorizontal,
  Share2,
  Play,
  Users,
  Settings,
  Trash2,
  Edit,
  Ban,
  Award,
  ShieldAlert,
  Globe,
  Sliders,
  UserX,
  MessageCircle
} from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

// Hardcoded files to mirror the exact Flutter files created on disk
const FLUTTER_FILES: Record<string, { path: string; name: string; content: string; language: string }> = {
  'pubspec': {
    name: 'pubspec.yaml',
    path: 'hello_doctor/pubspec.yaml',
    language: 'yaml',
    content: `name: hello_doctor
description: "A professional multi-role telemedicine application skeleton."
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # Navigation
  go_router: ^13.2.0

  # State Management
  provider: ^6.1.2

  # Persistent Storage
  shared_preferences: ^2.2.2

  # Network API
  http: ^1.2.0

  # Image Selection
  image_picker: ^1.0.7

  # Local Notifications
  flutter_local_notifications: ^17.0.0

  # Typography (Google Fonts)
  google_fonts: ^6.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

flutter:
  uses-material-design: true`
  },
  'manifest': {
    name: 'AndroidManifest.xml',
    path: 'hello_doctor/android/app/src/main/AndroidManifest.xml',
    language: 'xml',
    content: `<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.hello_doctor">
   <application
        android:label="Hello Doctor"
        android:name="\${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>`
  },
  'main': {
    name: 'main.dart',
    path: 'hello_doctor/lib/main.dart',
    language: 'dart',
    content: `import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes.dart';
import 'core/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        // Role state & Authentication providers will go here in the next prompt.
        Provider<String>(create: (_) => 'Hello Doctor Skeleton'),
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
}`
  },
  'theme': {
    name: 'theme.dart',
    path: 'hello_doctor/lib/core/theme.dart',
    language: 'dart',
    content: `import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClinicalTheme {
  static const Color primaryBlue = Color(0xff2f80ed);
  static const Color backgroundLight = Color(0xfff8fafd);
  static const Color surfaceWhite = Colors.white;
  static const Color textDark = Color(0xff1a1c1e);
  static const Color textSecondary = Color(0xff6e7278);
  static const Color alertRed = Color(0xffeb5757);
  static const Color accentGreen = Color(0xff27ae60);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryBlue,
        background: backgroundLight,
        surface: surfaceWhite,
        onPrimary: Colors.white,
        onBackground: textDark,
        onSurface: textDark,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceWhite,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffe0e4ec)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffe0e4ec)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
      ),
    );
  }
}`
  },
  'routes': {
    name: 'routes.dart',
    path: 'hello_doctor/lib/core/routes.dart',
    language: 'dart',
    content: `import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/role_selection_screen.dart';
import '../screens/patient/patient_home.dart';
import '../screens/doctor/doctor_home.dart';
import '../screens/pharmacy/pharmacy_home.dart';
import '../screens/diagnostic/diagnostic_home.dart';

class AppRoutes {
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  static const String patientHome = '/patient-home';
  static const String doctorHome = '/doctor-home';
  static const String pharmacyHome = '/pharmacy-home';
  static const String diagnosticHome = '/diagnostic-home';

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
        builder: (context, state) => const DoctorHome(),
      ),
      GoRoute(
        path: pharmacyHome,
        builder: (context, state) => const PharmacyHome(),
      ),
      GoRoute(
        path: diagnosticHome,
        builder: (context, state) => const DiagnosticHome(),
      ),
    ],
  );
}`
  },
  'splash': {
    name: 'splash_screen.dart',
    path: 'hello_doctor/lib/screens/splash_screen.dart',
    language: 'dart',
    content: `import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        context.go(AppRoutes.roleSelection);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2f80ed),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_hospital_rounded,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Hello Doctor',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Telemedicine App',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}`
  },
  'role_selection': {
    name: 'role_selection_screen.dart',
    path: 'hello_doctor/lib/screens/role_selection_screen.dart',
    language: 'dart',
    content: `import 'package:flutter/material.dart';
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
                      route: AppRoutes.patientHome,
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context,
                      title: 'Doctor Portal',
                      subtitle: 'Manage appointments, write e-prescriptions & video call',
                      icon: Icons.medical_services_rounded,
                      color: const Color(0xff27ae60),
                      route: AppRoutes.doctorHome,
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context,
                      title: 'Pharmacy Portal',
                      subtitle: 'Process orders, track deliveries & manage inventory',
                      icon: Icons.local_pharmacy_rounded,
                      color: const Color(0xfff2994a),
                      route: AppRoutes.pharmacyHome,
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context,
                      title: 'Diagnostic Centre',
                      subtitle: 'Upload medical reports & manage home test requests',
                      icon: Icons.biotech_rounded,
                      color: const Color(0xff9b51e0),
                      route: AppRoutes.diagnosticHome,
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
}`
  },
  'patient_home': {
    name: 'patient_home.dart',
    path: 'hello_doctor/lib/screens/patient/patient_home.dart',
    language: 'dart',
    content: `import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  int _currentBottomTab = 0;
  int _currentPromoIndex = 0;
  String _selectedSpecialty = "All";
  bool _isEnglish = true;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final PageController _promoPageController = PageController();
  Timer? _promoTimer;

  // Specialties list
  final List<Map<String, dynamic>> _specialties = [
    {"name": "All", "icon": Icons.grid_view_rounded},
    {"name": "General Physician", "icon": Icons.stethoscope},
    {"name": "Gynecology", "icon": Icons.pregnant_woman_rounded},
    {"name": "Pediatrics", "icon": Icons.child_care_rounded},
    {"name": "Skin/Derm", "icon": Icons.face_retouching_natural_rounded},
    {"name": "Neurology", "icon": Icons.psychology_rounded},
    {"name": "Cardiology", "icon": Icons.favorite_rounded},
    {"name": "Gastroenterology", "icon": Icons.flatware_rounded},
    {"name": "Psychiatry", "icon": Icons.sentiment_satisfied_alt_rounded},
  ];

  // Promotional banners
  final List<Map<String, String>> _promos = [
    {
      "title": "First Video Consult Free",
      "subtitle": "Get expert medical advice instantly from home",
      "code": "FREEFIRST",
      "bgGradient": "linear-gradient(135deg, #2f80ed, #56ccf2)"
    },
    {
      "title": "Up to 25% Off Lab Tests",
      "subtitle": "Accurate pathology tests with free home sample collection",
      "code": "DIAG25",
      "bgGradient": "linear-gradient(135deg, #9b51e0, #e0c3fc)"
    },
    {
      "title": "Free Medicine Home Delivery",
      "subtitle": "Order prescription medicines and get fast dispatch",
      "code": "FREEDEL",
      "bgGradient": "linear-gradient(135deg, #f2994a, #f2c94c)"
    }
  ];

  // Dummy doctor list
  final List<Map<String, dynamic>> _doctors = [
    {
      "name": "Dr. Sarah Rahman",
      "specialty": "General Physician",
      "rating": 4.9,
      "reviews": 124,
      "fee": 500,
      "experience": 8,
      "isOnline": true,
      "photo": "assets/dr_sarah.png"
    },
    {
      "name": "Dr. Fahim Anjum",
      "specialty": "Gynecology",
      "rating": 4.8,
      "reviews": 98,
      "fee": 600,
      "experience": 10,
      "isOnline": false,
      "photo": "assets/dr_fahim.png"
    },
    {
      "name": "Dr. Naila Khan",
      "specialty": "Pediatrics",
      "rating": 4.9,
      "reviews": 210,
      "fee": 700,
      "experience": 12,
      "isOnline": true,
      "photo": "assets/dr_naila.png"
    },
    {
      "name": "Dr. Ariful Islam",
      "specialty": "Cardiology",
      "rating": 4.9,
      "reviews": 315,
      "fee": 800,
      "experience": 15,
      "isOnline": false,
      "photo": "assets/dr_arif.png"
    },
    {
      "name": "Dr. Tasnim Ahmed",
      "specialty": "Skin/Derm",
      "rating": 4.7,
      "reviews": 84,
      "fee": 500,
      "experience": 7,
      "isOnline": true,
      "photo": "assets/dr_tasnim.png"
    }
  ];

  @override
  void initState() {
    super.initState();
    _promoTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_promoPageController.hasClients) {
        int nextPageIndex = _currentPromoIndex + 1;
        if (nextPageIndex >= _promos.length) {
          nextPageIndex = 0;
        }
        _promoPageController.animateToPage(
          nextPageIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _promoPageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredDoctors {
    return _doctors.where((doc) {
      bool specialtyMatch = _selectedSpecialty == "All" || 
          doc["specialty"].toString().toLowerCase().contains(_selectedSpecialty.toLowerCase().split("/")[0]);
      bool searchMatch = _searchQuery.isEmpty || 
          doc["name"].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc["specialty"].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return specialtyMatch && searchMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ClinicalTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.local_hospital_rounded, color: ClinicalTheme.primaryBlue, size: 22),
            ),
            const SizedBox(width: 8),
            Text(
              _isEnglish ? 'Hello Doctor' : 'হ্যালো ডাক্তার',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.extrabold,
                fontSize: 18,
                color: ClinicalTheme.primaryBlue,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isEnglish = !_isEnglish;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isEnglish 
                      ? 'Language toggled to English' 
                      : 'ভাষা পরিবর্তন করে বাংলায় সেট করা হয়েছে'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ClinicalTheme.primaryBlue.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.g_translate_rounded, color: ClinicalTheme.primaryBlue, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    _isEnglish ? "EN" : "বাংলা",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: ClinicalTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: ClinicalTheme.textDark),
                onPressed: () {
                  _showNotificationDialog();
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: ClinicalTheme.alertRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () => _showProfileDialog(),
            child: Container(
              margin: const EdgeInsets.only(right: 16, left: 6, top: 10, bottom: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ClinicalTheme.primaryBlue.withOpacity(0.15), width: 1.5),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.amber,
                child: Text('K', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
      body: _currentBottomTab == 0
          ? _buildDashboardView()
          : _buildTabPlaceholderView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomTab,
        onTap: (index) {
          setState(() {
            _currentBottomTab = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: ClinicalTheme.primaryBlue,
        unselectedItemColor: ClinicalTheme.textSecondary.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 11),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            activeIcon: const Icon(Icons.home_rounded),
            label: _isEnglish ? 'Home' : 'হোম',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.play_circle_outline_rounded),
            activeIcon: const Icon(Icons.play_circle_filled_rounded),
            label: _isEnglish ? 'Clips' : 'ক্লিপস',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.medical_services_outlined),
            activeIcon: const Icon(Icons.medical_services_rounded),
            label: _isEnglish ? 'Doctor' : 'ডাক্তার',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.biotech_outlined),
            activeIcon: const Icon(Icons.biotech_rounded),
            label: _isEnglish ? 'Diagnostic' : 'ডায়াগনস্টিক',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_rounded),
            activeIcon: const Icon(Icons.menu_open_rounded),
            label: _isEnglish ? 'More' : 'আরও',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 4.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: _isEnglish ? 'Search doctor by name or symptom...' : 'ডাক্তারের নাম বা লক্ষণ দিয়ে খুঁজুন...',
                hintStyle: TextStyle(color: ClinicalTheme.textSecondary.withOpacity(0.5), fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, color: ClinicalTheme.primaryBlue, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = "";
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: ClinicalTheme.backgroundLight,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.08)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ClinicalTheme.primaryBlue, width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: PageView.builder(
              controller: _promoPageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPromoIndex = index;
                });
              },
              itemCount: _promos.length,
              itemBuilder: (context, index) {
                final promo = _promos[index];
                return _buildPromoCard(promo);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_promos.length, (index) {
              return Container(
                width: _currentPromoIndex == index ? 14 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: _currentPromoIndex == index 
                      ? ClinicalTheme.primaryBlue 
                      : ClinicalTheme.textSecondary.withOpacity(0.2),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEnglish ? 'Our Medical Services' : 'আমাদের চিকিৎসা সেবা সমূহ',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: ClinicalTheme.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _buildQuickActionCard(
                      title: _isEnglish ? 'Consult Now' : 'ডাক্তার দেখান',
                      subtitle: _isEnglish ? 'Instant video e-consult' : 'ইনস্ট্যান্ট ই-ভিজিট',
                      icon: Icons.video_call_rounded,
                      color: Colors.blue.shade600,
                      onTap: () => _simulateInstantConsult(),
                    ),
                    _buildQuickActionCard(
                      title: _isEnglish ? 'Book Appointment' : 'চেম্বার সিরিয়াল',
                      subtitle: _isEnglish ? 'Schedule clinic/e-visit' : 'দিনক্ষণ ঠিক করুন',
                      icon: Icons.calendar_month_rounded,
                      color: Colors.emerald.shade600,
                      onTap: () => _simulateBookingAppointment(),
                    ),
                    _buildQuickActionCard(
                      title: _isEnglish ? 'Order Medicine' : 'ওষুধ অর্ডার',
                      subtitle: _isEnglish ? 'Prescription home dispatch' : 'কুরিয়ারে ওষুধ কিনুন',
                      icon: Icons.local_pharmacy_rounded,
                      color: Colors.orange.shade700,
                      onTap: () {
                        setState(() {
                          _currentBottomTab = 3;
                        });
                      },
                    ),
                    _buildQuickActionCard(
                      title: _isEnglish ? 'Book Lab Test' : 'ল্যাব টেস্ট বুক',
                      subtitle: _isEnglish ? 'Pathology sample home' : 'বাসা থেকে রক্তের টেস্ট',
                      icon: Icons.science_rounded,
                      color: Colors.purple.shade600,
                      onTap: () {
                        setState(() {
                          _currentBottomTab = 3;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              _isEnglish ? 'Medical Specialties' : 'মেডিকেল স্পেশালিটি',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: ClinicalTheme.textDark,
              ),
            ),
          ),
          SizedBox(
            height: 94,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 16),
              itemCount: _specialties.length,
              itemBuilder: (context, index) {
                final spec = _specialties[index];
                final isSelected = _selectedSpecialty == spec["name"];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSpecialty = spec["name"];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 14),
                    child: Column(
                      children: [
                        Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected 
                                ? ClinicalTheme.primaryBlue 
                                : Colors.white,
                            border: Border.all(
                              color: isSelected 
                                  ? ClinicalTheme.primaryBlue 
                                  : Colors.grey.withOpacity(0.12),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected 
                                    ? ClinicalTheme.primaryBlue.withOpacity(0.15) 
                                    : Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Icon(
                            spec["icon"] as IconData,
                            color: isSelected ? Colors.white : ClinicalTheme.primaryBlue,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          spec["name"] == "All" 
                              ? (_isEnglish ? "All" : "সব")
                              : spec["name"],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.5,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.medium,
                            color: isSelected ? ClinicalTheme.primaryBlue : ClinicalTheme.textSecondary,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Text(
                  _isEnglish 
                      ? 'Popular Doctors (\${_filteredDoctors.length})' 
                      : 'জনপ্রিয় ডাক্তারবৃন্দ (\${_filteredDoctors.length})',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: ClinicalTheme.textDark,
                  ),
                ),
                if (_selectedSpecialty != "All" || _searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSpecialty = "All";
                        _searchController.clear();
                        _searchQuery = "";
                      });
                    },
                    child: const Text(
                      'Clear Filter',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.alertRed),
                    ),
                  )
              ],
            ),
          ),
          _filteredDoctors.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.person_search_rounded, size: 40, color: ClinicalTheme.textSecondary.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      Text(
                        _isEnglish ? 'No doctors found matching filters.' : 'প্রদত্ত তথ্য অনুযায়ী কোনো ডাক্তার পাওয়া যায়নি।',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 172,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 16, bottom: 12),
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doc = _filteredDoctors[index];
                      return _buildPopularDoctorCard(doc);
                    },
                  ),
                ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPromoCard(Map<String, String> promo) {
    Color color1 = ClinicalTheme.primaryBlue;
    Color color2 = Colors.blue.shade300;
    if (promo["code"] == "DIAG25") {
      color1 = Colors.purple.shade700;
      color2 = Colors.purple.shade300;
    } else if (promo["code"] == "FREEDEL") {
      color1 = Colors.orange.shade700;
      color2 = Colors.orange.shade400;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color1.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isEnglish ? "Promo Code: \${promo["code"]}" : "কুপন কোড: \${promo["code"]}",
                    style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  promo["title"]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  promo["subtitle"]!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontFamily: 'Inter',
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            promo["code"] == "FREEFIRST" 
                ? Icons.video_call_rounded 
                : (promo["code"] == "DIAG25" ? Icons.biotech_rounded : Icons.local_pharmacy_rounded),
            size: 54,
            color: Colors.white.withOpacity(0.35),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.12), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5,
                  color: ClinicalTheme.textDark,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9.5,
                  color: ClinicalTheme.textSecondary.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularDoctorCard(Map<String, dynamic> doc) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.12), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.1),
                      child: Text(
                        doc["name"].toString().split(" ")[1][0],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue),
                      ),
                    ),
                    if (doc["isOnline"] == true)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: ClinicalTheme.accentGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc["name"],
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: ClinicalTheme.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        doc["specialty"],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          color: ClinicalTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star_rate_rounded, color: Colors.amber, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            "\${doc["rating"]}",
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                          ),
                          Text(
                            " (\${doc["reviews"]})",
                            style: const TextStyle(fontSize: 10, color: ClinicalTheme.textSecondary),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Divider(color: Colors.grey.withOpacity(0.1), height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEnglish ? "Fee" : "ফি",
                      style: const TextStyle(fontSize: 9, color: ClinicalTheme.textSecondary),
                    ),
                    Text(
                      "৳ \${doc["fee"]}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _showDoctorProfileSheet(doc),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClinicalTheme.primaryBlue,
                    minimumSize: const Size(90, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _isEnglish ? 'View Profile' : 'প্রোফাইল',
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPlaceholderView() {
    String tabTitle = "Placeholder";
    IconData tabIcon = Icons.info_outline;
    Color tabColor = ClinicalTheme.primaryBlue;
    Widget tabContent = const SizedBox();

    if (_currentBottomTab == 1) {
      tabTitle = _isEnglish ? "Medical Clips Feed" : "মেডিকেল ক্লিপস ফিড";
      tabIcon = Icons.play_circle_filled_rounded;
      tabColor = ClinicalTheme.primaryBlue;
      tabContent = _buildClipsFeedTab();
    } else if (_currentBottomTab == 2) {
      tabTitle = _isEnglish ? "Doctor Consultations" : "ডাক্তার পরামর্শ";
      tabIcon = Icons.medical_services_rounded;
      tabColor = ClinicalTheme.accentGreen;
      tabContent = _buildDoctorsListTab();
    } else if (_currentBottomTab == 3) {
      tabTitle = _isEnglish ? "Diagnostic & Pathology" : "ডায়াগনস্টিক ও প্যাথলজি";
      tabIcon = Icons.biotech_rounded;
      tabColor = Colors.purple;
      tabContent = _buildDiagnosticTab();
    } else if (_currentBottomTab == 4) {
      tabTitle = _isEnglish ? "More Menu options" : "আরও অন্যান্য অপশন";
      tabIcon = Icons.menu_open_rounded;
      tabColor = Colors.orange;
      tabContent = _buildMoreMenuTab();
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: tabColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(tabIcon, size: 36, color: tabColor),
            ),
            const SizedBox(height: 12),
            Text(
              tabTitle,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
            ),
            const SizedBox(height: 6),
            const Text(
              'Digital health portal integration live simulation',
              style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: ClinicalTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            tabContent,
          ],
        ),
      ),
    );
  }

  Widget _buildClipsFeedTab() {
    final List<Map<String, String>> clips = [
      {"title": "How to control Hypertension", "author": "Dr. Sarah Rahman", "views": "1.2k"},
      {"title": "Daily habits for a healthy heart", "author": "Dr. Ariful Islam", "views": "850"},
      {"title": "Baby vaccination checklist", "author": "Dr. Naila Khan", "views": "2.4k"},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: clips.length,
      itemBuilder: (context, index) {
        final clip = clips[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.withOpacity(0.12)),
          ),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
            ),
            title: Text(clip["title"]!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12.5, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark)),
            subtitle: Text("\${clip["author"]} • \${clip["views"]} views", style: const TextStyle(fontSize: 10)),
            trailing: const Icon(Icons.bookmark_border_rounded, size: 18),
          ),
        );
      },
    );
  }

  Widget _buildDoctorsListTab() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _doctors.length,
      itemBuilder: (context, index) {
        final doc = _doctors[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.withOpacity(0.12)),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.1),
              child: Text(doc["name"].toString().split(" ")[1][0]),
            ),
            title: Text(doc["name"], style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold)),
            subtitle: Text("\${doc["specialty"]} • \${doc["experience"]} yrs Exp"),
            trailing: Text("৳ \${doc["fee"]}", style: const TextStyle(fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue)),
            onTap: () => _showDoctorProfileSheet(doc),
          ),
        );
      },
    );
  }

  Widget _buildDiagnosticTab() {
    final packages = [
      {"name": "General Health Checkup", "price": 1200, "tests": "CBC, Blood Sugar, SGPT"},
      {"name": "Diabetes Care Pack", "price": 800, "tests": "HbA1c, Fasting Glucose"},
      {"name": "Heart Care Evaluation", "price": 2500, "tests": "ECG, Lipid Profile, Creatinine"},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final pack = packages[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.withOpacity(0.12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pack["name"] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark)),
                      const SizedBox(height: 2),
                      Text(pack["tests"] as String, style: const TextStyle(fontSize: 10.5, color: ClinicalTheme.textSecondary)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("৳ \${pack["price"]}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Simulated lab booking: \${pack["name"]}')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        minimumSize: const Size(64, 26),
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text('Book', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoreMenuTab() {
    return Column(
      children: [
        _buildMenuTile(Icons.history_rounded, _isEnglish ? "Consultation History" : "পরামর্শের ইতিহাস", () {}),
        _buildMenuTile(Icons.medical_information_rounded, _isEnglish ? "My Health Records" : "আমার প্রেসক্রিপশন ও ফাইল", () {}),
        _buildMenuTile(Icons.account_balance_wallet_rounded, _isEnglish ? "Payments & Refunds" : "পেমেন্ট হিস্টোরি", () {}),
        _buildMenuTile(Icons.help_outline_rounded, _isEnglish ? "Support Hotline" : "হেল্পলাইন সাপোর্ট", () {}),
        const Divider(height: 24, thickness: 1),
        ElevatedButton.icon(
          onPressed: () {
            context.go(AppRoutes.roleSelection);
          },
          icon: const Icon(Icons.logout_rounded, size: 18, color: Colors.white),
          label: Text(_isEnglish ? 'Switch Portal Role' : 'পোর্টাল রোল পরিবর্তন'),
          style: ElevatedButton.styleFrom(backgroundColor: ClinicalTheme.primaryBlue),
        ),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: ClinicalTheme.primaryBlue, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: ClinicalTheme.textDark)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 16),
      dense: true,
      onTap: onTap,
    );
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_isEnglish ? "Notifications" : "বিজ্ঞপ্তি"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.check_circle_outline, color: ClinicalTheme.accentGreen),
                title: Text(_isEnglish ? "OTP Verified" : "ওটিপি ভেরিফিকেশন সফল"),
                subtitle: Text(_isEnglish ? "Profile verified successfully" : "মোবাইল ভেরিফিকেশন সম্পন্ন হয়েছে"),
              ),
              ListTile(
                leading: const Icon(Icons.campaign_outlined, color: ClinicalTheme.primaryBlue),
                title: Text(_isEnglish ? "Free Consult Alert!" : "ফ্রি পরামর্শ অফার"),
                subtitle: Text(_isEnglish ? "Your first on-demand consult is free" : "প্রথম পরামর্শ সম্পূর্ণ ফ্রী"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.amber,
                child: Text('K', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_isEnglish ? "Karim Uddin" : "করিম উদ্দিন", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const Text("karim@gmail.com", style: TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
                ],
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildProfileField(Icons.phone_android, "+880 01912345678"),
              _buildProfileField(Icons.location_on_rounded, "Dhaka, Bangladesh"),
              _buildProfileField(Icons.bloodtype_rounded, "O+ Positive"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  Widget _buildProfileField(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: ClinicalTheme.primaryBlue),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontSize: 12, color: ClinicalTheme.textDark, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showDoctorProfileSheet(Map<String, dynamic> doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          maxHeight: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.1),
                    child: Text(
                      doc["name"].toString().split(" ")[1][0],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc["name"], style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark)),
                        Text(doc["specialty"], style: const TextStyle(fontSize: 13, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rate_rounded, color: Colors.amber, size: 16),
                            const SizedBox(width: 2),
                            Text("\${doc["rating"]} Rating", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark)),
                            const SizedBox(width: 8),
                            Text("\${doc["experience"]} yrs Exp", style: const TextStyle(fontSize: 12, color: ClinicalTheme.textSecondary)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Biography',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
              ),
              const SizedBox(height: 6),
              Text(
                'Professional senior consultant with extensive clinical expertise, dedicated to delivering state-of-the-art diagnostic care and continuous support through digital telemedicine and on-demand treatment pathways.',
                style: TextStyle(fontSize: 12, color: ClinicalTheme.textSecondary.withOpacity(0.95), height: 1.4),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Consultation Fee', style: TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary)),
                      Text('৳ \${doc["fee"]}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Initiating direct video call with \${doc["name"]}...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ClinicalTheme.primaryBlue,
                      minimumSize: const Size(160, 48),
                    ),
                    child: const Text('Connect Video Visit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _simulateInstantConsult() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Consult Doctor Now', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.ring_volume_rounded, size: 48, color: ClinicalTheme.primaryBlue),
              const SizedBox(height: 12),
              const Text('Connecting to available general practitioner for on-demand visit...', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5)),
              const SizedBox(height: 8),
              LinearProgressIndicator(color: ClinicalTheme.primaryBlue, backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.1)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: ClinicalTheme.alertRed)),
            )
          ],
        );
      },
    );
  }

  void _simulateBookingAppointment() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Book Chamber Appointment', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Chamber / Slot:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildSlotButton("Tomorrow, 10:00 AM - 12:00 PM"),
              _buildSlotButton("Tomorrow, 06:00 PM - 08:00 PM"),
              _buildSlotButton("Monday, 11:00 AM - 01:00 PM"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  Widget _buildSlotButton(String slot) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Appointment requested for slot: \$slot')),
          );
        },
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 38),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(slot, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }
}`
  },
  'doctor_home': {
    name: 'doctor_home.dart',
    path: 'hello_doctor/lib/screens/doctor/doctor_home.dart',
    language: 'dart',
    content: `import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor Portal',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go(AppRoutes.roleSelection),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xff27ae60).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  size: 72,
                  color: Color(0xff27ae60),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Doctor Home',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ClinicalTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Coming Soon',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ClinicalTheme.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Digital prescriptions, active video consultation channels, and patient history logs will be available here soon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: ClinicalTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.roleSelection),
                icon: const Icon(Icons.swap_horiz_rounded),
                label: const Text('Change Portal Role'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff27ae60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}`
  },
  'pharmacy_home': {
    name: 'pharmacy_home.dart',
    path: 'hello_doctor/lib/screens/pharmacy/pharmacy_home.dart',
    language: 'dart',
    content: `import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';

class PharmacyHome extends StatelessWidget {
  const PharmacyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pharmacy Portal',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go(AppRoutes.roleSelection),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
                  Icons.local_pharmacy_rounded,
                  size: 72,
                  color: Color(0xfff2994a),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pharmacy Home',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ClinicalTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Coming Soon',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ClinicalTheme.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'E-prescription verification, order dispatch trackers, and stock/medicine catalogs will be accessible here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: ClinicalTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.roleSelection),
                icon: const Icon(Icons.swap_horiz_rounded),
                label: const Text('Change Portal Role'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfff2994a),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}`
  },
  'diagnostic_home': {
    name: 'diagnostic_home.dart',
    path: 'hello_doctor/lib/screens/diagnostic/diagnostic_home.dart',
    language: 'dart',
    content: `import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

class DiagnosticHome extends StatefulWidget {
  const DiagnosticHome({super.key});

  @override
  State<DiagnosticHome> createState() => _DiagnosticHomeState();
}

class _DiagnosticHomeState extends State<DiagnosticHome> {
  int _currentIndex = 0;
  String _selectedBranch = 'Main Branch';
  Map<String, dynamic>? _selectedOrderDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnostic Hub', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        actions: [
          DropdownButton<String>(
            value: _selectedBranch,
            items: ['Main Branch', 'Dhanmondi Branch', 'Uttara Branch'].map((String val) {
              return DropdownMenuItem<String>(value: val, child: Text(val));
            }).toList(),
            onChanged: (val) => setState(() => _selectedBranch = val!),
          )
        ],
      ),
      body: _buildActiveTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.biotech), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: 'Lab Info'),
        ],
      ),
    );
  }

  Widget _buildActiveTab() {
    // Renders custom sub-components (Specimen Stepper, QR Scanner, Pathologist Signoff, secure billing ledgers)
    return const Center(child: Text('Interactive Lab Workspace Live'));
  }
}`
  },
  'user_model': {
    name: 'user_model.dart',
    path: 'hello_doctor/lib/models/user_model.dart',
    language: 'dart',
    content: `enum UserRole { patient, doctor, pharmacy, diagnostic, admin }
enum AccountStatus { approved, pending }

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? password;
  final UserRole role;
  final AccountStatus status;

  // Role-specific fields...
  final String? bmdcNumber;
  final String? specialty;
  final int? yearsOfExperience;
  final double? consultationFee;
  final String? bio;
  final String? profilePhotoPath;
  final String? ownerName;
  final String? tradeLicenseNumber;
  final String? contactPerson;
  final String? licenseNumber;
  final String? address;
  final String? city;
  final String? licenseDocPath;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.password,
    required this.role,
    required this.status,
    this.bmdcNumber,
    this.specialty,
    this.yearsOfExperience,
    this.consultationFee,
    this.bio,
    this.profilePhotoPath,
    this.ownerName,
    this.tradeLicenseNumber,
    this.contactPerson,
    this.licenseNumber,
    this.address,
    this.city,
    this.licenseDocPath,
  });
}`
  },
  'auth_service': {
    name: 'auth_service.dart',
    path: 'hello_doctor/lib/services/auth_service.dart',
    language: 'dart',
    content: `import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  List<UserModel> _allUsers = [];
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  List<UserModel> get allUsers => _allUsers;
  bool get isLoading => _isLoading;

  Future<void> _init() async {
    // Loads from shared_preferences...
  }

  Future<bool> verifyPatientOtp(String phone, String code, {String? name, String? email}) async {
    // Mock OTP verification...
  }

  Future<bool> registerDoctor({required String name, required String phone, required String email, ...}) async {
    // Sets status to pending, saves to shared_preferences...
  }

  Future<void> approveUser(String userId) async {
    // Approves partner, notifies listeners...
  }
}`
  },
  'pending_approval': {
    name: 'pending_approval_screen.dart',
    path: 'hello_doctor/lib/screens/auth/pending_approval_screen.dart',
    language: 'dart',
    content: `import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Icon(Icons.pending_actions_rounded, size: 80, color: Color(0xfff2994a)),
            Text('Pending Approval', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Welcome, \${user?.name}! Your account is pending Super Admin approval.'),
            ElevatedButton(
              onPressed: () => authService.logout(),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}`
  },
  'patient_auth': {
    name: 'patient_auth_screen.dart',
    path: 'hello_doctor/lib/screens/auth/patient_auth_screen.dart',
    language: 'dart',
    content: `// Phone OTP and Email fallback logins...`
  },
  'doctor_register': {
    name: 'doctor_register_screen.dart',
    path: 'hello_doctor/lib/screens/auth/doctor_register_screen.dart',
    language: 'dart',
    content: `// Image Picker photo & certificate uploads...`
  },
  'pharmacy_register': {
    name: 'pharmacy_register_screen.dart',
    path: 'hello_doctor/lib/screens/auth/pharmacy_register_screen.dart',
    language: 'dart',
    content: `// Trade License & address information onboarding...`
  },
  'diagnostic_register': {
    name: 'diagnostic_register_screen.dart',
    path: 'hello_doctor/lib/screens/auth/diagnostic_register_screen.dart',
    language: 'dart',
    content: `// DGHS certificate & contact onboarding...`
  },
  'admin_login': {
    name: 'admin_login_screen.dart',
    path: 'hello_doctor/lib/screens/auth/admin_login_screen.dart',
    language: 'dart',
    content: `// Admin credential verification...`
  },
  'admin_home': {
    name: 'admin_home.dart',
    path: 'hello_doctor/lib/screens/admin/admin_home.dart',
    language: 'dart',
    content: `// Vetting application approval dashboards...`
  }
};

export default function App() {
  // Navigation State for the Simulated Flutter App
  const [flutterScreen, setFlutterScreen] = useState<
    'splash' | 'role_selection' | 'patient_home' | 'doctor_home' | 'pharmacy_home' | 'diagnostic_home' |
    'patient_auth' | 'doctor_register' | 'pharmacy_register' | 'diagnostic_register' | 'admin_login' | 'pending_approval' | 'admin_home'
  >('splash');
  const [splashProgress, setSplashProgress] = useState(0);

  // Simulated Database & Authentication States in React
  const [users, setUsers] = useState<any[]>([
    {
      id: 'admin-001',
      name: 'Super Admin',
      phone: '01700000000',
      email: 'admin@hellodoctor.com',
      password: 'admin123',
      role: 'admin',
      status: 'approved',
    },
    {
      id: 'patient-1',
      name: 'Karim Uddin',
      phone: '01711223344',
      email: 'karim@gmail.com',
      password: 'patient123',
      role: 'patient',
      status: 'approved',
    },
    {
      id: 'patient-2',
      name: 'Nusrat Jahan',
      phone: '01819887766',
      email: 'nusrat@gmail.com',
      password: 'patient123',
      role: 'patient',
      status: 'approved',
    },
    {
      id: 'doctor-mock',
      name: 'Dr. Sarah Rahman',
      phone: '01811111111',
      email: 'sarah.rahman@hellodoctor.com',
      password: 'doctor123',
      role: 'doctor',
      status: 'pending',
      bmdcNumber: 'BMDC-83921',
      specialty: 'Cardiology',
      yearsOfExperience: 8,
      consultationFee: 800,
      bio: 'Senior consultant of Cardiology at Evercare Hospital.',
      licenseDocPath: 'mbbscertificate_sarah.pdf',
    },
    {
      id: 'doctor-approved-1',
      name: 'Dr. Aminul Islam',
      phone: '01922222222',
      email: 'aminul.islam@hellodoctor.com',
      password: 'doctor123',
      role: 'doctor',
      status: 'approved',
      bmdcNumber: 'BMDC-49204',
      specialty: 'Pediatrics',
      yearsOfExperience: 12,
      consultationFee: 1000,
      bio: 'Head of Pediatric Medicine, Dhaka Medical College Hospital.',
      licenseDocPath: 'specialist_board_certification.pdf',
    },
    {
      id: 'pharmacy-approved-1',
      name: 'Lazz Pharma (Dhanmondi)',
      phone: '01533333333',
      email: 'lazz@lazzpharma.com',
      password: 'pharmacy123',
      role: 'pharmacy',
      status: 'approved',
      ownerName: 'Lutfor Rahman',
      tradeLicenseNumber: 'TL-849201-DH',
      address: 'House 12, Road 4, Dhanmondi, Dhaka',
      city: 'Dhaka',
      licenseDocPath: 'lazz_pharma_license.pdf',
    },
    {
      id: 'pharmacy-pending-1',
      name: 'Tamanna Pharmacy',
      phone: '01644444444',
      email: 'tamanna@pharmacy.com',
      password: 'pharmacy123',
      role: 'pharmacy',
      status: 'pending',
      ownerName: 'M.A. Rashid',
      tradeLicenseNumber: 'TL-903811-DH',
      address: 'Mirpur 10 Circle, Mirpur, Dhaka',
      city: 'Dhaka',
      licenseDocPath: 'tamanna_trade_license.pdf',
    },
    {
      id: 'diagnostic-approved-1',
      name: 'Popular Diagnostics Ltd.',
      phone: '01755555555',
      email: 'popular@diagnostic.com',
      password: 'diagnostic123',
      role: 'diagnostic',
      status: 'approved',
      contactPerson: 'Kamrul Hasan (Director)',
      licenseNumber: 'DGHS-LIC-4029',
      address: 'Road 2, Dhanmondi, Dhaka',
      city: 'Dhaka',
      licenseDocPath: 'popular_dghs_license.pdf',
    },
    {
      id: 'diagnostic-pending-1',
      name: 'Apex Lab & Imaging',
      phone: '01966666666',
      email: 'apex@lab.com',
      password: 'diagnostic123',
      role: 'diagnostic',
      status: 'pending',
      contactPerson: 'Zakir Hossain',
      licenseNumber: 'DGHS-LIC-8012',
      address: 'CDA Avenue, GEC Circle, Chittagong',
      city: 'Chittagong',
      licenseDocPath: 'apex_lab_dghs.pdf',
    }
  ]);
  const [currentUser, setCurrentUser] = useState<any | null>(null);

  // Simulator Form States
  const [phoneInput, setPhoneInput] = useState('');
  const [nameInput, setNameInput] = useState('');
  const [emailInput, setEmailInput] = useState('');
  const [passwordInput, setPasswordInput] = useState('');
  const [otpSent, setOtpSent] = useState(false);
  const [otpInput, setOtpInput] = useState('');
  const [isPhoneFlow, setIsPhoneFlow] = useState(true);
  const [isEmailSignUp, setIsEmailSignUp] = useState(false);

  // Doctor Specific Form States
  const [doctorBmdc, setDoctorBmdc] = useState('');
  const [doctorSpecialty, setDoctorSpecialty] = useState('General Medicine');
  const [doctorExperience, setDoctorExperience] = useState('5');
  const [doctorFee, setDoctorFee] = useState('500');
  const [doctorBio, setDoctorBio] = useState('');
  const [doctorPhoto, setDoctorPhoto] = useState<string | null>(null);
  const [doctorLicense, setDoctorLicense] = useState<string | null>(null);

  // Pharmacy Form States
  const [pharmacyName, setPharmacyName] = useState('');
  const [pharmacyOwner, setPharmacyOwner] = useState('');
  const [pharmacyTradeLicense, setPharmacyTradeLicense] = useState('');
  const [pharmacyAddress, setPharmacyAddress] = useState('');
  const [pharmacyCity, setPharmacyCity] = useState('');
  const [pharmacyLicenseFile, setPharmacyLicenseFile] = useState<string | null>(null);

  // Diagnostic Form States
  const [diagnosticName, setDiagnosticName] = useState('');
  const [diagnosticContact, setDiagnosticContact] = useState('');
  const [diagnosticLicense, setDiagnosticLicense] = useState('');
  const [diagnosticAddress, setDiagnosticAddress] = useState('');
  const [diagnosticCity, setDiagnosticCity] = useState('');
  const [diagnosticLicenseFile, setDiagnosticLicenseFile] = useState<string | null>(null);

  // General App/Dashboard states
  const [activeTab, setActiveTab] = useState<'simulator' | 'explorer'>('simulator');
  const [selectedFileKey, setSelectedFileKey] = useState<string>('pubspec');
  const [copied, setCopied] = useState(false);
  const [currentTime, setCurrentTime] = useState('21:12');

  // Patient Portal Simulator States
  const [patientTab, setPatientTab] = useState<'home' | 'clips' | 'doctor' | 'diagnostic' | 'more'>('home');
  const [patientMoreSubScreen, setPatientMoreSubScreen] = useState<string | null>(null);
  const [patientLanguage, setPatientLanguage] = useState<'EN' | 'BN'>('EN');
  const [patientSearch, setPatientSearch] = useState('');
  const [selectedSpecialty, setSelectedSpecialty] = useState<string | null>(null);
  const [currentBanner, setCurrentBanner] = useState(0);
  const [selectedDoctorForBooking, setSelectedDoctorForBooking] = useState<any | null>(null);
  const [bookingSuccess, setBookingSuccess] = useState(false);
  const [activeVideoCall, setActiveVideoCall] = useState<any | null>(null);
  const [consultationModal, setConsultationModal] = useState(false);
  const [labBookingModal, setLabBookingModal] = useState<any | null>(null);
  const [medicineCartModal, setMedicineCartModal] = useState(false);
  const [medicineCart, setMedicineCart] = useState<any[]>([]);

  // Patient Portal New Features Simulated States
  const [patientProfileName, setPatientProfileName] = useState('Karim Uddin');
  const [patientProfileDob, setPatientProfileDob] = useState('12/10/1992');
  const [patientProfileGender, setPatientProfileGender] = useState('Male');
  const [patientProfileBlood, setPatientProfileBlood] = useState('O+');
  const [patientProfileAddress, setPatientProfileAddress] = useState('House 42, Road 11, Banani, Dhaka');
  const [patientProfileAllergies, setPatientProfileAllergies] = useState(['Penicillin', 'Peanuts']);
  const [patientProfileConditions, setPatientProfileConditions] = useState(['Hypertension']);
  const [patientProfileSurgeries, setPatientProfileSurgeries] = useState(['Appendectomy (2019)']);
  
  const [patientInsuranceProvider, setPatientInsuranceProvider] = useState('MetLife Bangladesh');
  const [patientInsurancePolicy, setPatientInsurancePolicy] = useState('ML-9382-PAT');
  const [patientInsuranceVerified, setPatientInsuranceVerified] = useState(false);
  const [patientInsuranceFront, setPatientInsuranceFront] = useState<string | null>(null);
  const [patientInsuranceBack, setPatientInsuranceBack] = useState<string | null>(null);

  const [patientSimulatedNotifications, setPatientSimulatedNotifications] = useState([
    { id: '1', title: 'Appointment Reminder', body: 'Your video consultation with Dr. Sarah Rahman starts in 15 minutes.', time: 'Just now', type: 'reminder', isRead: false },
    { id: '2', title: 'Order Status Changed', body: 'Your medicine order (ID: RX-84920) is packaged and dispatched.', time: '2 hours ago', type: 'order', isRead: false },
    { id: '3', title: 'New Feed Activity', body: 'Dr. Sarah Rahman posted a new medical tip about Hypertension control.', time: 'Today, 10:00 AM', type: 'feed', isRead: true }
  ]);
  const [patientFaqExpanded, setPatientFaqExpanded] = useState<number | null>(null);

  // Doctor Portal Simulator States
  const [doctorPortalTab, setDoctorPortalTab] = useState<'home' | 'appointments' | 'reports' | 'account'>('home');
  const [doctorOnline, setDoctorOnline] = useState(true);
  const [doctorViewScreen, setDoctorViewScreen] = useState<'dashboard' | 'queue' | 'availability' | 'earnings' | 'prescription' | 'ehr' | 'feed'>('dashboard');

  // Pharmacy Portal Simulator States
  const [pharmacyTab, setPharmacyTab] = useState<'orders' | 'inventory' | 'billing' | 'analytics' | 'account'>('orders');
  const [selectedPharmacyOrder, setSelectedPharmacyOrder] = useState<any | null>(null);
  const [genericAlternativesMed, setGenericAlternativesMed] = useState<string | null>(null);
  const [pharmacyOrders, setPharmacyOrders] = useState<any[]>([
    {
      id: 'ORD-1001',
      patientName: 'Karim Uddin',
      age: 42,
      sex: 'Male',
      allergies: ['Penicillin', 'Dust'],
      medicines: ['Napa 500mg', 'Fexo 120mg', 'Seclo 20mg'],
      status: 'Pending',
      prescriptionId: 'Rx-93821',
      subtotal: 450,
      deliveryCharge: 60,
      total: 510,
      paymentType: 'Cash on Delivery',
      isPaid: false,
      dateString: '2026-07-05',
    },
    {
      id: 'ORD-1002',
      patientName: 'Rahima Begum',
      age: 35,
      sex: 'Female',
      allergies: [],
      medicines: ['Moxacil 500mg', 'Pantix 20mg'],
      status: 'Verified',
      prescriptionId: 'Rx-10492',
      subtotal: 320,
      deliveryCharge: 60,
      total: 380,
      insuranceRef: 'INS-92381-RX',
      paymentType: 'Paid Online',
      isPaid: true,
      dateString: '2026-07-05',
    },
    {
      id: 'ORD-1003',
      patientName: 'Zayan Islam',
      age: 12,
      sex: 'Male',
      allergies: ['Peanuts'],
      medicines: ['Tufnil 80mg', 'Napa 500mg'],
      status: 'Delivered',
      prescriptionId: 'Rx-08492',
      subtotal: 180,
      deliveryCharge: 60,
      total: 240,
      paymentType: 'Cash on Delivery',
      isPaid: true,
      dateString: '2026-07-04',
    }
  ]);
  const [pharmacyInventory, setPharmacyInventory] = useState<any[]>([
    { name: 'Napa 500mg', generic: 'Paracetamol', stock: 120, expiryDate: '2026-12-15', price: 1.5, threshold: 15 },
    { name: 'Fexo 120mg', generic: 'Fexofenadine', stock: 8, expiryDate: '2027-04-12', price: 8.0, threshold: 15 },
    { name: 'Seclo 20mg', generic: 'Omeprazole', stock: 240, expiryDate: '2026-07-20', price: 5.0, threshold: 15 },
    { name: 'Moxacil 500mg', generic: 'Amoxicillin', stock: 5, expiryDate: '2026-10-10', price: 7.5, threshold: 15 },
    { name: 'Pantix 20mg', generic: 'Pantoprazole', stock: 95, expiryDate: '2026-07-18', price: 7.0, threshold: 15 },
    { name: 'Tufnil 80mg', generic: 'Tolfenamic Acid', stock: 50, expiryDate: '2028-01-15', price: 12.0, threshold: 15 }
  ]);
  const [showAddStockModal, setShowAddStockModal] = useState(false);
  const [newStockMed, setNewStockMed] = useState({ name: '', generic: '', stock: '', price: '', expiryDate: '2027-01-01' });

  // Diagnostic Portal Simulator States
  const [diagnosticTab, setDiagnosticTab] = useState<'orders' | 'schedule' | 'reports' | 'account'>('orders');
  const [diagnosticBranch, setDiagnosticBranch] = useState<'Main Branch' | 'Dhanmondi Branch' | 'Uttara Branch'>('Main Branch');
  const [selectedDiagnosticOrder, setSelectedDiagnosticOrder] = useState<any | null>(null);
  
  // Schedule pickup state
  const [showScheduleModal, setShowScheduleModal] = useState(false);
  const [scheduleOrder, setScheduleOrder] = useState<any | null>(null);
  const [scheduleDate, setScheduleDate] = useState('2026-07-05');
  const [scheduleTime, setScheduleTime] = useState('08:30');
  const [assignedStaff, setAssignedStaff] = useState('Ripon Sarker (Senior Phlebotomist)');
  
  // Report Upload state
  const [showReportUploadModal, setShowReportUploadModal] = useState(false);
  const [reportOrder, setReportOrder] = useState<any | null>(null);
  const [reportPathologist, setReportPathologist] = useState('Prof. Dr. Rafiqul Alam, MD (Pathology)');
  const [reportFindings, setReportFindings] = useState('Normal physiological counts observed.');
  const [isDigitallySigned, setIsDigitallySigned] = useState(true);
  
  // Custom dialogs/overlays
  const [showSampleQRModal, setShowSampleQRModal] = useState<any | null>(null);
  const [showReportDetailModal, setShowReportDetailModal] = useState<any | null>(null);
  const [showPatientResultsMock, setShowPatientResultsMock] = useState(false);
  
  // Diagnostic orders database
  const [diagnosticOrders, setDiagnosticOrders] = useState<any[]>([
    {
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
    },
    {
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
    },
    {
      id: 'LAB-1023',
      patientName: 'Kazi Rayhan',
      patientPhone: '01511224466',
      age: 63,
      sex: 'Male',
      tests: ['Lipid Profile', 'Serum Creatinine', 'ECG'],
      location: 'Home Collection',
      address: 'House 19, Sector 4, Uttara, Dhaka',
      status: 'Sample Collected',
      scheduledTime: '2026-07-05 08:30',
      assignedStaff: 'Ripon Sarker (Senior Phlebotomist)',
      sampleId: 'SMP-9302-H',
      testPrice: 2800.0,
      collectionFee: 150.0,
      total: 2950.0,
      paymentType: 'Cash on Delivery',
      isPaid: false,
      branch: 'Uttara Branch',
      dateString: '2026-07-05',
    },
    {
      id: 'LAB-1024',
      patientName: 'Fariha Rahman',
      patientPhone: '01611776655',
      age: 31,
      sex: 'Female',
      tests: ['HBA1C Diabetes Screening'],
      location: 'Home Collection',
      address: 'Lane 2, Mirpur 10, Dhaka',
      status: 'Processing',
      scheduledTime: '2026-07-05 09:15',
      assignedStaff: 'Sumon Ahmed (Phlebotomist)',
      sampleId: 'SMP-1049-H',
      testPrice: 900.0,
      collectionFee: 150.0,
      total: 1050.0,
      paymentType: 'bKash',
      isPaid: true,
      branch: 'Main Branch',
      dateString: '2026-07-05',
    },
    {
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
    }
  ]);

  // Social Health Feed Web Simulator States
  const [feedPosts, setFeedPosts] = useState([
    {
      id: 'feed-post-1',
      authorId: 'doc-1',
      authorName: 'Dr. Sarah Rahman',
      authorRole: 'Doctor',
      authorAvatar: '🩺',
      content: 'Cardiovascular health starts with your morning routine! Try swapping your second cup of sweet milk tea for green tea and complete 30 minutes of brisk walking. Your heart will thank you! 🫀🚶‍♀️\n\nWhat cardiovascular habits are you tracking this week? Let me know in the comments!',
      mediaUrls: [],
      mediaType: 'none',
      timestamp: new Date(Date.now() - 3 * 3600 * 1000).toISOString(),
      likedByUids: ['patient_mock'],
      comments: [
        {
          id: 'feed-comment-1',
          postId: 'feed-post-1',
          authorId: 'patient_mock',
          authorName: 'Karim Uddin',
          authorRole: 'Patient',
          authorAvatar: '👤',
          text: 'I started walking 20 minutes daily, Dr. Sarah! Feeling much lighter already.',
          timestamp: new Date(Date.now() - 2 * 3600 * 1000).toISOString(),
        }
      ]
    },
    {
      id: 'feed-post-2',
      authorId: 'pharmacy-1',
      authorName: 'Lazz Pharma (Dhanmondi)',
      authorRole: 'Pharmacy',
      authorAvatar: '💊',
      content: 'Stay alert: seasonal flu is on the rise in Dhaka city. We have fully restocked genuine Napa Extend, Fexo, and standard pediatric nebulizer solutions. Home delivery is available via Hello Doctor.\n\nNote: Always consult a verified physician before administering antibiotics!',
      mediaUrls: [],
      mediaType: 'none',
      timestamp: new Date(Date.now() - 24 * 3600 * 1000).toISOString(),
      likedByUids: [],
      comments: []
    },
    {
      id: 'feed-post-3',
      authorId: 'diag-1',
      authorName: 'Popular Diagnostic Center',
      authorRole: 'Diagnostic Centre',
      authorAvatar: '🔬',
      content: 'Take charge of your health before symptoms arise. Get our Premium Wellness Full Body Checkup (48 Parameters) including Liver Profile, Kidney Function, and Lipid Profiles at an exclusive 15% discount for Hello Doctor subscribers! 🩺🧪',
      mediaUrls: [],
      mediaType: 'none',
      timestamp: new Date(Date.now() - 48 * 3600 * 1000).toISOString(),
      likedByUids: ['doc-1'],
      comments: []
    }
  ]);

  // Super Admin Simulator States
  const [adminTab, setAdminTab] = useState<'dashboard' | 'approvals' | 'users' | 'settings' | 'content' | 'audit' | 'support' | 'notifications'>('dashboard');
  const [approvalsRoleTab, setApprovalsRoleTab] = useState<'doctor' | 'pharmacy' | 'diagnostic'>('doctor');
  const [adminUserSearch, setAdminUserSearch] = useState('');
  const [adminUserRoleFilter, setAdminUserRoleFilter] = useState<'all' | 'patient' | 'doctor' | 'pharmacy' | 'diagnostic'>('all');
  const [selectedAdminUser, setSelectedAdminUser] = useState<any | null>(null);
  const [showAdminUserEditModal, setShowAdminUserEditModal] = useState(false);

  // Settings states
  const [consultationFeeRange, setConsultationFeeRange] = useState({ min: 300, max: 2000 });
  const [commissionPercentage, setCommissionPercentage] = useState(15);
  const [doctorSpecialties, setDoctorSpecialties] = useState<string[]>([
    'Cardiology', 'Dermatology', 'Neurology', 'Pediatrics', 'General Medicine', 'Orthopedics', 'Gynecology'
  ]);
  const [newSpecialtyText, setNewSpecialtyText] = useState('');
  
  const [labTestCatalog, setLabTestCatalog] = useState<any[]>([
    { id: 't1', name: 'Complete Blood Count (CBC)', price: 600 },
    { id: 't2', name: 'Fasting Blood Sugar (FBS)', price: 300 },
    { id: 't3', name: 'Thyroid Panel (T3, T4, TSH)', price: 1500 },
    { id: 't4', name: 'Lipid Profile', price: 1200 },
    { id: 't5', name: 'Serum Creatinine', price: 400 }
  ]);
  const [showAddTestModal, setShowAddTestModal] = useState(false);
  const [newLabTest, setNewLabTest] = useState({ name: '', price: '' });
  const [editingLabTest, setEditingLabTest] = useState<any | null>(null);

  const [serviceableCities, setServiceableCities] = useState<string[]>([
    'Dhaka', 'Chittagong', 'Sylhet', 'Rajshahi', 'Khulna', 'Barisal'
  ]);
  const [newCityText, setNewCityText] = useState('');

  // Content Management states
  const [termsAndConditions, setTermsAndConditions] = useState(
    'Hello Doctor Platform Terms & Conditions\n\n1. Acceptance of Terms\nBy accessing and using Hello Doctor, you agree to comply with these terms, our clinical protocol rules, and government healthcare codes.\n\n2. Patient Consent\nTelemedicine consults do not replace emergency face-to-face visits. Users consent to secure digital summary logs.'
  );
  const [privacyPolicy, setPrivacyPolicy] = useState(
    'Hello Doctor Privacy Policy\n\n1. Medical Records Privacy\nYour diagnostic history, medication logs, and consultations are secured using secure digital access protocols. They are never shared without explicit patient consent.\n\n2. Secure Communications\nVideo and chat lines are protected with industry-standard TLS tunnels.'
  );

  // Audit Logs database
  const [auditLogs, setAuditLogs] = useState<any[]>([
    { id: 'log-1', action: 'Dr. Sarah Rahman registered as Cardiology Specialist', user: 'System-Auto', timestamp: '2026-07-05 08:30:12' },
    { id: 'log-2', action: 'Popular Diagnostics Ltd. verified via DGHS database', user: 'Super Admin', timestamp: '2026-07-05 09:12:44' },
    { id: 'log-3', action: 'Platform transaction commission set to 15%', user: 'Super Admin', timestamp: '2026-07-05 10:05:00' },
    { id: 'log-4', action: 'Added specialty: Pediatric Surgery', user: 'Super Admin', timestamp: '2026-07-05 11:15:30' },
    { id: 'log-5', action: 'Lazz Pharma (Dhanmondi) approved for active dispatch', user: 'Super Admin', timestamp: '2026-07-05 11:32:04' }
  ]);

  // Support Tickets database
  const [supportTickets, setSupportTickets] = useState<any[]>([
    {
      id: 'tkt-101',
      user: 'Karim Uddin',
      role: 'Patient',
      subject: 'Refund on cancelled lab test',
      status: 'Open',
      message: 'I scheduled a CBC test for yesterday morning but the phlebotomist did not arrive. Please refund my bKash payment.',
      replies: [
        { sender: 'Patient', text: 'I scheduled a CBC test but phlebotomist did not arrive. Please refund.', timestamp: '2026-07-04 14:30' }
      ]
    },
    {
      id: 'tkt-102',
      user: 'Dr. Sarah Rahman',
      role: 'Doctor',
      subject: 'Payout delays',
      status: 'In Progress',
      message: 'My completed video consultation fees of BDT 4500 haven\'t hit my mobile banking wallet yet.',
      replies: [
        { sender: 'Doctor', text: 'Completed 6 consults yesterday but wallet shows BDT 0. Please look into it.', timestamp: '2026-07-04 18:15' },
        { sender: 'Admin', text: 'Hello Dr. Sarah, our financial ledgers are clearing these today by 6 PM. Apologies for the hold.', timestamp: '2026-07-04 19:00' }
      ]
    },
    {
      id: 'tkt-103',
      user: 'Lazz Pharma',
      role: 'Pharmacy',
      subject: 'Order cancellation issues',
      status: 'Resolved',
      message: 'Order #MED-8422 was cancelled by the patient after we packaged it. Who covers packaging costs?',
      replies: [
        { sender: 'Pharmacy', text: 'Order was packaged and ready when cancellation notification arrived.', timestamp: '2026-07-03 10:00' },
        { sender: 'Admin', text: 'Hello, in cancellation cases, the platform handles packaging restocking fees up to BDT 100.', timestamp: '2026-07-03 12:45' }
      ]
    }
  ]);
  const [selectedTicketId, setSelectedTicketId] = useState<string | null>(null);
  const [supportReplyText, setSupportReplyText] = useState('');

  // Push Notification Form states
  const [pushTitle, setPushTitle] = useState('');
  const [pushMessage, setPushMessage] = useState('');
  const [pushTarget, setPushTarget] = useState<'All' | 'Patients' | 'Doctors' | 'Pharmacies' | 'Diagnostics'>('All');

  const [feedActiveCommentsPost, setFeedActiveCommentsPost] = useState<string | null>(null);
  const [feedNewCommentText, setFeedNewCommentText] = useState('');
  const [createPostModal, setCreatePostModal] = useState(false);
  const [newPostCaption, setNewPostCaption] = useState('');
  const [newPostAttachedImages, setNewPostAttachedImages] = useState<string[]>([]);
  const [newPostAttachedVideo, setNewPostAttachedVideo] = useState<string | null>(null);
  const [newPostMediaType, setNewPostMediaType] = useState<'none' | 'image' | 'video'>('none');

  const renderHealthFeed = (currentUser: { id: string; name: string; role: string; avatar: string }) => {
    const isPatient = currentUser.role === 'Patient';
    const isEnglish = patientLanguage === 'EN';

    const handleToggleLike = (postId: string) => {
      setFeedPosts(prev => prev.map(post => {
        if (post.id === postId) {
          const liked = post.likedByUids.includes(currentUser.id);
          const newLikes = liked 
            ? post.likedByUids.filter(id => id !== currentUser.id)
            : [...post.likedByUids, currentUser.id];
          return { ...post, likedByUids: newLikes };
        }
        return post;
      }));
    };

    const handleAddComment = (postId: string) => {
      if (!feedNewCommentText.trim()) return;
      setFeedPosts(prev => prev.map(post => {
        if (post.id === postId) {
          const newComment = {
            id: `comment-${Date.now()}`,
            postId,
            authorId: currentUser.id,
            authorName: currentUser.name,
            authorRole: currentUser.role,
            authorAvatar: currentUser.avatar,
            text: feedNewCommentText,
            timestamp: new Date().toISOString()
          };
          return { ...post, comments: [...post.comments, newComment] };
        }
        return post;
      }));
      setFeedNewCommentText('');
    };

    const handleCreatePost = () => {
      if (!newPostCaption.trim() && newPostAttachedImages.length === 0 && !newPostAttachedVideo) return;
      
      const newPost = {
        id: `post-${Date.now()}`,
        authorId: currentUser.id,
        authorName: currentUser.name,
        authorRole: currentUser.role,
        authorAvatar: currentUser.avatar,
        content: newPostCaption,
        mediaUrls: newPostAttachedVideo ? [newPostAttachedVideo] : newPostAttachedImages,
        mediaType: newPostAttachedVideo ? 'video' : (newPostAttachedImages.length > 0 ? 'image' : 'none') as 'none' | 'image' | 'video',
        timestamp: new Date().toISOString(),
        likedByUids: [],
        comments: []
      };

      setFeedPosts([newPost, ...feedPosts]);
      
      // Reset state
      setNewPostCaption('');
      setNewPostAttachedImages([]);
      setNewPostAttachedVideo(null);
      setNewPostMediaType('none');
      setCreatePostModal(false);
      triggerNotification(
        isEnglish ? "Post shared!" : "পোস্ট শেয়ার হয়েছে!",
        isEnglish ? "Your update is live on the Health Feed." : "আপনার পোস্টটি হেলথ ফিডে প্রকাশ করা হয়েছে।"
      );
    };

    const formatTime = (isoString: string) => {
      const diffMs = Date.now() - new Date(isoString).getTime();
      const diffMin = Math.floor(diffMs / 60000);
      const diffHrs = Math.floor(diffMin / 60);
      if (diffMin < 1) return isEnglish ? 'Just now' : 'এইমাত্র';
      if (diffMin < 60) return isEnglish ? `${diffMin}m ago` : `${diffMin} মিনিট আগে`;
      if (diffHrs < 24) return isEnglish ? `${diffHrs}h ago` : `${diffHrs} ঘণ্টা আগে`;
      return new Date(isoString).toLocaleDateString();
    };

    return (
      <div className="flex-1 flex flex-col h-full overflow-hidden text-slate-800">
        {/* Scrollable feed content list */}
        <div className="flex-1 overflow-y-auto px-4 py-3 space-y-4 scrollbar-none">
          
          {/* 1. CREATE POST HEADER BAR */}
          <div className="bg-white border border-slate-150 rounded-2xl p-3.5 shadow-sm">
            <div className="flex items-center gap-3">
              <div className="h-9 w-9 bg-blue-50 border border-blue-100 rounded-full flex items-center justify-center text-lg shadow-sm">
                {currentUser.avatar}
              </div>
              <div 
                onClick={() => {
                  if (isPatient) {
                    triggerNotification(
                      isEnglish ? "Clinical Posts Only" : "শুধুমাত্র যাচাইকৃত পোস্ট",
                      isEnglish ? "Only verified medical providers can publish posts on Health Feed." : "ভুল তথ্য প্রতিরোধে শুধুমাত্র নিবন্ধিত ডাক্তার ও ফার্মেসি পোস্ট করতে পারেন।"
                    );
                  } else {
                    setCreatePostModal(true);
                  }
                }}
                className="flex-1 bg-slate-50 border border-slate-150 rounded-full py-2 px-4 text-xs font-semibold text-slate-500 cursor-pointer hover:bg-slate-100 transition-all flex items-center justify-between"
              >
                <span>
                  {isPatient 
                    ? (isEnglish ? "Only verified professionals can post..." : "শুধুমাত্র পেশাদাররা পোস্ট করতে পারবেন...")
                    : (isEnglish ? "What's on your mind?" : "আপনি এখন কী ভাবছেন?")
                  }
                </span>
                {isPatient && <Lock className="h-3.5 w-3.5 text-slate-400" />}
              </div>
            </div>
          </div>

          {/* 2. MAIN POSTS LIST */}
          <div className="space-y-4 pb-20">
            {feedPosts.map(post => {
              const hasLiked = post.likedByUids.includes(currentUser.id);
              const badgeColor = post.authorRole === 'Doctor' ? 'bg-blue-100 text-blue-600 border-blue-200' 
                : post.authorRole === 'Pharmacy' ? 'bg-emerald-100 text-emerald-600 border-emerald-200'
                : post.authorRole === 'Diagnostic Centre' ? 'bg-purple-100 text-purple-600 border-purple-200'
                : 'bg-slate-100 text-slate-600 border-slate-200';

              return (
                <div key={post.id} className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm space-y-3 flex flex-col relative overflow-hidden">
                  
                  {/* Card Header row */}
                  <div className="flex items-start gap-3">
                    <div className="h-10 w-10 rounded-full bg-slate-50 border border-slate-100 flex items-center justify-center text-xl shadow-sm">
                      {post.authorAvatar}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap">
                        <strong className="font-extrabold text-xs text-slate-800 tracking-tight block truncate">{post.authorName}</strong>
                        <span className={`text-[8.5px] font-black uppercase tracking-wider px-1.5 py-0.5 rounded border ${badgeColor} font-mono`}>
                          {post.authorRole}
                        </span>
                      </div>
                      <span className="text-[9.5px] text-slate-400 font-medium font-mono mt-0.5 block">{formatTime(post.timestamp)}</span>
                    </div>
                    <button className="text-slate-400 hover:text-slate-600">
                      <MoreHorizontal className="h-4 w-4" />
                    </button>
                  </div>

                  {/* Post Caption Body Text */}
                  <div className="text-xs text-slate-700 leading-relaxed whitespace-pre-line break-words">
                    {post.content}
                  </div>

                  {/* Media attachment preview box */}
                  {post.mediaUrls && post.mediaUrls.length > 0 && (
                    <div className="rounded-xl overflow-hidden border border-slate-200 bg-slate-900 relative">
                      {post.mediaType === 'video' ? (
                        <div className="relative aspect-video flex flex-col items-center justify-center text-center p-4">
                          <div className="absolute inset-0 bg-slate-950 opacity-60"></div>
                          <div className="z-10 h-11 w-11 bg-blue-600/90 hover:scale-105 rounded-full flex items-center justify-center mx-auto mb-2 cursor-pointer shadow-lg active:scale-95 transition-all">
                            <Play className="h-5 w-5 fill-white text-white translate-x-0.5" />
                          </div>
                          <span className="z-10 text-[9px] font-bold text-blue-200 uppercase tracking-widest font-mono">Tap to Play Video Clip</span>
                        </div>
                      ) : (
                        <img 
                          src={post.mediaUrls[0]} 
                          alt="Post attachment" 
                          className="w-full max-h-56 object-cover"
                          onError={(e) => {
                            // If local mock file fails to load, show beautiful placeholder
                            (e.target as HTMLImageElement).src = 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=500&q=80';
                          }}
                        />
                      )}
                    </div>
                  )}

                  {/* Interactive Counts Row */}
                  <div className="flex items-center justify-between text-[10px] text-slate-400 font-bold border-b border-slate-100 pb-2.5 mt-2">
                    <div className="flex items-center gap-1.5">
                      <span className="flex items-center justify-center h-4 w-4 bg-red-50 rounded-full border border-red-100">❤️</span>
                      <span>{post.likedByUids.length} Likes</span>
                    </div>
                    <span>{post.comments.length} Comments</span>
                  </div>

                  {/* Actions Row (Like, Comment, Share) */}
                  <div className="grid grid-cols-3 gap-1 pt-1 text-[11px] font-bold text-slate-500">
                    <button 
                      onClick={() => handleToggleLike(post.id)}
                      className={`flex items-center justify-center gap-1.5 py-1.5 rounded-lg hover:bg-slate-50 active:scale-95 transition-all ${hasLiked ? 'text-red-500 font-black' : ''}`}
                    >
                      <Heart className={`h-4 w-4 ${hasLiked ? 'fill-red-500 text-red-500' : ''}`} />
                      <span>{hasLiked ? (isEnglish ? 'Liked' : 'লাইকড') : (isEnglish ? 'Like' : 'লাইক')}</span>
                    </button>

                    <button 
                      onClick={() => setFeedActiveCommentsPost(post.id)}
                      className="flex items-center justify-center gap-1.5 py-1.5 rounded-lg hover:bg-slate-50 active:scale-95 transition-all"
                    >
                      <MessageSquare className="h-4 w-4" />
                      <span>{isEnglish ? 'Comment' : 'কমেন্ট'}</span>
                    </button>

                    <button 
                      onClick={() => triggerNotification(
                        isEnglish ? "Link Copied" : "লিংক কপিড",
                        isEnglish ? "Post link copied to system clipboard." : "পোস্টের লিংকটি ক্লিপবোর্ডে কপি করা হয়েছে।"
                      )}
                      className="flex items-center justify-center gap-1.5 py-1.5 rounded-lg hover:bg-slate-50 active:scale-95 transition-all"
                    >
                      <Share2 className="h-4 w-4" />
                      <span>{isEnglish ? 'Share' : 'শেয়ার'}</span>
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* 3. CREATE POST SCREEN MODAL OVERLAY */}
        {createPostModal && (
          <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-xs z-50 flex items-end">
            <div className="bg-white rounded-t-3xl w-full max-h-[92%] flex flex-col shadow-2xl animate-slide-up overflow-hidden">
              <div className="px-4 py-3 border-b border-slate-150 flex items-center justify-between bg-slate-50">
                <div className="flex items-center gap-1.5">
                  <span className="text-sm">📝</span>
                  <h4 className="font-extrabold text-xs text-slate-800">{isEnglish ? 'Create Social Post' : 'পোস্ট তৈরি করুন'}</h4>
                </div>
                <button 
                  onClick={() => {
                    setCreatePostModal(false);
                    setNewPostCaption('');
                    setNewPostAttachedImages([]);
                    setNewPostAttachedVideo(null);
                    setNewPostMediaType('none');
                  }}
                  className="p-1.5 bg-slate-150 rounded-full hover:bg-slate-200 text-slate-600"
                >
                  <X className="h-3.5 w-3.5" />
                </button>
              </div>

              {/* Modal scrollable form body */}
              <div className="flex-1 overflow-y-auto p-4 space-y-4">
                <div className="flex items-center gap-3">
                  <div className="h-10 w-10 bg-blue-50 border border-blue-100 rounded-full flex items-center justify-center text-xl shadow-sm">
                    {currentUser.avatar}
                  </div>
                  <div>
                    <h5 className="font-black text-xs text-slate-800 leading-tight">{currentUser.name}</h5>
                    <span className="text-[8.5px] font-mono font-bold bg-blue-100 text-blue-600 border border-blue-200 px-1.5 py-0.5 rounded block w-fit uppercase mt-0.5 tracking-wider">{currentUser.role}</span>
                  </div>
                </div>

                <textarea
                  rows={4}
                  placeholder={isEnglish ? "What medical update or tip would you like to share?" : "আপনি কোনো টিপস বা নতুন তথ্য শেয়ার করতে চান?"}
                  value={newPostCaption}
                  onChange={(e) => setNewPostCaption(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 focus:border-blue-500 focus:outline-none p-3 rounded-xl text-xs font-semibold leading-relaxed"
                />

                {/* Show Preview of Attachments inside Modal */}
                {newPostAttachedImages.length > 0 && (
                  <div className="space-y-2">
                    <span className="text-[9px] font-black text-slate-400 uppercase tracking-widest block font-mono">ATTACHED IMAGE PREVIEWS ({newPostAttachedImages.length})</span>
                    <div className="flex gap-2 overflow-x-auto pb-1">
                      {newPostAttachedImages.map((src, i) => (
                        <div key={i} className="relative h-16 w-16 rounded-xl overflow-hidden border border-slate-200 flex-shrink-0">
                          <img src={src} className="h-full w-full object-cover" alt="preview" />
                          <button 
                            onClick={() => {
                              const updated = [...newPostAttachedImages];
                              updated.splice(i, 1);
                              setNewPostAttachedImages(updated);
                              if (updated.length === 0) setNewPostMediaType('none');
                            }}
                            className="absolute top-1 right-1 bg-black/60 rounded-full p-0.5 text-white"
                          >
                            <X className="h-2.5 w-2.5" />
                          </button>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                {newPostAttachedVideo && (
                  <div className="space-y-2">
                    <span className="text-[9px] font-black text-slate-400 uppercase tracking-widest block font-mono">ATTACHED VIDEO PREVIEW</span>
                    <div className="bg-slate-900 aspect-video rounded-xl flex items-center justify-center p-3 relative border border-slate-200">
                      <div className="text-center text-white z-10">
                        <Video className="h-8 w-8 text-blue-400 mx-auto mb-1.5" />
                        <h6 className="font-extrabold text-[10px] truncate max-w-[200px]">{newPostAttachedVideo.split('/').pop()}</h6>
                        <span className="text-[8px] text-slate-400 block font-mono mt-0.5">Ready to publish</span>
                      </div>
                      <button 
                        onClick={() => {
                          setNewPostAttachedVideo(null);
                          setNewPostMediaType('none');
                        }}
                        className="absolute top-2 right-2 bg-black/60 rounded-full p-1 text-white z-20"
                      >
                        <X className="h-3 w-3" />
                      </button>
                    </div>
                  </div>
                )}
              </div>

              {/* Attachment selector toolbar & post action buttons */}
              <div className="p-3 border-t border-slate-150 bg-slate-50 flex items-center justify-between">
                <div className="flex gap-1.5">
                  {/* Photo selector mock button */}
                  <button 
                    onClick={() => {
                      // Attach standard sample health visuals
                      const images = [
                        'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400&q=80',
                        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400&q=80',
                        'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=400&q=80'
                      ];
                      const nextImg = images[newPostAttachedImages.length % images.length];
                      setNewPostAttachedImages([...newPostAttachedImages, nextImg]);
                      setNewPostMediaType('image');
                      setNewPostAttachedVideo(null); // Clear video
                    }}
                    className="p-2 bg-white hover:bg-slate-100 rounded-xl border border-slate-200 text-emerald-600 flex items-center gap-1 text-[10px] font-black"
                  >
                    <span>🖼️</span> {isEnglish ? 'Photos' : 'ছবি যোগ'}
                  </button>

                  {/* Video selector mock button */}
                  <button 
                    onClick={() => {
                      setNewPostAttachedVideo('/assets/videos/heart_health_tip.mp4');
                      setNewPostMediaType('video');
                      setNewPostAttachedImages([]); // Clear images
                    }}
                    className="p-2 bg-white hover:bg-slate-100 rounded-xl border border-slate-200 text-red-500 flex items-center gap-1 text-[10px] font-black"
                  >
                    <span>🎥</span> {isEnglish ? 'Video' : 'ভিডিও যোগ'}
                  </button>
                </div>

                <button
                  onClick={handleCreatePost}
                  disabled={!newPostCaption.trim() && newPostAttachedImages.length === 0 && !newPostAttachedVideo}
                  className="px-4 py-2 bg-blue-600 hover:bg-blue-700 disabled:bg-slate-200 disabled:text-slate-400 text-white rounded-xl text-xs font-black transition-all shadow-md active:scale-95"
                >
                  {isEnglish ? 'Post' : 'পোস্ট করুন'}
                </button>
              </div>
            </div>
          </div>
        )}

        {/* 4. COMMENTS BOTTOM SHEET OVERLAY */}
        {feedActiveCommentsPost && (() => {
          const activePost = feedPosts.find(p => p.id === feedActiveCommentsPost);
          if (!activePost) return null;

          return (
            <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-xs z-50 flex items-end">
              <div className="bg-white rounded-t-3xl w-full max-h-[85%] flex flex-col shadow-2xl animate-slide-up overflow-hidden">
                <div className="px-4 py-3 border-b border-slate-150 flex items-center justify-between">
                  <h4 className="font-extrabold text-xs text-slate-800">Comments ({activePost.comments.length})</h4>
                  <button 
                    onClick={() => {
                      setFeedActiveCommentsPost(null);
                      setFeedNewCommentText('');
                    }}
                    className="p-1 bg-slate-100 hover:bg-slate-200 rounded-full"
                  >
                    <X className="h-3.5 w-3.5" />
                  </button>
                </div>

                {/* Scrollable list of comments */}
                <div className="flex-1 overflow-y-auto p-4 space-y-3.5">
                  {activePost.comments.length === 0 ? (
                    <div className="text-center py-10 text-slate-400 font-semibold space-y-1">
                      <span className="text-3xl block">💬</span>
                      <p className="text-xs">{isEnglish ? 'No comments yet.' : 'কোনো মন্তব্য নেই।'}</p>
                      <p className="text-[10px] text-slate-300 font-medium">{isEnglish ? 'Start the conversation below!' : 'প্রথম মন্তব্যটি করুন!'}</p>
                    </div>
                  ) : (
                    activePost.comments.map(comm => (
                      <div key={comm.id} className="flex gap-2.5 items-start">
                        <div className="h-8 w-8 rounded-full bg-slate-100 flex items-center justify-center text-sm flex-shrink-0">
                          {comm.authorAvatar}
                        </div>
                        <div className="flex-1 bg-slate-50 border border-slate-100 rounded-2xl p-2.5">
                          <div className="flex items-center gap-1.5 flex-wrap">
                            <strong className="font-extrabold text-[11px] text-slate-800">{comm.authorName}</strong>
                            <span className="text-[8px] font-black uppercase tracking-wider px-1 py-0.2 rounded bg-slate-200/60 text-slate-500 font-mono scale-95">
                              {comm.authorRole}
                            </span>
                            <span className="text-[8px] font-semibold text-slate-400 font-mono ml-auto">{formatTime(comm.timestamp)}</span>
                          </div>
                          <p className="text-[11.5px] text-slate-600 mt-1 leading-normal break-words">{comm.text}</p>
                        </div>
                      </div>
                    ))
                  )}
                </div>

                {/* Persistent input field bottom bar */}
                <div className="p-3 border-t border-slate-150 flex gap-2 items-center bg-slate-50">
                  <input
                    type="text"
                    placeholder={isEnglish ? "Write a comment..." : "একটি মন্তব্য লিখুন..."}
                    value={feedNewCommentText}
                    onChange={(e) => setFeedNewCommentText(e.target.value)}
                    onKeyDown={(e) => {
                      if (e.key === 'Enter') handleAddComment(activePost.id);
                    }}
                    className="flex-1 bg-white border border-slate-200 focus:border-blue-500 focus:outline-none px-3.5 py-2 rounded-xl text-xs font-semibold"
                  />
                  <button 
                    onClick={() => handleAddComment(activePost.id)}
                    className="p-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl shadow active:scale-95 transition-all"
                  >
                    <Send className="h-4 w-4" />
                  </button>
                </div>
              </div>
            </div>
          );
        })()}
      </div>
    );
  };

  const [selectedEhrPatient, setSelectedEhrPatient] = useState<{ id: string; name: string } | null>({ id: 'patient_mock', name: 'Karim Uddin' });
  const [selectedPrescriptionPatient, setSelectedPrescriptionPatient] = useState<{ id: string; name: string } | null>({ id: 'patient_mock', name: 'Karim Uddin' });
  const [doctorNotificationsExpanded, setDoctorNotificationsExpanded] = useState(false);
  const [activeDoctorCall, setActiveDoctorCall] = useState<any | null>(null);
  const [prescriptionComplaints, setPrescriptionComplaints] = useState('');
  const [prescriptionDiagnosis, setPrescriptionDiagnosis] = useState('');
  const [prescriptionAdvice, setPrescriptionAdvice] = useState('');
  const [prescriptionMedicines, setPrescriptionMedicines] = useState<any[]>([
    { name: "Tab. Paracetamol 500mg", dosage: "1+1+1", duration: "3 Days", timing: "After Meal" },
    { name: "Syp. Tuz 100ml", dosage: "2 tsp", duration: "7 Days", timing: "Before Meal" }
  ]);
  const [prescriptionMedInput, setPrescriptionMedInput] = useState('');
  const [prescriptionDosage, setPrescriptionDosage] = useState('1+0+1');
  const [prescriptionDuration, setPrescriptionDuration] = useState('5 Days');
  const [prescriptionTiming, setPrescriptionTiming] = useState('After Meal');
  const [ehrActiveTab, setEhrActiveTab] = useState<'history' | 'allergies' | 'past_rx'>('history');
  const [selectedScheduleDay, setSelectedScheduleDay] = useState('Monday');

  // File explorer tree expands
  const [isLibExpanded, setIsLibExpanded] = useState(true);
  const [isCoreExpanded, setIsCoreExpanded] = useState(true);
  const [isScreensExpanded, setIsScreensExpanded] = useState(true);
  const [isModelsExpanded, setIsModelsExpanded] = useState(true);
  const [isServicesExpanded, setIsServicesExpanded] = useState(true);

  // Local notifications simulation
  const [notification, setNotification] = useState<{ title: string; body: string } | null>(null);

  // Update dynamic clock in simulator
  useEffect(() => {
    const updateClock = () => {
      const now = new Date();
      let hours = now.getHours().toString().padStart(2, '0');
      let minutes = now.getMinutes().toString().padStart(2, '0');
      setCurrentTime(`${hours}:${minutes}`);
    };
    updateClock();
    const timer = setInterval(updateClock, 1000);
    return () => clearInterval(timer);
  }, []);

  // Waiting room automated simulation and video call timer
  useEffect(() => {
    let interval: any;
    if (activeVideoCall) {
      interval = setInterval(() => {
        setActiveVideoCall((prev: any) => {
          if (!prev) return null;
          if (prev.step === 'waiting') {
            const nextTicks = (prev.waitingTicks || 0) + 1;
            let status = "Waiting for doctor";
            let subStatus = "The doctor is wrapping up another consult and will join shortly.";
            let step = 'waiting';
            if (nextTicks === 3) {
              status = "Doctor joined";
              subStatus = "Establishing secure WebRTC peer connection...";
            } else if (nextTicks === 5) {
              status = "Connecting...";
              subStatus = "Handshaking audio/video descriptors...";
            } else if (nextTicks >= 7) {
              step = 'call';
              status = "Connected";
              subStatus = "Secure WebRTC call active.";
            }
            return {
              ...prev,
              waitingTicks: nextTicks,
              status,
              subStatus,
              step
            };
          } else if (prev.step === 'call') {
            return {
              ...prev,
              duration: (prev.duration || 0) + 1
            };
          }
          return prev;
        });
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [activeVideoCall]);

  // Active doctor call duration timer
  useEffect(() => {
    let interval: any;
    if (activeDoctorCall) {
      interval = setInterval(() => {
        setActiveDoctorCall((prev: any) => {
          if (!prev) return null;
          return {
            ...prev,
            duration: (prev.duration || 0) + 1
          };
        });
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [activeDoctorCall]);

  // Simulate splash screen 2-second timeout on load or reload
  useEffect(() => {
    if (flutterScreen === 'splash') {
      setSplashProgress(0);
      const interval = setInterval(() => {
        setSplashProgress(prev => {
          if (prev >= 100) {
            clearInterval(interval);
            setTimeout(() => {
              setFlutterScreen('role_selection');
              triggerNotification(
                'Welcome to Hello Doctor!', 
                'Select a portal below to start exploring telemedicine workflows.'
              );
            }, 300);
            return 100;
          }
          return prev + 5;
        });
      }, 90);
      return () => clearInterval(interval);
    }
  }, [flutterScreen]);

  // Handle local notification trigger simulation
  const triggerNotification = (title: string, body: string) => {
    setNotification({ title, body });
    setTimeout(() => {
      setNotification(null);
    }, 4500);
  };

  const handleCopyCode = () => {
    navigator.clipboard.writeText(FLUTTER_FILES[selectedFileKey].content);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleSelectFile = (key: string) => {
    setSelectedFileKey(key);
    setActiveTab('explorer');
  };

  const handleNavigateToRole = (screen: 'patient_home' | 'doctor_home' | 'pharmacy_home' | 'diagnostic_home') => {
    setFlutterScreen(screen);
    const roleNames: Record<string, string> = {
      patient_home: 'Patient Portal',
      doctor_home: 'Doctor Portal',
      pharmacy_home: 'Pharmacy Portal',
      diagnostic_home: 'Diagnostic Centre'
    };
    triggerNotification(
      `${roleNames[screen]} Connected`,
      `You have successfully navigated into the clinical dashboard of ${roleNames[screen]}.`
    );
  };

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 flex flex-col font-sans selection:bg-blue-500 selection:text-white">
      {/* Dynamic Header */}
      <header className="bg-slate-950/80 backdrop-blur-md border-b border-slate-800 px-6 py-4 sticky top-0 z-50">
        <div className="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="h-10 w-10 bg-blue-600 rounded-xl flex items-center justify-center shadow-lg shadow-blue-500/10">
              <Hospital className="h-6 w-6 text-white" />
            </div>
            <div>
              <h1 className="text-xl font-bold font-display tracking-tight text-white flex items-center gap-2">
                Hello Doctor <span className="text-xs bg-blue-500/10 text-blue-400 font-mono px-2 py-0.5 rounded border border-blue-500/20">Flutter Project v1.0.0</span>
              </h1>
              <p className="text-xs text-slate-400">Professional multi-role Telemedicine App skeleton built & structured</p>
            </div>
          </div>

          {/* Tab selectors */}
          <div className="flex items-center bg-slate-900 border border-slate-800 p-1 rounded-xl gap-1">
            <button
              onClick={() => setActiveTab('simulator')}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                activeTab === 'simulator' 
                  ? 'bg-blue-600 text-white shadow-md shadow-blue-500/10' 
                  : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              <Smartphone className="h-4 w-4" />
              App Simulator
            </button>
            <button
              onClick={() => setActiveTab('explorer')}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                activeTab === 'explorer' 
                  ? 'bg-blue-600 text-white shadow-md shadow-blue-500/10' 
                  : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              <Code className="h-4 w-4" />
              Code Explorer
            </button>
          </div>
        </div>
      </header>

      {/* Main Workspace */}
      <main className="flex-1 max-w-7xl w-full mx-auto p-4 md:p-6 grid grid-cols-1 lg:grid-cols-12 gap-6 items-stretch">
        
        {/* LEFT COLUMN: Flutter Interactive Device Simulator */}
        <section className={`lg:col-span-5 flex flex-col items-center justify-center ${activeTab === 'simulator' ? 'block' : 'hidden lg:flex'}`}>
          <div className="text-center mb-4 hidden lg:block">
            <span className="text-xs font-mono text-slate-400 bg-slate-800/40 px-3 py-1.5 rounded-full border border-slate-800">
              Interactive Live App View (Port 3000)
            </span>
          </div>

          {/* Smartphone Frame Container */}
          <div className="relative w-[345px] h-[700px] bg-slate-950 rounded-[48px] p-3 shadow-2xl border-4 border-slate-800 shadow-blue-500/5 ring-1 ring-slate-800 flex flex-col overflow-hidden">
            
            {/* Dynamic Camera Notch */}
            <div className="absolute top-4 left-1/2 -translate-x-1/2 w-32 h-6 bg-black rounded-full z-50 flex items-center justify-center">
              <div className="w-3 h-3 bg-slate-900 rounded-full border border-slate-800 mr-2"></div>
              <div className="w-1.5 h-1.5 bg-blue-900 rounded-full"></div>
            </div>

            {/* Simulated Device Screen Canvas */}
            <div className="flex-1 rounded-[38px] bg-white text-slate-900 flex flex-col overflow-hidden relative select-none">
              
              {/* Device Status Bar */}
              <div className={`h-11 px-6 flex items-center justify-between text-xs font-medium z-40 ${
                flutterScreen === 'splash' ? 'text-white/80' : 'text-slate-800 bg-slate-100/40 backdrop-blur-sm'
              }`}>
                <span>{currentTime}</span>
                <div className="flex items-center gap-1.5">
                  <Wifi className="h-3.5 w-3.5" />
                  <Battery className="h-4 w-4" />
                </div>
              </div>

              {/* Push Notifications simulation (Sliding Overlay) */}
              <AnimatePresence>
                {notification && (
                  <motion.div
                    initial={{ y: -100, opacity: 0 }}
                    animate={{ y: 0, opacity: 1 }}
                    exit={{ y: -100, opacity: 0 }}
                    className="absolute top-12 left-3 right-3 bg-slate-900/95 backdrop-blur text-white p-3 rounded-2xl shadow-xl z-50 border border-slate-800 flex items-start gap-2.5 cursor-pointer"
                    onClick={() => setNotification(null)}
                  >
                    <div className="p-1.5 bg-blue-600 rounded-lg text-white">
                      <Bell className="h-4 w-4" />
                    </div>
                    <div className="flex-1">
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-bold font-display text-blue-400">LOCAL NOTIFICATION</span>
                        <span className="text-[10px] text-slate-400 font-mono">now</span>
                      </div>
                      <h4 className="text-xs font-semibold mt-0.5 text-white">{notification.title}</h4>
                      <p className="text-[11px] text-slate-300 mt-0.5 leading-normal">{notification.body}</p>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>

              {/* Screens Router Canvas */}
              <div className="flex-1 flex flex-col overflow-y-auto relative bg-slate-50">
                <AnimatePresence mode="wait">
                  
                  {/* SPLASH SCREEN */}
                  {flutterScreen === 'splash' && (
                    <motion.div
                      key="splash"
                      initial={{ opacity: 0 }}
                      animate={{ opacity: 1 }}
                      exit={{ opacity: 0 }}
                      className="absolute inset-0 bg-blue-600 flex flex-col items-center justify-center p-6 text-white z-20"
                    >
                      <div className="flex-1 flex flex-col items-center justify-center">
                        <motion.div 
                          animate={{ scale: [1, 1.05, 1] }}
                          transition={{ repeat: Infinity, duration: 2 }}
                          className="p-6 bg-white/10 rounded-[32px] mb-6 backdrop-blur-sm border border-white/10"
                        >
                          <Hospital className="h-16 w-16 text-white" />
                        </motion.div>
                        <h2 className="text-3xl font-extrabold font-display tracking-tight">Hello Doctor</h2>
                        <p className="text-sm text-white/70 mt-1.5 tracking-wider uppercase font-medium">Telemedicine App</p>
                      </div>

                      <div className="w-full max-w-[200px] mb-12">
                        <div className="h-1 bg-white/20 rounded-full overflow-hidden">
                          <motion.div 
                            className="h-full bg-white" 
                            style={{ width: `${splashProgress}%` }}
                          />
                        </div>
                        <div className="text-center mt-3 text-xs text-white/60 font-mono">Initializing Skeleton...</div>
                      </div>
                    </motion.div>
                  )}

                  {/* ROLE SELECTION SCREEN */}
                  {flutterScreen === 'role_selection' && (
                    <motion.div
                      key="role_selection"
                      initial={{ opacity: 0, x: 20 }}
                      animate={{ opacity: 1, x: 0 }}
                      exit={{ opacity: -20 }}
                      className="flex-1 flex flex-col p-6"
                    >
                      <div className="mt-4 mb-6">
                        <span className="text-xs font-medium text-slate-400">Welcome to</span>
                        <h2 className="text-2xl font-bold font-display text-blue-600 mt-0.5">Hello Doctor</h2>
                        <p className="text-xs text-slate-500 mt-2 leading-relaxed">
                          Please select your portal role to proceed with clinical visits, pharmacy management, or diagnostics.
                        </p>
                      </div>

                      {/* 4 Portals list */}
                      <div className="space-y-3 flex-1">
                        
                        {/* Patient Portal Card */}
                        <button
                          onClick={() => {
                            setPhoneInput('');
                            setNameInput('');
                            setEmailInput('');
                            setPasswordInput('');
                            setOtpSent(false);
                            setOtpInput('');
                            setFlutterScreen('patient_auth');
                          }}
                          className="w-full text-left bg-white p-3.5 rounded-xl border-2 border-slate-100 hover:border-blue-500/30 hover:bg-slate-50/50 transition-all flex items-center gap-3.5 group"
                        >
                          <div className="h-10 w-10 rounded-lg bg-blue-50 flex items-center justify-center text-blue-600 group-hover:scale-105 transition-transform shrink-0">
                            <User className="h-5 w-5" />
                          </div>
                          <div className="flex-1 min-w-0">
                            <h3 className="font-bold text-xs text-slate-800 font-display">Patient Portal</h3>
                            <p className="text-[10px] text-slate-400 truncate">Consult doctors & book lab tests</p>
                          </div>
                          <ChevronRightIcon className="h-4 w-4 text-slate-300 group-hover:text-blue-500 group-hover:translate-x-0.5 transition-all shrink-0" />
                        </button>

                        {/* Doctor Portal Card */}
                        <button
                          onClick={() => {
                            setNameInput('');
                            setEmailInput('');
                            setPasswordInput('');
                            setPhoneInput('');
                            setDoctorBmdc('');
                            setDoctorBio('');
                            setDoctorPhoto(null);
                            setDoctorLicense(null);
                            setFlutterScreen('doctor_register');
                          }}
                          className="w-full text-left bg-white p-3.5 rounded-xl border-2 border-slate-100 hover:border-emerald-500/30 hover:bg-slate-50/50 transition-all flex items-center gap-3.5 group"
                        >
                          <div className="h-10 w-10 rounded-lg bg-emerald-50 flex items-center justify-center text-emerald-600 group-hover:scale-105 transition-transform shrink-0">
                            <Stethoscope className="h-5 w-5" />
                          </div>
                          <div className="flex-1 min-w-0">
                            <h3 className="font-bold text-xs text-slate-800 font-display">Doctor Portal</h3>
                            <p className="text-[10px] text-slate-400 truncate">Prescriptions & patient e-visits</p>
                          </div>
                          <ChevronRightIcon className="h-4 w-4 text-slate-300 group-hover:text-emerald-500 group-hover:translate-x-0.5 transition-all shrink-0" />
                        </button>

                        {/* Pharmacy Portal Card */}
                        <button
                          onClick={() => {
                            setPharmacyName('');
                            setPharmacyOwner('');
                            setPhoneInput('');
                            setEmailInput('');
                            setPasswordInput('');
                            setPharmacyTradeLicense('');
                            setPharmacyAddress('');
                            setPharmacyCity('');
                            setPharmacyLicenseFile(null);
                            setFlutterScreen('pharmacy_register');
                          }}
                          className="w-full text-left bg-white p-3.5 rounded-xl border-2 border-slate-100 hover:border-amber-500/30 hover:bg-slate-50/50 transition-all flex items-center gap-3.5 group"
                        >
                          <div className="h-10 w-10 rounded-lg bg-amber-50 flex items-center justify-center text-amber-600 group-hover:scale-105 transition-transform shrink-0">
                            <Pill className="h-5 w-5" />
                          </div>
                          <div className="flex-1 min-w-0">
                            <h3 className="font-bold text-xs text-slate-800 font-display">Pharmacy Portal</h3>
                            <p className="text-[10px] text-slate-400 truncate">Track prescription medicine dispatch</p>
                          </div>
                          <ChevronRightIcon className="h-4 w-4 text-slate-300 group-hover:text-amber-500 group-hover:translate-x-0.5 transition-all shrink-0" />
                        </button>

                        {/* Diagnostic Centre Card */}
                        <button
                          onClick={() => {
                            setDiagnosticName('');
                            setDiagnosticContact('');
                            setPhoneInput('');
                            setEmailInput('');
                            setPasswordInput('');
                            setDiagnosticLicense('');
                            setDiagnosticAddress('');
                            setDiagnosticCity('');
                            setDiagnosticLicenseFile(null);
                            setFlutterScreen('diagnostic_register');
                          }}
                          className="w-full text-left bg-white p-3.5 rounded-xl border-2 border-slate-100 hover:border-purple-500/30 hover:bg-slate-50/50 transition-all flex items-center gap-3.5 group"
                        >
                          <div className="h-10 w-10 rounded-lg bg-purple-50 flex items-center justify-center text-purple-600 group-hover:scale-105 transition-transform shrink-0">
                            <FlaskConical className="h-5 w-5" />
                          </div>
                          <div className="flex-1 min-w-0">
                            <h3 className="font-bold text-xs text-slate-800 font-display">Diagnostic Centre</h3>
                            <p className="text-[10px] text-slate-400 truncate">Report uploads & diagnostic tests</p>
                          </div>
                          <ChevronRightIcon className="h-4 w-4 text-slate-300 group-hover:text-purple-500 group-hover:translate-x-0.5 transition-all shrink-0" />
                        </button>

                      </div>

                      {/* Admin Access Portal Row */}
                      <div className="mt-4 pt-4 border-t border-slate-100 flex flex-col gap-2">
                        <button
                          onClick={() => {
                            setEmailInput('');
                            setPasswordInput('');
                            setFlutterScreen('admin_login');
                          }}
                          className="w-full py-2.5 bg-slate-100 text-slate-700 rounded-xl text-xs font-semibold hover:bg-slate-200 transition-all flex items-center justify-center gap-2"
                        >
                          <Shield className="h-4 w-4 text-slate-500" />
                          Super Admin Portal Access
                        </button>
                      </div>

                      {/* Footer branding */}
                      <div className="text-center pt-4 border-t border-slate-100 mt-2">
                        <p className="text-[9px] text-slate-400 font-mono tracking-wider">SECURED CLINICAL CORE NODE</p>
                      </div>
                    </motion.div>
                  )}

                  {/* PATIENT AUTH SCREEN */}
                  {flutterScreen === 'patient_auth' && (
                    <motion.div
                      key="patient_auth"
                      initial={{ opacity: 0, x: 20 }}
                      animate={{ opacity: 1, x: 0 }}
                      exit={{ opacity: -20 }}
                      className="flex-1 flex flex-col p-6"
                    >
                      <button 
                        onClick={() => setFlutterScreen('role_selection')}
                        className="self-start flex items-center gap-1.5 text-xs font-semibold text-blue-600 hover:text-blue-700 mb-4 bg-blue-50 px-3 py-1.5 rounded-full transition-all"
                      >
                        <ArrowLeft className="h-3.5 w-3.5" />
                        Back
                      </button>

                      <div className="mb-4">
                        <h2 className="text-xl font-bold font-display text-blue-600">Patient Authentication</h2>
                        <p className="text-xs text-slate-500 mt-1">Sign in instantly via Phone OTP or Email</p>
                      </div>

                      {/* Auth Type Switcher */}
                      <div className="grid grid-cols-2 bg-slate-100 p-1 rounded-lg mb-4">
                        <button
                          onClick={() => { setIsPhoneFlow(true); setOtpSent(false); }}
                          className={`py-1.5 text-xs font-semibold rounded-md transition-all ${isPhoneFlow ? 'bg-white text-blue-600 shadow-sm' : 'text-slate-500'}`}
                        >
                          Phone OTP
                        </button>
                        <button
                          onClick={() => { setIsPhoneFlow(false); setIsEmailSignUp(false); }}
                          className={`py-1.5 text-xs font-semibold rounded-md transition-all ${!isPhoneFlow ? 'bg-white text-blue-600 shadow-sm' : 'text-slate-500'}`}
                        >
                          Email & Pass
                        </button>
                      </div>

                      {isPhoneFlow ? (
                        <div className="space-y-4 flex-1 flex flex-col justify-between">
                          <div className="space-y-3">
                            {!otpSent ? (
                              <>
                                <div className="space-y-1">
                                  <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Mobile Number</label>
                                  <div className="flex gap-2">
                                    <span className="bg-slate-100 border border-slate-200 px-3 py-2 rounded-lg text-xs font-bold text-slate-600 flex items-center">+880</span>
                                    <input
                                      type="tel"
                                      placeholder="01xxxxxxxxx"
                                      value={phoneInput}
                                      onChange={(e) => setPhoneInput(e.target.value)}
                                      className="flex-1 bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-blue-500"
                                    />
                                  </div>
                                </div>
                                
                                <div className="space-y-1">
                                  <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Full Name (New Patients)</label>
                                  <input
                                    type="text"
                                    placeholder="Enter your name"
                                    value={nameInput}
                                    onChange={(e) => setNameInput(e.target.value)}
                                    className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-blue-500"
                                  />
                                </div>

                                <button
                                  onClick={() => {
                                    if (phoneInput.length < 10) {
                                      triggerNotification('Validation Error', 'Please enter a valid mobile number');
                                      return;
                                    }
                                    setOtpSent(true);
                                    triggerNotification('Mock OTP Sent', 'Simulated 6-digit OTP sent to ' + phoneInput + '. Enter any 6-digit code to continue.');
                                  }}
                                  className="w-full py-2.5 bg-blue-600 text-white rounded-xl text-xs font-bold hover:bg-blue-700 transition-all shadow-md shadow-blue-500/10"
                                >
                                  Send Verification OTP
                                </button>
                              </>
                            ) : (
                              <>
                                <div className="bg-blue-50 border border-blue-100 p-3 rounded-xl text-xs text-blue-700">
                                  We simulated sending a 6-digit code to <strong>+880 {phoneInput}</strong>. You may type any 6 digits to bypass.
                                </div>

                                <div className="space-y-1">
                                  <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Enter OTP Verification Code</label>
                                  <input
                                    type="text"
                                    placeholder="123456"
                                    maxLength={6}
                                    value={otpInput}
                                    onChange={(e) => setOtpInput(e.target.value)}
                                    className="w-full bg-white border border-slate-200 tracking-widest text-center py-2.5 rounded-lg text-sm font-bold focus:outline-none focus:border-blue-500"
                                  />
                                </div>

                                <button
                                  onClick={() => {
                                    if (otpInput.length < 6) {
                                      triggerNotification('Validation Error', 'Please enter a 6-digit OTP code.');
                                      return;
                                    }
                                    const patientUser = {
                                      id: 'patient-' + Date.now(),
                                      name: nameInput || 'Anonymous Patient',
                                      phone: phoneInput,
                                      email: emailInput || 'patient@hellodoctor.com',
                                      role: 'patient',
                                      status: 'approved'
                                    };
                                    setUsers(prev => [...prev, patientUser]);
                                    setCurrentUser(patientUser);
                                    setFlutterScreen('patient_home');
                                    triggerNotification('Login Successful', 'Welcome back, ' + patientUser.name);
                                  }}
                                  className="w-full py-2.5 bg-emerald-600 text-white rounded-xl text-xs font-bold hover:bg-emerald-700 transition-all shadow-md shadow-emerald-500/10"
                                >
                                  Verify OTP & Sign In
                                </button>
                              </>
                            )}
                          </div>

                          <div className="pt-4 border-t border-slate-100">
                            <button
                              onClick={() => {
                                const bioUser = {
                                  id: 'patient-bio',
                                  name: 'Karim Uddin',
                                  phone: '01912345678',
                                  email: 'karim@gmail.com',
                                  role: 'patient',
                                  status: 'approved'
                                };
                                setCurrentUser(bioUser);
                                setFlutterScreen('patient_home');
                                triggerNotification('Biometric Sign In', 'Authenticated via fingerprint key successfully!');
                              }}
                              className="w-full py-2.5 bg-slate-900 text-white rounded-xl text-xs font-semibold hover:bg-slate-850 transition-all flex items-center justify-center gap-2"
                            >
                              <Fingerprint className="h-4 w-4 text-emerald-400" />
                              Use Biometric Fingerprint (Quick Test)
                            </button>
                          </div>
                        </div>
                      ) : (
                        <div className="space-y-4">
                          <div className="space-y-3">
                            <div className="space-y-1">
                              <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Email Address</label>
                              <input
                                type="email"
                                placeholder="Enter your email"
                                value={emailInput}
                                onChange={(e) => setEmailInput(e.target.value)}
                                className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-blue-500"
                              />
                            </div>

                            <div className="space-y-1">
                              <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Password</label>
                              <input
                                type="password"
                                placeholder="••••••••"
                                value={passwordInput}
                                onChange={(e) => setPasswordInput(e.target.value)}
                                className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-blue-500"
                              />
                            </div>

                            {isEmailSignUp && (
                              <div className="space-y-1">
                                <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Full Name</label>
                                <input
                                  type="text"
                                  placeholder="Enter your name"
                                  value={nameInput}
                                  onChange={(e) => setNameInput(e.target.value)}
                                  className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-blue-500"
                                />
                              </div>
                            )}

                            <button
                              onClick={() => {
                                if (!emailInput || !passwordInput) {
                                  triggerNotification('Validation Error', 'Please complete email and password fields.');
                                  return;
                                }
                                if (isEmailSignUp) {
                                  const patientUser = {
                                    id: 'patient-' + Date.now(),
                                    name: nameInput || 'New Patient',
                                    phone: '01600000000',
                                    email: emailInput,
                                    role: 'patient',
                                    status: 'approved'
                                  };
                                  setUsers(prev => [...prev, patientUser]);
                                  setCurrentUser(patientUser);
                                  setFlutterScreen('patient_home');
                                  triggerNotification('Registration Successful', 'Welcome, ' + patientUser.name);
                                } else {
                                  // Log in as patient
                                  const existing = users.find(u => u.email === emailInput && u.role === 'patient');
                                  const loggedUser = existing || {
                                    id: 'patient-fallback',
                                    name: 'Patient Fallback',
                                    phone: '01611111111',
                                    email: emailInput,
                                    role: 'patient',
                                    status: 'approved'
                                  };
                                  setCurrentUser(loggedUser);
                                  setFlutterScreen('patient_home');
                                  triggerNotification('Login Successful', 'Welcome, ' + loggedUser.name);
                                }
                              }}
                              className="w-full py-2.5 bg-blue-600 text-white rounded-xl text-xs font-bold hover:bg-blue-700 transition-all shadow-md shadow-blue-500/10"
                            >
                              {isEmailSignUp ? 'Create Patient Account' : 'Log In with Email'}
                            </button>

                            <div className="text-center">
                              <button
                                onClick={() => setIsEmailSignUp(!isEmailSignUp)}
                                className="text-[11px] text-blue-600 hover:underline font-semibold"
                              >
                                {isEmailSignUp ? 'Already have an account? Sign In' : "Don't have an account? Sign Up"}
                              </button>
                            </div>
                          </div>
                        </div>
                      )}
                    </motion.div>
                  )}

                  {/* DOCTOR REGISTER SCREEN */}
                  {flutterScreen === 'doctor_register' && (
                    <motion.div
                      key="doctor_register"
                      initial={{ opacity: 0, x: 20 }}
                      animate={{ opacity: 1, x: 0 }}
                      exit={{ opacity: -20 }}
                      className="flex-1 flex flex-col p-5 overflow-y-auto"
                    >
                      <button 
                        onClick={() => setFlutterScreen('role_selection')}
                        className="self-start flex items-center gap-1.5 text-xs font-semibold text-emerald-600 hover:text-emerald-700 mb-3 bg-emerald-50 px-3 py-1.5 rounded-full transition-all"
                      >
                        <ArrowLeft className="h-3.5 w-3.5" />
                        Back
                      </button>

                      <div className="mb-4">
                        <h2 className="text-xl font-bold font-display text-emerald-600">Doctor Registration</h2>
                        <p className="text-xs text-slate-500">Apply for practicing credentials vetting</p>
                      </div>

                      <div className="space-y-3.5 text-left pb-6">
                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Full Name</label>
                          <input
                            type="text"
                            placeholder="Dr. Name"
                            value={nameInput}
                            onChange={(e) => setNameInput(e.target.value)}
                            className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-emerald-500"
                          />
                        </div>

                        <div className="grid grid-cols-2 gap-2">
                          <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">BMDC License</label>
                            <input
                              type="text"
                              placeholder="BMDC-xxxxx"
                              value={doctorBmdc}
                              onChange={(e) => setDoctorBmdc(e.target.value)}
                              className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-emerald-500"
                            />
                          </div>
                          <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Phone</label>
                            <input
                              type="text"
                              placeholder="01xxxxxxxxx"
                              value={phoneInput}
                              onChange={(e) => setPhoneInput(e.target.value)}
                              className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-emerald-500"
                            />
                          </div>
                        </div>

                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Email Address</label>
                          <input
                            type="email"
                            placeholder="doctor@hellodoctor.com"
                            value={emailInput}
                            onChange={(e) => setEmailInput(e.target.value)}
                            className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-emerald-500"
                          />
                        </div>

                        <div className="grid grid-cols-2 gap-2">
                          <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Specialty</label>
                            <select
                              value={doctorSpecialty}
                              onChange={(e) => setDoctorSpecialty(e.target.value)}
                              className="w-full bg-white border border-slate-200 px-2 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-emerald-500"
                            >
                              <option value="General Medicine">General Medicine</option>
                              <option value="Cardiology">Cardiology</option>
                              <option value="Pediatrics">Pediatrics</option>
                              <option value="Gynecology">Gynecology</option>
                              <option value="Dermatology">Dermatology</option>
                            </select>
                          </div>
                          <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Fee (BDT)</label>
                            <input
                              type="number"
                              value={doctorFee}
                              onChange={(e) => setDoctorFee(e.target.value)}
                              className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-emerald-500"
                            />
                          </div>
                        </div>

                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Short Bio</label>
                          <textarea
                            placeholder="Consultant of medicine..."
                            value={doctorBio}
                            onChange={(e) => setDoctorBio(e.target.value)}
                            rows={2}
                            className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-emerald-500"
                          />
                        </div>

                        {/* File pickers simulations */}
                        <div className="grid grid-cols-2 gap-2 pt-1">
                          <button
                            onClick={() => {
                              setDoctorPhoto('dr_avatar_picked.png');
                              triggerNotification('Mock Image Picked', 'Simulated Picking Profile Picture');
                            }}
                            className={`py-2 border-2 border-dashed rounded-lg text-[10px] font-semibold flex items-center justify-center gap-1 transition-all ${doctorPhoto ? 'border-emerald-500 bg-emerald-50 text-emerald-700' : 'border-slate-200 text-slate-400 hover:bg-slate-50'}`}
                          >
                            <Upload className="h-3 w-3" />
                            {doctorPhoto ? 'Photo Uploaded!' : 'Upload Photo'}
                          </button>
                          <button
                            onClick={() => {
                              setDoctorLicense('mbbscertificate_picked.pdf');
                              triggerNotification('Mock Document Uploaded', 'Simulated Upload of MBBS/BMDC License');
                            }}
                            className={`py-2 border-2 border-dashed rounded-lg text-[10px] font-semibold flex items-center justify-center gap-1 transition-all ${doctorLicense ? 'border-emerald-500 bg-emerald-50 text-emerald-700' : 'border-slate-200 text-slate-400 hover:bg-slate-50'}`}
                          >
                            <File className="h-3 w-3" />
                            {doctorLicense ? 'License Uploaded!' : 'Upload Credentials'}
                          </button>
                        </div>

                        <button
                          onClick={() => {
                            if (!nameInput || !phoneInput || !doctorBmdc) {
                              triggerNotification('Validation Error', 'Please enter Name, Phone, and BMDC license number.');
                              return;
                            }
                            const pendingDoc = {
                              id: 'doctor-' + Date.now(),
                              name: nameInput.startsWith('Dr.') ? nameInput : 'Dr. ' + nameInput,
                              phone: phoneInput,
                              email: emailInput || 'doctor@hellodoctor.com',
                              role: 'doctor',
                              status: 'pending',
                              bmdcNumber: doctorBmdc,
                              specialty: doctorSpecialty,
                              yearsOfExperience: parseInt(doctorExperience),
                              consultationFee: parseFloat(doctorFee),
                              bio: doctorBio || 'Senior medical professional',
                              licenseDocPath: doctorLicense || 'credential_scans.pdf'
                            };
                            setUsers(prev => [...prev, pendingDoc]);
                            setCurrentUser(pendingDoc);
                            setFlutterScreen('pending_approval');
                            triggerNotification('Application Registered', 'Welcome, ' + pendingDoc.name + '! Your profile has been queued for Super Admin approval.');
                          }}
                          className="w-full py-2.5 bg-emerald-600 text-white rounded-xl text-xs font-bold hover:bg-emerald-700 transition-all shadow-md shadow-emerald-500/10 mt-2"
                        >
                          Submit For Verification
                        </button>

                        {/* Fast login tool for testing */}
                        <div className="pt-2 text-center">
                          <button
                            onClick={() => {
                              // Fast log in as the default approved physician or any other approved doctor
                              const approvedDoc = {
                                id: 'doctor-preapproved',
                                name: 'Dr. Sarah Rahman',
                                phone: '01811111111',
                                email: 'sarah.rahman@hellodoctor.com',
                                role: 'doctor',
                                status: 'approved'
                              };
                              setCurrentUser(approvedDoc);
                              setFlutterScreen('doctor_home');
                              triggerNotification('Clinical Login', 'Practice mode initialized for Dr. Sarah Rahman.');
                            }}
                            className="text-[10px] text-emerald-600 font-semibold hover:underline bg-emerald-50 px-3 py-1.5 rounded-full"
                          >
                            ⚡ Bypass Verification (Dr. Sarah Rahman - Approved)
                          </button>
                        </div>

                      </div>
                    </motion.div>
                  )}

                  {/* PHARMACY REGISTER SCREEN */}
                  {flutterScreen === 'pharmacy_register' && (
                    <motion.div
                      key="pharmacy_register"
                      initial={{ opacity: 0, x: 20 }}
                      animate={{ opacity: 1, x: 0 }}
                      exit={{ opacity: -20 }}
                      className="flex-1 flex flex-col p-5 overflow-y-auto"
                    >
                      <button 
                        onClick={() => setFlutterScreen('role_selection')}
                        className="self-start flex items-center gap-1.5 text-xs font-semibold text-amber-600 hover:text-amber-700 mb-3 bg-amber-50 px-3 py-1.5 rounded-full transition-all"
                      >
                        <ArrowLeft className="h-3.5 w-3.5" />
                        Back
                      </button>

                      <div className="mb-4">
                        <h2 className="text-xl font-bold font-display text-amber-600">Pharmacy Registration</h2>
                        <p className="text-xs text-slate-500">Register pharmacy franchise outlet securely</p>
                      </div>

                      <div className="space-y-3.5 text-left pb-6">
                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Pharmacy Name</label>
                          <input
                            type="text"
                            placeholder="Lazz Pharma, etc."
                            value={pharmacyName}
                            onChange={(e) => setPharmacyName(e.target.value)}
                            className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-amber-500"
                          />
                        </div>

                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Owner Full Name</label>
                          <input
                            type="text"
                            placeholder="Owner Name"
                            value={pharmacyOwner}
                            onChange={(e) => setPharmacyOwner(e.target.value)}
                            className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-amber-500"
                          />
                        </div>

                        <div className="grid grid-cols-2 gap-2">
                          <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Trade License No</label>
                            <input
                              type="text"
                              placeholder="TL-xxxx-xxxx"
                              value={pharmacyTradeLicense}
                              onChange={(e) => setPharmacyTradeLicense(e.target.value)}
                              className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-amber-500"
                            />
                          </div>
                          <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Phone</label>
                            <input
                              type="text"
                              placeholder="01xxxxxxxxx"
                              value={phoneInput}
                              onChange={(e) => setPhoneInput(e.target.value)}
                              className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-amber-500"
                            />
                          </div>
                        </div>

                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Email Address</label>
                          <input
                            type="email"
                            placeholder="pharmacy@hellodoctor.com"
                            value={emailInput}
                            onChange={(e) => setEmailInput(e.target.value)}
                            className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-amber-500"
                          />
                        </div>

                        <div className="grid grid-cols-2 gap-2">
                          <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">City</label>
                            <input
                              type="text"
                              placeholder="Dhaka"
                              value={pharmacyCity}
                              onChange={(e) => setPharmacyCity(e.target.value)}
                              className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-amber-500"
                            />
                          </div>
                          <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Address</label>
                            <input
                              type="text"
                              placeholder="Road 10, Banani"
                              value={pharmacyAddress}
                              onChange={(e) => setPharmacyAddress(e.target.value)}
                              className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-amber-500"
                            />
                          </div>
                        </div>

                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Trade License Scans</label>
                          <button
                            onClick={() => {
                              setPharmacyLicenseFile('tradelicense_pdf_scanned.pdf');
                              triggerNotification('Trade License Uploaded', 'Simulated PDF Trade License Attachment successfully.');
                            }}
                            className={`w-full py-2.5 border-2 border-dashed rounded-lg text-[10px] font-semibold flex items-center justify-center gap-1 transition-all ${pharmacyLicenseFile ? 'border-amber-500 bg-amber-50 text-amber-700' : 'border-slate-200 text-slate-400 hover:bg-slate-50'}`}
                          >
                            <Upload className="h-3.5 w-3.5" />
                            {pharmacyLicenseFile ? 'License Upload Successful!' : 'Simulate Trade License PDF Attachment'}
                          </button>
                        </div>

                        <button
                          onClick={() => {
                            if (!pharmacyName || !phoneInput || !pharmacyTradeLicense) {
                              triggerNotification('Validation Error', 'Please complete Pharmacy Name, Phone, and Trade License.');
                              return;
                            }
                            const pendingPharma = {
                              id: 'pharmacy-' + Date.now(),
                              name: pharmacyName,
                              phone: phoneInput,
                              email: emailInput || 'pharmacy@hellodoctor.com',
                              role: 'pharmacy',
                              status: 'pending',
                              ownerName: pharmacyOwner || 'Franchise Partner',
                              tradeLicenseNumber: pharmacyTradeLicense,
                              address: pharmacyAddress,
                              city: pharmacyCity,
                              licenseDocPath: pharmacyLicenseFile || 'tradelicense_banani.pdf'
                            };
                            setUsers(prev => [...prev, pendingPharma]);
                            setCurrentUser(pendingPharma);
                            setFlutterScreen('pending_approval');
                            triggerNotification('Franchise Submitted', 'Onboarding packet queued for vetting review.');
                          }}
                          className="w-full py-2.5 bg-amber-600 text-white rounded-xl text-xs font-bold hover:bg-amber-700 transition-all shadow-md shadow-amber-500/10 mt-2"
                        >
                          Submit Pharmacy Registration
                        </button>

                        <div className="pt-1 text-center">
                          <button
                            onClick={() => {
                              const approvedPharma = {
                                id: 'pharmacy-approved',
                                name: 'Lazz Pharma (Dhanmondi)',
                                role: 'pharmacy',
                                status: 'approved'
                              };
                              setCurrentUser(approvedPharma);
                              setFlutterScreen('pharmacy_home');
                              triggerNotification('Pharmacy Login', 'Active inventory hub connected.');
                            }}
                            className="text-[10px] text-amber-600 font-semibold hover:underline bg-amber-50 px-3 py-1.5 rounded-full"
                          >
                            ⚡ Bypass Verification (Lazz Pharma - Approved)
                          </button>
                        </div>
                      </div>
                    </motion.div>
                  )}

                  {/* DIAGNOSTIC REGISTER SCREEN */}
                  {flutterScreen === 'diagnostic_register' && (
                    <motion.div
                      key="diagnostic_register"
                      initial={{ opacity: 0, x: 20 }}
                      animate={{ opacity: 1, x: 0 }}
                      exit={{ opacity: -20 }}
                      className="flex-1 flex flex-col p-5 overflow-y-auto"
                    >
                      <button 
                        onClick={() => setFlutterScreen('role_selection')}
                        className="self-start flex items-center gap-1.5 text-xs font-semibold text-purple-600 hover:text-purple-700 mb-3 bg-purple-50 px-3 py-1.5 rounded-full transition-all"
                      >
                        <ArrowLeft className="h-3.5 w-3.5" />
                        Back
                      </button>

                      <div className="mb-4">
                        <h2 className="text-xl font-bold font-display text-purple-600">Diagnostic Registration</h2>
                        <p className="text-xs text-slate-500">Apply for laboratory partner clearance</p>
                      </div>

                      <div className="space-y-3.5 text-left pb-6">
                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Diagnostic Centre Name</label>
                          <input
                            type="text"
                            placeholder="Popular Diagnostic, etc."
                            value={diagnosticName}
                            onChange={(e) => setDiagnosticName(e.target.value)}
                            className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-purple-500"
                          />
                        </div>

                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Contact Person Name</label>
                          <input
                            type="text"
                            placeholder="Contact Executive"
                            value={diagnosticContact}
                            onChange={(e) => setDiagnosticContact(e.target.value)}
                            className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-purple-500"
                          />
                        </div>

                        <div className="grid grid-cols-2 gap-2">
                          <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">DGHS License No</label>
                            <input
                              type="text"
                              placeholder="DGHS-xxxxxx"
                              value={diagnosticLicense}
                              onChange={(e) => setDiagnosticLicense(e.target.value)}
                              className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-purple-500"
                            />
                          </div>
                          <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Phone</label>
                            <input
                              type="text"
                              placeholder="01xxxxxxxxx"
                              value={phoneInput}
                              onChange={(e) => setPhoneInput(e.target.value)}
                              className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-purple-500"
                            />
                          </div>
                        </div>

                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Email Address</label>
                          <input
                            type="email"
                            placeholder="lab@hellodoctor.com"
                            value={emailInput}
                            onChange={(e) => setEmailInput(e.target.value)}
                            className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-purple-500"
                          />
                        </div>

                        <div className="grid grid-cols-2 gap-2">
                          <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">City</label>
                            <input
                              type="text"
                              placeholder="Dhaka"
                              value={diagnosticCity}
                              onChange={(e) => setDiagnosticCity(e.target.value)}
                              className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-purple-500"
                            />
                          </div>
                          <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Address</label>
                            <input
                              type="text"
                              placeholder="Plot 15, Uttara"
                              value={diagnosticAddress}
                              onChange={(e) => setDiagnosticAddress(e.target.value)}
                              className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-semibold focus:outline-none focus:border-purple-500"
                            />
                          </div>
                        </div>

                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">DGHS License Clearance Scan</label>
                          <button
                            onClick={() => {
                              setDiagnosticLicenseFile('dghsclearance_scan.pdf');
                              triggerNotification('Clearance Uploaded', 'DGHS validation document simulation successful.');
                            }}
                            className={`w-full py-2.5 border-2 border-dashed rounded-lg text-[10px] font-semibold flex items-center justify-center gap-1 transition-all ${diagnosticLicenseFile ? 'border-purple-500 bg-purple-50 text-purple-700' : 'border-slate-200 text-slate-400 hover:bg-slate-50'}`}
                          >
                            <Upload className="h-3.5 w-3.5" />
                            {diagnosticLicenseFile ? 'DGHS Scan Attached!' : 'Simulate DGHS Scan Upload'}
                          </button>
                        </div>

                        <button
                          onClick={() => {
                            if (!diagnosticName || !phoneInput || !diagnosticLicense) {
                              triggerNotification('Validation Error', 'Please complete Center Name, Phone, and DGHS License Number.');
                              return;
                            }
                            const pendingDiag = {
                              id: 'diagnostic-' + Date.now(),
                              name: diagnosticName,
                              phone: phoneInput,
                              email: emailInput || 'lab@hellodoctor.com',
                              role: 'diagnostic',
                              status: 'pending',
                              contactPerson: diagnosticContact || 'Clearance Officer',
                              licenseNumber: diagnosticLicense,
                              address: diagnosticAddress,
                              city: diagnosticCity,
                              licenseDocPath: diagnosticLicenseFile || 'dghs_clearance_verified.pdf'
                            };
                            setUsers(prev => [...prev, pendingDiag]);
                            setCurrentUser(pendingDiag);
                            setFlutterScreen('pending_approval');
                            triggerNotification('Lab Applied', 'Clinical diagnostics clearance registered.');
                          }}
                          className="w-full py-2.5 bg-purple-600 text-white rounded-xl text-xs font-bold hover:bg-purple-700 transition-all shadow-md shadow-purple-500/10 mt-2"
                        >
                          Submit Lab Registration
                        </button>

                        <div className="pt-1 text-center">
                          <button
                            onClick={() => {
                              const approvedDiag = {
                                id: 'diagnostic-approved',
                                name: 'Popular Lab (Uttara)',
                                role: 'diagnostic',
                                status: 'approved'
                              };
                              setCurrentUser(approvedDiag);
                              setFlutterScreen('diagnostic_home');
                              triggerNotification('Diagnostic Login', 'Active laboratory workspace ready.');
                            }}
                            className="text-[10px] text-purple-600 font-semibold hover:underline bg-purple-50 px-3 py-1.5 rounded-full"
                          >
                            ⚡ Bypass Verification (Popular Lab - Approved)
                          </button>
                        </div>
                      </div>
                    </motion.div>
                  )}

                  {/* PENDING APPROVAL SCREEN */}
                  {flutterScreen === 'pending_approval' && (
                    <motion.div
                      key="pending_approval"
                      initial={{ opacity: 0, scale: 0.95 }}
                      animate={{ opacity: 1, scale: 1 }}
                      exit={{ opacity: 0 }}
                      className="flex-1 flex flex-col p-6 items-center justify-center text-center bg-white"
                    >
                      <div className="h-16 w-16 bg-amber-50 rounded-full flex items-center justify-center text-amber-500 mb-4 animate-bounce">
                        <Lock className="h-8 w-8" />
                      </div>
                      
                      <h3 className="text-lg font-bold text-slate-800 font-display">Vetting Review Pending</h3>
                      <p className="text-[11px] bg-amber-100 text-amber-700 font-mono font-bold px-2.5 py-0.5 rounded-full mt-1.5 uppercase tracking-wide">PENDING SUPER ADMIN APPROVAL</p>
                      
                      <p className="text-xs text-slate-500 mt-4 leading-relaxed max-w-xs">
                        Hello, <strong>{currentUser?.name || 'Partner'}</strong>! Thank you for registering. Your professional clinical credentials are currently under verification by our team.
                      </p>

                      <div className="w-full bg-slate-50 border border-slate-150 p-3.5 rounded-xl text-left mt-5 space-y-2">
                        <div className="text-[9px] font-bold text-slate-400 font-mono uppercase">Your Account Details</div>
                        <div className="text-xs text-slate-600 flex justify-between"><span className="text-slate-400">Role:</span> <span className="font-bold text-slate-700 capitalize">{currentUser?.role}</span></div>
                        <div className="text-xs text-slate-600 flex justify-between"><span className="text-slate-400">Phone:</span> <span className="font-semibold text-slate-700">{currentUser?.phone}</span></div>
                        {currentUser?.bmdcNumber && <div className="text-xs text-slate-600 flex justify-between"><span className="text-slate-400">BMDC No:</span> <span className="font-mono text-slate-700">{currentUser?.bmdcNumber}</span></div>}
                        {currentUser?.tradeLicenseNumber && <div className="text-xs text-slate-600 flex justify-between"><span className="text-slate-400">Trade Lic:</span> <span className="font-mono text-slate-700">{currentUser?.tradeLicenseNumber}</span></div>}
                        {currentUser?.licenseNumber && <div className="text-xs text-slate-600 flex justify-between"><span className="text-slate-400">DGHS Lic:</span> <span className="font-mono text-slate-700">{currentUser?.licenseNumber}</span></div>}
                      </div>

                      <div className="bg-blue-50/70 border border-blue-100 p-3 rounded-xl text-[10px] text-blue-700 font-medium text-left mt-4 flex items-start gap-1.5">
                        <span>💡</span>
                        <span><strong>Tip:</strong> Click on <strong>"Super Admin Portal Access"</strong> in the main screen to instantly approve this partner profile!</span>
                      </div>

                      <button
                        onClick={() => {
                          setCurrentUser(null);
                          setFlutterScreen('role_selection');
                          triggerNotification('Session Logged Out', 'Returned to Role Selection');
                        }}
                        className="w-full py-2.5 bg-slate-800 text-white rounded-xl text-xs font-semibold hover:bg-slate-900 transition-all mt-6 flex items-center justify-center gap-1.5"
                      >
                        <LogOut className="h-3.5 w-3.5" />
                        Log Out & Return
                      </button>
                    </motion.div>
                  )}

                  {/* ADMIN LOGIN SCREEN */}
                  {flutterScreen === 'admin_login' && (
                    <motion.div
                      key="admin_login"
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      exit={{ opacity: -20 }}
                      className="flex-1 flex flex-col p-6 justify-center"
                    >
                      <button 
                        onClick={() => setFlutterScreen('role_selection')}
                        className="self-start flex items-center gap-1.5 text-xs font-semibold text-slate-600 hover:text-slate-700 mb-6 bg-slate-50 px-3 py-1.5 rounded-full transition-all"
                      >
                        <ArrowLeft className="h-3.5 w-3.5" />
                        Cancel
                      </button>

                      <div className="mb-6">
                        <div className="h-12 w-12 bg-slate-900 text-white rounded-xl flex items-center justify-center mb-3">
                          <Shield className="h-6 w-6" />
                        </div>
                        <h2 className="text-xl font-bold font-display text-slate-800">Super Admin Portal</h2>
                        <p className="text-xs text-slate-500">Sign in with administrative credentials</p>
                      </div>

                      <div className="space-y-4">
                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Email</label>
                          <input
                            type="email"
                            value={emailInput}
                            onChange={(e) => setEmailInput(e.target.value)}
                            placeholder="admin@hellodoctor.com"
                            className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-mono font-semibold focus:outline-none focus:border-slate-800"
                          />
                        </div>

                        <div className="space-y-1">
                          <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Password</label>
                          <input
                            type="password"
                            value={passwordInput}
                            onChange={(e) => setPasswordInput(e.target.value)}
                            placeholder="admin123"
                            className="w-full bg-white border border-slate-200 px-3 py-2 rounded-lg text-xs font-mono font-semibold focus:outline-none focus:border-slate-800"
                          />
                        </div>

                        <button
                          onClick={() => {
                            if (emailInput === 'admin@hellodoctor.com' && passwordInput === 'admin123') {
                              const adminUser = users.find(u => u.role === 'admin') || {
                                id: 'admin-001',
                                name: 'Super Admin',
                                email: 'admin@hellodoctor.com',
                                role: 'admin'
                              };
                              setCurrentUser(adminUser);
                              setFlutterScreen('admin_home');
                              triggerNotification('Admin Authorized', 'Super Admin session initiated successfully.');
                            } else {
                              triggerNotification('Access Denied', 'Invalid Super Admin credentials. Hint: admin@hellodoctor.com / admin123');
                            }
                          }}
                          className="w-full py-2.5 bg-slate-900 text-white rounded-xl text-xs font-bold hover:bg-black transition-all shadow-md shadow-slate-500/10 mt-2"
                        >
                          Log In to Console
                        </button>

                        <div className="bg-slate-50 p-2.5 border border-slate-150 rounded-lg text-[10px] text-slate-500 leading-normal">
                          🔑 <strong>Admin Credentials:</strong><br />
                          Email: <code className="bg-slate-100 px-1 py-0.5 rounded text-slate-700">admin@hellodoctor.com</code><br />
                          Password: <code className="bg-slate-100 px-1 py-0.5 rounded text-slate-700">admin123</code>
                        </div>
                      </div>
                    </motion.div>
                  )}

                  {/* ADMIN HOME SCREEN */}
                  {flutterScreen === 'admin_home' && (
                    <motion.div
                      key="admin_home"
                      initial={{ opacity: 0 }}
                      animate={{ opacity: 1 }}
                      exit={{ opacity: 0 }}
                      className="flex-1 flex flex-col h-full bg-slate-900 text-slate-100 overflow-hidden font-sans"
                    >
                      {/* Top Admin Header Bar */}
                      <div className="flex items-center justify-between border-b border-slate-800 bg-slate-950 p-4 shrink-0 shadow-md">
                        <div className="flex items-center gap-2">
                          <div className="h-8 w-8 bg-blue-600 text-white rounded-lg flex items-center justify-center font-bold shadow-md shadow-blue-500/20">
                            <Shield className="h-4 w-4" />
                          </div>
                          <div>
                            <h2 className="text-sm font-black font-display text-white tracking-wider uppercase">Super Admin Panel</h2>
                            <p className="text-[10px] text-emerald-400 font-mono flex items-center gap-1">
                              <span className="h-1.5 w-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                              Platform Console Active
                            </p>
                          </div>
                        </div>
                        <button
                          onClick={() => {
                            setCurrentUser(null);
                            setFlutterScreen('role_selection');
                            triggerNotification('Console Session Exited', 'Logged out of Super Admin Portal.');
                          }}
                          className="text-[10px] font-bold text-red-400 bg-red-950/40 border border-red-900/40 hover:bg-red-900/50 px-3 py-1.5 rounded-lg transition-all"
                        >
                          Sign Out
                        </button>
                      </div>

                      {/* Main Scrollable Admin Workspace Area */}
                      <div className="flex-1 flex flex-col overflow-y-auto bg-slate-900">
                        
                        {/* 1. ADMIN HOME DASHBOARD TAB */}
                        {adminTab === 'dashboard' && (
                          <div className="p-4 space-y-4 animate-fadeIn">
                            {/* Welcome administrative banner */}
                            <div className="bg-gradient-to-r from-blue-900/40 to-indigo-900/30 border border-blue-800/40 p-4 rounded-xl shadow-sm">
                              <h3 className="text-sm font-bold text-white font-display">Administrative Overview</h3>
                              <p className="text-xs text-slate-400 mt-1 leading-normal">
                                Welcome, <strong>Super Admin</strong>. You have complete management over clinical verification queues, user directory locks, system configurations, and feed publications.
                              </p>
                            </div>

                            {/* STATISTICS METRICS GRID */}
                            <div className="grid grid-cols-2 gap-3">
                              <div className="bg-slate-950 border border-slate-800 p-3 rounded-xl">
                                <div className="text-slate-400 text-[10px] uppercase font-bold tracking-wider">Total Patients</div>
                                <div className="text-xl font-black text-blue-400 font-display mt-1">
                                  {users.filter(u => u.role === 'patient').length}
                                </div>
                                <div className="text-[9px] text-slate-500 mt-1">Simulated database profiles</div>
                              </div>

                              <div className="bg-slate-950 border border-slate-800 p-3 rounded-xl">
                                <div className="text-slate-400 text-[10px] uppercase font-bold tracking-wider">Total Doctors</div>
                                <div className="text-xl font-black text-emerald-400 font-display mt-1">
                                  {users.filter(u => u.role === 'doctor' && u.status === 'approved').length}
                                </div>
                                <div className="text-[9px] text-emerald-500/80 font-mono mt-1">
                                  + {users.filter(u => u.role === 'doctor' && u.status === 'pending').length} pending approval
                                </div>
                              </div>

                              <div className="bg-slate-950 border border-slate-800 p-3 rounded-xl">
                                <div className="text-slate-400 text-[10px] uppercase font-bold tracking-wider">Total Pharmacies</div>
                                <div className="text-xl font-black text-amber-400 font-display mt-1">
                                  {users.filter(u => u.role === 'pharmacy' && u.status === 'approved').length}
                                </div>
                                <div className="text-[9px] text-amber-500/80 font-mono mt-1">
                                  + {users.filter(u => u.role === 'pharmacy' && u.status === 'pending').length} pending vetting
                                </div>
                              </div>

                              <div className="bg-slate-950 border border-slate-800 p-3 rounded-xl">
                                <div className="text-slate-400 text-[10px] uppercase font-bold tracking-wider">Total Diagnostics</div>
                                <div className="text-xl font-black text-purple-400 font-display mt-1">
                                  {users.filter(u => u.role === 'diagnostic' && u.status === 'approved').length}
                                </div>
                                <div className="text-[9px] text-purple-500/80 font-mono mt-1">
                                  + {users.filter(u => u.role === 'diagnostic' && u.status === 'pending').length} pending DGHS verify
                                </div>
                              </div>

                              <div className="bg-slate-950 border border-amber-900/50 p-3 rounded-xl">
                                <div className="text-amber-400 text-[10px] uppercase font-bold tracking-wider">Pending Approvals</div>
                                <div className="text-xl font-black text-amber-500 font-display mt-1 animate-pulse">
                                  {users.filter(u => u.status === 'pending').length}
                                </div>
                                <div className="text-[9px] text-slate-500 mt-1">Credentials pending vetting</div>
                              </div>

                              <div className="bg-slate-950 border border-slate-800 p-3 rounded-xl">
                                <div className="text-slate-400 text-[10px] uppercase font-bold tracking-wider">Today's Revenue</div>
                                <div className="text-xl font-black text-white font-display mt-1">
                                  BDT 28,450
                                </div>
                                <div className="text-[9px] text-slate-400 font-mono mt-1">
                                  Platform Cut ({commissionPercentage}%): <span className="text-emerald-400">BDT {Math.floor(28450 * (commissionPercentage / 100))}</span>
                                </div>
                              </div>
                            </div>

                            {/* Requirement 10: ADMIN POST TO SOCIAL HEALTH FEED */}
                            <div className="bg-slate-950 border border-slate-800 p-4 rounded-xl space-y-3">
                              <div className="flex items-center gap-1.5 text-xs font-bold text-white uppercase tracking-wider font-display">
                                <Plus className="h-4 w-4 text-blue-500" />
                                Post to Public Health Feed
                              </div>
                              <p className="text-[10px] text-slate-400 leading-normal">
                                Publish clinical articles, platform updates, or warnings. Admin posts are pinned and marked with an official blue badge in the patient/doctor dashboard.
                              </p>
                              <div>
                                <textarea
                                  id="admin-feed-text"
                                  placeholder="Write a health alert, lifestyle tip, or system bulletin..."
                                  className="w-full bg-slate-900 border border-slate-800 focus:border-blue-500 focus:outline-none rounded-lg p-2.5 text-xs text-slate-200 resize-none h-20 placeholder:text-slate-600 font-medium"
                                />
                                <button
                                  onClick={() => {
                                    const textarea = document.getElementById('admin-feed-text') as HTMLTextAreaElement;
                                    const text = textarea?.value;
                                    if (!text || !text.trim()) return;
                                    
                                    const newPost = {
                                      id: `feed-post-admin-${Date.now()}`,
                                      authorId: 'admin-001',
                                      authorName: 'Official Hello Doctor Admin',
                                      authorRole: 'System Administrator',
                                      authorAvatar: '🛡️',
                                      content: text,
                                      mediaUrls: [],
                                      mediaType: 'none',
                                      timestamp: new Date().toISOString(),
                                      likedByUids: [],
                                      comments: []
                                    };
                                    setFeedPosts(prev => [newPost, ...prev]);
                                    setAuditLogs(prev => [
                                      { id: `log-${Date.now()}`, action: `Super Admin published health bulletin to feed`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                      ...prev
                                    ]);
                                    textarea.value = '';
                                    triggerNotification('Bulletin Published!', 'Your post has been broadcasted to all users health feeds.');
                                  }}
                                  className="w-full mt-2 py-2 bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white rounded-lg text-xs font-bold transition-all shadow-md shadow-blue-900/20"
                                >
                                  Publish Official Bulletin
                                </button>
                              </div>
                            </div>
                          </div>
                        )}

                        {/* 2. PENDING APPROVALS SCREEN */}
                        {adminTab === 'approvals' && (
                          <div className="p-4 space-y-4 animate-fadeIn">
                            <div className="flex items-center justify-between">
                              <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider">Pending Registrations</h3>
                              <span className="text-[10px] bg-amber-950 text-amber-400 border border-amber-900 px-2 py-0.5 rounded-full font-bold font-mono">
                                {users.filter(u => u.status === 'pending').length} Action Required
                              </span>
                            </div>

                            {/* Tab Selection */}
                            <div className="grid grid-cols-3 gap-1 bg-slate-950 border border-slate-800 p-1 rounded-lg">
                              {(['doctor', 'pharmacy', 'diagnostic'] as const).map((role) => (
                                <button
                                  key={role}
                                  onClick={() => setApprovalsRoleTab(role)}
                                  className={`py-1.5 rounded-md text-[10px] font-bold capitalize transition-all ${
                                    approvalsRoleTab === role 
                                      ? 'bg-blue-600 text-white shadow-sm' 
                                      : 'text-slate-400 hover:text-slate-200'
                                  }`}
                                >
                                  {role === 'diagnostic' ? 'Labs/Diag' : role + 's'}
                                </button>
                              ))}
                            </div>

                            {/* Registration List */}
                            <div className="space-y-3">
                              {users.filter(u => u.status === 'pending' && u.role === approvalsRoleTab).length === 0 ? (
                                <div className="bg-slate-950 border border-slate-800 rounded-xl p-6 text-center text-xs text-slate-400">
                                  <CheckCircle className="h-8 w-8 text-emerald-400 mx-auto mb-2" />
                                  No pending {approvalsRoleTab} applications in this queue.
                                </div>
                              ) : (
                                users.filter(u => u.status === 'pending' && u.role === approvalsRoleTab).map((item) => (
                                  <div key={item.id} className="bg-slate-950 border border-slate-800 rounded-xl p-3.5 space-y-3 shadow-sm">
                                    <div className="flex justify-between items-start border-b border-slate-900 pb-2">
                                      <div>
                                        <h4 className="text-xs font-bold text-white">{item.name}</h4>
                                        <p className="text-[10px] text-slate-400 font-mono mt-0.5">ID: {item.id}</p>
                                      </div>
                                      <span className="text-[9px] font-extrabold bg-blue-950 text-blue-400 border border-blue-900 px-2 py-0.5 rounded font-mono uppercase">
                                        {item.role}
                                      </span>
                                    </div>

                                    {/* Application submitted info rows */}
                                    <div className="text-[10px] text-slate-300 space-y-1 bg-slate-900 p-2.5 rounded-lg border border-slate-800/60 font-medium">
                                      <div className="flex justify-between"><span className="text-slate-500">Email:</span> <span>{item.email}</span></div>
                                      <div className="flex justify-between"><span className="text-slate-500">Phone:</span> <span>{item.phone}</span></div>
                                      
                                      {item.bmdcNumber && <div className="flex justify-between"><span className="text-slate-500">BMDC License:</span> <span className="font-mono text-emerald-400 font-bold">{item.bmdcNumber}</span></div>}
                                      {item.specialty && <div className="flex justify-between"><span className="text-slate-500">Specialty:</span> <span className="font-bold">{item.specialty}</span></div>}
                                      {item.yearsOfExperience && <div className="flex justify-between"><span className="text-slate-500">Experience:</span> <span>{item.yearsOfExperience} Years</span></div>}
                                      {item.consultationFee && <div className="flex justify-between"><span className="text-slate-500">Consultation Fee:</span> <span className="text-blue-400 font-bold">BDT {item.consultationFee}</span></div>}
                                      
                                      {item.ownerName && <div className="flex justify-between"><span className="text-slate-500">Owner Name:</span> <span>{item.ownerName}</span></div>}
                                      {item.tradeLicenseNumber && <div className="flex justify-between"><span className="text-slate-500">Trade Lic:</span> <span className="font-mono text-emerald-400">{item.tradeLicenseNumber}</span></div>}
                                      
                                      {item.contactPerson && <div className="flex justify-between"><span className="text-slate-500">Contact Person:</span> <span>{item.contactPerson}</span></div>}
                                      {item.licenseNumber && <div className="flex justify-between"><span className="text-slate-500">DGHS License:</span> <span className="font-mono text-emerald-400">{item.licenseNumber}</span></div>}
                                      
                                      {item.address && <div className="flex justify-between"><span className="text-slate-500">Address:</span> <span className="text-right max-w-[150px] truncate">{item.address}, {item.city}</span></div>}

                                      {/* Simulated License Doc Viewer */}
                                      <div className="pt-2 mt-2 border-t border-slate-800 flex items-center justify-between text-blue-400">
                                        <span className="text-[9px] flex items-center gap-1">
                                          <FileText className="h-3.5 w-3.5" />
                                          Attached: {item.licenseDocPath || 'licence_scan.pdf'}
                                        </span>
                                        <button 
                                          onClick={() => {
                                            alert(`Viewing File: ${item.licenseDocPath || 'license_scan.pdf'}\n\nClinical Audit Checklist:\n- Verified with Government Database: YES\n- Date Verified: July 2026\n- Security Signature: MATCHED`);
                                          }}
                                          className="text-[9px] font-bold text-blue-500 bg-blue-950 px-2 py-0.5 rounded border border-blue-900 hover:bg-blue-900 hover:text-white transition-all"
                                        >
                                          Preview Document
                                        </button>
                                      </div>
                                    </div>

                                    {/* Action Buttons */}
                                    <div className="grid grid-cols-2 gap-2">
                                      <button
                                        onClick={() => {
                                          const applicantName = item.name;
                                          setUsers(prev => prev.filter(u => u.id !== item.id));
                                          setAuditLogs(prev => [
                                            { id: `log-${Date.now()}`, action: `Rejected & Denied application for ${applicantName}`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                            ...prev
                                          ]);
                                          triggerNotification('Application Denied', `Rejected and deleted registration for ${applicantName}`);
                                        }}
                                        className="py-1.5 bg-red-950/40 hover:bg-red-900/30 text-red-400 text-xs font-bold rounded-lg transition-all border border-red-900/50"
                                      >
                                        Deny & Reject
                                      </button>
                                      <button
                                        onClick={() => {
                                          setUsers(prev => prev.map(u => u.id === item.id ? { ...u, status: 'approved' } : u));
                                          setAuditLogs(prev => [
                                            { id: `log-${Date.now()}`, action: `Approved Application: ${item.name} (${item.role.toUpperCase()})`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                            ...prev
                                          ]);
                                          triggerNotification('Partner Approved!', `${item.name} is now approved and active on the network!`);
                                        }}
                                        className="py-1.5 bg-emerald-600 hover:bg-emerald-700 active:bg-emerald-800 text-white text-xs font-bold rounded-lg transition-all shadow-md shadow-emerald-900/20"
                                      >
                                        Approve & Activate
                                      </button>
                                    </div>
                                  </div>
                                ))
                              )}
                            </div>
                          </div>
                        )}

                        {/* 3. USER MANAGEMENT SCREEN */}
                        {adminTab === 'users' && (
                          <div className="p-4 space-y-4 animate-fadeIn">
                            {/* Search and filter toolbar */}
                            <div className="space-y-2">
                              <div className="relative">
                                <Search className="absolute left-2.5 top-2.5 h-3.5 w-3.5 text-slate-500" />
                                <input
                                  type="text"
                                  placeholder="Search by name, email, or phone..."
                                  value={adminUserSearch}
                                  onChange={(e) => setAdminUserSearch(e.target.value)}
                                  className="w-full bg-slate-950 border border-slate-800 focus:border-blue-500 focus:outline-none rounded-xl pl-8.5 pr-3 py-2 text-xs text-slate-200 placeholder:text-slate-600"
                                />
                              </div>

                              <div className="flex items-center gap-1.5 overflow-x-auto pb-1">
                                {(['all', 'patient', 'doctor', 'pharmacy', 'diagnostic'] as const).map((filter) => (
                                  <button
                                    key={filter}
                                    onClick={() => setAdminUserRoleFilter(filter)}
                                    className={`px-3 py-1 rounded-full text-[10px] font-bold uppercase shrink-0 transition-all ${
                                      adminUserRoleFilter === filter 
                                        ? 'bg-blue-600 text-white border border-blue-500' 
                                        : 'bg-slate-950 text-slate-400 border border-slate-800 hover:text-slate-200'
                                    }`}
                                  >
                                    {filter === 'all' ? 'All Roles' : filter === 'diagnostic' ? 'Labs' : filter + 's'}
                                  </button>
                                ))}
                              </div>
                            </div>

                            {/* User Profile List */}
                            <div className="space-y-2.5 max-h-[400px] overflow-y-auto">
                              {users.filter(u => {
                                const matchesSearch = u.name.toLowerCase().includes(adminUserSearch.toLowerCase()) || 
                                                      u.email.toLowerCase().includes(adminUserSearch.toLowerCase()) || 
                                                      u.phone.includes(adminUserSearch);
                                const matchesRole = adminUserRoleFilter === 'all' || u.role === adminUserRoleFilter;
                                return matchesSearch && matchesRole && u.role !== 'admin';
                              }).map((u) => (
                                <div key={u.id} className="bg-slate-950 border border-slate-800 rounded-xl p-3 space-y-2.5 transition-all hover:border-slate-700">
                                  <div className="flex items-start justify-between">
                                    <div className="flex items-center gap-2.5">
                                      <div className={`h-8 w-8 rounded-full flex items-center justify-center font-bold text-xs ${
                                        u.role === 'doctor' ? 'bg-emerald-950 text-emerald-400 border border-emerald-800' :
                                        u.role === 'pharmacy' ? 'bg-amber-950 text-amber-400 border border-amber-800' :
                                        u.role === 'diagnostic' ? 'bg-purple-950 text-purple-400 border border-purple-800' :
                                        'bg-blue-950 text-blue-400 border border-blue-800'
                                      }`}>
                                        {u.role === 'doctor' ? 'Dr' : u.role === 'pharmacy' ? 'Ph' : u.role === 'diagnostic' ? 'Dx' : 'Pt'}
                                      </div>
                                      <div>
                                        <h4 className="text-xs font-bold text-white flex items-center gap-1.5">
                                          {u.name}
                                          {u.status === 'suspended' && (
                                            <span className="text-[8px] bg-red-950 text-red-500 px-1.5 py-0.2 rounded font-black border border-red-900/60 font-mono uppercase">
                                              SUSPENDED
                                            </span>
                                          )}
                                        </h4>
                                        <p className="text-[9px] text-slate-500 font-mono">Role: <span className="uppercase">{u.role}</span> | {u.phone}</p>
                                      </div>
                                    </div>

                                    {/* Action lock suspension triggers */}
                                    <div className="flex items-center gap-1">
                                      <button
                                        onClick={() => {
                                          setSelectedAdminUser(u);
                                          setShowAdminUserEditModal(true);
                                        }}
                                        className="text-[9px] font-bold text-blue-400 bg-blue-950/40 border border-blue-900/40 hover:bg-blue-900/40 p-1 rounded transition-all"
                                        title="Edit Profile"
                                      >
                                        <Edit className="h-3 w-3" />
                                      </button>
                                      <button
                                        onClick={() => {
                                          const newStatus = u.status === 'suspended' ? 'approved' : 'suspended';
                                          setUsers(prev => prev.map(item => item.id === u.id ? { ...item, status: newStatus } : item));
                                          
                                          setAuditLogs(prev => [
                                            { 
                                              id: `log-${Date.now()}`, 
                                              action: `${newStatus === 'suspended' ? 'Suspended' : 'Reactivated'} account of ${u.name}`, 
                                              user: 'Super Admin', 
                                              timestamp: new Date().toLocaleString() 
                                            },
                                            ...prev
                                          ]);
                                          
                                          triggerNotification(
                                            newStatus === 'suspended' ? 'Account Suspended!' : 'Account Reactivated!', 
                                            `${u.name} account status successfully locked/unlocked.`
                                          );
                                        }}
                                        className={`text-[9px] font-bold p-1 rounded transition-all ${
                                          u.status === 'suspended' 
                                            ? 'text-emerald-400 bg-emerald-950/40 border border-emerald-900/40 hover:bg-emerald-900/40' 
                                            : 'text-red-400 bg-red-950/40 border border-red-900/40 hover:bg-red-900/40'
                                        }`}
                                        title={u.status === 'suspended' ? 'Reactivate' : 'Suspend Account'}
                                      >
                                        {u.status === 'suspended' ? <Check className="h-3 w-3" /> : <Ban className="h-3 w-3" />}
                                      </button>
                                    </div>
                                  </div>

                                  <div className="text-[10px] text-slate-400 space-y-1 bg-slate-900 p-2 rounded border border-slate-800/40">
                                    <div className="flex justify-between"><span>Email Address:</span> <span className="text-white font-mono">{u.email}</span></div>
                                    {u.bmdcNumber && <div className="flex justify-between"><span>BMDC Code:</span> <span className="text-white font-mono">{u.bmdcNumber}</span></div>}
                                    {u.tradeLicenseNumber && <div className="flex justify-between"><span>Trade License:</span> <span className="text-white font-mono">{u.tradeLicenseNumber}</span></div>}
                                    {u.licenseNumber && <div className="flex justify-between"><span>DGHS License:</span> <span className="text-white font-mono">{u.licenseNumber}</span></div>}
                                    {u.address && <div className="flex justify-between"><span>Location:</span> <span className="text-white max-w-[150px] truncate">{u.address}, {u.city}</span></div>}
                                  </div>
                                </div>
                              ))}
                            </div>
                          </div>
                        )}

                        {/* 4. GLOBAL SETTINGS SCREEN */}
                        {adminTab === 'settings' && (
                          <div className="p-4 space-y-4 animate-fadeIn overflow-y-auto max-h-[440px]">
                            
                            {/* A. FEE & COMMISSION EDITOR */}
                            <div className="bg-slate-950 border border-slate-800 p-3.5 rounded-xl space-y-3">
                              <h4 className="text-xs font-bold text-white uppercase tracking-wider font-display flex items-center gap-1.5">
                                <Sliders className="h-4 w-4 text-blue-500" />
                                Fee & Commission Setup
                              </h4>
                              <div className="space-y-2 text-xs">
                                <div>
                                  <label className="text-slate-400 block mb-1">Default Consultation Fee Range (BDT)</label>
                                  <div className="grid grid-cols-2 gap-2">
                                    <div>
                                      <span className="text-[9px] text-slate-500 block mb-0.5">Minimum Fee</span>
                                      <input
                                        type="number"
                                        value={consultationFeeRange.min}
                                        onChange={(e) => setConsultationFeeRange(prev => ({ ...prev, min: parseInt(e.target.value) || 0 }))}
                                        className="w-full bg-slate-900 border border-slate-800 rounded px-2.5 py-1.5 text-xs text-slate-200 focus:outline-none focus:border-blue-500"
                                      />
                                    </div>
                                    <div>
                                      <span className="text-[9px] text-slate-500 block mb-0.5">Maximum Fee</span>
                                      <input
                                        type="number"
                                        value={consultationFeeRange.max}
                                        onChange={(e) => setConsultationFeeRange(prev => ({ ...prev, max: parseInt(e.target.value) || 0 }))}
                                        className="w-full bg-slate-900 border border-slate-800 rounded px-2.5 py-1.5 text-xs text-slate-200 focus:outline-none focus:border-blue-500"
                                      />
                                    </div>
                                  </div>
                                </div>

                                <div>
                                  <label className="text-slate-400 block mb-1">Platform Commission Cut (%)</label>
                                  <div className="flex gap-2">
                                    <input
                                      type="number"
                                      value={commissionPercentage}
                                      onChange={(e) => setCommissionPercentage(parseInt(e.target.value) || 0)}
                                      className="w-24 bg-slate-900 border border-slate-800 rounded px-2.5 py-1.5 text-xs text-slate-200 focus:outline-none focus:border-blue-500 font-bold"
                                    />
                                    <span className="text-[10px] text-slate-500 self-center leading-normal">Applied to doctor consultations, pharmacy sales, and lab transactions.</span>
                                  </div>
                                </div>

                                <button
                                  onClick={() => {
                                    setAuditLogs(prev => [
                                      { id: `log-${Date.now()}`, action: `Updated Platform commission to ${commissionPercentage}% & consulting range to ${consultationFeeRange.min}-${consultationFeeRange.max} BDT`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                      ...prev
                                    ]);
                                    triggerNotification('Settings Saved', 'Platform financial parameters updated successfully.');
                                  }}
                                  className="w-full py-1.5 bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white rounded font-bold text-xs mt-1 transition-all"
                                >
                                  Update Financial Parameters
                                </button>
                              </div>
                            </div>

                            {/* B. SPECIALTY MANAGER */}
                            <div className="bg-slate-950 border border-slate-800 p-3.5 rounded-xl space-y-3">
                              <h4 className="text-xs font-bold text-white uppercase tracking-wider font-display flex items-center gap-1.5">
                                <Stethoscope className="h-4 w-4 text-emerald-400" />
                                Doctor Specialties Directory
                              </h4>
                              <p className="text-[10px] text-slate-500">Add or remove medical categories shown during patient doctor search onboarding.</p>
                              
                              <div className="flex gap-1.5">
                                <input
                                  type="text"
                                  placeholder="New specialty name (e.g., Oncology)..."
                                  value={newSpecialtyText}
                                  onChange={(e) => setNewSpecialtyText(e.target.value)}
                                  className="flex-1 bg-slate-900 border border-slate-800 focus:outline-none focus:border-emerald-500 rounded px-2 py-1 text-xs"
                                />
                                <button
                                  onClick={() => {
                                    if (!newSpecialtyText.trim()) return;
                                    setDoctorSpecialties(prev => [...prev, newSpecialtyText.trim()]);
                                    setAuditLogs(prev => [
                                      { id: `log-${Date.now()}`, action: `Added specialty: ${newSpecialtyText.trim()}`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                      ...prev
                                    ]);
                                    triggerNotification('Specialty Added', `Medical category ${newSpecialtyText.trim()} added.`);
                                    setNewSpecialtyText('');
                                  }}
                                  className="px-3 bg-emerald-600 hover:bg-emerald-700 text-white rounded font-bold text-xs"
                                >
                                  Add
                                </button>
                              </div>

                              <div className="flex flex-wrap gap-1.5 pt-1 max-h-[100px] overflow-y-auto">
                                {doctorSpecialties.map((spec) => (
                                  <span key={spec} className="inline-flex items-center gap-1 bg-slate-900 text-[10px] text-slate-300 px-2 py-0.5 rounded border border-slate-800">
                                    {spec}
                                    <button 
                                      onClick={() => {
                                        setDoctorSpecialties(prev => prev.filter(s => s !== spec));
                                        setAuditLogs(prev => [
                                          { id: `log-${Date.now()}`, action: `Removed specialty: ${spec}`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                          ...prev
                                        ]);
                                      }}
                                      className="text-red-400 hover:text-red-600 ml-1 font-bold text-[9px]"
                                    >
                                      ×
                                    </button>
                                  </span>
                                ))}
                              </div>
                            </div>

                            {/* C. LAB TEST CATALOG MANAGER */}
                            <div className="bg-slate-950 border border-slate-800 p-3.5 rounded-xl space-y-3">
                              <h4 className="text-xs font-bold text-white uppercase tracking-wider font-display flex items-center gap-1.5">
                                <FlaskConical className="h-4 w-4 text-purple-400" />
                                Diagnostic Lab Test Catalog
                              </h4>
                              <p className="text-[10px] text-slate-500 font-medium">Add, edit, or remove lab test offerings available for patient booking.</p>
                              
                              <div className="bg-slate-900 border border-slate-800 rounded-lg p-2.5 space-y-2">
                                <span className="text-[9px] font-bold text-slate-400 block uppercase">Add New Lab Test</span>
                                <div className="grid grid-cols-3 gap-1">
                                  <input
                                    type="text"
                                    placeholder="Test Name (e.g. ECG)..."
                                    value={newLabTest.name}
                                    onChange={(e) => setNewLabTest(prev => ({ ...prev, name: e.target.value }))}
                                    className="col-span-2 bg-slate-950 border border-slate-800 rounded px-2 py-1 text-xs"
                                  />
                                  <input
                                    type="number"
                                    placeholder="Price BDT..."
                                    value={newLabTest.price}
                                    onChange={(e) => setNewLabTest(prev => ({ ...prev, price: e.target.value }))}
                                    className="bg-slate-950 border border-slate-800 rounded px-2 py-1 text-xs"
                                  />
                                </div>
                                <button
                                  onClick={() => {
                                    if (!newLabTest.name.trim() || !newLabTest.price) return;
                                    const testId = `t-${Date.now()}`;
                                    const priceNum = parseInt(newLabTest.price) || 0;
                                    setLabTestCatalog(prev => [...prev, { id: testId, name: newLabTest.name.trim(), price: priceNum }]);
                                    setAuditLogs(prev => [
                                      { id: `log-${Date.now()}`, action: `Added Lab Test: ${newLabTest.name.trim()} (BDT ${priceNum})`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                      ...prev
                                    ]);
                                    triggerNotification('Lab Test Created', `Test '${newLabTest.name.trim()}' successfully appended to live diagnostic lists.`);
                                    setNewLabTest({ name: '', price: '' });
                                  }}
                                  className="w-full py-1 bg-purple-600 hover:bg-purple-700 text-white rounded text-[10px] font-bold"
                                >
                                  Register Test to App Catalog
                                </button>
                              </div>

                              {/* Catalog list */}
                              <div className="space-y-1.5 max-h-[140px] overflow-y-auto pt-1">
                                {labTestCatalog.map((test) => (
                                  <div key={test.id} className="flex justify-between items-center bg-slate-900/60 border border-slate-800/80 px-2.5 py-1.5 rounded-lg text-xs">
                                    <div>
                                      <span className="font-bold text-slate-200 block">{test.name}</span>
                                      <span className="text-[10px] text-slate-400 font-mono">ID: {test.id}</span>
                                    </div>
                                    <div className="flex items-center gap-2">
                                      <span className="text-emerald-400 font-mono font-bold">BDT {test.price}</span>
                                      <button
                                        onClick={() => {
                                          setLabTestCatalog(prev => prev.filter(t => t.id !== test.id));
                                          setAuditLogs(prev => [
                                            { id: `log-${Date.now()}`, action: `Deleted Lab Test: ${test.name}`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                            ...prev
                                          ]);
                                        }}
                                        className="text-red-400 hover:text-red-600 text-[10px]"
                                      >
                                        Delete
                                      </button>
                                    </div>
                                  </div>
                                ))}
                              </div>
                            </div>

                            {/* D. CITY / ZONE MANAGER */}
                            <div className="bg-slate-950 border border-slate-800 p-3.5 rounded-xl space-y-3">
                              <h4 className="text-xs font-bold text-white uppercase tracking-wider font-display flex items-center gap-1.5">
                                <Globe className="h-4 w-4 text-blue-400" />
                                Serviceable Cities & Hub Zones
                              </h4>
                              <p className="text-[10px] text-slate-500">Manage areas where medical delivery and lab collection features are active.</p>
                              
                              <div className="flex gap-1.5">
                                <input
                                  type="text"
                                  placeholder="New city (e.g., Gazipur)..."
                                  value={newCityText}
                                  onChange={(e) => setNewCityText(e.target.value)}
                                  className="flex-1 bg-slate-900 border border-slate-800 focus:outline-none focus:border-blue-500 rounded px-2 py-1 text-xs"
                                />
                                <button
                                  onClick={() => {
                                    if (!newCityText.trim()) return;
                                    setServiceableCities(prev => [...prev, newCityText.trim()]);
                                    setAuditLogs(prev => [
                                      { id: `log-${Date.now()}`, action: `Added active hub zone: ${newCityText.trim()}`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                      ...prev
                                    ]);
                                    triggerNotification('Zone Activated', `Service area ${newCityText.trim()} is now live.`);
                                    setNewCityText('');
                                  }}
                                  className="px-3 bg-blue-600 hover:bg-blue-700 text-white rounded font-bold text-xs"
                                >
                                  Add Zone
                                </button>
                              </div>

                              <div className="grid grid-cols-2 gap-1.5 max-h-[100px] overflow-y-auto">
                                {serviceableCities.map((city) => (
                                  <div key={city} className="flex justify-between items-center bg-slate-900 px-2.5 py-1 rounded border border-slate-800 text-[10px] text-slate-300">
                                    <span>📍 {city}</span>
                                    <button 
                                      onClick={() => {
                                        setServiceableCities(prev => prev.filter(c => c !== city));
                                        setAuditLogs(prev => [
                                          { id: `log-${Date.now()}`, action: `Deactivated active zone: ${city}`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                          ...prev
                                        ]);
                                      }}
                                      className="text-red-400 hover:text-red-500 font-bold ml-2"
                                    >
                                      Delete
                                    </button>
                                  </div>
                                ))}
                              </div>
                            </div>
                          </div>
                        )}

                        {/* 5. CONTENT MANAGEMENT SCREEN */}
                        {adminTab === 'content' && (
                          <div className="p-4 space-y-4 animate-fadeIn">
                            <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider font-display">Content Management (CMS)</h3>
                            <p className="text-[10px] text-slate-500 leading-normal">
                              Update static documentation served inside the patient and partner apps (Terms of Service, Legal disclaimers, Privacy protections).
                            </p>

                            <div className="space-y-4">
                              {/* Terms & Conditions Box */}
                              <div className="space-y-1">
                                <label className="text-xs font-bold text-slate-300 block">Terms & Conditions</label>
                                <textarea
                                  value={termsAndConditions}
                                  onChange={(e) => setTermsAndConditions(e.target.value)}
                                  className="w-full h-24 bg-slate-950 border border-slate-800 focus:outline-none focus:border-blue-500 rounded-lg p-2.5 text-xs text-slate-300 font-mono resize-none leading-relaxed"
                                />
                              </div>

                              {/* Privacy Policy Box */}
                              <div className="space-y-1">
                                <label className="text-xs font-bold text-slate-300 block">Privacy Policy</label>
                                <textarea
                                  value={privacyPolicy}
                                  onChange={(e) => setPrivacyPolicy(e.target.value)}
                                  className="w-full h-24 bg-slate-950 border border-slate-800 focus:outline-none focus:border-blue-500 rounded-lg p-2.5 text-xs text-slate-300 font-mono resize-none leading-relaxed"
                                />
                              </div>

                              <button
                                onClick={() => {
                                  setAuditLogs(prev => [
                                    { id: `log-${Date.now()}`, action: `Updated Legal Documents (T&C and Privacy Policy) on CMS`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                    ...prev
                                  ]);
                                  triggerNotification('Static Content Updated', 'Legal and Privacy policies synced to application CDNs.');
                                }}
                                className="w-full py-2 bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white font-bold rounded-lg text-xs shadow-md"
                              >
                                Save CMS Document Revisions
                              </button>
                            </div>
                          </div>
                        )}

                        {/* 6. AUDIT LOG SCREEN */}
                        {adminTab === 'audit' && (
                          <div className="p-4 space-y-3 animate-fadeIn">
                            <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider">Administrative Security Audit</h3>
                            <p className="text-[10px] text-slate-500">Live tracker logging critical system actions, registration authorizations, and policy adjustments.</p>

                            <div className="space-y-2 max-h-[380px] overflow-y-auto">
                              {auditLogs.map((log) => (
                                <div key={log.id} className="bg-slate-950 border border-slate-850 p-2.5 rounded-lg border-l-2 border-l-blue-500 space-y-1 shadow-sm">
                                  <div className="flex justify-between text-[9px] text-slate-500">
                                    <span className="font-bold text-slate-400 flex items-center gap-1">
                                      👤 actor: {log.user}
                                    </span>
                                    <span className="font-mono">{log.timestamp}</span>
                                  </div>
                                  <div className="text-[11px] font-semibold text-slate-200">
                                    {log.action}
                                  </div>
                                  <div className="text-[8px] font-mono text-slate-600">ID: {log.id} | Integrity signature verified</div>
                                </div>
                              ))}
                            </div>
                          </div>
                        )}

                        {/* 7. SUPPORT TICKETS SCREEN */}
                        {adminTab === 'support' && (
                          <div className="p-4 space-y-4 animate-fadeIn">
                            
                            {selectedTicketId === null ? (
                              // Ticket List View
                              <div className="space-y-3">
                                <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider">Help Desk & Support Tickets</h3>
                                <div className="space-y-2 max-h-[380px] overflow-y-auto">
                                  {supportTickets.map((t) => (
                                    <div 
                                      key={t.id} 
                                      onClick={() => setSelectedTicketId(t.id)}
                                      className="bg-slate-950 border border-slate-800 hover:border-slate-700 p-3 rounded-xl cursor-pointer transition-all space-y-2"
                                    >
                                      <div className="flex justify-between items-center">
                                        <div className="flex items-center gap-1.5">
                                          <span className="h-1.5 w-1.5 rounded-full bg-blue-500"></span>
                                          <span className="text-[10px] font-mono font-bold text-slate-500">{t.id}</span>
                                        </div>
                                        <span className={`text-[8px] font-black px-2 py-0.5 rounded font-mono uppercase ${
                                          t.status === 'Open' ? 'bg-red-950 text-red-400 border border-red-900/40' :
                                          t.status === 'In Progress' ? 'bg-amber-950 text-amber-400 border border-amber-900/40' :
                                          'bg-emerald-950 text-emerald-400 border border-emerald-900/40'
                                        }`}>
                                          {t.status}
                                        </span>
                                      </div>

                                      <div className="space-y-1">
                                        <div className="text-xs font-bold text-white leading-snug">{t.subject}</div>
                                        <div className="text-[9px] text-slate-400 font-medium">From: <span className="text-slate-300 font-semibold">{t.user}</span> ({t.role})</div>
                                        <p className="text-[10px] text-slate-500 line-clamp-2 mt-1">{t.message}</p>
                                      </div>

                                      <div className="text-[9px] text-blue-400 font-bold text-right pt-1 border-t border-slate-900 flex items-center justify-end gap-1">
                                        <MessageSquare className="h-3 w-3" />
                                        <span>View thread & reply ({t.replies.length})</span>
                                      </div>
                                    </div>
                                  ))}
                                </div>
                              </div>
                            ) : (
                              // Ticket Detail and Reply Chat Screen
                              (() => {
                                const ticket = supportTickets.find(t => t.id === selectedTicketId);
                                if (!ticket) return null;
                                return (
                                  <div className="space-y-3 flex flex-col h-[400px]">
                                    {/* Back Header */}
                                    <div className="flex justify-between items-center pb-2 border-b border-slate-800">
                                      <button 
                                        onClick={() => setSelectedTicketId(null)}
                                        className="flex items-center gap-1 text-[10px] font-bold text-blue-400 hover:text-blue-300"
                                      >
                                        <ArrowLeft className="h-3 w-3" />
                                        Back to Tickets
                                      </button>
                                      
                                      {/* Change status dropdown */}
                                      <select
                                        value={ticket.status}
                                        onChange={(e) => {
                                          const newStatus = e.target.value;
                                          setSupportTickets(prev => prev.map(t => t.id === ticket.id ? { ...t, status: newStatus } : t));
                                          setAuditLogs(prev => [
                                            { id: `log-${Date.now()}`, action: `Updated ticket ${ticket.id} status to ${newStatus}`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                            ...prev
                                          ]);
                                          triggerNotification('Ticket Status Updated', `Ticket is now marked as ${newStatus}`);
                                        }}
                                        className="bg-slate-950 border border-slate-800 rounded px-2 py-0.5 text-[9px] font-bold text-slate-300 outline-none focus:border-blue-500"
                                      >
                                        <option value="Open">Open</option>
                                        <option value="In Progress">In Progress</option>
                                        <option value="Resolved">Resolved</option>
                                      </select>
                                    </div>

                                    {/* Original Ticket Query details */}
                                    <div className="bg-slate-950 border border-slate-850 p-2.5 rounded-lg text-xs space-y-1">
                                      <div className="text-white font-bold">{ticket.subject}</div>
                                      <div className="text-[9px] text-slate-500">ID: {ticket.id} | Contact: {ticket.user} ({ticket.role})</div>
                                      <p className="text-[10px] text-slate-400 pt-1 leading-normal border-t border-slate-900/60 mt-1">{ticket.message}</p>
                                    </div>

                                    {/* Chat Reply Threads */}
                                    <div className="flex-1 bg-slate-950 rounded-xl border border-slate-850 p-3.5 overflow-y-auto space-y-2.5 max-h-[200px]">
                                      {ticket.replies.length === 0 ? (
                                        <div className="text-[10px] text-slate-600 text-center py-4">No communication history. Reply below to initiate administrative support chat.</div>
                                      ) : (
                                        ticket.replies.map((reply, index) => {
                                          const isAdmin = reply.sender === 'Admin';
                                          return (
                                            <div key={index} className={`flex flex-col ${isAdmin ? 'items-end' : 'items-start'}`}>
                                              <span className="text-[8px] text-slate-500 font-mono mb-0.5 font-bold uppercase">{reply.sender}</span>
                                              <div className={`p-2 rounded-lg text-[10px] max-w-[85%] leading-normal font-medium ${
                                                isAdmin 
                                                  ? 'bg-blue-600 text-white rounded-tr-none' 
                                                  : 'bg-slate-800 text-slate-200 rounded-tl-none'
                                              }`}>
                                                {reply.text}
                                              </div>
                                              <span className="text-[7px] text-slate-600 font-mono mt-0.5">{reply.timestamp || 'Just now'}</span>
                                            </div>
                                          );
                                        })
                                      )}
                                    </div>

                                    {/* Reply Submission Input */}
                                    <div className="flex gap-2.5 border-t border-slate-800 pt-2 shrink-0">
                                      <input
                                        type="text"
                                        placeholder="Type administrative advice, instructions..."
                                        value={supportReplyText}
                                        onChange={(e) => setSupportReplyText(e.target.value)}
                                        className="flex-1 bg-slate-950 border border-slate-800 focus:outline-none focus:border-blue-500 rounded-lg px-3 py-2 text-xs text-slate-200"
                                        onKeyDown={(e) => {
                                          if (e.key === 'Enter') {
                                            const btn = document.getElementById('btn-send-support-reply');
                                            btn?.click();
                                          }
                                        }}
                                      />
                                      <button
                                        id="btn-send-support-reply"
                                        onClick={() => {
                                          if (!supportReplyText.trim()) return;
                                          const newReply = {
                                            sender: 'Admin',
                                            text: supportReplyText.trim(),
                                            timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
                                          };
                                          setSupportTickets(prev => prev.map(t => {
                                            if (t.id === ticket.id) {
                                              return { ...t, replies: [...t.replies, newReply] };
                                            }
                                            return t;
                                          }));
                                          setSupportReplyText('');
                                          triggerNotification('Support Reply Dispatched', 'Your administrative instructions sent to clinical dashboard.');
                                        }}
                                        className="px-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg flex items-center justify-center transition-all shadow"
                                      >
                                        <Send className="h-3.5 w-3.5" />
                                      </button>
                                    </div>
                                  </div>
                                );
                              })()
                            )}
                          </div>
                        )}

                        {/* 8. PUSH NOTIFICATION BROADCASTER SCREEN */}
                        {adminTab === 'notifications' && (
                          <div className="p-4 space-y-4 animate-fadeIn">
                            <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider font-display">Simulated Push Notification Broadcaster</h3>
                            <p className="text-[10px] text-slate-500 leading-normal">
                              Dispatch emergency notification bulletins directly to user device bars via localized flutter background messaging queues.
                            </p>

                            <div className="bg-slate-950 border border-slate-800 rounded-xl p-4 space-y-3 shadow-sm">
                              <div>
                                <label className="text-[10px] text-slate-400 uppercase font-bold tracking-wider block mb-1">Target Audience</label>
                                <select
                                  value={pushTarget}
                                  onChange={(e) => setPushTarget(e.target.value as any)}
                                  className="w-full bg-slate-900 border border-slate-800 rounded-lg p-2 text-xs text-slate-200 focus:outline-none focus:border-blue-500"
                                >
                                  <option value="All">All Users (Broad Distribution)</option>
                                  <option value="Patients">Patients Only</option>
                                  <option value="Doctors">Clinical Specialists Only</option>
                                  <option value="Pharmacies">Dispensation Hubs Only</option>
                                  <option value="Diagnostics">Laboratory Admins Only</option>
                                </select>
                              </div>

                              <div>
                                <label className="text-[10px] text-slate-400 uppercase font-bold tracking-wider block mb-1">Notification Title</label>
                                <input
                                  type="text"
                                  placeholder="Emergency: Flu Epidemic Alert / Payout Status..."
                                  value={pushTitle}
                                  onChange={(e) => setPushTitle(e.target.value)}
                                  className="w-full bg-slate-900 border border-slate-800 rounded-lg p-2 text-xs text-slate-200 focus:outline-none focus:border-blue-500 font-bold"
                                />
                              </div>

                              <div>
                                <label className="text-[10px] text-slate-400 uppercase font-bold tracking-wider block mb-1">Message Content</label>
                                <textarea
                                  placeholder="Type the message body that will display on the patient or partner notification status bar..."
                                  value={pushMessage}
                                  onChange={(e) => setPushMessage(e.target.value)}
                                  className="w-full h-20 bg-slate-900 border border-slate-800 rounded-lg p-2 text-xs text-slate-200 focus:outline-none focus:border-blue-500 resize-none font-medium placeholder:text-slate-600"
                                />
                              </div>

                              <button
                                onClick={() => {
                                  if (!pushTitle.trim() || !pushMessage.trim()) {
                                    triggerNotification('Broadcast Error', 'Please input title and content.');
                                    return;
                                  }
                                  // Trigger mock notification
                                  triggerNotification(`📢 Broadcast: ${pushTitle}`, `Sent to ${pushTarget}: ${pushMessage}`);
                                  
                                  setAuditLogs(prev => [
                                    { id: `log-${Date.now()}`, action: `Broadcast Notification to ${pushTarget}: "${pushTitle}"`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                    ...prev
                                  ]);
                                  setPushTitle('');
                                  setPushMessage('');
                                }}
                                className="w-full py-2 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 active:from-blue-850 text-white rounded-lg text-xs font-bold transition-all shadow-md shadow-indigo-900/30 flex items-center justify-center gap-1.5"
                              >
                                <Bell className="h-4 w-4 text-white animate-bounce" />
                                Send Local Broadcaster Dispatch
                              </button>
                            </div>
                          </div>
                        )}

                      </div>

                      {/* 9. ADMIN BOTTOM NAVIGATION TABS */}
                      <div className="border-t border-slate-800 bg-slate-950 px-2.5 py-1.5 shrink-0 flex justify-between items-center text-[9px] font-bold text-slate-500 overflow-x-auto gap-4 scrollbar-none">
                        <button
                          onClick={() => setAdminTab('dashboard')}
                          className={`flex flex-col items-center gap-1 min-w-[36px] transition-all ${adminTab === 'dashboard' ? 'text-blue-500' : 'hover:text-slate-300'}`}
                        >
                          <Activity className="h-4 w-4" />
                          <span>Console</span>
                        </button>

                        <button
                          onClick={() => setAdminTab('approvals')}
                          className={`flex flex-col items-center gap-1 min-w-[36px] relative transition-all ${adminTab === 'approvals' ? 'text-blue-500' : 'hover:text-slate-300'}`}
                        >
                          {users.filter(u => u.status === 'pending').length > 0 && (
                            <span className="absolute -top-1 -right-1 h-3.5 w-3.5 bg-red-500 text-white rounded-full flex items-center justify-center text-[7px] font-bold scale-90 border border-slate-950 animate-pulse">
                              {users.filter(u => u.status === 'pending').length}
                            </span>
                          )}
                          <ShieldAlert className="h-4 w-4" />
                          <span>Vetting</span>
                        </button>

                        <button
                          onClick={() => setAdminTab('users')}
                          className={`flex flex-col items-center gap-1 min-w-[36px] transition-all ${adminTab === 'users' ? 'text-blue-500' : 'hover:text-slate-300'}`}
                        >
                          <Users className="h-4 w-4" />
                          <span>Directory</span>
                        </button>

                        <button
                          onClick={() => setAdminTab('settings')}
                          className={`flex flex-col items-center gap-1 min-w-[36px] transition-all ${adminTab === 'settings' ? 'text-blue-500' : 'hover:text-slate-300'}`}
                        >
                          <Settings className="h-4 w-4" />
                          <span>Config</span>
                        </button>

                        <button
                          onClick={() => setAdminTab('content')}
                          className={`flex flex-col items-center gap-1 min-w-[36px] transition-all ${adminTab === 'content' ? 'text-blue-500' : 'hover:text-slate-300'}`}
                        >
                          <FileText className="h-4 w-4" />
                          <span>CMS</span>
                        </button>

                        <button
                          onClick={() => setAdminTab('support')}
                          className={`flex flex-col items-center gap-1 min-w-[36px] relative transition-all ${adminTab === 'support' ? 'text-blue-500' : 'hover:text-slate-300'}`}
                        >
                          {supportTickets.filter(t => t.status === 'Open').length > 0 && (
                            <span className="absolute -top-1 -right-1 h-3.5 w-3.5 bg-blue-500 text-white rounded-full flex items-center justify-center text-[7px] font-bold scale-90 border border-slate-950 animate-pulse">
                              {supportTickets.filter(t => t.status === 'Open').length}
                            </span>
                          )}
                          <MessageCircle className="h-4 w-4" />
                          <span>Support</span>
                        </button>

                        <button
                          onClick={() => setAdminTab('notifications')}
                          className={`flex flex-col items-center gap-1 min-w-[36px] transition-all ${adminTab === 'notifications' ? 'text-blue-500' : 'hover:text-slate-300'}`}
                        >
                          <Bell className="h-4 w-4" />
                          <span>Notify</span>
                        </button>

                        <button
                          onClick={() => setAdminTab('audit')}
                          className={`flex flex-col items-center gap-1 min-w-[36px] transition-all ${adminTab === 'audit' ? 'text-blue-500' : 'hover:text-slate-300'}`}
                        >
                          <Award className="h-4 w-4" />
                          <span>Audit</span>
                        </button>
                      </div>

                      {/* USER PROFILE VIEW / EDIT PROFILE MODAL */}
                      {showAdminUserEditModal && selectedAdminUser && (
                        <div className="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4 z-[9999] animate-fadeIn">
                          <div className="bg-slate-900 border border-slate-800 rounded-xl p-5 w-full max-w-sm space-y-4">
                            <div className="flex justify-between items-center border-b border-slate-800 pb-2">
                              <h4 className="text-xs font-black font-display text-white tracking-wide uppercase">Edit {selectedAdminUser.role} Profile</h4>
                              <button 
                                onClick={() => {
                                  setShowAdminUserEditModal(false);
                                  setSelectedAdminUser(null);
                                }} 
                                className="text-slate-400 hover:text-white font-bold"
                              >
                                ×
                              </button>
                            </div>

                            <div className="space-y-3.5 text-xs">
                              <div>
                                <label className="text-slate-400 block mb-1">Full Name</label>
                                <input
                                  type="text"
                                  value={selectedAdminUser.name}
                                  onChange={(e) => setSelectedAdminUser((prev: any) => ({ ...prev, name: e.target.value }))}
                                  className="w-full bg-slate-950 border border-slate-800 rounded px-2.5 py-1.5 focus:border-blue-500 focus:outline-none"
                                />
                              </div>

                              <div>
                                <label className="text-slate-400 block mb-1">Phone Number</label>
                                <input
                                  type="text"
                                  value={selectedAdminUser.phone}
                                  onChange={(e) => setSelectedAdminUser((prev: any) => ({ ...prev, phone: e.target.value }))}
                                  className="w-full bg-slate-950 border border-slate-800 rounded px-2.5 py-1.5 focus:border-blue-500 focus:outline-none font-mono"
                                />
                              </div>

                              <div>
                                <label className="text-slate-400 block mb-1">Email Address</label>
                                <input
                                  type="email"
                                  value={selectedAdminUser.email}
                                  onChange={(e) => setSelectedAdminUser((prev: any) => ({ ...prev, email: e.target.value }))}
                                  className="w-full bg-slate-950 border border-slate-800 rounded px-2.5 py-1.5 focus:border-blue-500 focus:outline-none font-mono"
                                />
                              </div>

                              {selectedAdminUser.role === 'doctor' && (
                                <>
                                  <div>
                                    <label className="text-slate-400 block mb-1">Consultation Fee (BDT)</label>
                                    <input
                                      type="number"
                                      value={selectedAdminUser.consultationFee || 0}
                                      onChange={(e) => setSelectedAdminUser((prev: any) => ({ ...prev, consultationFee: parseInt(e.target.value) || 0 }))}
                                      className="w-full bg-slate-950 border border-slate-800 rounded px-2.5 py-1.5 focus:border-blue-500 focus:outline-none font-mono text-emerald-400 font-bold"
                                    />
                                  </div>
                                  <div>
                                    <label className="text-slate-400 block mb-1">Specialty</label>
                                    <select
                                      value={selectedAdminUser.specialty || ''}
                                      onChange={(e) => setSelectedAdminUser((prev: any) => ({ ...prev, specialty: e.target.value }))}
                                      className="w-full bg-slate-950 border border-slate-800 rounded px-2 py-1.5 text-slate-300 focus:outline-none"
                                    >
                                      {doctorSpecialties.map(spec => (
                                        <option key={spec} value={spec}>{spec}</option>
                                      ))}
                                    </select>
                                  </div>
                                </>
                              )}

                              {selectedAdminUser.address !== undefined && (
                                <div>
                                  <label className="text-slate-400 block mb-1">Street Address</label>
                                  <input
                                    type="text"
                                    value={selectedAdminUser.address || ''}
                                    onChange={(e) => setSelectedAdminUser((prev: any) => ({ ...prev, address: e.target.value }))}
                                    className="w-full bg-slate-950 border border-slate-800 rounded px-2.5 py-1.5 focus:border-blue-500 focus:outline-none"
                                  />
                                </div>
                              )}
                            </div>

                            <button
                              onClick={() => {
                                setUsers(prev => prev.map(u => u.id === selectedAdminUser.id ? selectedAdminUser : u));
                                setAuditLogs(prev => [
                                  { id: `log-${Date.now()}`, action: `Updated user profile metadata: ${selectedAdminUser.name}`, user: 'Super Admin', timestamp: new Date().toLocaleString() },
                                  ...prev
                                ]);
                                setShowAdminUserEditModal(false);
                                triggerNotification('Profile Updated', `Successfully committed profile edits for ${selectedAdminUser.name}.`);
                              }}
                              className="w-full py-2 bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white rounded font-bold text-xs"
                            >
                              Save Directory Changes
                            </button>
                          </div>
                        </div>
                      )}
                    </motion.div>
                  )}

                  {/* PORTAL HOMES (PATIENT) */}
                  {flutterScreen === 'patient_home' && (() => {
                    const t = patientLanguage === 'EN' ? {
                      welcome: "Hello,",
                      subWelcome: "Find your clinical specialist",
                      searchPlaceholder: "Search doctor by name or symptom...",
                      consultNow: "Consult Now",
                      consultNowDesc: "Instant 5-Min Video Connection",
                      bookAppt: "Book Appt",
                      bookApptDesc: "Schedule Specialist Visit",
                      orderMed: "Order Medicine",
                      orderMedDesc: "2-Hr Express Delivery",
                      labTest: "Book Lab Test",
                      labTestDesc: "Home Sample Collection",
                      specialties: "Medical Departments",
                      popularDocs: "Popular Specialists",
                      availNow: "Available Now",
                      consultFee: "Consult Fee",
                      bdt: "BDT",
                      exp: "Exp",
                      rating: "Rating",
                      clipsTitle: "Clinical Health Clips",
                      diagnosticTitle: "Diagnostic Packages & Tests",
                      moreTitle: "Patient Command Center",
                      biometrics: "Biometric Sign-In",
                      pastPrescriptions: "My Prescriptions",
                      labReports: "My Lab Reports",
                      support: "Contact Support Helpline",
                      bookingModalTitle: "Schedule Clinical Appointment",
                      date: "Select Appointment Date",
                      time: "Select Timing Slot",
                      successBooking: "Appointment Scheduled Successfully!",
                      videoConsulting: "Instant Clinical Consultation",
                      videoSubText: "Connecting you securely to our on-duty general physician...",
                      endCall: "End Consultation",
                      addToCart: "Add to Cart",
                      checkout: "Proceed to Checkout",
                      orderSuccess: "Medicine Order Dispatched!",
                      cartEmpty: "Your pharmacy cart is empty.",
                      selectSlot: "Please select a preferred date and time.",
                    } : {
                      welcome: "হ্যালো,",
                      subWelcome: "আপনার প্রয়োজনীয় বিশেষজ্ঞ ডাক্তার খুঁজুন",
                      searchPlaceholder: "ডাক্তারের নাম বা লক্ষণ দিয়ে খুঁজুন...",
                      consultNow: "জরুরী কল",
                      consultNowDesc: "৫ মিনিটে ডাক্তার কানেকশন",
                      bookAppt: "অ্যাপয়েন্টমেন্ট",
                      bookApptDesc: "विशेषজ্ঞ ডাক্তার বুকিং",
                      orderMed: "ওষুধ অর্ডার",
                      orderMedDesc: "২ ঘন্টায় হোম ডেলিভারি",
                      labTest: "ল্যাব টেস্ট",
                      labTestDesc: "বাসা থেকে স্যাম্পল সংগ্রহ",
                      specialties: "মেডিকেল ডিপার্টমেন্ট সমূহ",
                      popularDocs: "জনপ্রিয় বিশেষজ্ঞগণ",
                      availNow: "উপলব্ধ আছেন",
                      consultFee: "ভিজিট ফি",
                      bdt: "টাকা",
                      exp: "অভিজ্ঞতা",
                      rating: "রেটিং",
                      clipsTitle: "মেডিকেল হেলথ ক্লিপস",
                      diagnosticTitle: "ডায়াগনস্টিক প্যাকেজ ও টেস্ট",
                      moreTitle: "পেশেন্ট কমান্ড সেন্টার",
                      biometrics: "বায়োমেট্রিক লগইন",
                      pastPrescriptions: "আমার প্রেসক্রিপশন সমূহ",
                      labReports: "আমার টেস্ট রিপোর্ট",
                      support: "সহায়তা হেল্পলাইন",
                      bookingModalTitle: "অ্যাপয়েন্টমেন্ট নির্ধারণ করুন",
                      date: "অ্যাপয়েন্টমেন্টের তারিখ নির্বাচন করুন",
                      time: "সময় স্লট নির্ধারণ করুন",
                      successBooking: "অ্যাপয়েন্টমেন্ট বুকিং সম্পন্ন হয়েছে!",
                      videoConsulting: "জরুরী মেডিকেল কনসালটেশন",
                      videoSubText: "অন-ডিউটি চিকিৎসকের সাথে সংযোগ স্থাপন করা হচ্ছে...",
                      endCall: "কল শেষ করুন",
                      addToCart: "কার্টে যোগ করুন",
                      checkout: "অর্ডার সম্পন্ন করুন",
                      orderSuccess: "ওষুধের অর্ডার পাঠানো হয়েছে!",
                      cartEmpty: "আপনার ওষধের কার্ট খালি আছে।",
                      selectSlot: "দয়া করে তারিখ ও সময় স্লট নির্বাচন করুন।",
                    };

                    const simulatedDoctors = [
                      { id: 'doc-1', name: 'Dr. Sarah Rahman', specialty: 'Heart', rating: '4.9', reviews: 142, exp: '8 yrs', fee: 800, status: 'Online', bio: 'Senior cardiologist at Evercare Hospital.', photo: '👩‍⚕️' },
                      { id: 'doc-2', name: 'Dr. Mahbub Alam', specialty: 'General Physician', rating: '4.8', reviews: 320, exp: '12 yrs', fee: 500, status: 'Online', bio: 'Expert in chronic fever and family healthcare.', photo: '👨‍⚕️' },
                      { id: 'doc-3', name: 'Dr. Nusrat Jahan', specialty: 'Gynecology', rating: '4.9', reviews: 215, exp: '10 yrs', fee: 700, status: 'In Clinic', bio: 'Specialist in maternal medicine and wellness.', photo: '👩‍⚕️' },
                      { id: 'doc-4', name: 'Dr. Kazi Omar', specialty: 'Pediatrics', rating: '4.7', reviews: 98, exp: '6 yrs', fee: 600, status: 'Online', bio: 'Child health care consultant and immunologist.', photo: '👨‍⚕️' },
                      { id: 'doc-5', name: 'Dr. Arifa Binte', specialty: 'Skin', rating: '4.8', reviews: 164, exp: '7 yrs', fee: 800, status: 'Busy', bio: 'Specialist in clinical dermatology and acne treatment.', photo: '👩‍⚕️' }
                    ];

                    const specialtiesList = [
                      { id: 'all', name: patientLanguage === 'EN' ? 'All' : 'সব', icon: Stethoscope, filterVal: null },
                      { id: 'general', name: patientLanguage === 'EN' ? 'General' : 'জেনারেল', icon: Stethoscope, filterVal: 'General Physician' },
                      { id: 'gynecology', name: patientLanguage === 'EN' ? 'Gynecology' : 'গাইনি', icon: User, filterVal: 'Gynecology' },
                      { id: 'pediatrics', name: patientLanguage === 'EN' ? 'Pediatrics' : 'শিশু রোগ', icon: Sparkles, filterVal: 'Pediatrics' },
                      { id: 'skin', name: patientLanguage === 'EN' ? 'Skin' : 'চর্মরোগ', icon: Pill, filterVal: 'Skin' },
                      { id: 'heart', name: patientLanguage === 'EN' ? 'Heart' : 'হৃদরোগ', icon: Heart, filterVal: 'Heart' }
                    ];

                    const healthClips = [
                      { id: 'clip-1', title: "5 Daily Habits for a Healthy Heart", doctor: "Dr. Sarah Rahman", specialty: "Cardiologist", duration: "1:35", views: "1.2k views", likes: 184 },
                      { id: 'clip-2', title: "Understanding Seasonal Allergies in Kids", doctor: "Dr. Kazi Omar", specialty: "Pediatrician", duration: "2:10", views: "3.4k views", likes: 520 },
                      { id: 'clip-3', title: "Skincare Routine for Humidity", doctor: "Dr. Arifa Binte", specialty: "Dermatologist", duration: "1:55", views: "850 views", likes: 92 }
                    ];

                    const labPackages = [
                      { id: 'lab-1', name: "CBC (Complete Blood Count)", price: 400, desc: "Evaluates overall health and detects wide range of disorders." },
                      { id: 'lab-2', name: "Lipid Profile (Cholesterol)", price: 1000, desc: "Measures blood fats to evaluate heart disease risk." },
                      { id: 'lab-3', name: "HbA1c (Blood Glucose)", price: 450, desc: "Average blood sugar level over the past 3 months." },
                      { id: 'lab-4', name: "Full Body Checkup (Premium)", price: 3500, desc: "Complete 48-parameter checkup including liver & kidney tests." }
                    ];

                    const pharmacyMedicines = [
                      { id: 'med-1', name: "Napa Extend (Paracetamol 665mg)", price: 15, unit: "strip (10 tabs)", brand: "Beximco Pharma" },
                      { id: 'med-2', name: "Seclo 20 (Omeprazole 20mg)", price: 50, unit: "strip (10 caps)", brand: "Square Pharma" },
                      { id: 'med-3', name: "Fexo 120 (Fexofenadine)", price: 80, unit: "strip (10 tabs)", brand: "Incepta Pharma" },
                      { id: 'med-4', name: "Monas 10 (Montelukast)", price: 160, unit: "strip (10 tabs)", brand: "Acme Laboratories" }
                    ];

                    // Filtering doctors
                    const filteredDoctors = simulatedDoctors.filter(doc => {
                      const matchesSpecialty = !selectedSpecialty || doc.specialty === selectedSpecialty;
                      const matchesSearch = !patientSearch || doc.name.toLowerCase().includes(patientSearch.toLowerCase()) || doc.specialty.toLowerCase().includes(patientSearch.toLowerCase());
                      return matchesSpecialty && matchesSearch;
                    });

                    return (
                      <motion.div
                        key="patient_home"
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        className="flex-1 flex flex-col bg-slate-50 relative h-full text-slate-800"
                      >
                        {/* 1. Header (Bilingual, Bell, Avatar) */}
                        <div className="bg-white border-b border-slate-150 px-4 py-3 sticky top-0 z-30 flex items-center justify-between shadow-sm">
                          <div className="flex items-center gap-2">
                            <div className="h-8 w-8 bg-blue-600 rounded-lg flex items-center justify-center shadow-md">
                              <Hospital className="h-4 w-4 text-white" />
                            </div>
                            <div>
                              <h3 className="font-extrabold text-sm text-blue-600 tracking-tight font-display">Hello Doctor</h3>
                              <p className="text-[9px] text-slate-400 font-bold uppercase tracking-wider">{patientLanguage === 'EN' ? 'Patient Portal' : 'পেশেন্ট পোর্টাল'}</p>
                            </div>
                          </div>

                          <div className="flex items-center gap-2">
                            {/* Language Selector Toggle */}
                            <button
                              onClick={() => {
                                setPatientLanguage(prev => prev === 'EN' ? 'BN' : 'EN');
                                triggerNotification(
                                  patientLanguage === 'EN' ? 'ভাষা পরিবর্তন করা হয়েছে' : 'Language Switched',
                                  patientLanguage === 'EN' ? 'অ্যাপ এখন বাংলা ভাষায় প্রদর্শিত হচ্ছে।' : 'App content is now displayed in English.'
                                );
                              }}
                              className="text-[10px] font-bold bg-slate-100 hover:bg-slate-200 text-slate-700 px-2 py-1 rounded-md transition-all border border-slate-200"
                            >
                              {patientLanguage === 'EN' ? 'BN' : 'EN'}
                            </button>

                            {/* Notifications bell */}
                            <button 
                              onClick={() => triggerNotification(
                                patientLanguage === 'EN' ? "No New Alerts" : "কোন নতুন বিজ্ঞপ্তি নেই", 
                                patientLanguage === 'EN' ? "Your clinical profile is fully synchronized." : "আপনার ক্লিনিক্যাল প্রোফাইল সিঙ্ক করা আছে।"
                              )}
                              className="p-1.5 hover:bg-slate-100 rounded-full text-slate-500 hover:text-blue-600 transition-all relative"
                            >
                              <Bell className="h-4 w-4" />
                              <span className="absolute top-1 right-1 h-2 w-2 bg-red-500 rounded-full"></span>
                            </button>

                            {/* Avatar */}
                            <div 
                              onClick={() => triggerNotification(
                                patientLanguage === 'EN' ? 'Profile Details' : 'প্রোফাইল বিবরণ',
                                `${patientLanguage === 'EN' ? 'Patient:' : 'রুগী:'} ${currentUser?.name || 'Karim Uddin'} | ${currentUser?.phone || '01912345678'}`
                              )}
                              className="h-7 w-7 rounded-full bg-blue-100 border border-blue-200 flex items-center justify-center text-blue-600 text-[10px] font-bold cursor-pointer relative"
                            >
                              {currentUser?.name ? currentUser.name.split(' ').map((n: string) => n[0]).join('').slice(0, 2).toUpperCase() : 'PT'}
                              <span className="absolute bottom-0 right-0 h-2 w-2 bg-emerald-500 border border-white rounded-full"></span>
                            </div>
                          </div>
                        </div>

                        {/* Interactive Main Body with Scrollable Area */}
                        <div className="flex-1 overflow-y-auto px-4 py-3 space-y-4 pb-16">
                          
                          {/* DYNAMIC TAB SWITCHER */}
                          {patientTab === 'home' && (
                            <>
                              {/* 2. Welcome Title & Interactive Search Bar */}
                              <div className="mt-1">
                                <span className="text-xs text-slate-400 font-semibold">{t.welcome}</span>
                                <h4 className="text-sm font-extrabold text-slate-800 tracking-tight leading-tight">{currentUser?.name || 'Karim Uddin'} 👋</h4>
                                <p className="text-[10px] text-slate-500 mt-0.5 font-medium">{t.subWelcome}</p>
                              </div>

                              {/* Search Input */}
                              <div className="relative">
                                <Search className="absolute left-3 top-2.5 h-4 w-4 text-slate-400" />
                                <input
                                  type="text"
                                  placeholder={t.searchPlaceholder}
                                  value={patientSearch}
                                  onChange={(e) => setPatientSearch(e.target.value)}
                                  className="w-full bg-white border border-slate-200/80 rounded-xl py-2 pl-9 pr-4 text-xs font-medium focus:outline-none focus:border-blue-500 shadow-sm"
                                />
                                {patientSearch && (
                                  <button onClick={() => setPatientSearch('')} className="absolute right-3 top-2.5 text-slate-400 hover:text-slate-600">
                                    <X className="h-4 w-4" />
                                  </button>
                                )}
                              </div>

                              {/* 3. Promotional Carousel Banner with Dot Indicators */}
                              <div className="relative overflow-hidden rounded-2xl border border-slate-150 shadow-sm">
                                <div className="bg-gradient-to-r from-blue-600 to-blue-700 p-4 text-white flex justify-between items-center relative min-h-[105px]">
                                  {currentBanner === 0 && (
                                    <div className="space-y-1 z-10 max-w-[190px]">
                                      <span className="bg-blue-500/30 text-[8px] font-bold px-2 py-0.5 rounded-full border border-blue-400/20 uppercase tracking-wide">Discount Alert</span>
                                      <h5 className="font-extrabold text-xs leading-snug">50% Off First Consultation</h5>
                                      <p className="text-[9px] text-blue-100 font-medium">Use Coupon code: <span className="font-mono bg-white/20 px-1 py-0.5 rounded font-bold">HELLODOC50</span></p>
                                    </div>
                                  )}
                                  {currentBanner === 1 && (
                                    <div className="space-y-1 z-10 max-w-[190px]">
                                      <span className="bg-red-500/30 text-[8px] font-bold px-2 py-0.5 rounded-full border border-red-400/20 uppercase tracking-wide text-red-100">Dengue Advisory</span>
                                      <h5 className="font-extrabold text-xs leading-snug">Get Home Blood Test Samples Collection</h5>
                                      <p className="text-[9px] text-red-100 font-medium">Reports dispatched online in 12 hours.</p>
                                    </div>
                                  )}
                                  {currentBanner === 2 && (
                                    <div className="space-y-1 z-10 max-w-[190px]">
                                      <span className="bg-amber-500/30 text-[8px] font-bold px-2 py-0.5 rounded-full border border-amber-400/20 uppercase tracking-wide text-amber-100">Super Fast Delivery</span>
                                      <h5 className="font-extrabold text-xs leading-snug">Order Medicines Instantly</h5>
                                      <p className="text-[9px] text-amber-100 font-medium">Express home dispatch in 2 hours.</p>
                                    </div>
                                  )}

                                  <div className="text-4xl filter saturate-50 select-none opacity-20 absolute right-4 top-4">
                                    {currentBanner === 0 ? '🩺' : currentBanner === 1 ? '🧬' : '💊'}
                                  </div>

                                  <button 
                                    onClick={() => setCurrentBanner(prev => (prev + 1) % 3)} 
                                    className="absolute right-3 bottom-3 bg-white/20 hover:bg-white/30 text-white rounded-full p-1 transition-all"
                                  >
                                    <ChevronRight className="h-3 w-3" />
                                  </button>
                                </div>
                                
                                {/* Dots indicator */}
                                <div className="absolute left-4 bottom-3 flex gap-1 z-10">
                                  {[0, 1, 2].map((i) => (
                                    <span 
                                      key={i} 
                                      onClick={() => setCurrentBanner(i)}
                                      className={`h-1.5 w-1.5 rounded-full transition-all cursor-pointer ${currentBanner === i ? 'bg-white w-3' : 'bg-white/40'}`}
                                    />
                                  ))}
                                </div>
                              </div>

                              {/* 4. Quick Action Cards (Consult, Book, Order, Diagnostic) */}
                              <div className="grid grid-cols-2 gap-3">
                                {/* Consult Now (Instant Video Call) */}
                                <button
                                  onClick={() => {
                                    setActiveVideoCall({
                                      step: 'waiting',
                                      waitingTicks: 0,
                                      status: 'Waiting for doctor',
                                      subStatus: 'The doctor is wrapping up another consult and will join shortly.',
                                      doctorName: 'Dr. Sarah Rahman',
                                      doctorSpecialty: 'General Physician',
                                      doctorDegrees: 'MBBS, FCPS',
                                      appId: 'APT-57291',
                                      duration: 0,
                                      notes: '',
                                      rating: 5,
                                      muted: false,
                                      videoOff: false,
                                      chatExpanded: false,
                                      messages: [
                                        { sender: 'System', text: 'Secure e-consultation room created. Start talking!' }
                                      ]
                                    });
                                    triggerNotification(
                                      patientLanguage === 'EN' ? "Connecting Call..." : "কল সংযোগ করা হচ্ছে...",
                                      patientLanguage === 'EN' ? "Routing you to the first available General Practitioner." : "আপনাকে উপলব্ধ চিকিৎসকের সাথে সংযোগ করা হচ্ছে।"
                                    );
                                  }}
                                  className="text-left bg-white border border-slate-150 p-3 rounded-xl hover:border-blue-500/30 hover:shadow-md transition-all group relative overflow-hidden flex flex-col justify-between"
                                >
                                  <div className="h-8 w-8 bg-blue-50 text-blue-600 rounded-lg flex items-center justify-center shrink-0 mb-3 group-hover:scale-105 transition-all">
                                    <Video className="h-4.5 w-4.5" />
                                  </div>
                                  <div>
                                    <h5 className="font-extrabold text-xs text-slate-800 leading-tight">{t.consultNow}</h5>
                                    <p className="text-[9px] text-slate-400 mt-0.5 leading-normal">{t.consultNowDesc}</p>
                                  </div>
                                </button>

                                {/* Book Appointment */}
                                <button
                                  onClick={() => {
                                    setPatientTab('doctor');
                                    triggerNotification(
                                      patientLanguage === 'EN' ? "Select Doctor" : "ডাক্তার নির্বাচন করুন",
                                      patientLanguage === 'EN' ? "Choose from our catalog of verified clinical specialists." : "যাচাইকৃত বিশেষজ্ঞ চিকিৎসকদের থেকে নির্বাচন করুন।"
                                    );
                                  }}
                                  className="text-left bg-white border border-slate-150 p-3 rounded-xl hover:border-emerald-500/30 hover:shadow-md transition-all group flex flex-col justify-between"
                                >
                                  <div className="h-8 w-8 bg-emerald-50 text-emerald-600 rounded-lg flex items-center justify-center shrink-0 mb-3 group-hover:scale-105 transition-all">
                                    <Calendar className="h-4.5 w-4.5" />
                                  </div>
                                  <div>
                                    <h5 className="font-extrabold text-xs text-slate-800 leading-tight">{t.bookAppt}</h5>
                                    <p className="text-[9px] text-slate-400 mt-0.5 leading-normal">{t.bookApptDesc}</p>
                                  </div>
                                </button>

                                {/* Order Medicine */}
                                <button
                                  onClick={() => {
                                    setMedicineCartModal(true);
                                    triggerNotification(
                                      patientLanguage === 'EN' ? "Lazz Pharmacy Dispatch" : "লাজ ফার্মা ডিসপ্যাচ",
                                      patientLanguage === 'EN' ? "Add common prescribed medicines directly to dispatch." : "কার্টে প্রয়োজনীয় প্রেসক্রিপশন ও ওষুধ যুক্ত করুন।"
                                    );
                                  }}
                                  className="text-left bg-white border border-slate-150 p-3 rounded-xl hover:border-amber-500/30 hover:shadow-md transition-all group flex flex-col justify-between"
                                >
                                  <div className="h-8 w-8 bg-amber-50 text-amber-600 rounded-lg flex items-center justify-center shrink-0 mb-3 group-hover:scale-105 transition-all">
                                    <Pill className="h-4.5 w-4.5" />
                                  </div>
                                  <div>
                                    <h5 className="font-extrabold text-xs text-slate-800 leading-tight">{t.orderMed}</h5>
                                    <p className="text-[9px] text-slate-400 mt-0.5 leading-normal">{t.orderMedDesc}</p>
                                  </div>
                                </button>

                                {/* Book Lab Test */}
                                <button
                                  onClick={() => {
                                    setPatientTab('diagnostic');
                                    triggerNotification(
                                      patientLanguage === 'EN' ? "Diagnostics Partners" : "ডায়াগনস্টিক পার্টনার",
                                      patientLanguage === 'EN' ? "Book lab panels with verified local pathology clinics." : "পাঠলজি ল্যাব ও হোম স্যাম্পল কালেকশন বুকিং করুন।"
                                    );
                                  }}
                                  className="text-left bg-white border border-slate-150 p-3 rounded-xl hover:border-purple-500/30 hover:shadow-md transition-all group flex flex-col justify-between"
                                >
                                  <div className="h-8 w-8 bg-purple-50 text-purple-600 rounded-lg flex items-center justify-center shrink-0 mb-3 group-hover:scale-105 transition-all">
                                    <FlaskConical className="h-4.5 w-4.5" />
                                  </div>
                                  <div>
                                    <h5 className="font-extrabold text-xs text-slate-800 leading-tight">{t.labTest}</h5>
                                    <p className="text-[9px] text-slate-400 mt-0.5 leading-normal">{t.labTestDesc}</p>
                                  </div>
                                </button>
                              </div>

                              {/* 5. Horizontal Medical specialties/departments */}
                              <div className="space-y-2">
                                <div className="flex items-center justify-between">
                                  <h4 className="text-xs font-extrabold text-slate-800 uppercase tracking-wider font-mono">{t.specialties}</h4>
                                  {selectedSpecialty && (
                                    <button onClick={() => setSelectedSpecialty(null)} className="text-[10px] text-blue-600 hover:underline font-bold">
                                      {patientLanguage === 'EN' ? 'Clear Filter' : 'ফিল্টার মুছুন'}
                                    </button>
                                  )}
                                </div>
                                <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-none select-none">
                                  {specialtiesList.map((dept) => {
                                    const DeptIcon = dept.icon;
                                    const isSelected = selectedSpecialty === dept.filterVal;
                                    return (
                                      <button
                                        key={dept.id}
                                        onClick={() => {
                                          setSelectedSpecialty(dept.filterVal);
                                          triggerNotification(
                                            patientLanguage === 'EN' ? 'Specialty Filter Applied' : 'মেডিকেল ফিল্টার প্রয়োগ করা হয়েছে',
                                            `${patientLanguage === 'EN' ? 'Showing' : 'প্রদর্শিত হচ্ছে:'} ${dept.name}`
                                          );
                                        }}
                                        className={`flex items-center gap-1.5 px-3 py-2 rounded-xl text-xs font-semibold whitespace-nowrap transition-all border ${
                                          isSelected 
                                            ? 'bg-blue-600 border-blue-600 text-white shadow-md shadow-blue-500/10 scale-95' 
                                            : 'bg-white border-slate-150 text-slate-600 hover:bg-slate-50'
                                        }`}
                                      >
                                        <DeptIcon className={`h-3.5 w-3.5 ${isSelected ? 'text-white' : 'text-blue-500'}`} />
                                        <span>{dept.name}</span>
                                      </button>
                                    );
                                  })}
                                </div>
                              </div>

                              {/* 6. Popular Doctors horizontal list */}
                              <div className="space-y-2 pb-4">
                                <h4 className="text-xs font-extrabold text-slate-800 uppercase tracking-wider font-mono">{t.popularDocs} ({filteredDoctors.length})</h4>
                                <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-none">
                                  {filteredDoctors.length === 0 ? (
                                    <div className="bg-white border border-slate-150 rounded-2xl p-6 text-center w-full text-xs text-slate-400">
                                      {patientLanguage === 'EN' ? "No doctors match search criteria." : "কোন ডাক্তার পাওয়া যায়নি।"}
                                    </div>
                                  ) : (
                                    filteredDoctors.map((doc) => (
                                      <div 
                                        key={doc.id} 
                                        className="bg-white border border-slate-150 rounded-2xl p-3 shrink-0 w-[185px] space-y-2 shadow-sm flex flex-col justify-between"
                                      >
                                        <div className="flex items-start gap-2">
                                          <div className="h-9 w-9 rounded-lg bg-blue-50 flex items-center justify-center text-lg select-none">
                                            {doc.photo}
                                          </div>
                                          <div className="min-w-0">
                                            <h5 className="font-extrabold text-xs text-slate-800 leading-tight truncate">{doc.name}</h5>
                                            <p className="text-[9px] text-blue-500 font-bold truncate mt-0.5">{doc.specialty}</p>
                                          </div>
                                        </div>

                                        <div className="text-[10px] text-slate-500 space-y-0.5 bg-slate-50 p-1.5 rounded-lg font-medium leading-normal">
                                          <div className="flex items-center justify-between">
                                            <span>⭐ {doc.rating}</span>
                                            <span>({doc.reviews})</span>
                                          </div>
                                          <div className="flex justify-between text-[9px] text-slate-400">
                                            <span>{t.exp}: {doc.exp}</span>
                                            <span className="text-emerald-600 font-bold">● {doc.status}</span>
                                          </div>
                                        </div>

                                        <div className="flex items-center justify-between pt-1 border-t border-slate-100 mt-1">
                                          <div>
                                            <div className="text-[8px] text-slate-400 uppercase font-bold">{t.consultFee}</div>
                                            <div className="text-xs font-extrabold text-slate-800">{doc.fee} {t.bdt}</div>
                                          </div>
                                          <button
                                            onClick={() => {
                                              setSelectedDoctorForBooking(doc);
                                            }}
                                            className="px-2.5 py-1 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-[10px] font-bold transition-all shadow-sm"
                                          >
                                            {t.bookAppt}
                                          </button>
                                        </div>
                                      </div>
                                    ))
                                  )}
                                </div>
                              </div>
                            </>
                          )}

                          {/* CLIPS (HEALTH FEED) TAB */}
                          {patientTab === 'clips' && (
                            <div className="space-y-4 flex-1 flex flex-col h-full overflow-hidden">
                              <div className="mt-1 px-4">
                                <span className="text-xs bg-blue-100 text-blue-600 font-bold px-2 py-0.5 rounded-full font-mono uppercase tracking-wider">{patientLanguage === 'EN' ? 'HEALTH FEED' : 'হেলথ ফিড'}</span>
                                <h4 className="text-sm font-extrabold text-slate-800 tracking-tight leading-tight mt-1">{patientLanguage === 'EN' ? 'Facebook-Style Medical & Health Feed' : 'মেডিকেল ও হেলথ নিউজ ফিড'}</h4>
                              </div>
                              {renderHealthFeed({ id: 'patient_mock', name: 'Karim Uddin', role: 'Patient', avatar: '👤' })}
                            </div>
                          )}

                          {/* DOCTOR SPECIALISTS DIRECTORY TAB */}
                          {patientTab === 'doctor' && (
                            <div className="space-y-4">
                              <div className="mt-1">
                                <h4 className="text-sm font-extrabold text-slate-800 tracking-tight leading-tight">{patientLanguage === 'EN' ? 'Specialist Clinical Directory' : 'বিশেষজ্ঞ ক্লিনিক্যাল ডিরেক্টরি'}</h4>
                                <p className="text-[10px] text-slate-500 mt-0.5">{patientLanguage === 'EN' ? 'Browse all verified physicians online' : 'অনলাইনে আমাদের নিবন্ধিত ডাক্তারগণ'}</p>
                              </div>

                              {/* Quick directory search */}
                              <div className="relative">
                                <Search className="absolute left-3 top-2.5 h-4 w-4 text-slate-400" />
                                <input
                                  type="text"
                                  placeholder={t.searchPlaceholder}
                                  value={patientSearch}
                                  onChange={(e) => setPatientSearch(e.target.value)}
                                  className="w-full bg-white border border-slate-200/80 rounded-xl py-2 pl-9 pr-4 text-xs font-medium focus:outline-none focus:border-blue-500 shadow-sm"
                                />
                              </div>

                              {/* Specialty quick selections */}
                              <div className="flex gap-1.5 overflow-x-auto pb-1 select-none scrollbar-none text-[10px]">
                                {specialtiesList.map((dept) => {
                                  const isSelected = selectedSpecialty === dept.filterVal;
                                  return (
                                    <button
                                      key={dept.id}
                                      onClick={() => setSelectedSpecialty(dept.filterVal)}
                                      className={`px-2.5 py-1 rounded-full whitespace-nowrap transition-all border ${
                                        isSelected 
                                          ? 'bg-blue-600 border-blue-600 text-white font-bold' 
                                          : 'bg-white border-slate-150 text-slate-500 hover:bg-slate-50'
                                      }`}
                                    >
                                      {dept.name}
                                    </button>
                                  );
                                })}
                              </div>

                              <div className="space-y-3">
                                {filteredDoctors.map((doc) => (
                                  <div key={doc.id} className="bg-white border border-slate-150 rounded-2xl p-3 shadow-sm flex gap-3">
                                    <div className="h-12 w-12 rounded-xl bg-blue-50 border border-blue-100 flex items-center justify-center text-2xl select-none shrink-0">
                                      {doc.photo}
                                    </div>
                                    <div className="flex-1 min-w-0 space-y-1">
                                      <div className="flex items-start justify-between gap-1">
                                        <div className="min-w-0">
                                          <h5 className="font-extrabold text-xs text-slate-800 leading-tight truncate">{doc.name}</h5>
                                          <p className="text-[9px] text-blue-500 font-bold truncate mt-0.5">{doc.specialty}</p>
                                        </div>
                                        <span className="text-[9px] bg-emerald-50 text-emerald-700 px-1.5 py-0.5 rounded-md font-mono font-bold whitespace-nowrap">
                                          {doc.status}
                                        </span>
                                      </div>

                                      <p className="text-[10px] text-slate-400 line-clamp-1 leading-relaxed font-medium">{doc.bio}</p>

                                      <div className="flex items-center justify-between pt-1.5 border-t border-slate-100 mt-1.5 text-[10px] text-slate-500">
                                        <span className="font-semibold">Fee: <strong className="text-slate-800">{doc.fee} {t.bdt}</strong></span>
                                        <button 
                                          onClick={() => setSelectedDoctorForBooking(doc)}
                                          className="text-xs text-blue-600 hover:underline font-extrabold"
                                        >
                                          {t.bookAppt} →
                                        </button>
                                      </div>
                                    </div>
                                  </div>
                                ))}
                              </div>
                            </div>
                          )}

                          {/* DIAGNOSTIC PORTAL TAB */}
                          {patientTab === 'diagnostic' && (
                            <div className="space-y-4">
                              <div className="mt-1">
                                <span className="text-xs bg-purple-100 text-purple-700 font-bold px-2 py-0.5 rounded-full font-mono uppercase tracking-wider">{patientLanguage === 'EN' ? 'DIAGNOSTICS' : 'ডায়াগনস্টিক'}</span>
                                <h4 className="text-sm font-extrabold text-slate-800 tracking-tight leading-tight mt-1">{t.diagnosticTitle}</h4>
                              </div>

                              <div className="space-y-3">
                                {labPackages.map((pack) => (
                                  <div key={pack.id} className="bg-white border border-slate-150 rounded-2xl p-3 shadow-sm space-y-2">
                                    <div className="flex items-start justify-between">
                                      <div>
                                        <h5 className="font-extrabold text-xs text-slate-800 leading-snug">{pack.name}</h5>
                                        <p className="text-[10px] text-slate-400 mt-0.5 leading-normal">{pack.desc}</p>
                                      </div>
                                      <div className="text-right shrink-0">
                                        <span className="text-xs font-extrabold text-purple-600">{pack.price} {t.bdt}</span>
                                      </div>
                                    </div>

                                    <button
                                      onClick={() => {
                                        setLabBookingModal(pack);
                                        triggerNotification(
                                          patientLanguage === 'EN' ? "Lab Test Selected" : "ল্যাব টেস্ট নির্বাচন সম্পন্ন",
                                          `${pack.name} ${patientLanguage === 'EN' ? 'queued. Confirm your slot.' : 'যোগ করা হয়েছে।'}`
                                        );
                                      }}
                                      className="w-full py-1.5 bg-purple-50 hover:bg-purple-100 text-purple-700 rounded-lg text-[10px] font-bold transition-all border border-purple-100"
                                    >
                                      {patientLanguage === 'EN' ? "Schedule Home Collection" : "হোম কালেকশন শিডিউল করুন"}
                                    </button>
                                  </div>
                                ))}
                              </div>
                            </div>
                          )}

                          {/* MORE SETTINGS / PRESCRIPTIONS TAB */}
                          {patientTab === 'more' && (
                            <div className="space-y-4">
                              {patientMoreSubScreen === null ? (
                                <div className="space-y-4 animate-fadeIn">
                                  <div className="mt-1">
                                    <h4 className="text-sm font-extrabold text-slate-800 tracking-tight leading-tight">{t.moreTitle}</h4>
                                    <p className="text-[10px] text-slate-500 mt-0.5">{patientLanguage === 'EN' ? 'Manage electronic health records & options' : 'আপনার ইলেকট্রনিক হেলথ রেকর্ড ও অপশন'}</p>
                                  </div>

                                  {/* Beautiful Menu List */}
                                  <div className="bg-white border border-slate-150 rounded-2xl divide-y divide-slate-100 overflow-hidden shadow-sm">
                                    <button 
                                      onClick={() => setPatientMoreSubScreen('profile')}
                                      className="w-full flex items-center justify-between p-3.5 hover:bg-slate-50 transition-all text-left"
                                    >
                                      <div className="flex items-center gap-3">
                                        <div className="p-2 bg-blue-50 text-blue-600 rounded-xl">
                                          <User className="h-4 w-4" />
                                        </div>
                                        <div>
                                          <h5 className="text-xs font-bold text-slate-800 leading-tight">Patient Profile</h5>
                                          <p className="text-[9px] text-slate-400 font-medium">Personal info, photo & medical history</p>
                                        </div>
                                      </div>
                                      <ChevronRight className="h-4 w-4 text-slate-400" />
                                    </button>

                                    <button 
                                      onClick={() => setPatientMoreSubScreen('insurance')}
                                      className="w-full flex items-center justify-between p-3.5 hover:bg-slate-50 transition-all text-left"
                                    >
                                      <div className="flex items-center gap-3">
                                        <div className="p-2 bg-emerald-50 text-emerald-600 rounded-xl">
                                          <Shield className="h-4 w-4" />
                                        </div>
                                        <div>
                                          <h5 className="text-xs font-bold text-slate-800 leading-tight">Health Insurance</h5>
                                          <p className="text-[9px] text-slate-400 font-medium">Verify coverage benefits & upload card</p>
                                        </div>
                                      </div>
                                      <ChevronRight className="h-4 w-4 text-slate-400" />
                                    </button>

                                    <button 
                                      onClick={() => setPatientMoreSubScreen('appointments')}
                                      className="w-full flex items-center justify-between p-3.5 hover:bg-slate-50 transition-all text-left"
                                    >
                                      <div className="flex items-center gap-3">
                                        <div className="p-2 bg-indigo-50 text-indigo-600 rounded-xl">
                                          <Calendar className="h-4 w-4" />
                                        </div>
                                        <div>
                                          <h5 className="text-xs font-bold text-slate-800 leading-tight">My Appointments</h5>
                                          <p className="text-[9px] text-slate-400 font-medium">Upcoming & past consult summaries</p>
                                        </div>
                                      </div>
                                      <ChevronRight className="h-4 w-4 text-slate-400" />
                                    </button>

                                    <button 
                                      onClick={() => setPatientMoreSubScreen('notifications')}
                                      className="w-full flex items-center justify-between p-3.5 hover:bg-slate-50 transition-all text-left"
                                    >
                                      <div className="flex items-center gap-3">
                                        <div className="p-2 bg-amber-50 text-amber-600 rounded-xl relative">
                                          <Bell className="h-4 w-4" />
                                          {patientSimulatedNotifications.some(n => !n.isRead) && (
                                            <span className="absolute top-1.5 right-1.5 w-1.5 h-1.5 bg-red-500 rounded-full animate-pulse" />
                                          )}
                                        </div>
                                        <div>
                                          <h5 className="text-xs font-bold text-slate-800 leading-tight">Notifications</h5>
                                          <p className="text-[9px] text-slate-400 font-medium">Live status alerts & local triggers</p>
                                        </div>
                                      </div>
                                      <ChevronRight className="h-4 w-4 text-slate-400" />
                                    </button>

                                    <button 
                                      onClick={() => setPatientMoreSubScreen('support')}
                                      className="w-full flex items-center justify-between p-3.5 hover:bg-slate-50 transition-all text-left"
                                    >
                                      <div className="flex items-center gap-3">
                                        <div className="p-2 bg-purple-50 text-purple-600 rounded-xl">
                                          <HelpCircle className="h-4 w-4" />
                                        </div>
                                        <div>
                                          <h5 className="text-xs font-bold text-slate-800 leading-tight">Help & Support</h5>
                                          <p className="text-[9px] text-slate-400 font-medium">FAQ database & customer helpdesk</p>
                                        </div>
                                      </div>
                                      <ChevronRight className="h-4 w-4 text-slate-400" />
                                    </button>
                                  </div>

                                  {/* Interactive Help & Log Out */}
                                  <div className="space-y-2">
                                    <button
                                      onClick={() => triggerNotification(
                                        patientLanguage === 'EN' ? "Dialing Support Helpline" : "হেল্পলাইনে কল করা হচ্ছে", 
                                        "16263 (Ministry of Health clinical telemedicine loop mock)"
                                      )}
                                      className="w-full py-2.5 border border-dashed border-blue-200 text-blue-600 rounded-xl text-xs font-semibold hover:bg-blue-50 transition-all flex items-center justify-center gap-1.5"
                                    >
                                      <Phone className="h-3.5 w-3.5" />
                                      {t.support} (16263)
                                    </button>

                                    <button
                                      onClick={() => {
                                        setCurrentUser(null);
                                        setFlutterScreen('role_selection');
                                        triggerNotification(
                                          patientLanguage === 'EN' ? "Logged Out" : "লগআউট করা হয়েছে", 
                                          patientLanguage === 'EN' ? "Clinical session cleared." : "ক্লিনিক্যাল সেশন বন্ধ হয়েছে।"
                                        );
                                      }}
                                      className="w-full py-2.5 bg-red-50 text-red-600 hover:bg-red-100 rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-1.5"
                                    >
                                      <LogOut className="h-3.5 w-3.5" />
                                      {patientLanguage === 'EN' ? "Log Out Clinical Session" : "ক্লিনিক্যাল সেশন থেকে প্রস্থান"}
                                    </button>
                                  </div>
                                </div>
                              ) : (
                                <div className="space-y-4 animate-fadeIn">
                                  {/* BACK HEADER */}
                                  <button 
                                    onClick={() => setPatientMoreSubScreen(null)}
                                    className="flex items-center gap-1.5 text-xs font-bold text-blue-600 hover:text-blue-700 bg-blue-50/50 px-3 py-1.5 rounded-lg transition-all"
                                  >
                                    <ArrowLeft className="h-3.5 w-3.5" />
                                    Back to Menu
                                  </button>

                                  {/* SUB-SCREEN 1: PROFILE */}
                                  {patientMoreSubScreen === 'profile' && (
                                    <div className="space-y-4">
                                      <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm space-y-4">
                                        <div className="flex items-center gap-3">
                                          <div className="h-12 w-12 bg-blue-100 rounded-full flex items-center justify-center text-blue-700 text-sm font-bold">
                                            {patientProfileName.split(' ').map(n => n[0]).join('')}
                                          </div>
                                          <div>
                                            <h5 className="text-sm font-bold text-slate-800">Edit Profile Details</h5>
                                            <p className="text-[10px] text-slate-400">Manage digital identification info</p>
                                          </div>
                                        </div>

                                        <div className="grid grid-cols-2 gap-3">
                                          <div className="col-span-2">
                                            <label className="block text-[10px] font-bold text-slate-400 mb-1">Full Name</label>
                                            <input 
                                              type="text" 
                                              value={patientProfileName} 
                                              onChange={(e) => setPatientProfileName(e.target.value)}
                                              className="w-full border border-slate-200 rounded-lg p-2 text-xs focus:ring-1 focus:ring-blue-500 outline-none"
                                            />
                                          </div>
                                          <div>
                                            <label className="block text-[10px] font-bold text-slate-400 mb-1">Date of Birth</label>
                                            <input 
                                              type="text" 
                                              value={patientProfileDob} 
                                              onChange={(e) => setPatientProfileDob(e.target.value)}
                                              className="w-full border border-slate-200 rounded-lg p-2 text-xs focus:ring-1 focus:ring-blue-500 outline-none"
                                            />
                                          </div>
                                          <div>
                                            <label className="block text-[10px] font-bold text-slate-400 mb-1">Blood Group</label>
                                            <select 
                                              value={patientProfileBlood} 
                                              onChange={(e) => setPatientProfileBlood(e.target.value)}
                                              className="w-full border border-slate-200 rounded-lg p-2 text-xs focus:ring-1 focus:ring-blue-500 outline-none"
                                            >
                                              {['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].map(bg => (
                                                <option key={bg} value={bg}>{bg}</option>
                                              ))}
                                            </select>
                                          </div>
                                          <div className="col-span-2">
                                            <label className="block text-[10px] font-bold text-slate-400 mb-1">Residential Address</label>
                                            <input 
                                              type="text" 
                                              value={patientProfileAddress} 
                                              onChange={(e) => setPatientProfileAddress(e.target.value)}
                                              className="w-full border border-slate-200 rounded-lg p-2 text-xs focus:ring-1 focus:ring-blue-500 outline-none"
                                            />
                                          </div>
                                        </div>
                                      </div>

                                      {/* Digital Medical History */}
                                      <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm space-y-3">
                                        <h5 className="font-bold text-[10px] text-slate-400 font-mono tracking-wider uppercase">Digital Medical History</h5>
                                        
                                        {/* Allergies */}
                                        <div className="space-y-1.5">
                                          <span className="text-[10.5px] font-bold text-slate-700">Drug & Food Allergies</span>
                                          <div className="flex flex-wrap gap-1.5">
                                            {patientProfileAllergies.map(tag => (
                                              <span key={tag} className="flex items-center gap-1 bg-red-50 text-red-600 border border-red-100 px-2 py-0.5 rounded-full text-[9px] font-bold">
                                                {tag}
                                                <button onClick={() => setPatientProfileAllergies(patientProfileAllergies.filter(t => t !== tag))} className="text-red-400 hover:text-red-600">×</button>
                                              </span>
                                            ))}
                                            <button 
                                              onClick={() => {
                                                const val = prompt('Enter allergy:');
                                                if (val) setPatientProfileAllergies([...patientProfileAllergies, val]);
                                              }}
                                              className="text-[9px] font-bold text-blue-600 border border-dashed border-blue-200 px-2 py-0.5 rounded-full hover:bg-blue-50"
                                            >
                                              + Add tag
                                            </button>
                                          </div>
                                        </div>

                                        {/* Chronic Conditions */}
                                        <div className="space-y-1.5 pt-2">
                                          <span className="text-[10.5px] font-bold text-slate-700">Chronic Illnesses</span>
                                          <div className="flex flex-wrap gap-1.5">
                                            {patientProfileConditions.map(tag => (
                                              <span key={tag} className="flex items-center gap-1 bg-amber-50 text-amber-600 border border-amber-100 px-2 py-0.5 rounded-full text-[9px] font-bold">
                                                {tag}
                                                <button onClick={() => setPatientProfileConditions(patientProfileConditions.filter(t => t !== tag))} className="text-amber-400 hover:text-amber-600">×</button>
                                              </span>
                                            ))}
                                            <button 
                                              onClick={() => {
                                                const val = prompt('Enter condition:');
                                                if (val) setPatientProfileConditions([...patientProfileConditions, val]);
                                              }}
                                              className="text-[9px] font-bold text-blue-600 border border-dashed border-blue-200 px-2 py-0.5 rounded-full hover:bg-blue-50"
                                            >
                                              + Add tag
                                            </button>
                                          </div>
                                        </div>

                                        {/* Surgeries */}
                                        <div className="space-y-1.5 pt-2">
                                          <span className="text-[10.5px] font-bold text-slate-700">Past Surgeries</span>
                                          <div className="flex flex-wrap gap-1.5">
                                            {patientProfileSurgeries.map(tag => (
                                              <span key={tag} className="flex items-center gap-1 bg-indigo-50 text-indigo-600 border border-indigo-100 px-2 py-0.5 rounded-full text-[9px] font-bold">
                                                {tag}
                                                <button onClick={() => setPatientProfileSurgeries(patientProfileSurgeries.filter(t => t !== tag))} className="text-indigo-400 hover:text-indigo-600">×</button>
                                              </span>
                                            ))}
                                            <button 
                                              onClick={() => {
                                                const val = prompt('Enter surgery:');
                                                if (val) setPatientProfileSurgeries([...patientProfileSurgeries, val]);
                                              }}
                                              className="text-[9px] font-bold text-blue-600 border border-dashed border-blue-200 px-2 py-0.5 rounded-full hover:bg-blue-50"
                                            >
                                              + Add tag
                                            </button>
                                          </div>
                                        </div>
                                      </div>

                                      <button 
                                        onClick={() => {
                                          triggerNotification("Profile Saved", "All personal variables & medical histories successfully persisted.");
                                          setPatientMoreSubScreen(null);
                                        }}
                                        className="w-full py-2.5 bg-blue-600 text-white hover:bg-blue-700 rounded-xl font-bold text-xs"
                                      >
                                        Save Changes
                                      </button>
                                    </div>
                                  )}

                                  {/* SUB-SCREEN 2: INSURANCE */}
                                  {patientMoreSubScreen === 'insurance' && (
                                    <div className="space-y-4">
                                      {/* Verification Status Banner */}
                                      <div className={`p-4 rounded-2xl border flex items-center gap-3.5 ${patientInsuranceVerified ? 'bg-emerald-50 border-emerald-100 text-emerald-800' : 'bg-amber-50 border-amber-100 text-amber-800'}`}>
                                        <div className={`p-2 rounded-xl text-white ${patientInsuranceVerified ? 'bg-emerald-500' : 'bg-amber-500'}`}>
                                          <ShieldAlert className="h-5 w-5" />
                                        </div>
                                        <div className="flex-1 min-w-0">
                                          <h6 className="text-xs font-bold leading-tight">{patientInsuranceVerified ? 'Verification Active' : 'Verification Pending'}</h6>
                                          <p className="text-[9px] text-slate-500 font-medium leading-tight mt-0.5">Benefits are subject to e-Desk checks.</p>
                                        </div>
                                        {/* Toggle switch for easy simulation testing */}
                                        <label className="relative inline-flex items-center cursor-pointer select-none shrink-0">
                                          <input 
                                            type="checkbox" 
                                            className="sr-only peer" 
                                            checked={patientInsuranceVerified}
                                            onChange={(e) => setPatientInsuranceVerified(e.target.checked)}
                                          />
                                          <div className="w-9 h-5 bg-slate-200 rounded-full peer peer-checked:after:translate-x-full peer-checked:bg-emerald-500 after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-4 after:w-4 after:transition-all"></div>
                                        </label>
                                      </div>

                                      {/* Policy Forms */}
                                      <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm space-y-3">
                                        <h5 className="font-bold text-[10px] text-slate-400 font-mono tracking-wider uppercase">Insurance Policy Details</h5>
                                        <div className="space-y-2">
                                          <div>
                                            <label className="block text-[10.5px] font-bold text-slate-600 mb-0.5">Insurance Provider</label>
                                            <input 
                                              type="text" 
                                              value={patientInsuranceProvider} 
                                              onChange={(e) => setPatientInsuranceProvider(e.target.value)}
                                              className="w-full border border-slate-200 rounded-lg p-2 text-xs outline-none"
                                            />
                                          </div>
                                          <div>
                                            <label className="block text-[10.5px] font-bold text-slate-600 mb-0.5">Policy Number</label>
                                            <input 
                                              type="text" 
                                              value={patientInsurancePolicy} 
                                              onChange={(e) => setPatientInsurancePolicy(e.target.value)}
                                              className="w-full border border-slate-200 rounded-lg p-2 text-xs outline-none"
                                            />
                                          </div>
                                        </div>
                                      </div>

                                      {/* Card Photo upload mock */}
                                      <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm space-y-3">
                                        <h5 className="font-bold text-[10px] text-slate-400 font-mono tracking-wider uppercase">Card Image Submissions</h5>
                                        <div className="grid grid-cols-2 gap-3">
                                          <button 
                                            onClick={() => {
                                              setPatientInsuranceFront('https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=300');
                                              triggerNotification("Front Card Processed", "Image compressed & attached.");
                                            }}
                                            className="h-24 border border-dashed border-slate-200 rounded-xl hover:bg-slate-50 transition-all flex flex-col items-center justify-center gap-1.5"
                                          >
                                            {patientInsuranceFront ? (
                                              <img src={patientInsuranceFront} alt="front" className="h-full w-full object-cover rounded-xl" />
                                            ) : (
                                              <>
                                                <PlusCircle className="h-5 w-5 text-slate-400" />
                                                <span className="text-[10px] font-bold text-slate-600">Upload Front</span>
                                              </>
                                            )}
                                          </button>

                                          <button 
                                            onClick={() => {
                                              setPatientInsuranceBack('https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=300');
                                              triggerNotification("Back Card Processed", "Image compressed & attached.");
                                            }}
                                            className="h-24 border border-dashed border-slate-200 rounded-xl hover:bg-slate-50 transition-all flex flex-col items-center justify-center gap-1.5"
                                          >
                                            {patientInsuranceBack ? (
                                              <img src={patientInsuranceBack} alt="back" className="h-full w-full object-cover rounded-xl" />
                                            ) : (
                                              <>
                                                <PlusCircle className="h-5 w-5 text-slate-400" />
                                                <span className="text-[10px] font-bold text-slate-600">Upload Back</span>
                                              </>
                                            )}
                                          </button>
                                        </div>
                                      </div>

                                      <button 
                                        onClick={() => {
                                          triggerNotification("Policy Registered", "e-Health validation ticket created.");
                                          setPatientMoreSubScreen(null);
                                        }}
                                        className="w-full py-2.5 bg-blue-600 text-white hover:bg-blue-700 rounded-xl font-bold text-xs"
                                      >
                                        Save & Verify Policy
                                      </button>
                                    </div>
                                  )}

                                  {/* SUB-SCREEN 3: APPOINTMENTS */}
                                  {patientMoreSubScreen === 'appointments' && (
                                    <div className="space-y-4">
                                      <div className="bg-white border border-slate-150 rounded-2xl p-3.5 shadow-sm space-y-3">
                                        <h5 className="font-bold text-[10px] text-slate-400 font-mono tracking-wider uppercase">Upcoming Appointments</h5>
                                        <div className="bg-blue-50/45 border border-blue-100 p-3 rounded-2xl flex flex-col gap-2.5">
                                          <div className="flex justify-between items-start">
                                            <div>
                                              <div className="text-[11px] font-extrabold text-slate-800">Dr. Sarah Rahman</div>
                                              <div className="text-[9.5px] text-blue-600 font-extrabold font-mono mt-0.5">Today • 04:00 PM</div>
                                            </div>
                                            <span className="bg-emerald-500/10 text-emerald-600 text-[8px] font-bold px-2 py-0.5 rounded font-mono uppercase tracking-wider">
                                              Upcoming
                                            </span>
                                          </div>
                                          <button 
                                            onClick={() => setActiveVideoCall({
                                              step: 'waiting',
                                              waitingTicks: 0,
                                              status: 'Waiting for doctor',
                                              subStatus: 'The doctor is wrapping up another consult and will join shortly.',
                                              doctorName: 'Dr. Sarah Rahman',
                                              doctorSpecialty: 'Cardiologist',
                                              doctorDegrees: 'MBBS, FCPS',
                                              appId: 'APT-38290',
                                              duration: 0,
                                              notes: '',
                                              rating: 5,
                                              muted: false,
                                              videoOff: false,
                                              chatExpanded: false,
                                              messages: [
                                                { sender: 'System', text: 'Secure e-consultation room created. Start talking!' }
                                              ]
                                            })}
                                            className="w-full py-1.5 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-[10px] font-extrabold transition-all shadow-sm flex items-center justify-center gap-1"
                                          >
                                            <Video className="h-3.5 w-3.5" />
                                            {patientLanguage === 'EN' ? "Join Video Consultation" : "কনসালটেশনে যোগ দিন"}
                                          </button>
                                        </div>
                                      </div>

                                      <div className="bg-white border border-slate-150 rounded-2xl p-3.5 shadow-sm space-y-3">
                                        <h5 className="font-bold text-[10px] text-slate-400 font-mono tracking-wider uppercase">Past Visits</h5>
                                        <div className="space-y-2">
                                          <div className="bg-slate-50 border border-slate-150 p-2.5 rounded-xl flex items-center justify-between gap-2">
                                            <div className="min-w-0">
                                              <div className="text-[10px] font-bold text-slate-700 truncate">Cardiology Checkup</div>
                                              <div className="text-[9px] text-slate-400 font-medium">Dr. Sarah Rahman • Completed</div>
                                            </div>
                                            <button 
                                              onClick={() => setConsultationModal(true)}
                                              className="text-[10px] font-bold bg-blue-50 text-blue-600 hover:bg-blue-100 px-2.5 py-1 rounded-md shrink-0"
                                            >
                                              Summary
                                            </button>
                                          </div>
                                        </div>
                                      </div>
                                    </div>
                                  )}

                                  {/* SUB-SCREEN 4: NOTIFICATIONS */}
                                  {patientMoreSubScreen === 'notifications' && (
                                    <div className="space-y-4">
                                      {/* Inject and Controls */}
                                      <div className="bg-slate-50 border border-slate-200 p-3 rounded-2xl flex items-center justify-between gap-1.5">
                                        <span className="text-[10px] font-bold text-slate-600">Simulate:</span>
                                        <div className="flex gap-1.5">
                                          <button 
                                            onClick={() => {
                                              setPatientSimulatedNotifications([
                                                {
                                                  id: String(Date.now()),
                                                  title: 'Appt Starting Soon',
                                                  body: 'Your live session with Dr. Sarah Rahman is ready!',
                                                  time: 'Just now',
                                                  type: 'reminder',
                                                  isRead: false
                                                },
                                                ...patientSimulatedNotifications
                                              ]);
                                              triggerNotification("Local Push Triggered", "Live consultation starts soon.");
                                            }}
                                            className="bg-blue-50 text-blue-600 hover:bg-blue-100 text-[9px] font-bold px-2 py-1 rounded"
                                          >
                                            Appt Soon
                                          </button>
                                          <button 
                                            onClick={() => {
                                              setPatientSimulatedNotifications([
                                                {
                                                  id: String(Date.now()),
                                                  title: 'Lab Report Verified',
                                                  body: 'Your diagnostic test CBC-839 is verified.',
                                                  time: 'Just now',
                                                  type: 'order',
                                                  isRead: false
                                                },
                                                ...patientSimulatedNotifications
                                              ]);
                                              triggerNotification("Local Push Triggered", "Diagnostic verified.");
                                            }}
                                            className="bg-purple-50 text-purple-600 hover:bg-purple-100 text-[9px] font-bold px-2 py-1 rounded"
                                          >
                                            Lab Ready
                                          </button>
                                        </div>
                                      </div>

                                      <div className="space-y-2">
                                        {patientSimulatedNotifications.map(n => (
                                          <div key={n.id} className={`p-3.5 rounded-2xl border transition-all ${n.isRead ? 'bg-white border-slate-150' : 'bg-blue-50/20 border-blue-100'}`}>
                                            <div className="flex justify-between items-start gap-2">
                                              <h6 className="text-[11px] font-bold text-slate-800">{n.title}</h6>
                                              {!n.isRead && <span className="w-1.5 h-1.5 bg-blue-600 rounded-full shrink-0" />}
                                            </div>
                                            <p className="text-[10px] text-slate-500 mt-0.5 leading-snug">{n.body}</p>
                                            <div className="flex justify-between items-center mt-2.5">
                                              <span className="text-[9px] text-slate-400 font-medium">{n.time}</span>
                                              <button 
                                                onClick={() => {
                                                  setPatientSimulatedNotifications(
                                                    patientSimulatedNotifications.map(x => x.id === n.id ? { ...x, isRead: !x.isRead } : x)
                                                  );
                                                }}
                                                className="text-[9px] font-bold text-blue-600 hover:text-blue-700"
                                              >
                                                {n.isRead ? 'Mark Unread' : 'Mark Read'}
                                              </button>
                                            </div>
                                          </div>
                                        ))}
                                      </div>
                                    </div>
                                  )}

                                  {/* SUB-SCREEN 5: HELP & SUPPORT */}
                                  {patientMoreSubScreen === 'support' && (
                                    <div className="space-y-4">
                                      {/* Support Hotline banner */}
                                      <div className="bg-blue-600 rounded-2xl p-4 text-white text-center space-y-3 shadow-sm">
                                        <PhoneCall className="h-6 w-6 mx-auto text-blue-200" />
                                        <div>
                                          <h6 className="text-xs font-bold">24/7 Clinical Helpdesk</h6>
                                          <p className="text-[9.5px] text-blue-100 mt-0.5">Contact support for instant reservation queries</p>
                                        </div>
                                        <button 
                                          onClick={() => alert('Starting live support simulation...')}
                                          className="bg-white text-blue-600 font-bold text-[10px] px-3 py-1.5 rounded-lg w-full"
                                        >
                                          Start Support Chat
                                        </button>
                                      </div>

                                      {/* FAQs */}
                                      <div className="bg-white border border-slate-150 rounded-2xl p-3.5 shadow-sm space-y-2">
                                        <h5 className="font-bold text-[10px] text-slate-400 font-mono tracking-wider uppercase">FAQ Database</h5>
                                        <div className="space-y-1.5">
                                          {[
                                            { q: "How do I book a video consult?", a: "Select a specialty, pick your doctor, and choose an available slot." },
                                            { q: "Are doctors verified?", a: "Yes, every clinician is manually BMDC checked and approved." },
                                            { q: "Can I cancel/refund?", a: "Yes, cancel any consult from your appointments panel up to 1 hour before." }
                                          ].map((faq, idx) => {
                                            const isExp = patientFaqExpanded === idx;
                                            return (
                                              <div key={idx} className="border-b border-slate-100 last:border-none pb-1.5 last:pb-0">
                                                <button 
                                                  onClick={() => setPatientFaqExpanded(isExp ? null : idx)}
                                                  className="w-full flex items-center justify-between text-left py-1 text-[10.5px] font-bold text-slate-700 hover:text-blue-600 transition-all"
                                                >
                                                  <span>{faq.q}</span>
                                                  <ChevronRight className={`h-3 w-3 text-slate-400 transform transition-transform ${isExp ? 'rotate-90' : ''}`} />
                                                </button>
                                                {isExp && (
                                                  <p className="text-[9.5px] text-slate-500 bg-slate-50 p-2 rounded-lg mt-1 leading-relaxed animate-fadeIn">
                                                    {faq.a}
                                                  </p>
                                                )}
                                              </div>
                                            );
                                          })}
                                        </div>
                                      </div>
                                    </div>
                                  )}
                                </div>
                              )}
                            </div>
                          )}

                        </div>

                        {/* Interactive iOS/Android styled Bottom Tab Navigation of the App */}
                        <div className="absolute bottom-0 left-0 right-0 h-13 bg-white border-t border-slate-150 grid grid-cols-5 items-center justify-items-center text-[9px] font-bold text-slate-400 z-30 shadow-[0_-2px_10px_rgba(0,0,0,0.02)]">
                          <button
                            onClick={() => setPatientTab('home')}
                            className={`flex flex-col items-center gap-0.5 ${patientTab === 'home' ? 'text-blue-600 font-extrabold' : 'hover:text-slate-600'}`}
                          >
                            <Hospital className="h-4 w-4" />
                            <span>{patientLanguage === 'EN' ? 'Home' : 'হোম'}</span>
                          </button>
                          
                          <button
                            onClick={() => setPatientTab('clips')}
                            className={`flex flex-col items-center gap-0.5 ${patientTab === 'clips' ? 'text-blue-600 font-extrabold' : 'hover:text-slate-600'}`}
                          >
                            <Activity className="h-4 w-4" />
                            <span>{patientLanguage === 'EN' ? 'Health Feed' : 'হেলথ ফিড'}</span>
                          </button>

                          <button
                            onClick={() => setPatientTab('doctor')}
                            className={`flex flex-col items-center gap-0.5 ${patientTab === 'doctor' ? 'text-blue-600 font-extrabold' : 'hover:text-slate-600'}`}
                          >
                            <Stethoscope className="h-4 w-4" />
                            <span>{patientLanguage === 'EN' ? 'Doctor' : 'ডাক্তার'}</span>
                          </button>

                          <button
                            onClick={() => setPatientTab('diagnostic')}
                            className={`flex flex-col items-center gap-0.5 ${patientTab === 'diagnostic' ? 'text-blue-600 font-extrabold' : 'hover:text-slate-600'}`}
                          >
                            <FlaskConical className="h-4 w-4" />
                            <span>{patientLanguage === 'EN' ? 'Diagnostic' : 'ল্যাব'}</span>
                          </button>

                          <button
                            onClick={() => setPatientTab('more')}
                            className={`flex flex-col items-center gap-0.5 ${patientTab === 'more' ? 'text-blue-600 font-extrabold' : 'hover:text-slate-600'}`}
                          >
                            <User className="h-4 w-4" />
                            <span>{patientLanguage === 'EN' ? 'More' : 'প্রোফাইল'}</span>
                          </button>
                        </div>

                        {/* ==================== INTERACTIVE SIMULATOR OVERLAYS ==================== */}

                        {/* A. Live Simulated Video Consultation Call */}
                        <AnimatePresence>
                          {activeVideoCall && (
                            <motion.div
                              initial={{ opacity: 0, scale: 0.95 }}
                              animate={{ opacity: 1, scale: 1 }}
                              exit={{ opacity: 0, scale: 0.95 }}
                              className="absolute inset-0 bg-slate-900 z-50 text-white flex flex-col justify-between overflow-hidden"
                            >
                              {/* ----------------- STEP 1: VIRTUAL WAITING ROOM ----------------- */}
                              {activeVideoCall.step === 'waiting' && (
                                <div className="flex-1 flex flex-col justify-between p-5 text-center">
                                  <div className="flex items-center justify-between pt-2">
                                    <div className="flex items-center gap-1">
                                      <Activity className="h-4 w-4 text-blue-500 animate-pulse" />
                                      <span className="font-mono text-[9px] text-blue-400 font-bold uppercase tracking-wider">SECURE RTC LINK</span>
                                    </div>
                                    <span className="text-[9px] font-mono bg-white/10 px-2 py-0.5 rounded text-slate-300 font-bold">
                                      ID: {activeVideoCall.appId}
                                    </span>
                                  </div>

                                  <div className="space-y-6 my-auto">
                                    {/* Pulsing deep radar animation */}
                                    <div className="relative h-24 w-24 mx-auto flex items-center justify-center">
                                      <div className="absolute inset-0 rounded-full bg-blue-600/20 animate-ping" />
                                      <div className="absolute -inset-2 rounded-full bg-blue-500/10 animate-pulse" />
                                      <div className="h-16 w-16 bg-blue-600 rounded-full flex items-center justify-center text-3xl shadow-lg border border-blue-400/30">
                                        👨‍⚕️
                                      </div>
                                    </div>

                                    <div className="space-y-2 max-w-xs mx-auto">
                                      <h4 className="font-extrabold text-sm text-white">
                                        Connecting to {activeVideoCall.doctorName}
                                      </h4>
                                      <p className="text-[10.5px] text-slate-300 leading-relaxed font-medium">
                                        Please wait. The on-duty practitioner will call you on the app once your secure video link is established.
                                      </p>
                                    </div>

                                    {/* Dynamic status badge */}
                                    <div className="bg-slate-950/60 border border-slate-800 p-3 rounded-2xl max-w-xs mx-auto">
                                      <div className="flex items-center gap-2 justify-center">
                                        <div className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse" />
                                        <span className="text-[10px] font-extrabold text-emerald-400 uppercase tracking-wider">
                                          {activeVideoCall.status}
                                        </span>
                                      </div>
                                      <p className="text-[9px] text-slate-400 mt-1 font-medium leading-relaxed">
                                        {activeVideoCall.subStatus}
                                      </p>
                                    </div>
                                  </div>

                                  {/* Clinician's pre-call guidelines card */}
                                  <div className="bg-slate-800/40 border border-slate-700/50 p-3 rounded-xl text-left text-[9px] text-slate-300 space-y-1.5 max-w-xs mx-auto w-full mb-4">
                                    <div className="font-bold text-blue-400 uppercase tracking-wide">💡 Telehealth Checklist:</div>
                                    <div className="flex items-center gap-1.5">✓ Keep device upright at eye level</div>
                                    <div className="flex items-center gap-1.5">✓ Ensure stable internet connection</div>
                                    <div className="flex items-center gap-1.5">✓ Grant microphone & camera access prompts</div>
                                  </div>

                                  <button
                                    onClick={() => setActiveVideoCall(null)}
                                    className="w-full py-2.5 bg-red-600/25 border border-red-500/40 hover:bg-red-600 text-red-100 rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-1.5"
                                  >
                                    <Phone className="h-3.5 w-3.5 rotate-[135deg]" />
                                    Leave Waiting Room
                                  </button>
                                </div>
                              )}

                              {/* ----------------- STEP 2: ACTIVE VIDEO CONSULTATION CALL ----------------- */}
                              {activeVideoCall.step === 'call' && (() => {
                                // Formatting duration
                                const secs = activeVideoCall.duration || 0;
                                const formatTime = `${Math.floor(secs / 60).toString().padStart(2, '0')}:${(secs % 60).toString().padStart(2, '0')}`;
                                return (
                                  <div className="flex-1 flex flex-col justify-between relative h-full">
                                    {/* Header Overlay */}
                                    <div className="absolute top-4 inset-x-4 flex items-center justify-between z-10 bg-slate-950/45 backdrop-blur-sm p-2.5 rounded-2xl border border-slate-800/50">
                                      <div className="flex items-center gap-2">
                                        <div className="h-2 w-2 rounded-full bg-red-600 animate-pulse" />
                                        <span className="text-[10px] font-mono font-bold uppercase tracking-wider text-slate-300">
                                          P2P WebRTC CALL
                                        </span>
                                      </div>
                                      <span className="font-mono text-xs font-bold bg-white/10 px-2.5 py-1 rounded-lg text-white">
                                        {formatTime}
                                      </span>
                                    </div>

                                    {/* Main Feed Container (Remote Doctor View) */}
                                    <div className="flex-1 bg-slate-950 relative flex items-center justify-center overflow-hidden">
                                      {activeVideoCall.videoOff ? (
                                        <div className="text-center space-y-2 text-slate-400">
                                          <VideoOff className="h-10 w-10 text-slate-600 mx-auto animate-pulse" />
                                          <div className="text-xs font-bold text-white">Your Feed Disabled</div>
                                          <p className="text-[9px] text-slate-500">Camera shutter closed by local controls.</p>
                                        </div>
                                      ) : (
                                        <div className="absolute inset-0 flex flex-col items-center justify-center text-center p-4">
                                          {/* Animated medical diagnostic soundwave backdrop */}
                                          <div className="absolute inset-x-0 bottom-1/4 h-24 flex items-center justify-center gap-1 opacity-20">
                                            <div className="h-12 w-1 bg-blue-500 rounded animate-bounce [animation-delay:0.1s]" />
                                            <div className="h-16 w-1 bg-blue-500 rounded animate-bounce [animation-delay:0.3s]" />
                                            <div className="h-8 w-1 bg-blue-500 rounded animate-bounce [animation-delay:0.2s]" />
                                            <div className="h-20 w-1 bg-blue-500 rounded animate-bounce [animation-delay:0.5s]" />
                                            <div className="h-12 w-1 bg-blue-500 rounded animate-bounce [animation-delay:0.4s]" />
                                          </div>

                                          {/* Doctor camera feed mockup */}
                                          <div className="space-y-2 relative z-10">
                                            <div className="h-20 w-20 bg-blue-600/10 rounded-full flex items-center justify-center text-4xl mx-auto mb-2 border border-blue-500/20 animate-pulse relative shadow-inner">
                                              👨‍⚕️
                                              <span className="absolute bottom-0 right-0 h-4 w-4 rounded-full bg-emerald-500 border-2 border-slate-900 flex items-center justify-center text-[8px]">✓</span>
                                            </div>
                                            <div className="text-sm font-extrabold text-white tracking-tight">
                                              {activeVideoCall.doctorName}
                                            </div>
                                            <div className="text-[10px] text-slate-400 font-semibold uppercase tracking-wider">
                                              {activeVideoCall.doctorDegrees} • {activeVideoCall.doctorSpecialty}
                                            </div>
                                            <div className="text-[9px] text-emerald-400 bg-emerald-500/10 px-2 py-0.5 rounded-full inline-block font-bold">
                                              Online via Firebase Signaler
                                            </div>
                                          </div>
                                        </div>
                                      )}

                                      {/* Local Camera self PiP view */}
                                      <div className="absolute bottom-4 right-4 h-24 w-18 bg-slate-800 rounded-xl overflow-hidden border-2 border-slate-700/80 flex flex-col items-center justify-center text-lg shadow-2xl z-10">
                                        <div className="text-xl">👨</div>
                                        <span className="text-[7px] text-slate-400 font-mono font-bold mt-1 uppercase tracking-wider">You (Local)</span>
                                      </div>

                                      {/* Floating Doctor's Advice Notepad (Clinical Notes Input) */}
                                      <div className="absolute bottom-4 left-4 z-10">
                                        {activeVideoCall.notepadExpanded ? (
                                          <div className="bg-slate-900/95 border border-slate-700 p-3 rounded-2xl w-[190px] shadow-2xl flex flex-col gap-2">
                                            <div className="flex justify-between items-center pb-1 border-b border-slate-800">
                                              <span className="text-[9px] font-bold text-blue-400 uppercase tracking-wide">🩺 In-Call Notepad</span>
                                              <button onClick={() => {
                                                setActiveVideoCall((prev: any) => ({ ...prev, notepadExpanded: false }));
                                              }} className="text-[9px] text-slate-400 hover:text-white">Close</button>
                                            </div>
                                            <textarea
                                              placeholder="Jot down physician advice, drug dosage, diagnostic checklist..."
                                              value={activeVideoCall.notes}
                                              onChange={(e) => {
                                                const text = e.target.value;
                                                setActiveVideoCall((prev: any) => ({ ...prev, notes: text }));
                                              }}
                                              className="w-full bg-slate-950 border border-slate-800 rounded-lg p-1.5 text-[10px] text-slate-200 placeholder-slate-600 focus:outline-none focus:border-blue-500 min-h-[75px] resize-none"
                                            />
                                            <div className="text-[8px] text-slate-500 italic">Saved dynamically to e-health record.</div>
                                          </div>
                                        ) : (
                                          <button
                                            onClick={() => {
                                              setActiveVideoCall((prev: any) => ({ ...prev, notepadExpanded: true }));
                                            }}
                                            className="bg-blue-600 hover:bg-blue-700 text-white text-[9.5px] font-extrabold px-3 py-1.5 rounded-full shadow-lg border border-blue-500/40 flex items-center gap-1.5"
                                          >
                                            <span>🩺</span> Note Advice
                                          </button>
                                        )}
                                      </div>
                                    </div>

                                    {/* Slide-Up Chat Panel Integration */}
                                    {activeVideoCall.chatExpanded && (
                                      <div className="h-1/2 bg-slate-900 border-t border-slate-800 flex flex-col relative z-20">
                                        <div className="p-2.5 border-b border-slate-800 flex justify-between items-center bg-slate-950">
                                          <span className="text-[10px] font-extrabold text-blue-400 uppercase tracking-wider flex items-center gap-1">
                                            <MessageSquare className="h-3.5 w-3.5" />
                                            Clinical Consultation Chat
                                          </span>
                                          <button
                                            onClick={() => {
                                              setActiveVideoCall((prev: any) => ({ ...prev, chatExpanded: false }));
                                            }}
                                            className="p-1 text-slate-400 hover:text-white"
                                          >
                                            <X className="h-4 w-4" />
                                          </button>
                                        </div>

                                        {/* Message stream */}
                                        <div className="flex-1 overflow-y-auto p-3 space-y-2 text-[10px] font-medium">
                                          {(activeVideoCall.messages || []).map((m: any, idx: number) => {
                                            const isSystem = m.sender === 'System';
                                            const isDoc = m.sender === 'Doctor';
                                            return (
                                              <div key={idx} className={`flex flex-col ${isSystem ? 'items-center' : isDoc ? 'items-start' : 'items-end'}`}>
                                                <div className={`p-2 rounded-xl max-w-[200px] leading-relaxed ${
                                                  isSystem ? 'bg-slate-950 text-slate-500 text-[8px] italic tracking-wide text-center border border-slate-800/30' :
                                                  isDoc ? 'bg-slate-800 text-slate-100 rounded-tl-none' :
                                                  'bg-blue-600 text-white rounded-tr-none'
                                                }`}>
                                                  {!isSystem && <div className="text-[8px] opacity-60 mb-0.5 font-bold font-mono">{m.sender}</div>}
                                                  {m.text}
                                                </div>
                                              </div>
                                            );
                                          })}
                                        </div>

                                        {/* Chat inputs */}
                                        <div className="p-2 border-t border-slate-800 bg-slate-950 flex gap-2">
                                          <input
                                            type="text"
                                            placeholder="Type a clinical query or symptom..."
                                            onKeyDown={(e) => {
                                              if (e.key === 'Enter') {
                                                const el = e.target as HTMLInputElement;
                                                const val = el.value;
                                                if (val.trim()) {
                                                  // send msg
                                                  setActiveVideoCall((prev: any) => {
                                                    const currentMsgs = prev.messages || [];
                                                    return { ...prev, messages: [...currentMsgs, { sender: 'Patient', text: val }] };
                                                  });
                                                  el.value = '';
                                                  // simulated physician response
                                                  setTimeout(() => {
                                                    setActiveVideoCall((prev: any) => {
                                                      if (!prev) return null;
                                                      let reply = "I see. Let me document this. I'll include a suitable advice module in your prescription.";
                                                      if (val.toLowerCase().includes('fever') || val.toLowerCase().includes('temperature')) {
                                                        reply = "Fever noted. Antipyretics like Paracetamol are recommended. Rest well and hydrate.";
                                                      } else if (val.toLowerCase().includes('cough') || val.toLowerCase().includes('throat')) {
                                                        reply = "For dry cough, warm saline gargles combined with an antihistamine or cough expectorant works best.";
                                                      }
                                                      return { ...prev, messages: [...(prev.messages || []), { sender: 'Doctor', text: reply }] };
                                                    });
                                                  }, 1500);
                                                }
                                              }
                                            }}
                                            className="flex-1 bg-slate-900 border border-slate-800 text-[10.5px] p-2 rounded-xl placeholder-slate-600 focus:outline-none focus:border-blue-500"
                                          />
                                        </div>
                                      </div>
                                    )}

                                    {/* Action Bottom Tool Bar */}
                                    <div className="p-4 bg-slate-950/90 border-t border-slate-800/80 flex items-center justify-around gap-2 z-10">
                                      {/* Toggle Audio */}
                                      <button
                                        onClick={() => {
                                          setActiveVideoCall((prev: any) => ({ ...prev, muted: !prev.muted }));
                                          triggerNotification(
                                            activeVideoCall.muted ? "Mic Enabled" : "Mic Muted",
                                            activeVideoCall.muted ? "Audio feed unmuted." : "Microphone input turned off."
                                          );
                                        }}
                                        className={`h-10 w-10 rounded-full flex items-center justify-center transition-all ${
                                          activeVideoCall.muted ? 'bg-red-600/20 text-red-500 border border-red-500/40' : 'bg-slate-800 text-slate-300 hover:bg-slate-700'
                                        }`}
                                      >
                                        {activeVideoCall.muted ? <MicOff className="h-4 w-4" /> : <Mic className="h-4 w-4" />}
                                      </button>

                                      {/* Toggle Video */}
                                      <button
                                        onClick={() => {
                                          setActiveVideoCall((prev: any) => ({ ...prev, videoOff: !prev.videoOff }));
                                        }}
                                        className={`h-10 w-10 rounded-full flex items-center justify-center transition-all ${
                                          activeVideoCall.videoOff ? 'bg-red-600/20 text-red-500 border border-red-500/40' : 'bg-slate-800 text-slate-300 hover:bg-slate-700'
                                        }`}
                                      >
                                        {activeVideoCall.videoOff ? <VideoOff className="h-4 w-4" /> : <Video className="h-4 w-4" />}
                                      </button>

                                      {/* Switch Camera */}
                                      <button
                                        onClick={() => triggerNotification("Camera Flipped", "Rear camera feed selected.")}
                                        className="h-10 w-10 rounded-full bg-slate-800 text-slate-300 hover:bg-slate-700 flex items-center justify-center transition-all"
                                      >
                                        🔄
                                      </button>

                                      {/* Open Chat */}
                                      <button
                                        onClick={() => {
                                          setActiveVideoCall((prev: any) => ({ ...prev, chatExpanded: !prev.chatExpanded }));
                                        }}
                                        className={`h-10 w-10 rounded-full flex items-center justify-center transition-all ${
                                          activeVideoCall.chatExpanded ? 'bg-blue-600 text-white' : 'bg-slate-800 text-slate-300 hover:bg-slate-700'
                                        }`}
                                      >
                                        <MessageSquare className="h-4 w-4" />
                                      </button>

                                      {/* End call red button */}
                                      <button
                                        onClick={() => {
                                          setActiveVideoCall((prev: any) => ({ ...prev, step: 'rating' }));
                                          triggerNotification(
                                            patientLanguage === 'EN' ? "Consultation Concluded" : "কনসালটেশন সমাপ্ত",
                                            patientLanguage === 'EN' ? "Leaving e-consultation node." : "কনসালটেশন পোর্টাল সমাপ্ত হয়েছে।"
                                          );
                                        }}
                                        className="h-11 w-11 bg-red-600 hover:bg-red-700 rounded-full flex items-center justify-center shadow-lg transition-all"
                                      >
                                        <Phone className="h-5 w-5 text-white rotate-[135deg]" />
                                      </button>
                                    </div>
                                  </div>
                                );
                              })()}

                              {/* ----------------- STEP 3: POST-CALL RATING ----------------- */}
                              {activeVideoCall.step === 'rating' && (
                                <div className="flex-1 flex flex-col justify-between p-5 text-center bg-slate-950">
                                  <div className="pt-4">
                                    <div className="h-10 w-10 bg-blue-600/10 rounded-full flex items-center justify-center text-xl mx-auto mb-2 border border-blue-500/20">
                                      💬
                                    </div>
                                    <h4 className="font-extrabold text-sm text-white">How was your visit?</h4>
                                    <p className="text-[10px] text-slate-400 mt-1">Rate your digital consultation session with {activeVideoCall.doctorName}.</p>
                                  </div>

                                  {/* Star Rating Controls */}
                                  <div className="space-y-6 max-w-xs mx-auto w-full my-auto">
                                    <div className="flex items-center justify-center gap-2">
                                      {[1, 2, 3, 4, 5].map((star) => (
                                        <button
                                          key={star}
                                          onClick={() => {
                                            setActiveVideoCall((prev: any) => ({ ...prev, rating: star }));
                                          }}
                                          className="p-1 hover:scale-110 transition-all focus:outline-none"
                                        >
                                          <Star className={`h-8 w-8 ${star <= (activeVideoCall.rating || 5) ? 'text-amber-400 fill-amber-400' : 'text-slate-600'}`} />
                                        </button>
                                      ))}
                                    </div>

                                    {/* Review Input */}
                                    <div className="space-y-1.5 text-left">
                                      <label className="text-[9px] font-bold text-slate-400 uppercase tracking-wider">Leave written feedback (optional)</label>
                                      <textarea
                                        placeholder="Help us improve. Was the network stable? Did the physician help?"
                                        rows={3}
                                        className="w-full bg-slate-900 border border-slate-800 text-[10.5px] p-2.5 rounded-xl text-slate-200 placeholder-slate-600 focus:outline-none focus:border-blue-500 resize-none"
                                      />
                                    </div>
                                  </div>

                                  <div className="space-y-2 mb-2">
                                    <button
                                      onClick={() => {
                                        setActiveVideoCall((prev: any) => ({ ...prev, step: 'summary' }));
                                        triggerNotification("Feedback Logged", "Thank you for supporting telehealth!");
                                      }}
                                      className="w-full py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold transition-all shadow-md shadow-blue-500/15"
                                    >
                                      Submit Feedback
                                    </button>
                                    <button
                                      onClick={() => {
                                        setActiveVideoCall((prev: any) => ({ ...prev, step: 'summary' }));
                                      }}
                                      className="w-full py-2 text-slate-400 hover:text-white rounded-xl text-xs font-semibold transition-all"
                                    >
                                      Skip Feedback
                                    </button>
                                  </div>
                                </div>
                              )}

                              {/* ----------------- STEP 4: POST-VISIT EHR SUMMARY ----------------- */}
                              {activeVideoCall.step === 'summary' && (
                                <div className="flex-1 flex flex-col bg-white text-slate-800 overflow-y-auto">
                                  {/* Header Badge */}
                                  <div className="bg-gradient-to-b from-blue-50 to-white px-5 pt-6 pb-4 border-b border-slate-100 flex flex-col items-center text-center">
                                    <div className="h-10 w-10 bg-emerald-500/15 text-emerald-600 rounded-full flex items-center justify-center text-lg mb-2 border border-emerald-500/20">
                                      ✓
                                    </div>
                                    <span className="text-[9px] font-mono font-bold text-blue-600 uppercase tracking-widest">
                                      CLINICAL VISIT RECORD
                                    </span>
                                    <h4 className="font-extrabold text-sm text-slate-800 mt-1">E-Consultation Completed</h4>
                                    <p className="text-[10px] text-slate-400 font-semibold font-mono mt-0.5">ROOM NODE: {activeVideoCall.appId}</p>
                                  </div>

                                  <div className="p-4 space-y-4">
                                    {/* Practitioner Details Card */}
                                    <div className="bg-slate-50 border border-slate-150 rounded-2xl p-3 flex items-center gap-3">
                                      <div className="h-11 w-11 bg-blue-50 border border-blue-200 rounded-full flex items-center justify-center text-2xl">
                                        👨‍⚕️
                                      </div>
                                      <div>
                                        <h5 className="font-bold text-[12.5px] text-slate-800">{activeVideoCall.doctorName}</h5>
                                        <p className="text-[10px] text-slate-500 font-semibold">{activeVideoCall.doctorDegrees} • {activeVideoCall.doctorSpecialty}</p>
                                      </div>
                                    </div>

                                    {/* Clinical Advice / Physician's Notes */}
                                    <div className="bg-slate-50 border border-slate-150 rounded-2xl p-3.5 space-y-2">
                                      <h5 className="font-bold text-[10px] text-blue-600 font-mono tracking-wider uppercase flex items-center gap-1">
                                        <span>📋</span> Clinical Notes & Advice
                                      </h5>
                                      <div className="bg-white border border-slate-100 rounded-xl p-3 text-[11px] text-slate-700 leading-relaxed font-semibold italic">
                                        {activeVideoCall.notes ? `"${activeVideoCall.notes}"` : '"Take Napa Extend 665mg (1 tablet after lunch and dinner for fever/body aches). Drink lots of warm water, take steam inhalation twice daily, and review clinic in 3 days."'}
                                      </div>
                                    </div>

                                    {/* Digital Prescription (E-Rx Verification) */}
                                    <div className="bg-slate-50 border border-slate-150 rounded-2xl p-3.5 space-y-3">
                                      <div className="flex justify-between items-center">
                                        <h5 className="font-bold text-[10px] text-slate-400 font-mono tracking-wider uppercase">
                                          Prescribed Remedies (Verified)
                                        </h5>
                                        <span className="text-[8px] font-extrabold bg-blue-100 text-blue-600 px-1.5 py-0.5 rounded font-mono uppercase tracking-wider">
                                          E-Rx Verified
                                        </span>
                                      </div>

                                      <div className="space-y-1.5 text-[10.5px]">
                                        <div className="flex justify-between items-center bg-white p-2.5 rounded-xl border border-slate-100">
                                          <div>
                                            <strong className="font-bold text-slate-800 block">Napa Extend (Paracetamol)</strong>
                                            <span className="text-[9px] text-slate-400">665mg • 1 + 0 + 1 (After Meal) • 5 Days</span>
                                          </div>
                                          <span className="text-[9px] text-slate-400 font-bold">Qty: 2 Box</span>
                                        </div>
                                        <div className="flex justify-between items-center bg-white p-2.5 rounded-xl border border-slate-100">
                                          <div>
                                            <strong className="font-bold text-slate-800 block">Tusca Cough Syrup</strong>
                                            <span className="text-[9px] text-slate-400">100ml • 2 Spoon Daily • 7 Days</span>
                                          </div>
                                          <span className="text-[9px] text-slate-400 font-bold">Qty: 1 Bottle</span>
                                        </div>
                                      </div>

                                      {/* Action Buttons inside Summary */}
                                      <div className="grid grid-cols-2 gap-2 pt-2">
                                        {/* Download Prescription PDF */}
                                        <button
                                          onClick={() => {
                                            triggerNotification("Downloading Rx", "HELLODOC_PRESCRIPTION_" + activeVideoCall.appId + ".pdf downloaded.");
                                          }}
                                          className="py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-[10.5px] font-bold transition-all border border-slate-200/50 flex items-center justify-center gap-1"
                                        >
                                          <Download className="h-3.5 w-3.5" />
                                          Download Rx
                                        </button>

                                        {/* Order Prescribed Medicines directly into express pharmacy delivery */}
                                        <button
                                          onClick={() => {
                                            // Add prescribed medicines directly to local cart and launch checkout modal!
                                            const prescribedMeds = [
                                              { id: 'med_1', name: "Napa Extend (Paracetamol 665mg)", price: 35, quantity: 2, image: "💊" },
                                              { id: 'med_2', name: "Tusca (Cough Syrup)", price: 85, quantity: 1, image: "🧪" }
                                            ];
                                            setMedicineCart(prescribedMeds);
                                            setMedicineCartModal(true);
                                            setActiveVideoCall(null);
                                            triggerNotification(
                                              "Meds Added to Cart!", 
                                              "E-Prescription order compiled and dispatched to your checkout."
                                            );
                                          }}
                                          className="py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-[10.5px] font-bold transition-all flex items-center justify-center gap-1 shadow-md shadow-blue-500/15"
                                        >
                                          <ShoppingCart className="h-3.5 w-3.5" />
                                          Order Meds
                                        </button>
                                      </div>
                                    </div>
                                  </div>

                                  {/* Close Summary, Return Home */}
                                  <div className="p-4 border-t border-slate-100 bg-white mt-auto">
                                    <button
                                      onClick={() => {
                                        setActiveVideoCall(null);
                                      }}
                                      className="w-full py-3 bg-slate-900 hover:bg-black text-white rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-1 shadow-md"
                                    >
                                      Return to Patient Home
                                    </button>
                                  </div>
                                </div>
                              )}
                            </motion.div>
                          )}
                        </AnimatePresence>

                        {/* B. Doctor Appointment Date/Time Booking Modal */}
                        <AnimatePresence>
                          {selectedDoctorForBooking && (
                            <motion.div
                              initial={{ opacity: 0, y: 100 }}
                              animate={{ opacity: 1, y: 0 }}
                              exit={{ opacity: 0, y: 100 }}
                              className="absolute inset-x-0 bottom-0 max-h-[380px] bg-white rounded-t-[32px] shadow-2xl border-t border-slate-150 z-40 p-5 flex flex-col justify-between overflow-y-auto"
                            >
                              <div className="space-y-3">
                                <div className="flex justify-between items-start">
                                  <div>
                                    <h4 className="font-extrabold text-xs text-slate-400 uppercase tracking-wider font-mono">{t.bookingModalTitle}</h4>
                                    <h5 className="font-extrabold text-sm text-slate-800 mt-1">{selectedDoctorForBooking.name}</h5>
                                    <p className="text-[10px] text-blue-600 font-bold">{selectedDoctorForBooking.specialty} • Fee: {selectedDoctorForBooking.fee} {t.bdt}</p>
                                  </div>
                                  <button onClick={() => setSelectedDoctorForBooking(null)} className="p-1 hover:bg-slate-100 rounded-full">
                                    <X className="h-4 w-4 text-slate-400" />
                                  </button>
                                </div>

                                {/* Date Selections */}
                                <div className="space-y-1.5">
                                  <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">{t.date}</label>
                                  <div className="grid grid-cols-3 gap-2">
                                    <button className="py-2 px-1 text-center bg-blue-50 border border-blue-500 rounded-xl text-[10px] font-bold text-blue-600">
                                      Tomorrow <span className="block text-[8px] text-blue-400">July 6</span>
                                    </button>
                                    <button className="py-2 px-1 text-center bg-slate-50 border border-slate-150 rounded-xl text-[10px] font-semibold text-slate-600 hover:bg-slate-100">
                                      Tuesday <span className="block text-[8px] text-slate-400">July 7</span>
                                    </button>
                                    <button className="py-2 px-1 text-center bg-slate-50 border border-slate-150 rounded-xl text-[10px] font-semibold text-slate-600 hover:bg-slate-100">
                                      Wednesday <span className="block text-[8px] text-slate-400">July 8</span>
                                    </button>
                                  </div>
                                </div>

                                {/* Slot selections */}
                                <div className="space-y-1.5">
                                  <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">{t.time}</label>
                                  <div className="grid grid-cols-2 gap-2 text-[10px]">
                                    <button className="py-1.5 bg-blue-50 border border-blue-500 rounded-lg text-blue-600 font-bold text-center">
                                      04:00 PM - 04:30 PM
                                    </button>
                                    <button className="py-1.5 bg-slate-50 border border-slate-150 rounded-lg text-slate-600 font-semibold text-center hover:bg-slate-100">
                                      07:00 PM - 07:30 PM
                                    </button>
                                  </div>
                                </div>
                              </div>

                              <div className="pt-4 border-t border-slate-100 mt-4">
                                <button
                                  onClick={() => {
                                    const apptDoc = selectedDoctorForBooking;
                                    setSelectedDoctorForBooking(null);
                                    setBookingSuccess(true);
                                    triggerNotification(
                                      patientLanguage === 'EN' ? "Appt Scheduled!" : "অ্যাপয়েন্টমেন্ট সফল হয়েছে!", 
                                      `${apptDoc.name} ${patientLanguage === 'EN' ? 'confirmed tomorrow at 04:00 PM' : 'আগামীকাল বিকাল ৪:০০ টায় কনফার্ম করা হয়েছে।'}`
                                    );
                                  }}
                                  className="w-full py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold transition-all"
                                >
                                  {patientLanguage === 'EN' ? "Confirm Scheduled Slot" : "অ্যাপয়েন্টমেন্ট নিশ্চিত করুন"}
                                </button>
                              </div>
                            </motion.div>
                          )}
                        </AnimatePresence>

                        {/* Booking Success Dialog overlay */}
                        <AnimatePresence>
                          {bookingSuccess && (
                            <motion.div
                              initial={{ opacity: 0 }}
                              animate={{ opacity: 1 }}
                              exit={{ opacity: 0 }}
                              className="absolute inset-0 bg-black/60 z-50 flex items-center justify-center p-4"
                            >
                              <motion.div
                                initial={{ scale: 0.9 }}
                                animate={{ scale: 1 }}
                                exit={{ scale: 0.9 }}
                                className="bg-white rounded-[24px] p-6 text-center max-w-xs space-y-4 shadow-2xl"
                              >
                                <div className="h-12 w-12 bg-emerald-50 text-emerald-600 rounded-full flex items-center justify-center mx-auto text-xl">
                                  ✓
                                </div>
                                <h4 className="font-extrabold text-sm text-slate-800 leading-tight">{t.successBooking}</h4>
                                <p className="text-[10px] text-slate-500 leading-relaxed">
                                  {patientLanguage === 'EN' ? "Your slot with the clinical physician has been locked. Check your SMS or email for access codes." : "আপনার নির্দিষ্ট স্লট সফলভাবে বুক করা হয়েছে। অ্যাক্সেস কোডের জন্য আপনার এসএমএস দেখুন।"}
                                </p>
                                <div className="space-y-2">
                                  <button
                                    onClick={() => {
                                      setBookingSuccess(false);
                                      setActiveVideoCall({
                                        step: 'waiting',
                                        waitingTicks: 0,
                                        status: 'Waiting for doctor',
                                        subStatus: 'The doctor is wrapping up another consult and will join shortly.',
                                        doctorName: 'Dr. Mahbub Alam',
                                        doctorSpecialty: 'Telemedicine Specialist',
                                        doctorDegrees: 'MBBS, FCPS',
                                        appId: 'APT-' + Math.floor(10000 + Math.random() * 90000),
                                        duration: 0,
                                        notes: '',
                                        rating: 5,
                                        muted: false,
                                        videoOff: false,
                                        chatExpanded: false,
                                        messages: [
                                          { sender: 'System', text: 'Secure e-consultation room created. Start talking!' }
                                        ]
                                      });
                                    }}
                                    className="w-full py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold flex items-center justify-center gap-1.5 shadow-md shadow-blue-500/15"
                                  >
                                    <Video className="h-3.5 w-3.5" />
                                    {patientLanguage === 'EN' ? "Enter Waiting Room" : "ওয়েটিং রুমে প্রবেশ করুন"}
                                  </button>
                                  <button
                                    onClick={() => setBookingSuccess(false)}
                                    className="w-full py-2 text-slate-500 hover:bg-slate-100 rounded-xl text-xs font-semibold"
                                  >
                                    {patientLanguage === 'EN' ? "Close" : "বন্ধ করুন"}
                                  </button>
                                </div>
                              </motion.div>
                            </motion.div>
                          )}
                        </AnimatePresence>

                        {/* C. Diagnostics Lab Test Booking Details Modal */}
                        <AnimatePresence>
                          {labBookingModal && (
                            <motion.div
                              initial={{ opacity: 0, y: 100 }}
                              animate={{ opacity: 1, y: 0 }}
                              exit={{ opacity: 0, y: 100 }}
                              className="absolute inset-x-0 bottom-0 max-h-[350px] bg-white rounded-t-[32px] shadow-2xl border-t border-slate-150 z-40 p-5 flex flex-col justify-between"
                            >
                              <div className="space-y-3.5">
                                <div className="flex justify-between items-start">
                                  <div>
                                    <h4 className="font-extrabold text-xs text-purple-600 uppercase tracking-wider font-mono">DIAGNOSTIC WORKFLOW</h4>
                                    <h5 className="font-extrabold text-sm text-slate-800 mt-1">{labBookingModal.name}</h5>
                                    <p className="text-[10px] text-slate-400 mt-0.5">{labBookingModal.desc}</p>
                                  </div>
                                  <button onClick={() => setLabBookingModal(null)} className="p-1 hover:bg-slate-100 rounded-full">
                                    <X className="h-4 w-4 text-slate-400" />
                                  </button>
                                </div>

                                <div className="bg-purple-50 p-3 rounded-xl border border-purple-100 text-[10px] text-purple-700 space-y-1">
                                  <div className="font-bold">🧪 Home Blood Draw Sample Collection</div>
                                  <p className="leading-relaxed font-medium">A certified clinical phlebotomist from Popular Labs will dispatch to your registered address tomorrow morning.</p>
                                </div>
                              </div>

                              <div className="pt-4 border-t border-slate-100 mt-4 flex items-center justify-between">
                                <div>
                                  <span className="text-[9px] text-slate-400 block font-bold uppercase font-mono">Total Billed</span>
                                  <strong className="text-sm font-extrabold text-slate-800">{labBookingModal.price} {t.bdt}</strong>
                                </div>
                                <button
                                  onClick={() => {
                                    const testName = labBookingModal.name;
                                    setLabBookingModal(null);
                                    triggerNotification(
                                      patientLanguage === 'EN' ? "Lab Order Dispatched!" : "ল্যাব অর্ডার সম্পন্ন!", 
                                      `${testName} ${patientLanguage === 'EN' ? 'collection technician dispatched tomorrow at 8:00 AM.' : 'স্যাম্পল সংগ্রহের জন্য আগামী কাল সকালে প্রতিনিধি পৌঁছবেন।'}`
                                    );
                                  }}
                                  className="px-4 py-2 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-xs font-bold transition-all shadow-md shadow-purple-500/10"
                                >
                                  {patientLanguage === 'EN' ? "Book Home Collection Slot" : "ল্যাব স্লট বুক করুন"}
                                </button>
                              </div>
                            </motion.div>
                          )}
                        </AnimatePresence>

                        {/* D. Pharmacy Medicine Catalog & Cart Modal */}
                        <AnimatePresence>
                          {medicineCartModal && (
                            <motion.div
                              initial={{ opacity: 0, y: 100 }}
                              animate={{ opacity: 1, y: 0 }}
                              exit={{ opacity: 0, y: 100 }}
                              className="absolute inset-0 bg-white z-40 p-4 flex flex-col justify-between"
                            >
                              <div className="flex-1 flex flex-col overflow-hidden">
                                <div className="flex justify-between items-center border-b border-slate-100 pb-3 mb-3">
                                  <div>
                                    <h4 className="font-extrabold text-xs text-amber-600 uppercase tracking-wider font-mono">LAZZ PHARMACY CONSOLE</h4>
                                    <h5 className="font-extrabold text-sm text-slate-800 mt-0.5">{patientLanguage === 'EN' ? 'Select Verified Medicines' : 'ওষুধ নির্বাচন করুন'}</h5>
                                  </div>
                                  <button onClick={() => setMedicineCartModal(false)} className="p-1 hover:bg-slate-100 rounded-full">
                                    <X className="h-4 w-4 text-slate-400" />
                                  </button>
                                </div>

                                <div className="flex-1 overflow-y-auto space-y-3.5 pr-1">
                                  {pharmacyMedicines.map((med) => {
                                    const cartQty = medicineCart.find(item => item.id === med.id)?.qty || 0;
                                    return (
                                      <div key={med.id} className="bg-slate-50 border border-slate-150 p-3 rounded-2xl flex items-center justify-between gap-2 shadow-sm">
                                        <div className="min-w-0">
                                          <h6 className="font-bold text-xs text-slate-800 truncate">{med.name}</h6>
                                          <p className="text-[9px] text-slate-400 font-medium">{med.brand} • {med.unit}</p>
                                          <span className="text-xs font-extrabold text-amber-600 block mt-0.5">{med.price} {t.bdt}</span>
                                        </div>

                                        <div className="flex items-center gap-2 shrink-0">
                                          {cartQty > 0 ? (
                                            <div className="flex items-center bg-white border border-amber-200 p-1 rounded-lg gap-2 text-xs font-bold text-slate-700">
                                              <button 
                                                onClick={() => {
                                                  setMedicineCart(prev => prev.map(item => item.id === med.id ? { ...item, qty: item.qty - 1 } : item).filter(item => item.qty > 0));
                                                }}
                                                className="px-1.5 py-0.5 text-amber-600 bg-amber-50 rounded"
                                              >
                                                -
                                              </button>
                                              <span>{cartQty}</span>
                                              <button 
                                                onClick={() => {
                                                  setMedicineCart(prev => prev.map(item => item.id === med.id ? { ...item, qty: item.qty + 1 } : item));
                                                }}
                                                className="px-1.5 py-0.5 text-amber-600 bg-amber-50 rounded"
                                              >
                                                +
                                              </button>
                                            </div>
                                          ) : (
                                            <button
                                              onClick={() => {
                                                setMedicineCart(prev => [...prev, { id: med.id, name: med.name, price: med.price, qty: 1 }]);
                                                triggerNotification(
                                                  patientLanguage === 'EN' ? "Added to Cart" : "কার্টে যোগ করা হয়েছে", 
                                                  `${med.name} ${patientLanguage === 'EN' ? 'ready for dispatch.' : 'তালিকায় যোগ করা হয়েছে।'}`
                                                );
                                              }}
                                              className="bg-amber-600 hover:bg-amber-700 text-white rounded-lg px-2.5 py-1 text-[10px] font-bold"
                                            >
                                              {t.addToCart}
                                            </button>
                                          )}
                                        </div>
                                      </div>
                                    );
                                  })}
                                </div>
                              </div>

                              <div className="pt-4 border-t border-slate-100 mt-4 flex items-center justify-between">
                                <div>
                                  <span className="text-[8px] text-slate-400 block font-bold uppercase font-mono">Cart Items ({medicineCart.reduce((acc, x) => acc + x.qty, 0)})</span>
                                  <strong className="text-sm font-extrabold text-slate-800">
                                    {medicineCart.reduce((acc, x) => acc + (x.price * x.qty), 0)} {t.bdt}
                                  </strong>
                                </div>
                                <button
                                  onClick={() => {
                                    if (medicineCart.length === 0) {
                                      triggerNotification(
                                        patientLanguage === 'EN' ? "Empty Cart" : "কার্ট খালি", 
                                        t.cartEmpty
                                      );
                                      return;
                                    }
                                    setMedicineCart([]);
                                    setMedicineCartModal(false);
                                    triggerNotification(
                                      patientLanguage === 'EN' ? "Prescription Verified & Order Dispatched!" : "ওষুধের অর্ডার পাঠানো হয়েছে!", 
                                      patientLanguage === 'EN' ? "Lazz Pharmacy courier is preparing delivery in 2 Hours." : "লাজ ফার্মা ডেলিভারি কুরিয়ার প্রস্তুতি নিচ্ছে।"
                                    );
                                  }}
                                  className="px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-xl text-xs font-bold transition-all shadow-md shadow-amber-500/10"
                                >
                                  {t.checkout}
                                </button>
                              </div>
                            </motion.div>
                          )}
                        </AnimatePresence>

                      </motion.div>
                    );
                  })()}

                  {/* PORTAL HOMES (DOCTOR) */}
                  {flutterScreen === 'doctor_home' && (() => {
                    const activePatient = selectedEhrPatient || { id: 'patient_mock', name: 'Karim Uddin' };
                    return (
                      <motion.div
                        key="doctor_home"
                        initial={{ opacity: 0, x: 20 }}
                        animate={{ opacity: 1, x: 0 }}
                        exit={{ opacity: -20 }}
                        className="flex-1 flex flex-col bg-slate-50 overflow-hidden relative"
                      >
                        {/* A. DOCTOR NOTIFICATIONS OVERLAY */}
                        <AnimatePresence>
                          {doctorNotificationsExpanded && (
                            <motion.div
                              initial={{ opacity: 0, y: -20 }}
                              animate={{ opacity: 1, y: 0 }}
                              exit={{ opacity: 0, y: -20 }}
                              className="absolute inset-x-0 top-14 bg-white border-b border-slate-150 shadow-lg z-50 p-4 space-y-3"
                            >
                              <div className="flex justify-between items-center pb-2 border-b border-slate-100">
                                <h4 className="text-[11px] font-extrabold text-slate-500 uppercase tracking-widest font-mono">Recent Workplace Alerts</h4>
                                <button onClick={() => setDoctorNotificationsExpanded(false)} className="text-[10px] text-blue-600 font-bold hover:underline">Dismiss All</button>
                              </div>
                              <div className="space-y-2 max-h-[220px] overflow-y-auto">
                                <div className="p-2.5 bg-blue-50 border border-blue-100 rounded-xl flex items-start gap-2 text-xs">
                                  <span className="text-base">📢</span>
                                  <div>
                                    <strong className="font-bold text-slate-800">New Queue Request</strong>
                                    <p className="text-[10px] text-slate-500 mt-0.5">Patient Karim Uddin joined the active video loop for viral symptoms.</p>
                                  </div>
                                </div>
                                <div className="p-2.5 bg-red-50 border border-red-100 rounded-xl flex items-start gap-2 text-xs">
                                  <span className="text-base">⚠️</span>
                                  <div>
                                    <strong className="font-bold text-red-700">Urgent Callback Request</strong>
                                    <p className="text-[10px] text-slate-500 mt-0.5">Sultana Begum (68F) requested emergency assist for post-op chest tightness.</p>
                                  </div>
                                </div>
                              </div>
                            </motion.div>
                          )}
                        </AnimatePresence>

                        {/* B. ACTIVE CALL SIMULATION OVERLAY */}
                        <AnimatePresence>
                          {activeDoctorCall && (() => {
                            const secs = activeDoctorCall.duration || 0;
                            const minStr = Math.floor(secs / 60).toString().padStart(2, '0');
                            const secStr = (secs % 60).toString().padStart(2, '0');
                            return (
                              <motion.div
                                initial={{ opacity: 0, scale: 0.95 }}
                                animate={{ opacity: 1, scale: 1 }}
                                exit={{ opacity: 0, scale: 0.95 }}
                                className="absolute inset-0 bg-slate-900 z-50 text-white flex flex-col justify-between overflow-hidden"
                              >
                                <div className="flex items-center justify-between p-4 bg-slate-950/80 border-b border-white/5">
                                  <div className="flex items-center gap-1.5">
                                    <span className="h-2 w-2 rounded-full bg-red-500 animate-pulse"></span>
                                    <span className="font-mono text-[10px] text-red-400 font-bold tracking-widest uppercase">LIVE CONSULTATION</span>
                                  </div>
                                  <div className="font-mono text-xs bg-slate-800 px-3 py-1 rounded-full text-slate-200 border border-white/10 flex items-center gap-1">
                                    <Clock className="h-3 w-3 text-red-400" />
                                    <span>{minStr}:{secStr}</span>
                                  </div>
                                </div>

                                {/* Patient video stream display */}
                                <div className="flex-1 flex flex-col items-center justify-center relative p-6">
                                  {/* Doctor picture-in-picture stream */}
                                  <div className="absolute top-4 right-4 h-24 w-18 bg-slate-800 border-2 border-white/20 rounded-xl overflow-hidden shadow-lg z-10 flex flex-col items-center justify-center">
                                    <span className="text-xl">👩‍⚕️</span>
                                    <span className="text-[8px] text-slate-400 font-bold font-mono mt-1">You (Dr. Sarah)</span>
                                  </div>

                                  <div className="relative h-32 w-32 rounded-full bg-blue-500/10 flex items-center justify-center border border-blue-500/20 animate-pulse">
                                    <div className="absolute inset-0 rounded-full bg-blue-500/5 animate-ping"></div>
                                    <span className="text-6xl">🤕</span>
                                  </div>
                                  <h4 className="text-lg font-extrabold mt-4">{activeDoctorCall.patientName}</h4>
                                  <p className="text-xs text-slate-400 mt-1 font-semibold">{activeDoctorCall.patientAge} Yrs • {activeDoctorCall.patientGender} • {activeDoctorCall.patientWeight} kg</p>
                                  <div className="bg-slate-800/80 border border-white/5 px-4 py-2 rounded-2xl text-[11px] text-slate-300 italic text-center max-w-xs mt-4">
                                    "{activeDoctorCall.symptoms}"
                                  </div>
                                </div>

                                {/* Controls */}
                                <div className="bg-slate-950/90 border-t border-white/5 p-5 space-y-4">
                                  <div className="flex justify-around items-center">
                                    <button 
                                      onClick={() => triggerNotification("Microphone Toggled", "Mic is now muted.")}
                                      className="h-10 w-10 bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-full flex items-center justify-center transition-all border border-white/5"
                                    >
                                      <Mic className="h-4 w-4" />
                                    </button>
                                    <button 
                                      onClick={() => {
                                        // End call simulation
                                        const patientName = activeDoctorCall.patientName;
                                        setActiveDoctorCall(null);
                                        setSelectedPrescriptionPatient({ id: 'active_patient', name: patientName });
                                        setDoctorViewScreen('prescription');
                                        triggerNotification("Call Ended", "Now drafting prescription for " + patientName);
                                      }}
                                      className="h-12 w-12 bg-red-600 hover:bg-red-700 text-white rounded-full flex items-center justify-center transition-all shadow-lg shadow-red-600/30 font-bold"
                                    >
                                      <Phone className="h-5 w-5 transform rotate-135" />
                                    </button>
                                    <button 
                                      onClick={() => triggerNotification("Camera Toggled", "Video feed is now turned off.")}
                                      className="h-10 w-10 bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-full flex items-center justify-center transition-all border border-white/5"
                                    >
                                      <Video className="h-4 w-4" />
                                    </button>
                                  </div>
                                  <div className="text-center">
                                    <p className="text-[9px] text-slate-500 font-mono tracking-widest uppercase">Click the Red End Button to write Prescription (Rx)</p>
                                  </div>
                                </div>
                              </motion.div>
                            );
                          })()}
                        </AnimatePresence>

                        {/* C. TOP NAVIGATION APP BAR */}
                        <div className="bg-white border-b border-slate-150 h-14 px-4 flex justify-between items-center shrink-0 z-10 shadow-sm">
                          <div className="flex items-center gap-2">
                            <div className="h-8 w-8 bg-blue-600/10 text-blue-600 rounded-xl flex items-center justify-center font-bold">
                              <Stethoscope className="h-4 w-4" />
                            </div>
                            <div>
                              <h3 className="text-xs font-black text-slate-900 font-display uppercase tracking-wider">Hello Doctor</h3>
                              <p className="text-[9px] font-mono font-bold text-slate-400">PRACTITIONER SUITE</p>
                            </div>
                          </div>

                          <div className="flex items-center gap-2">
                            {/* Role selector swap button */}
                            <button
                              onClick={() => {
                                setCurrentUser(null);
                                setFlutterScreen('role_selection');
                                triggerNotification("Role Exited", "Returned to portal selection.");
                              }}
                              className="text-[10px] font-extrabold bg-slate-100 hover:bg-slate-200 text-slate-700 px-2.5 py-1.5 rounded-lg flex items-center gap-1 transition-all border border-slate-200/50"
                            >
                              <ArrowLeft className="h-3 w-3" />
                              Role Swap
                            </button>

                            {/* Notifications bell */}
                            <button 
                              onClick={() => setDoctorNotificationsExpanded(!doctorNotificationsExpanded)}
                              className="p-1.5 hover:bg-slate-100 rounded-full text-slate-500 hover:text-blue-600 transition-all relative"
                            >
                              <Bell className="h-4 w-4" />
                              <span className="absolute top-1 right-1 h-2 w-2 bg-red-500 rounded-full animate-pulse"></span>
                            </button>
                          </div>
                        </div>

                        {/* D. WORKSPACE BODY AREA */}
                        <div className="flex-1 overflow-y-auto px-4 py-4 space-y-4 pb-16">
                          
                          {/* D1. VIEW: DASHBOARD */}
                          {doctorViewScreen === 'dashboard' && doctorPortalTab === 'home' && (
                            <>
                              {/* 1. Doctor Greeting Card */}
                              <div className="bg-white border border-slate-150 rounded-2xl p-4 flex items-center justify-between shadow-sm">
                                <div className="flex items-center gap-3">
                                  <div className="h-12 w-12 rounded-full bg-blue-100 border-2 border-blue-300 flex items-center justify-center text-2xl relative">
                                    👨‍⚕️
                                    <div className="absolute -bottom-1 -right-1 h-4 w-4 bg-emerald-500 border-2 border-white rounded-full"></div>
                                  </div>
                                  <div>
                                    <span className="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Clinical Specialist</span>
                                    <h4 className="text-sm font-extrabold text-slate-800">Dr. Sarah Rahman 👋</h4>
                                    <p className="text-[9px] text-slate-500 font-semibold mt-0.5">Cardiologist • BMDC: A-84291</p>
                                  </div>
                                </div>
                              </div>

                              {/* 2. Online/Offline Live Toggle card */}
                              <div className={`border rounded-2xl p-3.5 flex items-center justify-between transition-all shadow-sm ${doctorOnline ? 'bg-emerald-50/50 border-emerald-150 text-emerald-900' : 'bg-slate-50 border-slate-200 text-slate-500'}`}>
                                <div className="flex items-center gap-2.5">
                                  <div className={`h-8 w-8 rounded-full flex items-center justify-center text-sm ${doctorOnline ? 'bg-emerald-100 text-emerald-600 animate-pulse' : 'bg-slate-200 text-slate-400'}`}>
                                    {doctorOnline ? "●" : "○"}
                                  </div>
                                  <div>
                                    <h5 className="font-extrabold text-xs">Instant Consultation Queue</h5>
                                    <p className="text-[10px] font-medium opacity-80">{doctorOnline ? "You are accepting live digital patients" : "You are offline for instant calls"}</p>
                                  </div>
                                </div>
                                <button
                                  onClick={() => {
                                    setDoctorOnline(!doctorOnline);
                                    triggerNotification(
                                      !doctorOnline ? "Workspace Online" : "Workspace Offline",
                                      !doctorOnline ? "Instant consultation channel has been opened." : "Instant consultation channel closed."
                                    );
                                  }}
                                  className={`w-12 h-6.5 rounded-full p-0.5 transition-colors focus:outline-none flex ${doctorOnline ? 'bg-emerald-600 justify-end' : 'bg-slate-300 justify-start'}`}
                                >
                                  <span className="h-5.5 w-5.5 rounded-full bg-white shadow-md transform transition-transform" />
                                </button>
                              </div>

                              {/* 3. Emergency / Urgent Callback Requests banner */}
                              <div className="bg-red-50 border border-red-100 rounded-2xl p-3.5 flex items-start gap-3 shadow-sm relative overflow-hidden">
                                <div className="absolute right-0 top-0 h-16 w-16 bg-red-500/5 rounded-full transform translate-x-4 -translate-y-4"></div>
                                <div className="h-9 w-9 bg-red-100 text-red-600 rounded-xl flex items-center justify-center text-lg shrink-0 mt-0.5">
                                  🚨
                                </div>
                                <div className="flex-1 space-y-2">
                                  <div className="flex justify-between items-center">
                                    <span className="text-[9px] font-extrabold bg-red-600 text-white px-2 py-0.5 rounded uppercase tracking-wider font-mono">EMERGENCY ASSIST</span>
                                    <span className="text-[9px] font-extrabold text-red-600 bg-red-100/50 px-1.5 py-0.5 rounded">1 Active</span>
                                  </div>
                                  <div>
                                    <h5 className="font-bold text-xs text-red-900">Sultana Begum (68F)</h5>
                                    <p className="text-[10.5px] text-red-700 leading-normal mt-0.5 font-medium">Post-op coronary stenting callback. Reports severe chest tightness & dyspnea.</p>
                                  </div>
                                  <button
                                    onClick={() => {
                                      setActiveDoctorCall({
                                        patientName: "Sultana Begum",
                                        patientAge: 68,
                                        patientGender: "Female",
                                        patientWeight: 62,
                                        symptoms: "Coronary stenting follow-up. Severe chest tightness & breathing distress.",
                                        duration: 0
                                      });
                                      triggerNotification("Dialing Emergency Call", "Establishing secure satellite WebRTC bridge to Sultana Begum.");
                                    }}
                                    className="w-full py-2 bg-red-600 hover:bg-red-700 text-white rounded-xl text-[10.5px] font-black transition-all flex items-center justify-center gap-1.5 shadow-md shadow-red-600/15"
                                  >
                                    <Phone className="h-3.5 w-3.5 text-white animate-bounce" />
                                    EMERGENCY CALLBACK NOW
                                  </button>
                                </div>
                              </div>

                              {/* 4. Overview Analytics cards in a row */}
                              <div className="grid grid-cols-2 gap-3.5">
                                <div 
                                  onClick={() => setDoctorViewScreen('queue')}
                                  className="bg-white border border-slate-150 hover:border-blue-300 rounded-2xl p-3.5 flex flex-col justify-between shadow-sm cursor-pointer transition-all hover:scale-[1.01]"
                                >
                                  <div className="flex justify-between items-start">
                                    <span className="text-lg">👥</span>
                                    <span className="text-[8px] font-bold uppercase font-mono tracking-widest bg-blue-100 text-blue-600 px-1.5 py-0.5 rounded">Queue</span>
                                  </div>
                                  <div className="mt-2.5">
                                    <h4 className="text-xl font-black text-slate-800">3</h4>
                                    <p className="text-[9px] text-slate-400 font-bold mt-0.5">Active Waiting Patients</p>
                                  </div>
                                </div>

                                <div className="bg-white border border-slate-150 rounded-2xl p-3.5 flex flex-col justify-between shadow-sm">
                                  <div className="flex justify-between items-start">
                                    <span className="text-lg">✅</span>
                                    <span className="text-[8px] font-bold uppercase font-mono tracking-widest bg-emerald-100 text-emerald-600 px-1.5 py-0.5 rounded">Done</span>
                                  </div>
                                  <div className="mt-2.5">
                                    <h4 className="text-xl font-black text-slate-800">5</h4>
                                    <p className="text-[9px] text-slate-400 font-bold mt-0.5">Completed Consults</p>
                                  </div>
                                </div>

                                <div 
                                  onClick={() => setDoctorViewScreen('earnings')}
                                  className="bg-white border border-slate-150 hover:border-emerald-300 rounded-2xl p-3.5 flex flex-col justify-between shadow-sm cursor-pointer transition-all hover:scale-[1.01]"
                                >
                                  <div className="flex justify-between items-start">
                                    <span className="text-lg">৳</span>
                                    <span className="text-[8px] font-bold uppercase font-mono tracking-widest bg-emerald-100 text-emerald-600 px-1.5 py-0.5 rounded">Payout</span>
                                  </div>
                                  <div className="mt-2.5">
                                    <h4 className="text-xl font-black text-slate-800">৳ 3,200</h4>
                                    <p className="text-[9px] text-slate-400 font-bold mt-0.5">Today's Earnings</p>
                                  </div>
                                </div>

                                <div className="bg-white border border-slate-150 rounded-2xl p-3.5 flex flex-col justify-between shadow-sm">
                                  <div className="flex justify-between items-start">
                                    <span className="text-lg">📈</span>
                                    <span className="text-[8px] font-bold uppercase font-mono tracking-widest bg-slate-100 text-slate-600 px-1.5 py-0.5 rounded">Growth</span>
                                  </div>
                                  <div className="mt-2.5">
                                    <h4 className="text-xl font-black text-slate-800">182</h4>
                                    <p className="text-[9px] text-slate-400 font-bold mt-0.5">Total Consulted Patients</p>
                                  </div>
                                </div>
                              </div>

                              {/* 5. Today's Appointments List */}
                              <div className="space-y-2.5">
                                <div className="flex justify-between items-center">
                                  <h4 className="text-[11px] font-extrabold text-slate-400 uppercase tracking-widest font-mono">Today's Scheduled Consultations</h4>
                                  <span className="text-[10px] text-blue-600 font-bold font-mono">3 Appointments</span>
                                </div>

                                <div className="space-y-2">
                                  <div className="bg-white border border-slate-150 p-3 rounded-xl flex items-center justify-between shadow-sm hover:border-slate-200 transition-all">
                                    <div className="flex items-center gap-2.5">
                                      <div className="h-9 w-9 bg-slate-50 rounded-lg flex items-center justify-center text-sm border border-slate-100">
                                        👨
                                      </div>
                                      <div>
                                        <h5 className="font-bold text-xs text-slate-800">Karim Uddin</h5>
                                        <p className="text-[10px] text-slate-400 font-semibold font-mono">10:30 AM (NOW) • General Followup</p>
                                      </div>
                                    </div>
                                    <button
                                      onClick={() => {
                                        setActiveDoctorCall({
                                          patientName: "Karim Uddin",
                                          patientAge: 28,
                                          patientGender: "Male",
                                          patientWeight: 74,
                                          symptoms: "High fever (102°F) since 2 days, chest congestion, sore throat, severe fatigue.",
                                          duration: 0
                                        });
                                        triggerNotification("Starting Call", "Connecting to Karim Uddin via RTC...");
                                      }}
                                      className="py-1.5 px-3 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-[10px] font-black tracking-wider uppercase transition-all shadow-md flex items-center gap-1"
                                    >
                                      <Phone className="h-3 w-3" />
                                      CALL
                                    </button>
                                  </div>

                                  <div className="bg-white border border-slate-150 p-3 rounded-xl flex items-center justify-between shadow-sm opacity-70">
                                    <div className="flex items-center gap-2.5">
                                      <div className="h-9 w-9 bg-slate-50 rounded-lg flex items-center justify-center text-sm border border-slate-100">
                                        👨
                                      </div>
                                      <div>
                                        <h5 className="font-bold text-xs text-slate-800">Asif Iqbal</h5>
                                        <p className="text-[10px] text-slate-400 font-semibold font-mono">12:45 PM • Respiratory Review</p>
                                      </div>
                                    </div>
                                    <button
                                      disabled
                                      className="py-1.5 px-3 bg-slate-100 text-slate-400 rounded-lg text-[10px] font-bold tracking-wider uppercase"
                                    >
                                      SCHEDULED
                                    </button>
                                  </div>

                                  <div className="bg-white border border-slate-150 p-3 rounded-xl flex items-center justify-between shadow-sm opacity-70">
                                    <div className="flex items-center gap-2.5">
                                      <div className="h-9 w-9 bg-slate-50 rounded-lg flex items-center justify-center text-sm border border-slate-100">
                                        👩
                                      </div>
                                      <div>
                                        <h5 className="font-bold text-xs text-slate-800">Tasnim Begum</h5>
                                        <p className="text-[10px] text-slate-400 font-semibold font-mono">03:00 PM • Hypertension Review</p>
                                      </div>
                                    </div>
                                    <button
                                      disabled
                                      className="py-1.5 px-3 bg-slate-100 text-slate-400 rounded-lg text-[10px] font-bold tracking-wider uppercase"
                                    >
                                      SCHEDULED
                                    </button>
                                  </div>
                                </div>
                              </div>
                            </>
                          )}

                          {/* D2. VIEW: PATIENT QUEUE SCREEN */}
                          {doctorViewScreen === 'queue' && (
                            <div className="space-y-4">
                              <div className="flex items-center gap-2">
                                <button
                                  onClick={() => setDoctorViewScreen('dashboard')}
                                  className="p-1 hover:bg-slate-200 rounded-full text-slate-600 transition-colors"
                                >
                                  <ArrowLeft className="h-4 w-4" />
                                </button>
                                <h4 className="font-extrabold text-sm text-slate-800">Patient Waiting Queue</h4>
                              </div>

                              <div className="space-y-3">
                                {[
                                  { id: 'q_1', pos: 1, name: "Karim Uddin", age: 28, gender: "Male", weight: 74, problem: "High fever (102°F) since 2 days, sore throat, severe body aches, dry cough, and fatigue.", attachments: ["Throat_Inflame.jpg"] },
                                  { id: 'q_2', pos: 2, name: "Rahima Begum", age: 68, gender: "Female", weight: 62, problem: "Dizziness, chest tightness post-cardiac stenting procedure.", attachments: [] },
                                  { id: 'q_3', pos: 3, name: "Asif Iqbal", age: 35, gender: "Male", weight: 80, problem: "Dry cough, shortness of breath on exertion, throat congestion.", attachments: ["Med_Label.jpg"] }
                                ].map((pt, idx) => {
                                  const isExpanded = selectedEhrPatient?.id === pt.id;
                                  return (
                                    <div key={pt.id} className="bg-white border border-slate-150 rounded-2xl overflow-hidden shadow-sm transition-all hover:border-slate-200">
                                      {/* Accordion Header */}
                                      <div 
                                        onClick={() => {
                                          if (isExpanded) {
                                            setSelectedEhrPatient(null);
                                          } else {
                                            setSelectedEhrPatient({ id: pt.id, name: pt.name });
                                          }
                                        }}
                                        className="p-3.5 flex items-center justify-between cursor-pointer hover:bg-slate-50/50 transition-colors"
                                      >
                                        <div className="flex items-center gap-3">
                                          <span className="h-6 w-6 rounded-full bg-blue-600/10 text-blue-600 border border-blue-200 text-xs font-black flex items-center justify-center font-mono">
                                            {pt.pos}
                                          </span>
                                          <div>
                                            <h5 className="font-extrabold text-xs text-slate-800">{pt.name}</h5>
                                            <p className="text-[10px] text-slate-400 font-semibold font-mono">{pt.gender} • {pt.age} Yrs • {pt.weight} kg</p>
                                          </div>
                                        </div>
                                        <ChevronDown className={`h-4 w-4 text-slate-400 transition-transform duration-200 ${isExpanded ? 'transform rotate-180 text-blue-600' : ''}`} />
                                      </div>

                                      {/* Accordion Body */}
                                      {isExpanded && (
                                        <div className="p-3.5 border-t border-slate-100 bg-slate-50/50 space-y-3.5">
                                          <div className="space-y-1.5">
                                            <span className="text-[9px] font-extrabold text-slate-400 uppercase tracking-wider font-mono">Stated Problem & Symptoms</span>
                                            <p className="text-[11px] text-slate-700 leading-relaxed bg-white border border-slate-150 p-2.5 rounded-xl font-medium">
                                              {pt.problem}
                                            </p>
                                          </div>

                                          {pt.attachments.length > 0 && (
                                            <div className="space-y-1.5">
                                              <span className="text-[9px] font-extrabold text-slate-400 uppercase tracking-wider font-mono">Attachments & Uploads ({pt.attachments.length})</span>
                                              <div className="flex gap-2">
                                                {pt.attachments.map((file, fIdx) => (
                                                  <div key={fIdx} className="bg-white border border-slate-200 p-2 rounded-xl flex items-center gap-2 text-[10px] font-semibold text-slate-600">
                                                    <span>📁</span>
                                                    <span>{file}</span>
                                                  </div>
                                                ))}
                                              </div>
                                            </div>
                                          )}

                                          {/* Patient Quick Action buttons */}
                                          <div className="grid grid-cols-4 gap-2 pt-1.5">
                                            <button
                                              onClick={() => {
                                                setSelectedEhrPatient({ id: pt.id, name: pt.name });
                                                setDoctorViewScreen('ehr');
                                                triggerNotification("EHR Loaded", "Viewing electronic records of " + pt.name);
                                              }}
                                              className="py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-[10.5px] font-extrabold rounded-xl transition-all border border-slate-200 flex flex-col items-center justify-center gap-1"
                                            >
                                              <span>📋</span>
                                              EHR Files
                                            </button>

                                            <button
                                              onClick={() => {
                                                triggerNotification("Direct Chat Activated", "Establishing live secure end-to-end messaging loop with " + pt.name);
                                              }}
                                              className="py-2.5 bg-blue-50 hover:bg-blue-100 text-blue-600 text-[10.5px] font-extrabold rounded-xl transition-all border border-blue-200/50 flex flex-col items-center justify-center gap-1"
                                            >
                                              <MessageSquare className="h-3.5 w-3.5 text-blue-600" />
                                              Chat Loop
                                            </button>

                                            <button
                                              onClick={() => {
                                                setActiveDoctorCall({
                                                  patientName: pt.name,
                                                  patientAge: pt.age,
                                                  patientGender: pt.gender,
                                                  patientWeight: pt.weight,
                                                  symptoms: pt.problem,
                                                  duration: 0
                                                });
                                                triggerNotification("Connecting Call", "Opening WebRTC viewport with " + pt.name);
                                              }}
                                              className="py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white text-[10.5px] font-extrabold rounded-xl transition-all shadow-md flex flex-col items-center justify-center gap-1"
                                            >
                                              <Video className="h-3.5 w-3.5 text-white" />
                                              Call Loop
                                            </button>

                                            <button
                                              onClick={() => {
                                                setSelectedPrescriptionPatient({ id: pt.id, name: pt.name });
                                                setDoctorViewScreen('prescription');
                                                setPrescriptionMedicines([]);
                                                triggerNotification("Prescription Mode", "Drafting medical prescription (Rx) for " + pt.name);
                                              }}
                                              className="py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-[10.5px] font-extrabold rounded-xl transition-all shadow-md flex flex-col items-center justify-center gap-1"
                                            >
                                              <Pill className="h-3.5 w-3.5 text-white" />
                                              Write Rx
                                            </button>
                                          </div>
                                        </div>
                                      )}
                                    </div>
                                  );
                                })}
                              </div>
                            </div>
                          )}

                          {/* D3. VIEW: AVAILABILITY & SHIFT SCHEDULER */}
                          {doctorViewScreen === 'availability' && (
                            <div className="space-y-4">
                              <div className="flex items-center gap-2">
                                <button
                                  onClick={() => setDoctorViewScreen('dashboard')}
                                  className="p-1 hover:bg-slate-200 rounded-full text-slate-600 transition-colors"
                                >
                                  <ArrowLeft className="h-4 w-4" />
                                </button>
                                <h4 className="font-extrabold text-sm text-slate-800">Availability & Shift Scheduler</h4>
                              </div>

                              {/* Calendar row days Monday to Sunday */}
                              <div className="flex justify-between gap-1 overflow-x-auto pb-1.5">
                                {['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map((day) => {
                                  const isActive = selectedScheduleDay === day;
                                  return (
                                    <button
                                      key={day}
                                      onClick={() => setSelectedScheduleDay(day)}
                                      className={`px-3 py-2 rounded-xl text-center flex flex-col items-center justify-center shrink-0 min-w-[54px] transition-all border ${isActive ? 'bg-blue-600 text-white border-blue-500 shadow-md shadow-blue-500/10' : 'bg-white text-slate-600 border-slate-150 hover:bg-slate-50'}`}
                                    >
                                      <span className="text-[8px] font-extrabold font-mono uppercase opacity-70">{day.slice(0, 3)}</span>
                                      <span className="text-xs font-black mt-0.5">{day === 'Monday' ? '06' : day === 'Tuesday' ? '07' : day === 'Wednesday' ? '08' : day === 'Thursday' ? '09' : day === 'Friday' ? '10' : day === 'Saturday' ? '11' : '12'}</span>
                                    </button>
                                  );
                                })}
                              </div>

                              {/* Selected Day Availability shifts list */}
                              <div className="bg-white border border-slate-150 rounded-2xl p-4 space-y-4 shadow-sm">
                                <div className="flex justify-between items-center pb-2 border-b border-slate-100">
                                  <h5 className="font-extrabold text-xs text-slate-800">{selectedScheduleDay} Active Blocks</h5>
                                  <span className="text-[9px] font-extrabold bg-blue-100 text-blue-600 px-2 py-0.5 rounded font-mono uppercase">Shift Config</span>
                                </div>

                                <div className="space-y-3">
                                  {[
                                    { id: 's_m', name: "Morning Session", time: "09:00 AM - 01:00 PM", active: true, icon: "🌅" },
                                    { id: 's_a', name: "Afternoon Session", time: "02:00 PM - 06:00 PM", active: true, icon: "☀️" },
                                    { id: 's_e', name: "Evening / Night Session", time: "07:00 PM - 10:00 PM", active: false, icon: "🌃" }
                                  ].map((shift) => (
                                    <div key={shift.id} className="flex items-center justify-between p-3 bg-slate-50 rounded-xl border border-slate-100">
                                      <div className="flex items-center gap-3">
                                        <span className="text-base">{shift.icon}</span>
                                        <div>
                                          <h6 className="font-bold text-xs text-slate-800">{shift.name}</h6>
                                          <p className="text-[10px] text-slate-400 font-semibold font-mono">{shift.time}</p>
                                        </div>
                                      </div>
                                      <div className="flex items-center gap-1.5">
                                        <span className={`text-[9px] font-mono font-bold ${shift.active ? 'text-blue-600' : 'text-slate-400'}`}>{shift.active ? 'ACTIVE' : 'INACTIVE'}</span>
                                        <button className={`w-9 h-5 rounded-full p-0.5 transition-colors focus:outline-none flex ${shift.active ? 'bg-blue-600 justify-end' : 'bg-slate-300 justify-start'}`}>
                                          <span className="h-4 w-4 rounded-full bg-white shadow" />
                                        </button>
                                      </div>
                                    </div>
                                  ))}
                                </div>

                                {/* Shift Scheduler bulk actions */}
                                <div className="grid grid-cols-2 gap-2.5 pt-2">
                                  <button
                                    onClick={() => triggerNotification("Schedule Copied", "Settings duplicated to all weekdays (Mon-Fri) successfully.")}
                                    className="py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-[10px] font-extrabold rounded-xl transition-all border border-slate-200"
                                  >
                                    Copy to Weekdays
                                  </button>
                                  <button
                                    onClick={() => triggerNotification("Availability Saved", "Weekly clinical roster successfully updated on server.")}
                                    className="py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-[10px] font-extrabold rounded-xl transition-all shadow-md shadow-blue-500/10"
                                  >
                                    Save Weekly Schedule
                                  </button>
                                </div>
                              </div>
                            </div>
                          )}

                          {/* D4. VIEW: EARNINGS DASHBOARD */}
                          {doctorViewScreen === 'earnings' && (
                            <div className="space-y-4">
                              <div className="flex items-center gap-2">
                                <button
                                  onClick={() => setDoctorViewScreen('dashboard')}
                                  className="p-1 hover:bg-slate-200 rounded-full text-slate-600 transition-colors"
                                >
                                  <ArrowLeft className="h-4 w-4" />
                                </button>
                                <h4 className="font-extrabold text-sm text-slate-800">Financial Analytics Dashboard</h4>
                              </div>

                              {/* Earnings stats row */}
                              <div className="grid grid-cols-2 gap-3">
                                <div className="bg-gradient-to-br from-emerald-600 to-emerald-700 p-4 rounded-2xl text-white shadow-md relative overflow-hidden">
                                  <div className="absolute right-0 bottom-0 h-16 w-16 bg-white/5 rounded-full transform translate-x-3 translate-y-3"></div>
                                  <span className="text-[9px] font-black uppercase font-mono tracking-widest text-white/80">TODAY'S PAYOUT</span>
                                  <h4 className="text-xl font-black mt-1">৳ 3,200</h4>
                                  <p className="text-[9px] text-white/70 font-semibold font-mono mt-0.5">5 Settled Invoices</p>
                                </div>

                                <div className="bg-white border border-slate-150 p-4 rounded-2xl shadow-sm">
                                  <span className="text-[9px] font-black uppercase font-mono tracking-widest text-slate-400">THIS MONTH</span>
                                  <h4 className="text-xl font-black text-slate-800 mt-1">৳ 38,400</h4>
                                  <p className="text-[9px] text-emerald-600 font-bold font-mono mt-0.5">+25.7% vs May</p>
                                </div>
                              </div>

                              {/* Beautiful interactive chart mockup */}
                              <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm space-y-3">
                                <div className="flex justify-between items-start">
                                  <div>
                                    <h5 className="font-extrabold text-xs text-slate-800">Roster Revenue comparison</h5>
                                    <p className="text-[9px] text-slate-400 font-medium mt-0.5">Monthly consult fees (BDT)</p>
                                  </div>
                                  <span className="text-[9px] font-bold bg-emerald-100 text-emerald-600 px-2 py-0.5 rounded font-mono uppercase">+25.7% Growth</span>
                                </div>

                                {/* Custom HTML/CSS Grouped Bar Chart */}
                                <div className="relative pt-6 pb-2">
                                  <div className="h-28 flex items-end justify-between border-b border-slate-100 relative z-10 px-2">
                                    {/* Month 1: March */}
                                    <div className="flex flex-col items-center gap-1.5 w-[14%]">
                                      <div className="w-4 bg-slate-200 rounded-t-sm h-[50%]" title="Target BDT 30k"></div>
                                      <div className="w-4 bg-blue-600 rounded-t-sm h-[60%]" title="Actual BDT 36k"></div>
                                      <span className="text-[9px] font-black font-mono text-slate-400 mt-1">MAR</span>
                                    </div>

                                    {/* Month 2: April */}
                                    <div className="flex flex-col items-center gap-1.5 w-[14%]">
                                      <div className="w-4 bg-slate-200 rounded-t-sm h-[40%]"></div>
                                      <div className="w-4 bg-blue-600 rounded-t-sm h-[50%]"></div>
                                      <span className="text-[9px] font-black font-mono text-slate-400 mt-1">APR</span>
                                    </div>

                                    {/* Month 3: May */}
                                    <div className="flex flex-col items-center gap-1.5 w-[14%]">
                                      <div className="w-4 bg-slate-200 rounded-t-sm h-[45%]"></div>
                                      <div className="w-4 bg-blue-600 rounded-t-sm h-[55%]"></div>
                                      <span className="text-[9px] font-black font-mono text-slate-400 mt-1">MAY</span>
                                    </div>

                                    {/* Month 4: June */}
                                    <div className="flex flex-col items-center gap-1.5 w-[14%]">
                                      <div className="w-4 bg-slate-200 rounded-t-sm h-[50%]"></div>
                                      <div className="w-4 bg-blue-600 rounded-t-sm h-[80%]"></div>
                                      <span className="text-[9px] font-black font-mono text-slate-400 mt-1">JUN</span>
                                    </div>
                                  </div>

                                  {/* Gridlines back */}
                                  <div className="absolute inset-x-0 top-6 bottom-8 flex flex-col justify-between pointer-events-none opacity-40 z-0">
                                    <div className="border-t border-slate-100 w-full h-0"></div>
                                    <div className="border-t border-slate-100 w-full h-0"></div>
                                    <div className="border-t border-slate-100 w-full h-0"></div>
                                  </div>
                                </div>

                                <div className="flex justify-center gap-4 pt-1.5 text-[10px] font-semibold text-slate-500 border-t border-slate-100">
                                  <div className="flex items-center gap-1">
                                    <span className="h-2 w-2 rounded-full bg-slate-300"></span>
                                    <span>Target Payout</span>
                                  </div>
                                  <div className="flex items-center gap-1">
                                    <span className="h-2 w-2 rounded-full bg-blue-600"></span>
                                    <span>Actual Revenue</span>
                                  </div>
                                </div>
                              </div>

                              {/* Transaction list */}
                              <div className="space-y-2">
                                <h5 className="text-[11px] font-extrabold text-slate-400 uppercase tracking-widest font-mono">Recent Consultation Payouts</h5>
                                <div className="space-y-2">
                                  {[
                                    { name: "Karim Uddin", amount: "৳ 600", fee: "৳ 600", date: "Today, 10:45 AM", type: "Digital Call" },
                                    { name: "Rahima Begum", amount: "৳ 800", fee: "৳ 800", date: "Today, 09:15 AM", type: "Emergency Call" },
                                    { name: "Asif Iqbal", amount: "৳ 600", fee: "৳ 600", date: "Yesterday, 06:30 PM", type: "Digital Call" }
                                  ].map((txn, txIdx) => (
                                    <div key={txIdx} className="bg-white border border-slate-150 p-3 rounded-xl flex justify-between items-center shadow-sm">
                                      <div>
                                        <h6 className="font-bold text-xs text-slate-800">{txn.name}</h6>
                                        <p className="text-[9px] text-slate-400 font-semibold font-mono">{txn.date} • {txn.type}</p>
                                      </div>
                                      <div className="text-right">
                                        <strong className="text-xs font-black text-emerald-600 font-mono block">{txn.amount}</strong>
                                        <span className="text-[8px] font-bold bg-emerald-50 text-emerald-600 px-1.5 py-0.5 rounded font-mono uppercase tracking-widest">SETTLED</span>
                                      </div>
                                    </div>
                                  ))}
                                </div>
                              </div>
                            </div>
                          )}

                          {/* D5. VIEW: PATIENT EHR VIEWER */}
                          {doctorViewScreen === 'ehr' && (
                            <div className="space-y-4">
                              <div className="flex items-center justify-between">
                                <div className="flex items-center gap-2">
                                  <button
                                    onClick={() => setDoctorViewScreen('queue')}
                                    className="p-1 hover:bg-slate-200 rounded-full text-slate-600 transition-colors"
                                  >
                                    <ArrowLeft className="h-4 w-4" />
                                  </button>
                                  <h4 className="font-extrabold text-sm text-slate-800">Electronic Health Record (EHR)</h4>
                                </div>
                                <span className="text-[9px] font-extrabold bg-blue-600 text-white px-2.5 py-0.5 rounded-full font-mono uppercase">VERIFIED</span>
                              </div>

                              {/* Patient Banner */}
                              <div className="bg-slate-900 text-white p-4 rounded-2xl shadow-md space-y-2 relative overflow-hidden">
                                <div className="absolute -right-4 -bottom-4 h-24 w-24 bg-white/5 rounded-full"></div>
                                <div className="flex justify-between items-start">
                                  <div>
                                    <span className="text-[8px] font-bold uppercase font-mono tracking-widest text-blue-400">PATIENT NODE ID</span>
                                    <h4 className="text-sm font-extrabold text-white mt-0.5">{activePatient.name}</h4>
                                    <p className="text-[9px] text-slate-300 font-semibold font-mono mt-0.5">UID: HD-PAT-9204 | Blood Group: O-positive</p>
                                  </div>
                                  <span className="text-2xl">📋</span>
                                </div>
                              </div>

                              {/* EHR Tab buttons */}
                              <div className="bg-slate-100 border border-slate-150 p-1 rounded-xl grid grid-cols-3 gap-1">
                                {[
                                  { key: 'history', label: "Visits" },
                                  { key: 'allergies', label: "Risks" },
                                  { key: 'past_rx', label: "Past Rx" }
                                ].map((tab) => {
                                  const isActive = ehrActiveTab === tab.key;
                                  return (
                                    <button
                                      key={tab.key}
                                      onClick={() => setEhrActiveTab(tab.key as any)}
                                      className={`py-1.5 rounded-lg text-center text-[10.5px] font-extrabold transition-all ${isActive ? 'bg-white text-blue-600 shadow-sm' : 'text-slate-500 hover:text-slate-800'}`}
                                    >
                                      {tab.label}
                                    </button>
                                  );
                                })}
                              </div>

                              {/* EHR Tab Contents */}
                              <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm min-h-[220px]">
                                {ehrActiveTab === 'history' && (
                                  <div className="space-y-4">
                                    <h5 className="font-extrabold text-xs text-slate-800 pb-2 border-b border-slate-100 flex items-center gap-1">
                                      <span>📈</span> Recorded Clinical Vitals (History)
                                    </h5>
                                    <div className="grid grid-cols-2 gap-2.5">
                                      <div className="bg-slate-50 p-3 rounded-xl border border-slate-100">
                                        <span className="text-[8px] font-extrabold text-slate-400 uppercase tracking-widest font-mono block">Blood Pressure</span>
                                        <strong className="text-sm text-slate-800 block mt-1">120/80 mmHg</strong>
                                        <span className="text-[8.5px] text-emerald-600 font-semibold mt-0.5 block font-mono">NORMAL</span>
                                      </div>
                                      <div className="bg-slate-50 p-3 rounded-xl border border-slate-100">
                                        <span className="text-[8px] font-extrabold text-slate-400 uppercase tracking-widest font-mono block">Body Temp</span>
                                        <strong className="text-sm text-slate-800 block mt-1">102.2 °F</strong>
                                        <span className="text-[8.5px] text-red-500 font-semibold mt-0.5 block font-mono">FEVER LEVEL</span>
                                      </div>
                                    </div>
                                    <div className="p-3 bg-blue-50/50 border border-blue-100 rounded-xl space-y-1">
                                      <strong className="text-[10.5px] font-bold text-blue-950 block">Specialist Clinical Notes</strong>
                                      <p className="text-[10px] text-blue-900 leading-normal font-semibold italic">"Recurrent congestion reporting sore throat. Examined lungs; clear on percussion. Patient checked for drug sensitivities, allergic risks noted."</p>
                                    </div>
                                  </div>
                                )}

                                {ehrActiveTab === 'allergies' && (
                                  <div className="space-y-4">
                                    <h5 className="font-extrabold text-xs text-slate-800 pb-2 border-b border-slate-100 flex items-center gap-1">
                                      <span>⚠️</span> Critical Drug Sensitivities & Allergies
                                    </h5>
                                    <div className="space-y-2">
                                      <div className="p-2.5 bg-red-50 border border-red-150 rounded-xl flex items-center justify-between text-xs font-semibold">
                                        <div className="flex items-center gap-2 text-red-900">
                                          <span>💊</span>
                                          <span>Penicillin Group</span>
                                        </div>
                                        <span className="text-[9px] font-extrabold bg-red-600 text-white px-2 py-0.5 rounded font-mono uppercase">HIGH RISK</span>
                                      </div>

                                      <div className="p-2.5 bg-amber-50 border border-amber-150 rounded-xl flex items-center justify-between text-xs font-semibold">
                                        <div className="flex items-center gap-2 text-amber-900">
                                          <span>💊</span>
                                          <span>Sulfa Antibiotics</span>
                                        </div>
                                        <span className="text-[9px] font-extrabold bg-amber-500 text-white px-2 py-0.5 rounded font-mono uppercase">MODERATE</span>
                                      </div>
                                    </div>

                                    <div className="p-3 bg-slate-50 border border-slate-150 rounded-xl space-y-1">
                                      <strong className="text-[10px] font-bold text-slate-500 uppercase tracking-widest font-mono block">Chronic Conditions</strong>
                                      <p className="text-[10.5px] text-slate-700 leading-normal font-medium">Chronic Mild Hypertension, Dyslipidemia.</p>
                                    </div>
                                  </div>
                                )}

                                {ehrActiveTab === 'past_rx' && (
                                  <div className="space-y-3">
                                    <h5 className="font-extrabold text-xs text-slate-800 pb-2 border-b border-slate-100 flex items-center gap-1">
                                      <span>📋</span> Historical E-Prescriptions
                                    </h5>
                                    <div className="p-3 bg-slate-50 border border-slate-150 rounded-xl space-y-2">
                                      <div className="flex justify-between items-center text-[10px] font-bold text-slate-400">
                                        <span>DATE: Jun 12, 2026</span>
                                        <span className="text-blue-600">Rx Ref: HD-9821</span>
                                      </div>
                                      <div className="bg-white p-2.5 rounded-lg border border-slate-100 text-[10.5px]">
                                        <strong className="font-bold text-slate-800 block">Cap. Amoxicillin 500mg</strong>
                                        <span className="text-[9px] text-slate-400 block mt-0.5">Dosage: 1+0+1 • Timing: After Meal • 7 Days</span>
                                      </div>
                                    </div>
                                  </div>
                                )}
                              </div>
                            </div>
                          )}

                          {/* D6. VIEW: WRITE PRESCRIPTION SCREEN */}
                          {doctorViewScreen === 'prescription' && (
                            <div className="space-y-4">
                              <div className="flex justify-between items-center pb-2 border-b border-slate-150">
                                <div className="flex items-center gap-2">
                                  <span className="text-base">📝</span>
                                  <h4 className="font-extrabold text-sm text-slate-800">Draft E-Prescription (Rx)</h4>
                                </div>
                                <button
                                  onClick={() => {
                                    setDoctorViewScreen('dashboard');
                                    triggerNotification("Draft Discarded", "Prescription draft cleared.");
                                  }}
                                  className="p-1 hover:bg-slate-200 rounded-full text-slate-500"
                                >
                                  <X className="h-4 w-4" />
                                </button>
                              </div>

                              {/* Prescribing For Card */}
                              <div className="bg-blue-50 border border-blue-200 rounded-2xl p-3 flex items-center gap-3">
                                <div className="h-10 w-10 bg-blue-100 rounded-full flex items-center justify-center text-xl">
                                  🤕
                                </div>
                                <div>
                                  <span className="text-[8px] font-extrabold text-blue-600 uppercase tracking-widest font-mono">PATIENT IN FOCUS</span>
                                  <h5 className="font-black text-xs text-slate-800">{selectedPrescriptionPatient?.name || 'Karim Uddin'}</h5>
                                  <p className="text-[9.5px] text-slate-400 font-semibold font-mono">HD-PAT-9204 • Male • 28 Yrs</p>
                                </div>
                              </div>

                              {/* Input Fields complaints & diagnosis */}
                              <div className="space-y-3 bg-white border border-slate-150 p-4 rounded-2xl shadow-sm">
                                <div className="space-y-1.5">
                                  <label className="text-[10px] font-extrabold text-slate-400 uppercase tracking-widest font-mono">Chief Complaints</label>
                                  <textarea
                                    rows={2}
                                    placeholder="Enter chief complaints (e.g., high fever since 2 days, chest congestion, sore throat)"
                                    value={prescriptionComplaints}
                                    onChange={(e) => setPrescriptionComplaints(e.target.value)}
                                    className="w-full bg-slate-50 border border-slate-250 rounded-xl p-2.5 text-xs font-semibold focus:outline-none focus:border-blue-500"
                                  />
                                </div>

                                <div className="space-y-1.5">
                                  <label className="text-[10px] font-extrabold text-slate-400 uppercase tracking-widest font-mono">Diagnosis / Clinical Impression</label>
                                  <input
                                    type="text"
                                    placeholder="Enter primary clinical diagnosis"
                                    value={prescriptionDiagnosis}
                                    onChange={(e) => setPrescriptionDiagnosis(e.target.value)}
                                    className="w-full bg-slate-50 border border-slate-250 rounded-xl p-2.5 text-xs font-semibold focus:outline-none focus:border-blue-500"
                                  />
                                </div>
                              </div>

                              {/* Medications section */}
                              <div className="bg-white border border-slate-150 p-4 rounded-2xl shadow-sm space-y-3">
                                <div className="flex justify-between items-center pb-2 border-b border-slate-100">
                                  <h5 className="font-extrabold text-xs text-slate-800">Add Medications (Rx)</h5>
                                  <span className="text-[9px] font-extrabold bg-blue-100 text-blue-600 px-2 py-0.5 rounded font-mono">DRUG LIST</span>
                                </div>

                                <div className="grid grid-cols-2 gap-2">
                                  <div className="col-span-2">
                                    <input
                                      type="text"
                                      placeholder="Medicine name (e.g. Tab. Napa Extend 665mg)"
                                      value={prescriptionMedInput}
                                      onChange={(e) => setPrescriptionMedInput(e.target.value)}
                                      className="w-full bg-slate-50 border border-slate-200 rounded-xl p-2.5 text-xs font-semibold focus:outline-none focus:border-blue-500"
                                    />
                                  </div>
                                  <div>
                                    <select
                                      value={prescriptionDosage}
                                      onChange={(e) => setPrescriptionDosage(e.target.value)}
                                      className="w-full bg-slate-50 border border-slate-200 rounded-xl p-2.5 text-xs font-semibold focus:outline-none focus:border-blue-500"
                                    >
                                      <option value="1+0+1">1 + 0 + 1</option>
                                      <option value="1+1+1">1 + 1 + 1</option>
                                      <option value="1+0+0">1 + 0 + 0</option>
                                      <option value="0+0+1">0 + 0 + 1</option>
                                      <option value="2 tsp">2 tsp daily</option>
                                    </select>
                                  </div>
                                  <div>
                                    <select
                                      value={prescriptionDuration}
                                      onChange={(e) => setPrescriptionDuration(e.target.value)}
                                      className="w-full bg-slate-50 border border-slate-200 rounded-xl p-2.5 text-xs font-semibold focus:outline-none focus:border-blue-500"
                                    >
                                      <option value="3 Days">3 Days</option>
                                      <option value="5 Days">5 Days</option>
                                      <option value="7 Days">7 Days</option>
                                      <option value="10 Days">10 Days</option>
                                      <option value="14 Days">14 Days</option>
                                    </select>
                                  </div>
                                  <div className="col-span-2">
                                    <select
                                      value={prescriptionTiming}
                                      onChange={(e) => setPrescriptionTiming(e.target.value)}
                                      className="w-full bg-slate-50 border border-slate-200 rounded-xl p-2.5 text-xs font-semibold focus:outline-none"
                                    >
                                      <option value="After Meal">After Meal (খাবার পর)</option>
                                      <option value="Before Meal">Before Meal (খাবার আগে)</option>
                                    </select>
                                  </div>
                                </div>

                                <button
                                  onClick={() => {
                                    if (!prescriptionMedInput) {
                                      triggerNotification("Form incomplete", "Please enter a valid medicine name.");
                                      return;
                                    }
                                    setPrescriptionMedicines([
                                      ...prescriptionMedicines,
                                      {
                                        name: prescriptionMedInput,
                                        dosage: prescriptionDosage,
                                        duration: prescriptionDuration,
                                        timing: prescriptionTiming
                                      }
                                    ]);
                                    setPrescriptionMedInput('');
                                    triggerNotification("Medication Added", prescriptionMedInput + " added to Rx.");
                                  }}
                                  className="w-full py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold transition-all shadow-md shadow-blue-500/10 flex items-center justify-center gap-1.5"
                                >
                                  <Plus className="h-4 w-4" />
                                  Add to Prescription list
                                </button>

                                {/* Added Medicines Roster */}
                                {prescriptionMedicines.length > 0 && (
                                  <div className="space-y-2 pt-2 border-t border-slate-100">
                                    {prescriptionMedicines.map((med, medIdx) => (
                                      <div key={medIdx} className="flex justify-between items-center p-2.5 bg-slate-50 rounded-xl border border-slate-100 text-xs">
                                        <div>
                                          <strong className="font-bold text-slate-800 block">{med.name}</strong>
                                          <span className="text-[9px] text-slate-400 block mt-0.5">{med.dosage} • {med.timing} • {med.duration}</span>
                                        </div>
                                        <button
                                          onClick={() => {
                                            setPrescriptionMedicines(prescriptionMedicines.filter((_, idx) => idx !== medIdx));
                                            triggerNotification("Medication Removed", "Cleared from list.");
                                          }}
                                          className="text-red-500 hover:text-red-600 p-1 rounded-full hover:bg-red-50"
                                        >
                                          <span>🗑️</span>
                                        </button>
                                      </div>
                                    ))}
                                  </div>
                                )}
                              </div>

                              {/* Advices and submit */}
                              <div className="bg-white border border-slate-150 p-4 rounded-2xl shadow-sm space-y-3">
                                <div className="space-y-1.5">
                                  <label className="text-[10px] font-extrabold text-slate-400 uppercase tracking-widest font-mono">Special Advices / General Instructions</label>
                                  <textarea
                                    rows={2}
                                    placeholder="Enter patient advices (e.g., drink warm water, avoid cold exposure, review in 3 days)"
                                    value={prescriptionAdvice}
                                    onChange={(e) => setPrescriptionAdvice(e.target.value)}
                                    className="w-full bg-slate-50 border border-slate-250 rounded-xl p-2.5 text-xs font-semibold focus:outline-none focus:border-blue-500"
                                  />
                                </div>

                                <button
                                  onClick={() => {
                                    if (prescriptionMedicines.length === 0) {
                                      triggerNotification("Cannot Dispatch", "Please add at least one medication.");
                                      return;
                                    }
                                    // Submit success
                                    triggerNotification("Prescription Dispatched", "E-Rx transmitted securely to " + (selectedPrescriptionPatient?.name || 'Patient'));
                                    setPrescriptionComplaints('');
                                    setPrescriptionDiagnosis('');
                                    setPrescriptionAdvice('');
                                    setPrescriptionMedicines([]);
                                    setDoctorViewScreen('dashboard');
                                  }}
                                  className="w-full py-3 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold transition-all shadow-md shadow-emerald-500/10 flex items-center justify-center gap-1.5"
                                >
                                  <span>🚀</span>
                                  Transmit & Dispatch E-Rx
                                </button>
                              </div>
                            </div>
                          )}

                          {/* D8. VIEW: HEALTH FEED SCREEN */}
                          {doctorViewScreen === 'feed' && (
                            <div className="space-y-4 flex-1 flex flex-col h-full overflow-hidden">
                              <div className="flex items-center gap-2 pb-2 border-b border-slate-150 px-4">
                                <button
                                  onClick={() => setDoctorViewScreen('dashboard')}
                                  className="p-1 hover:bg-slate-200 rounded-full text-slate-600 transition-colors"
                                >
                                  <ArrowLeft className="h-4 w-4" />
                                </button>
                                <h4 className="font-extrabold text-sm text-slate-800">Health Feed (Clinical Bulletins)</h4>
                              </div>
                              {renderHealthFeed({ id: 'doc-1', name: 'Dr. Sarah Rahman', role: 'Doctor', avatar: '🩺' })}
                            </div>
                          )}

                          {/* D7. VIEW: DOCTOR ACCOUNT / PROFILE */}
                          {doctorPortalTab === 'account' && (
                            <div className="space-y-4">
                              {/* Profile header card */}
                              <div className="bg-white border border-slate-150 rounded-2xl p-4 flex flex-col items-center justify-center text-center shadow-sm relative overflow-hidden">
                                <div className="absolute right-0 top-0 h-16 w-16 bg-blue-600/5 rounded-full transform translate-x-4 -translate-y-4"></div>
                                <div className="h-16 w-16 bg-blue-100 rounded-full flex items-center justify-center border-2 border-blue-300 text-3xl">
                                  👨‍⚕️
                                </div>
                                <h4 className="font-extrabold text-sm text-slate-800 mt-3">Dr. Sarah Rahman</h4>
                                <p className="text-[10px] bg-blue-100 text-blue-600 font-bold px-2.5 py-0.5 rounded-full font-mono mt-1 uppercase tracking-widest">MD, Cardiology</p>
                                
                                <div className="w-full grid grid-cols-2 gap-2 pt-4 mt-4 border-t border-slate-100 text-[10.5px]">
                                  <div className="bg-slate-50 p-2.5 rounded-xl border border-slate-100">
                                    <span className="text-slate-400 font-mono text-[8px] font-bold block uppercase tracking-wider">REGISTRATION</span>
                                    <strong className="text-slate-700 font-bold mt-0.5 block">BMDC A-84291</strong>
                                  </div>
                                  <div className="bg-slate-50 p-2.5 rounded-xl border border-slate-100">
                                    <span className="text-slate-400 font-mono text-[8px] font-bold block uppercase tracking-wider">EXPERIENCE</span>
                                    <strong className="text-slate-700 font-bold mt-0.5 block">12+ Years</strong>
                                  </div>
                                </div>
                              </div>

                              {/* Workspace Action Lists */}
                              <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm divide-y divide-slate-100">
                                <div 
                                  onClick={() => {
                                    setDoctorViewScreen('availability');
                                    setDoctorPortalTab('appointments');
                                  }}
                                  className="py-3 flex justify-between items-center cursor-pointer hover:bg-slate-50/50 -mx-4 px-4 transition-colors"
                                >
                                  <div className="flex items-center gap-3">
                                    <span className="text-base">📅</span>
                                    <div>
                                      <h5 className="font-bold text-xs text-slate-800">Weekly Availability & Shifts</h5>
                                      <p className="text-[9px] text-slate-400 font-medium mt-0.5">Edit calendar blocks & session timings</p>
                                    </div>
                                  </div>
                                  <ChevronRight className="h-4 w-4 text-slate-400" />
                                </div>

                                <div 
                                  onClick={() => {
                                    setDoctorViewScreen('earnings');
                                    setDoctorPortalTab('home');
                                  }}
                                  className="py-3 flex justify-between items-center cursor-pointer hover:bg-slate-50/50 -mx-4 px-4 transition-colors"
                                >
                                  <div className="flex items-center gap-3">
                                    <span className="text-base">৳</span>
                                    <div>
                                      <h5 className="font-bold text-xs text-slate-800">Financial Analytics & Payouts</h5>
                                      <p className="text-[9px] text-slate-400 font-medium mt-0.5">View today's receipts and monthly roster</p>
                                    </div>
                                  </div>
                                  <ChevronRight className="h-4 w-4 text-slate-400" />
                                </div>

                                <div 
                                  onClick={() => {
                                    setDoctorViewScreen('queue');
                                    setDoctorPortalTab('home');
                                  }}
                                  className="py-3 flex justify-between items-center cursor-pointer hover:bg-slate-50/50 -mx-4 px-4 transition-colors"
                                >
                                  <div className="flex items-center gap-3">
                                    <span className="text-base">👥</span>
                                    <div>
                                      <h5 className="font-bold text-xs text-slate-800">Patient Consultation Queue</h5>
                                      <p className="text-[9px] text-slate-400 font-medium mt-0.5">3 Active patients waiting on the board</p>
                                    </div>
                                  </div>
                                  <ChevronRight className="h-4 w-4 text-slate-400" />
                                </div>

                                <div 
                                  onClick={() => {
                                    setDoctorViewScreen('feed');
                                    setDoctorPortalTab('home');
                                  }}
                                  className="py-3 flex justify-between items-center cursor-pointer hover:bg-slate-50/50 -mx-4 px-4 transition-colors"
                                >
                                  <div className="flex items-center gap-3">
                                    <span className="text-base">📢</span>
                                    <div>
                                      <h5 className="font-bold text-xs text-slate-800">Health Feed (Clinical Posts)</h5>
                                      <p className="text-[9px] text-slate-400 font-medium mt-0.5">Post bulletins, tips, or review patient posts</p>
                                    </div>
                                  </div>
                                  <ChevronRight className="h-4 w-4 text-slate-400" />
                                </div>
                              </div>

                              {/* Workspace Info Panel */}
                              <div className="bg-slate-50 border border-slate-150 rounded-2xl p-4.5 text-xs text-slate-600 space-y-2">
                                <h5 className="font-bold text-[10px] text-blue-600 uppercase tracking-widest font-mono">WORKSPACE ENCRYPTION</h5>
                                <p className="text-[10px] leading-relaxed">Your digital practice is encrypted end-to-end under clinical protocol HIPAA/BMDC guidelines. Prescription electronic keys are signed via private clinical certificate nodes.</p>
                              </div>
                            </div>
                          )}

                        </div>

                        {/* E. FIXED BOTTOM TAB NAVIGATION BAR */}
                        <div className="absolute inset-x-0 bottom-0 h-16 bg-white border-t border-slate-150 px-6 flex justify-between items-center z-20 shadow-[0_-4px_12px_rgba(0,0,0,0.03)] shrink-0">
                          <button
                            onClick={() => {
                              setDoctorPortalTab('home');
                              setDoctorViewScreen('dashboard');
                            }}
                            className={`flex flex-col items-center gap-0.5 text-[9px] font-bold ${doctorPortalTab === 'home' && doctorViewScreen === 'dashboard' ? 'text-blue-600 font-black scale-105' : 'text-slate-400 hover:text-slate-600'}`}
                          >
                            <Stethoscope className="h-4 w-4" />
                            <span>Dashboard</span>
                          </button>

                          <button
                            onClick={() => {
                              setDoctorPortalTab('appointments');
                              setDoctorViewScreen('availability');
                            }}
                            className={`flex flex-col items-center gap-0.5 text-[9px] font-bold ${doctorPortalTab === 'appointments' && doctorViewScreen === 'availability' ? 'text-blue-600 font-black scale-105' : 'text-slate-400 hover:text-slate-600'}`}
                          >
                            <Calendar className="h-4 w-4" />
                            <span>Scheduler</span>
                          </button>

                          <button
                            onClick={() => {
                              setDoctorPortalTab('reports');
                              setDoctorViewScreen('ehr');
                            }}
                            className={`flex flex-col items-center gap-0.5 text-[9px] font-bold ${doctorPortalTab === 'reports' && doctorViewScreen === 'ehr' ? 'text-blue-600 font-black scale-105' : 'text-slate-400 hover:text-slate-600'}`}
                          >
                            <Activity className="h-4 w-4" />
                            <span>EHR Logs</span>
                          </button>

                          <button
                            onClick={() => {
                              setDoctorPortalTab('account');
                            }}
                            className={`flex flex-col items-center gap-0.5 text-[9px] font-bold ${doctorPortalTab === 'account' ? 'text-blue-600 font-black scale-105' : 'text-slate-400 hover:text-slate-600'}`}
                          >
                            <User className="h-4 w-4" />
                            <span>Profile</span>
                          </button>
                        </div>
                      </motion.div>
                    );
                  })()}

                  {/* PORTAL HOMES (PHARMACY) */}
                  {flutterScreen === 'pharmacy_home' && (
                    <motion.div
                      key="pharmacy_home"
                      initial={{ opacity: 0, x: 20 }}
                      animate={{ opacity: 1, x: 0 }}
                      exit={{ opacity: -20 }}
                      className="flex-1 flex flex-col p-6"
                    >
                      <button 
                        onClick={() => { setCurrentUser(null); setFlutterScreen('role_selection'); }}
                        className="self-start flex items-center gap-1.5 text-xs font-semibold text-amber-600 hover:text-amber-700 mb-6 bg-amber-50 px-3 py-1.5 rounded-full transition-all"
                      >
                        <ArrowLeft className="h-3.5 w-3.5" />
                        Log Out
                      </button>

                      <div className="flex-1 flex flex-col items-center justify-center text-center px-2">
                        <div className="h-20 w-20 bg-amber-100 rounded-full flex items-center justify-center text-amber-600 mb-6 relative">
                          <Pill className="h-10 w-10" />
                          <div className="absolute -bottom-1 -right-1 h-6 w-6 bg-emerald-500 border-4 border-white rounded-full flex items-center justify-center text-white text-[9px] font-bold animate-pulse">✓</div>
                        </div>
                        <h3 className="text-lg font-bold text-slate-800 font-display">Pharmacy Inventory</h3>
                        <p className="text-[10px] bg-amber-100 text-amber-600 font-semibold px-2.5 py-0.5 rounded-full font-mono mt-1.5 tracking-wider uppercase">Active Dispatch</p>
                        
                        <div className="mt-3 text-xs text-slate-600 font-medium">
                          Welcome, <span className="font-bold text-slate-800">{currentUser?.name || 'Lazz Dhanmondi'}</span>!
                        </div>

                        <p className="text-[11px] text-slate-500 mt-3 leading-relaxed max-w-xs">
                          Your franchise trade license clearance has been verified. You can coordinate courier delivery routes and dispense incoming medicine prescriptions.
                        </p>

                        <div className="w-full bg-slate-50 border border-slate-100 p-3.5 rounded-xl text-left mt-5 space-y-2.5">
                          <h4 className="text-[11px] font-bold text-slate-400 font-mono tracking-wider">PORTAL SKELETON SPECS</h4>
                          <div className="flex items-center gap-2 text-xs text-slate-600">
                            <CheckCircle className="h-3.5 w-3.5 text-amber-500" />
                            <span>GoRouter Path: <code className="bg-slate-100 px-1 py-0.5 rounded text-[11px] font-mono">/pharmacy-home</code></span>
                          </div>
                          <div className="flex items-center gap-2 text-xs text-slate-600">
                            <CheckCircle className="h-3.5 w-3.5 text-amber-500" />
                            <span>File: <span className="underline font-mono text-[11px]">pharmacy_home.dart</span></span>
                          </div>
                        </div>
                      </div>

                      <button
                        onClick={() => handleSelectFile('pharmacy_home')}
                        className="w-full py-3 bg-amber-600 text-white rounded-xl text-xs font-semibold hover:bg-amber-700 transition-all shadow-md shadow-amber-500/10 flex items-center justify-center gap-2 mt-6"
                      >
                        <Code className="h-4 w-4" />
                        View Flutter Source File
                      </button>
                    </motion.div>
                  )}

                  {/* PORTAL HOMES (DIAGNOSTIC) */}
                  {flutterScreen === 'diagnostic_home' && (() => {
                    // Helper to get matching orders for selected branch
                    const branchOrders = diagnosticOrders.filter(o => o.branch === diagnosticBranch);
                    
                    // Stats Calculations
                    const incomingCount = branchOrders.filter(o => o.status === 'Pending').length;
                    const scheduledCount = branchOrders.filter(o => o.status === 'Sample Collected' || o.scheduledTime).length;
                    const pendingUploadCount = branchOrders.filter(o => o.status === 'Processing').length;
                    const totalRevenue = branchOrders.reduce((sum, o) => sum + (o.isPaid ? o.total : 0), 0);

                    // Advance status handler
                    const handleAdvanceStatus = (orderId: string) => {
                      setDiagnosticOrders(prev => prev.map(o => {
                        if (o.id !== orderId) return o;
                        let nextStatus = o.status;
                        if (o.status === 'Pending') nextStatus = 'Sample Collected';
                        else if (o.status === 'Sample Collected') nextStatus = 'Processing';
                        else if (o.status === 'Processing') nextStatus = 'Report Ready';
                        else if (o.status === 'Report Ready') nextStatus = 'Delivered';
                        
                        triggerNotification('Order Updated', `Order ${o.id} status advanced to "${nextStatus}".`);
                        return { ...o, status: nextStatus };
                      }));
                      
                      // Also update selected detail view to reflect status change immediately
                      if (selectedDiagnosticOrder && selectedDiagnosticOrder.id === orderId) {
                        setSelectedDiagnosticOrder(prev => {
                          let nextStatus = prev.status;
                          if (prev.status === 'Pending') nextStatus = 'Sample Collected';
                          else if (prev.status === 'Sample Collected') nextStatus = 'Processing';
                          else if (prev.status === 'Processing') nextStatus = 'Report Ready';
                          else if (prev.status === 'Report Ready') nextStatus = 'Delivered';
                          return { ...prev, status: nextStatus };
                        });
                      }
                    };

                    return (
                      <motion.div
                        key="diagnostic_home"
                        initial={{ opacity: 0, x: 20 }}
                        animate={{ opacity: 1, x: 0 }}
                        exit={{ opacity: -20 }}
                        className="flex-1 flex flex-col h-full bg-slate-50 relative text-slate-700 overflow-hidden"
                      >
                        {/* A. STATUS BAR / HEADER */}
                        <div className="bg-purple-700 text-white p-4 shrink-0 shadow-md">
                          <div className="flex justify-between items-center">
                            <div className="flex items-center gap-2">
                              <button 
                                onClick={() => { setCurrentUser(null); setFlutterScreen('role_selection'); }}
                                className="p-1 hover:bg-purple-600 rounded-full transition-colors"
                                title="Exit to Roles Hub"
                              >
                                <ArrowLeft className="h-4 w-4" />
                              </button>
                              <div>
                                <h1 className="font-extrabold text-sm tracking-tight font-display flex items-center gap-1.5">
                                  <FlaskConical className="h-4 w-4 animate-pulse text-purple-200" />
                                  <span>Diagnostic Hub</span>
                                </h1>
                                <p className="text-[9px] text-purple-200 font-medium font-mono">DGHS Reg: #D-84291</p>
                              </div>
                            </div>

                            {/* Branch Selector Dropdown */}
                            <div className="relative">
                              <select 
                                value={diagnosticBranch}
                                onChange={(e: any) => {
                                  setDiagnosticBranch(e.target.value);
                                  triggerNotification('Branch Switched', `Active workspace changed to ${e.target.value}.`);
                                }}
                                className="bg-purple-600 border border-purple-500 text-white text-[10px] font-bold py-1 px-2.5 rounded-lg focus:outline-none cursor-pointer hover:bg-purple-500 transition-colors"
                              >
                                <option value="Main Branch">🏫 Main Branch</option>
                                <option value="Dhanmondi Branch">🏥 Dhanmondi</option>
                                <option value="Uttara Branch">🔬 Uttara Branch</option>
                              </select>
                            </div>
                          </div>
                        </div>

                        {/* B. DETAILED BANNER & STATS GRID */}
                        {diagnosticTab === 'orders' && !selectedDiagnosticOrder && (
                          <div className="p-3 bg-purple-50 border-b border-purple-100/60 shrink-0">
                            <div className="grid grid-cols-4 gap-1.5 text-center">
                              <div className="bg-white p-2 rounded-xl border border-purple-100 shadow-sm">
                                <span className="text-[14px] font-black text-purple-700 block">{incomingCount}</span>
                                <span className="text-[8px] text-slate-400 font-bold uppercase tracking-wide block leading-none mt-1">Incoming</span>
                              </div>
                              <div className="bg-white p-2 rounded-xl border border-purple-100 shadow-sm">
                                <span className="text-[14px] font-black text-amber-600 block">{scheduledCount}</span>
                                <span className="text-[8px] text-slate-400 font-bold uppercase tracking-wide block leading-none mt-1">Scheduled</span>
                              </div>
                              <div className="bg-white p-2 rounded-xl border border-purple-100 shadow-sm">
                                <span className="text-[14px] font-black text-blue-600 block">{pendingUploadCount}</span>
                                <span className="text-[8px] text-slate-400 font-bold uppercase tracking-wide block leading-none mt-1">Pending</span>
                              </div>
                              <div className="bg-white p-2 rounded-xl border border-purple-100 shadow-sm">
                                <span className="text-[13px] font-black text-emerald-600 block">৳{totalRevenue}</span>
                                <span className="text-[8px] text-slate-400 font-bold uppercase tracking-wide block leading-none mt-1">Revenue</span>
                              </div>
                            </div>
                          </div>
                        )}

                        {/* C. MAIN SCROLLABLE CONTENT BODY */}
                        <div className="flex-1 overflow-y-auto p-4 space-y-4 pb-20">
                          
                          {/* TAB 1: ORDERS LIST (with Details Drilling) */}
                          {diagnosticTab === 'orders' && (
                            <>
                              {!selectedDiagnosticOrder ? (
                                <div className="space-y-3">
                                  <div className="flex justify-between items-center">
                                    <h3 className="font-extrabold text-xs text-slate-800 tracking-wide uppercase font-mono">
                                      {diagnosticBranch} Requests ({branchOrders.length})
                                    </h3>
                                    <span className="text-[9px] text-purple-600 bg-purple-50 px-2 py-0.5 rounded-full font-bold">
                                      Real-Time Sync
                                    </span>
                                  </div>

                                  {branchOrders.length === 0 ? (
                                    <div className="bg-white border border-slate-150 rounded-2xl p-8 text-center text-slate-400 shadow-sm">
                                      <FlaskConical className="h-8 w-8 mx-auto text-slate-200 mb-2" />
                                      <p className="text-xs font-semibold">No lab requests at {diagnosticBranch} today.</p>
                                      <p className="text-[10px] text-slate-400 mt-1">Try switching to Dhanmondi or Uttara branch.</p>
                                    </div>
                                  ) : (
                                    <div className="space-y-2.5">
                                      {branchOrders.map((order) => (
                                        <div 
                                          key={order.id}
                                          onClick={() => setSelectedDiagnosticOrder(order)}
                                          className="bg-white border border-slate-150 hover:border-purple-200 rounded-2xl p-3.5 shadow-sm hover:shadow transition-all cursor-pointer relative overflow-hidden"
                                        >
                                          {order.status === 'Pending' && (
                                            <div className="absolute right-0 top-0 bg-red-500 text-white text-[8px] font-bold px-2 py-0.5 rounded-bl-lg font-mono uppercase tracking-wider animate-pulse">
                                              NEW
                                            </div>
                                          )}

                                          <div className="flex justify-between items-start">
                                            <div>
                                              <span className="text-[9px] bg-slate-100 text-slate-500 font-bold px-1.5 py-0.5 rounded font-mono">
                                                {order.id}
                                              </span>
                                              <h4 className="font-extrabold text-xs text-slate-800 mt-1">{order.patientName}</h4>
                                              <p className="text-[10px] text-slate-400 font-medium mt-0.5">
                                                {order.age} Yrs • {order.sex}
                                              </p>
                                            </div>

                                            <span className={`text-[9px] font-bold px-2 py-0.5 rounded-full font-mono uppercase ${
                                              order.status === 'Pending' ? 'bg-red-50 text-red-600' :
                                              order.status === 'Sample Collected' ? 'bg-amber-50 text-amber-600' :
                                              order.status === 'Processing' ? 'bg-blue-50 text-blue-600' :
                                              order.status === 'Report Ready' ? 'bg-indigo-50 text-indigo-600' :
                                              'bg-emerald-50 text-emerald-600'
                                            }`}>
                                              {order.status}
                                            </span>
                                          </div>

                                          {/* Tests Bullet */}
                                          <div className="mt-2 bg-slate-50 p-2 rounded-xl border border-slate-100 flex flex-wrap gap-1">
                                            {order.tests.map((test: string, i: number) => (
                                              <span key={i} className="text-[9px] bg-white border border-slate-200 px-1.5 py-0.5 rounded text-slate-600 font-semibold">
                                                🔬 {test}
                                              </span>
                                            ))}
                                          </div>

                                          <div className="mt-2.5 pt-2.5 border-t border-slate-100 flex justify-between items-center text-[10px] text-slate-500">
                                            <span className="font-medium flex items-center gap-1">
                                              📍 {order.location}
                                            </span>
                                            <span className="font-extrabold text-slate-700">
                                              ৳{order.total} • <span className="text-purple-600 font-bold">{order.paymentType}</span>
                                            </span>
                                          </div>
                                        </div>
                                      ))}
                                    </div>
                                  )}
                                </div>
                              ) : (
                                /* ORDER DETAILS COMPONENT DRILL-DOWN */
                                <div className="space-y-4">
                                  {/* Back button */}
                                  <button 
                                    onClick={() => setSelectedDiagnosticOrder(null)}
                                    className="flex items-center gap-1 text-[10px] font-bold text-slate-500 hover:text-slate-800 bg-slate-100 hover:bg-slate-200 px-3 py-1.5 rounded-xl transition-all"
                                  >
                                    <ArrowLeft className="h-3.5 w-3.5" />
                                    <span>Back to Requests</span>
                                  </button>

                                  {/* Patient Core Card */}
                                  <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm relative overflow-hidden">
                                    <div className="absolute right-3 top-3 bg-purple-50 text-purple-600 font-mono text-[9px] font-black px-2 py-0.5 rounded-full border border-purple-100">
                                      {selectedDiagnosticOrder.id}
                                    </div>

                                    <h4 className="font-black text-sm text-slate-800">{selectedDiagnosticOrder.patientName}</h4>
                                    <p className="text-[10px] text-slate-400 font-bold mt-0.5 font-mono">
                                      {selectedDiagnosticOrder.sex} • {selectedDiagnosticOrder.age} Years Old • Phone: {selectedDiagnosticOrder.patientPhone}
                                    </p>

                                    {/* Allergy Info (Patient profile allergy simulation) */}
                                    <div className="mt-3 bg-red-50 border border-red-100 rounded-xl p-2.5 flex items-start gap-2 text-red-700">
                                      <Shield className="h-4 w-4 text-red-500 shrink-0 mt-0.5" />
                                      <div>
                                        <h5 className="font-extrabold text-[9px] uppercase tracking-wider font-mono">Allergy Warning Profile</h5>
                                        <p className="text-[10px] mt-0.5 leading-tight font-medium">Patient is sensitive to Sulfonamides & Dust Mites. Handle pathology needles with strict antiseptic protocol.</p>
                                      </div>
                                    </div>
                                  </div>

                                  {/* Stepper Status Indicators */}
                                  <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm space-y-3">
                                    <h5 className="font-extrabold text-[10px] text-slate-400 uppercase font-mono tracking-wider">Clinical Stepper</h5>
                                    
                                    {/* Simulated Stepper Dots & Labels */}
                                    <div className="grid grid-cols-5 gap-1 text-center relative pt-2">
                                      {/* Horizontal connecting line */}
                                      <div className="absolute left-[10%] right-[10%] top-[19px] h-0.5 bg-slate-100 z-0"></div>
                                      
                                      {['Pending', 'Sample Collected', 'Processing', 'Report Ready', 'Delivered'].map((step, idx) => {
                                        const statuses = ['Pending', 'Sample Collected', 'Processing', 'Report Ready', 'Delivered'];
                                        const currentIdx = statuses.indexOf(selectedDiagnosticOrder.status);
                                        const isDone = statuses.indexOf(step) <= currentIdx;
                                        const isCurrent = step === selectedDiagnosticOrder.status;

                                        return (
                                          <div key={idx} className="flex flex-col items-center z-10 relative">
                                            <div className={`h-6 w-6 rounded-full flex items-center justify-center border-2 text-[9px] font-black transition-all ${
                                              isCurrent ? 'bg-purple-600 border-purple-600 text-white scale-110 shadow-md shadow-purple-200' :
                                              isDone ? 'bg-emerald-500 border-emerald-500 text-white' :
                                              'bg-white border-slate-200 text-slate-400'
                                            }`}>
                                              {isDone ? '✓' : idx + 1}
                                            </div>
                                            <span className={`text-[8px] font-bold mt-1.5 leading-none block ${
                                              isCurrent ? 'text-purple-600 font-black' :
                                              isDone ? 'text-emerald-600' :
                                              'text-slate-400'
                                            }`}>
                                              {step.replace('Collected', 'Recv').replace('Processing', 'Lab')}
                                            </span>
                                          </div>
                                        );
                                      })}
                                    </div>
                                  </div>

                                  {/* Lab Specimen Details */}
                                  <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm space-y-3">
                                    <h5 className="font-extrabold text-[10px] text-slate-400 uppercase font-mono tracking-wider">Specimen Details</h5>
                                    
                                    <div className="space-y-2 text-xs">
                                      <div className="flex justify-between py-1.5 border-b border-slate-100">
                                        <span className="text-slate-400 font-medium">Collection Location:</span>
                                        <span className="font-bold text-slate-800">{selectedDiagnosticOrder.location}</span>
                                      </div>
                                      {selectedDiagnosticOrder.location === 'Home Collection' && (
                                        <div className="flex justify-between py-1.5 border-b border-slate-100">
                                          <span className="text-slate-400 font-medium text-[10px] shrink-0">Address:</span>
                                          <span className="font-bold text-slate-800 text-right text-[10.5px] max-w-[180px] leading-tight">
                                            {selectedDiagnosticOrder.address}
                                          </span>
                                        </div>
                                      )}
                                      <div className="flex justify-between py-1.5 border-b border-slate-100">
                                        <span className="text-slate-400 font-medium">Total Test Fees:</span>
                                        <span className="font-extrabold text-slate-800">৳{selectedDiagnosticOrder.testPrice}</span>
                                      </div>
                                      <div className="flex justify-between py-1.5 border-b border-slate-100">
                                        <span className="text-slate-400 font-medium">Home Surcharge:</span>
                                        <span className="font-bold text-slate-800">৳{selectedDiagnosticOrder.collectionFee}</span>
                                      </div>
                                      <div className="flex justify-between py-2 border-b border-slate-100 bg-slate-50 -mx-4 px-4 font-mono">
                                        <span className="text-purple-700 font-black uppercase tracking-wider text-[9px] mt-0.5">Grand Total ({selectedDiagnosticOrder.paymentType}):</span>
                                        <span className="font-black text-purple-700 text-sm">৳{selectedDiagnosticOrder.total}</span>
                                      </div>
                                      
                                      {/* Assigned Info */}
                                      {selectedDiagnosticOrder.scheduledTime && (
                                        <div className="bg-purple-50/50 p-2.5 rounded-xl border border-purple-100/40 text-[10.5px] space-y-1">
                                          <div className="flex justify-between font-medium">
                                            <span className="text-slate-500">Scheduled Time:</span>
                                            <span className="text-slate-700 font-bold">{selectedDiagnosticOrder.scheduledTime}</span>
                                          </div>
                                          <div className="flex justify-between font-medium">
                                            <span className="text-slate-500">Staff Assigned:</span>
                                            <span className="text-slate-700 font-bold">{selectedDiagnosticOrder.assignedStaff}</span>
                                          </div>
                                          {selectedDiagnosticOrder.sampleId && (
                                            <div className="flex justify-between font-medium pt-1 border-t border-purple-100/50">
                                              <span className="text-purple-600 font-bold">Sample Barcode ID:</span>
                                              <button 
                                                onClick={() => setShowSampleQRModal(selectedDiagnosticOrder)}
                                                className="text-purple-700 font-extrabold hover:underline flex items-center gap-0.5"
                                              >
                                                🔍 {selectedDiagnosticOrder.sampleId}
                                              </button>
                                            </div>
                                          )}
                                        </div>
                                      )}
                                    </div>
                                  </div>

                                  {/* DYNAMIC ACTION CONSOLE */}
                                  <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm space-y-2.5">
                                    <h5 className="font-extrabold text-[10px] text-slate-400 uppercase font-mono tracking-wider">Clinical Action Roster</h5>
                                    
                                    {/* Action button conditional layout */}
                                    {selectedDiagnosticOrder.status === 'Pending' && (
                                      selectedDiagnosticOrder.location === 'Home Collection' ? (
                                        <button 
                                          onClick={() => {
                                            setScheduleOrder(selectedDiagnosticOrder);
                                            setShowScheduleModal(true);
                                          }}
                                          className="w-full py-2.5 bg-purple-600 text-white rounded-xl text-xs font-bold hover:bg-purple-700 transition-all flex items-center justify-center gap-1.5 shadow-md shadow-purple-500/10"
                                        >
                                          📅 Schedule Phlebotomist Pickup
                                        </button>
                                      ) : (
                                        <button 
                                          onClick={() => {
                                            const randSampleId = `SMP-${Math.floor(1000 + Math.random() * 9000)}-L`;
                                            setDiagnosticOrders(prev => prev.map(o => o.id === selectedDiagnosticOrder.id ? {
                                              ...o,
                                              status: 'Sample Collected',
                                              scheduledTime: 'Today (Walk-In)',
                                              assignedStaff: 'In-Lab Desk (Amina Begum)',
                                              sampleId: randSampleId
                                            } : o));
                                            setSelectedDiagnosticOrder(prev => ({
                                              ...prev,
                                              status: 'Sample Collected',
                                              scheduledTime: 'Today (Walk-In)',
                                              assignedStaff: 'In-Lab Desk (Amina Begum)',
                                              sampleId: randSampleId
                                            }));
                                            triggerNotification('Sample Registered', `Sample ID ${randSampleId} logged for walk-in patient.`);
                                          }}
                                          className="w-full py-2.5 bg-emerald-600 text-white rounded-xl text-xs font-bold hover:bg-emerald-700 transition-all flex items-center justify-center gap-1.5"
                                        >
                                          🧪 Register Walk-In Sample & Generate Barcode
                                        </button>
                                      )
                                    )}

                                    {selectedDiagnosticOrder.status === 'Sample Collected' && (
                                      <button 
                                        onClick={() => handleAdvanceStatus(selectedDiagnosticOrder.id)}
                                        className="w-full py-2.5 bg-blue-600 text-white rounded-xl text-xs font-bold hover:bg-blue-700 transition-all flex items-center justify-center gap-1.5 shadow-md shadow-blue-500/10"
                                      >
                                        🔬 Begin Lab Analyzer Processing
                                      </button>
                                    )}

                                    {selectedDiagnosticOrder.status === 'Processing' && (
                                      <button 
                                        onClick={() => {
                                          setReportOrder(selectedDiagnosticOrder);
                                          setShowReportUploadModal(true);
                                        }}
                                        className="w-full py-2.5 bg-indigo-600 text-white rounded-xl text-xs font-bold hover:bg-indigo-700 transition-all flex items-center justify-center gap-1.5 shadow-md shadow-indigo-500/10"
                                      >
                                        📝 Upload Pathology Report & Sign Certificate
                                      </button>
                                    )}

                                    {selectedDiagnosticOrder.status === 'Report Ready' && (
                                      <div className="space-y-2">
                                        <button 
                                          onClick={() => handleAdvanceStatus(selectedDiagnosticOrder.id)}
                                          className="w-full py-2.5 bg-emerald-600 text-white rounded-xl text-xs font-bold hover:bg-emerald-700 transition-all flex items-center justify-center gap-1.5"
                                        >
                                          📦 Mark Report Handed over & Dispatched
                                        </button>
                                        <button 
                                          onClick={() => {
                                            setShowReportDetailModal(selectedDiagnosticOrder);
                                          }}
                                          className="w-full py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-1.5"
                                        >
                                          📄 View Generated PDF Report
                                        </button>
                                      </div>
                                    )}

                                    {selectedDiagnosticOrder.status === 'Delivered' && (
                                      <div className="bg-emerald-50 border border-emerald-100 rounded-xl p-3 text-center text-emerald-800 text-xs font-bold">
                                        🎉 Clinical flow closed. PDF dispatched and archived on health feed.
                                      </div>
                                    )}

                                    {/* Message Patient (Chat Feature) */}
                                    <button 
                                      onClick={() => {
                                        triggerNotification('Clinical Chat', `Channel established with ${selectedDiagnosticOrder.patientName}.`);
                                        alert(`Clinical secure message portal launched with ${selectedDiagnosticOrder.patientName}.\nPatient Phone: ${selectedDiagnosticOrder.patientPhone}`);
                                      }}
                                      className="w-full py-2 text-purple-600 hover:bg-purple-50 text-xs font-extrabold rounded-xl border border-purple-200 transition-all flex items-center justify-center gap-1"
                                    >
                                      <MessageSquare className="h-3.5 w-3.5" />
                                      <span>Secure Message Patient</span>
                                    </button>
                                  </div>
                                </div>
                              )}
                            </>
                          )}

                          {/* TAB 2: SCHEDULE LIST */}
                          {diagnosticTab === 'schedule' && (
                            <div className="space-y-3">
                              <h3 className="font-extrabold text-xs text-slate-800 uppercase font-mono tracking-wider">
                                Phlebotomy Schedule ({branchOrders.filter(o => o.scheduledTime).length})
                              </h3>
                              
                              {branchOrders.filter(o => o.scheduledTime).length === 0 ? (
                                <div className="bg-white border border-slate-150 rounded-2xl p-8 text-center text-slate-400">
                                  <Calendar className="h-8 w-8 mx-auto text-slate-200 mb-2" />
                                  <p className="text-xs font-semibold">No scheduled collections on our roster.</p>
                                </div>
                              ) : (
                                <div className="space-y-2.5">
                                  {branchOrders.filter(o => o.scheduledTime).map((order) => (
                                    <div key={order.id} className="bg-white border border-slate-150 rounded-2xl p-3.5 shadow-sm space-y-3">
                                      <div className="flex justify-between items-start">
                                        <div>
                                          <h4 className="font-extrabold text-xs text-slate-800">{order.patientName}</h4>
                                          <p className="text-[9px] font-mono text-purple-600 font-bold mt-0.5">{order.id} • {order.location}</p>
                                        </div>
                                        <span className="text-[10px] bg-purple-50 border border-purple-100 text-purple-700 font-bold px-2 py-0.5 rounded-full font-mono">
                                          ⏰ {order.scheduledTime.split(' ')[1] || order.scheduledTime}
                                        </span>
                                      </div>

                                      <div className="text-[10.5px] text-slate-500 bg-slate-50 p-2.5 rounded-xl border border-slate-100 space-y-1">
                                        <div><strong>Staff:</strong> {order.assignedStaff}</div>
                                        {order.sampleId && <div><strong>Sample ID:</strong> {order.sampleId}</div>}
                                        <div className="truncate"><strong>Address:</strong> {order.address}</div>
                                      </div>

                                      <div className="flex justify-between gap-2 pt-1">
                                        {order.sampleId && (
                                          <button 
                                            onClick={() => setShowSampleQRModal(order)}
                                            className="px-3 py-1.5 bg-slate-100 hover:bg-slate-200 rounded-xl text-[10px] font-bold text-slate-700 transition-all flex items-center gap-1"
                                          >
                                            <Eye className="h-3.5 w-3.5" />
                                            <span>Scan Specimen QR</span>
                                          </button>
                                        )}
                                        {order.status === 'Sample Collected' && (
                                          <button 
                                            onClick={() => handleAdvanceStatus(order.id)}
                                            className="px-3 py-1.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-[10px] font-bold transition-all ml-auto"
                                          >
                                            🔬 Analyzer Processing
                                          </button>
                                        )}
                                      </div>
                                    </div>
                                  ))}
                                </div>
                              )}
                            </div>
                          )}

                          {/* TAB 3: REPORTS ARCHIVE */}
                          {diagnosticTab === 'reports' && (
                            <div className="space-y-3">
                              <h3 className="font-extrabold text-xs text-slate-800 uppercase font-mono tracking-wider">
                                Diagnostic Reports Archive ({branchOrders.filter(o => o.status === 'Report Ready' || o.status === 'Delivered').length})
                              </h3>

                              {branchOrders.filter(o => o.status === 'Report Ready' || o.status === 'Delivered').length === 0 ? (
                                <div className="bg-white border border-slate-150 rounded-2xl p-8 text-center text-slate-400">
                                  <FileText className="h-8 w-8 mx-auto text-slate-200 mb-2" />
                                  <p className="text-xs font-semibold">No pathology certificates issued yet today.</p>
                                </div>
                              ) : (
                                <div className="space-y-2.5">
                                  {branchOrders.filter(o => o.status === 'Report Ready' || o.status === 'Delivered').map((order) => (
                                    <div key={order.id} className="bg-white border border-slate-150 rounded-2xl p-3.5 shadow-sm flex justify-between items-center hover:border-purple-200 transition-all">
                                      <div>
                                        <h4 className="font-extrabold text-xs text-slate-800">{order.patientName}</h4>
                                        <p className="text-[9px] text-slate-400 font-bold mt-0.5">{order.tests.join(', ')}</p>
                                        <div className="flex items-center gap-1.5 mt-1">
                                          <span className="text-[8px] font-bold font-mono text-emerald-600 bg-emerald-50 px-1 rounded">
                                            ✓ Signed PDF
                                          </span>
                                          <span className="text-[8px] text-slate-400 font-medium">Verified by: {order.verifiedBy?.split(',')[0]}</span>
                                        </div>
                                      </div>

                                      <button 
                                        onClick={() => setShowReportDetailModal(order)}
                                        className="p-2 bg-purple-50 hover:bg-purple-100 text-purple-700 rounded-xl transition-all"
                                        title="View Certificate"
                                      >
                                        <FileText className="h-4 w-4" />
                                      </button>
                                    </div>
                                  ))}
                                </div>
                              )}
                            </div>
                          )}

                          {/* TAB 4: CLINICAL ACCOUNT & ADMIN APPROVAL */}
                          {diagnosticTab === 'account' && (
                            <div className="space-y-4">
                              {/* Lab License Verification */}
                              <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm text-center">
                                <div className="h-14 w-14 bg-purple-50 rounded-full flex items-center justify-center text-purple-600 mx-auto mb-3 border border-purple-100">
                                  <Hospital className="h-7 w-7" />
                                </div>
                                <h4 className="font-extrabold text-sm text-slate-800">Popular Labs & Diagnostics</h4>
                                <p className="text-[9px] text-slate-400 font-bold font-mono uppercase tracking-widest mt-0.5">Franchise Key: #PLD-392</p>

                                {/* License verified badge */}
                                <div className="mt-3 bg-emerald-50 border border-emerald-100 text-emerald-700 rounded-xl p-2.5 flex items-center justify-center gap-1.5 text-xs font-semibold mx-auto max-w-xs">
                                  <ShieldCheck className="h-4 w-4 text-emerald-600" />
                                  <span>Super Admin Approved & DGHS Active</span>
                                </div>
                              </div>

                              {/* Interactive Simulator Tools */}
                              <div className="bg-white border border-slate-150 rounded-2xl p-4 shadow-sm space-y-3">
                                <h5 className="font-extrabold text-[10px] text-slate-400 uppercase font-mono tracking-wider">Lab Testing Utilities</h5>
                                
                                <button 
                                  onClick={() => setShowPatientResultsMock(true)}
                                  className="w-full py-2.5 bg-slate-900 text-white rounded-xl text-xs font-bold hover:bg-slate-800 transition-all flex items-center justify-center gap-1.5"
                                >
                                  🧪 Open Patient-Facing "My Lab Results" Panel
                                </button>
                                
                                <button 
                                  onClick={() => {
                                    setDiagnosticOrders(prev => prev.map(o => ({ ...o, status: 'Pending', scheduledTime: undefined, assignedStaff: undefined, sampleId: undefined })));
                                    setSelectedDiagnosticOrder(null);
                                    triggerNotification('Simulator Reset', 'Reset all laboratory samples back to "Pending" order flow.');
                                  }}
                                  className="w-full py-2 text-red-600 hover:bg-red-50 text-xs font-extrabold rounded-xl border border-red-200 transition-all"
                                >
                                  🔄 Reset Simulator Data
                                </button>
                              </div>

                              {/* Technical Details panel */}
                              <div className="bg-slate-100 border border-slate-200 rounded-2xl p-4 text-[10.5px] text-slate-600 space-y-1.5 leading-relaxed">
                                <h6 className="font-extrabold text-[9px] text-slate-500 uppercase font-mono tracking-wider">Clinical Compliance Node</h6>
                                <p>This laboratory panel operates on automated specimen logging protocols. Barcode labels are verified using standards conforming to clinical lab automation networks.</p>
                                <div className="pt-2 border-t border-slate-200 flex justify-between font-mono text-[9px] text-slate-400">
                                  <span>DRAFT DART: diagnostic_home.dart</span>
                                  <span>ISO 9001 STATUS: OK</span>
                                </div>
                              </div>
                            </div>
                          )}

                        </div>

                        {/* D. LOWER PERSISTENT BOTTOM TAB CONTROLLER */}
                        <div className="absolute inset-x-0 bottom-0 h-16 bg-white border-t border-slate-250 px-5 flex justify-between items-center z-15 shadow-[0_-4px_10px_rgba(0,0,0,0.02)] shrink-0">
                          <button
                            onClick={() => { setDiagnosticTab('orders'); setSelectedDiagnosticOrder(null); }}
                            className={`flex flex-col items-center gap-1 text-[9px] font-bold ${diagnosticTab === 'orders' ? 'text-purple-700 font-black scale-105' : 'text-slate-400 hover:text-slate-600'}`}
                          >
                            <FlaskConical className="h-4.5 w-4.5" />
                            <span>Orders</span>
                          </button>

                          <button
                            onClick={() => { setDiagnosticTab('schedule'); }}
                            className={`flex flex-col items-center gap-1 text-[9px] font-bold ${diagnosticTab === 'schedule' ? 'text-purple-700 font-black scale-105' : 'text-slate-400 hover:text-slate-600'}`}
                          >
                            <Calendar className="h-4.5 w-4.5" />
                            <span>Schedule</span>
                          </button>

                          <button
                            onClick={() => { setDiagnosticTab('reports'); }}
                            className={`flex flex-col items-center gap-1 text-[9px] font-bold ${diagnosticTab === 'reports' ? 'text-purple-700 font-black scale-105' : 'text-slate-400 hover:text-slate-600'}`}
                          >
                            <FileText className="h-4.5 w-4.5" />
                            <span>Reports</span>
                          </button>

                          <button
                            onClick={() => { setDiagnosticTab('account'); }}
                            className={`flex flex-col items-center gap-1 text-[9px] font-bold ${diagnosticTab === 'account' ? 'text-purple-700 font-black scale-105' : 'text-slate-400 hover:text-slate-600'}`}
                          >
                            <User className="h-4.5 w-4.5" />
                            <span>Account</span>
                          </button>
                        </div>

                        {/* ======================= DIALOGS / OVERLAYS ======================= */}
                        
                        {/* 1. SCHEDULE COLLECTION DIALOG */}
                        <AnimatePresence>
                          {showScheduleModal && scheduleOrder && (
                            <div className="absolute inset-0 bg-slate-900/60 flex items-center justify-center p-4 z-50">
                              <motion.div 
                                initial={{ opacity: 0, scale: 0.95 }}
                                animate={{ opacity: 1, scale: 1 }}
                                exit={{ opacity: 0, scale: 0.95 }}
                                className="bg-white rounded-3xl p-5 w-full max-w-sm shadow-xl space-y-4"
                              >
                                <div className="flex justify-between items-center">
                                  <h4 className="font-black text-sm text-slate-800">Schedule Sample Collection</h4>
                                  <button onClick={() => { setShowScheduleModal(false); setScheduleOrder(null); }} className="text-slate-400 hover:text-slate-600">
                                    <X className="h-4 w-4" />
                                  </button>
                                </div>

                                <div className="space-y-3 text-xs">
                                  <div className="bg-slate-50 p-3 rounded-xl border border-slate-100">
                                    <div className="font-bold text-slate-700">{scheduleOrder.patientName}</div>
                                    <div className="text-[10px] text-slate-400 truncate mt-0.5">{scheduleOrder.address}</div>
                                  </div>

                                  <div className="space-y-1">
                                    <label className="text-[9px] font-black text-slate-400 uppercase font-mono block">Collection Date</label>
                                    <input 
                                      type="date" 
                                      value={scheduleDate}
                                      onChange={(e) => setScheduleDate(e.target.value)}
                                      className="w-full bg-slate-50 border border-slate-200 rounded-xl p-2 font-medium"
                                    />
                                  </div>

                                  <div className="space-y-1">
                                    <label className="text-[9px] font-black text-slate-400 uppercase font-mono block">Preferred Slot</label>
                                    <select 
                                      value={scheduleTime}
                                      onChange={(e) => setScheduleTime(e.target.value)}
                                      className="w-full bg-slate-50 border border-slate-200 rounded-xl p-2 font-medium"
                                    >
                                      <option value="08:30">08:30 AM - Early Morning Fasting</option>
                                      <option value="10:00">10:00 AM - Morning Block</option>
                                      <option value="12:30">12:30 PM - Afternoon Block</option>
                                      <option value="16:00">04:00 PM - Evening Block</option>
                                    </select>
                                  </div>

                                  <div className="space-y-1">
                                    <label className="text-[9px] font-black text-slate-400 uppercase font-mono block">Assign Phlebotomist Staff</label>
                                    <select 
                                      value={assignedStaff}
                                      onChange={(e) => setAssignedStaff(e.target.value)}
                                      className="w-full bg-slate-50 border border-slate-200 rounded-xl p-2 font-medium"
                                    >
                                      <option value="Ripon Sarker (Senior Phlebotomist)">Ripon Sarker (Senior Phlebotomist)</option>
                                      <option value="Sumon Ahmed (Phlebotomist)">Sumon Ahmed (Phlebotomist)</option>
                                      <option value="Taslima Khatun (Field Associate)">Taslima Khatun (Field Associate)</option>
                                    </select>
                                  </div>
                                </div>

                                <button 
                                  onClick={() => {
                                    const mockSampleId = `SMP-${Math.floor(1000 + Math.random() * 9000)}-H`;
                                    setDiagnosticOrders(prev => prev.map(o => o.id === scheduleOrder.id ? {
                                      ...o,
                                      status: 'Sample Collected',
                                      scheduledTime: `${scheduleDate} ${scheduleTime}`,
                                      assignedStaff: assignedStaff,
                                      sampleId: mockSampleId
                                    } : o));
                                    
                                    // Also update selectedDetail
                                    if (selectedDiagnosticOrder && selectedDiagnosticOrder.id === scheduleOrder.id) {
                                      setSelectedDiagnosticOrder(prev => ({
                                        ...prev,
                                        status: 'Sample Collected',
                                        scheduledTime: `${scheduleDate} ${scheduleTime}`,
                                        assignedStaff: assignedStaff,
                                        sampleId: mockSampleId
                                      }));
                                    }

                                    triggerNotification('Pickup Scheduled', `Assigned ${assignedStaff} for collection at ${scheduleTime}. Barcode: ${mockSampleId}`);
                                    setShowScheduleModal(false);
                                    setScheduleOrder(null);
                                  }}
                                  className="w-full py-2.5 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-xs font-bold transition-all"
                                >
                                  Confirm Schedule & Generate QR/Barcode
                                </button>
                              </motion.div>
                            </div>
                          )}
                        </AnimatePresence>

                        {/* 2. SPECIMEN QR CODE VIEW DIALOG */}
                        <AnimatePresence>
                          {showSampleQRModal && (
                            <div className="absolute inset-0 bg-slate-900/60 flex items-center justify-center p-4 z-50">
                              <motion.div 
                                initial={{ opacity: 0, scale: 0.95 }}
                                animate={{ opacity: 1, scale: 1 }}
                                exit={{ opacity: 0, scale: 0.95 }}
                                className="bg-white rounded-3xl p-5 w-full max-w-xs shadow-xl text-center space-y-4"
                              >
                                <div className="flex justify-between items-center text-left">
                                  <h4 className="font-black text-xs text-slate-800 font-mono">LAB SAMPLE SPECIMEN</h4>
                                  <button onClick={() => setShowSampleQRModal(null)} className="text-slate-400 hover:text-slate-600">
                                    <X className="h-4 w-4" />
                                  </button>
                                </div>

                                <div className="bg-slate-50 border border-slate-100 rounded-2xl p-4 flex flex-col items-center justify-center">
                                  {/* Mock Barcode Block */}
                                  <div className="h-16 w-full flex items-center justify-around gap-1 px-4 mb-2 bg-white border border-slate-200/60 rounded">
                                    {[2, 4, 1, 3, 5, 2, 4, 1, 6, 2, 3, 5, 2, 1, 4, 3, 2, 5].map((h, i) => (
                                      <div key={i} className="bg-slate-800" style={{ height: '40px', width: `${h}px` }}></div>
                                    ))}
                                  </div>
                                  <strong className="text-xs font-mono tracking-widest text-slate-800">{showSampleQRModal.sampleId}</strong>
                                </div>

                                <div className="text-left text-[10px] text-slate-500 bg-purple-50/50 p-2.5 rounded-xl space-y-1">
                                  <div><strong>Patient Name:</strong> {showSampleQRModal.patientName}</div>
                                  <div><strong>Required Tests:</strong> {showSampleQRModal.tests.join(', ')}</div>
                                  <div><strong>Roster Agent:</strong> {showSampleQRModal.assignedStaff}</div>
                                </div>

                                <button 
                                  onClick={() => setShowSampleQRModal(null)}
                                  className="w-full py-2 bg-slate-900 text-white rounded-xl text-xs font-bold hover:bg-slate-800 transition-all"
                                >
                                  Done Scanning Specimen
                                </button>
                              </motion.div>
                            </div>
                          )}
                        </AnimatePresence>

                        {/* 3. REPORT UPLOAD / SIGNATURE DIALOG */}
                        <AnimatePresence>
                          {showReportUploadModal && reportOrder && (
                            <div className="absolute inset-0 bg-slate-900/60 flex items-center justify-center p-4 z-50">
                              <motion.div 
                                initial={{ opacity: 0, scale: 0.95 }}
                                animate={{ opacity: 1, scale: 1 }}
                                exit={{ opacity: 0, scale: 0.95 }}
                                className="bg-white rounded-3xl p-5 w-full max-w-sm shadow-xl space-y-4"
                              >
                                <div className="flex justify-between items-center">
                                  <h4 className="font-black text-sm text-slate-800">Pathology Report Certificate</h4>
                                  <button onClick={() => { setShowReportUploadModal(false); setReportOrder(null); }} className="text-slate-400 hover:text-slate-600">
                                    <X className="h-4 w-4" />
                                  </button>
                                </div>

                                <div className="space-y-3.5 text-xs">
                                  <div className="bg-purple-50/30 p-3 rounded-xl border border-purple-100/40 text-[10.5px]">
                                    <div><strong>Patient:</strong> {reportOrder.patientName} ({reportOrder.sex}, {reportOrder.age})</div>
                                    <div className="mt-0.5"><strong>Prescribed Tests:</strong> {reportOrder.tests.join(', ')}</div>
                                  </div>

                                  {/* Mock File Picker */}
                                  <div className="bg-slate-50 border-2 border-dashed border-slate-200 hover:border-purple-300 rounded-2xl p-4 text-center cursor-pointer transition-colors">
                                    <Upload className="h-5 w-5 text-slate-400 mx-auto mb-1.5" />
                                    <span className="text-[10px] font-bold text-slate-700 block">Select PDF Report / Laboratory Image</span>
                                    <span className="text-[9px] text-slate-400 font-medium">Automatic OCR scans values</span>
                                  </div>

                                  <div className="space-y-1">
                                    <label className="text-[9px] font-black text-slate-400 uppercase font-mono block">Pathology Findings Summary</label>
                                    <textarea 
                                      value={reportFindings}
                                      onChange={(e) => setReportFindings(e.target.value)}
                                      rows={2}
                                      placeholder="Insert clinical feedback..."
                                      className="w-full bg-slate-50 border border-slate-200 rounded-xl p-2.5 font-medium text-slate-700 focus:outline-none focus:border-purple-500"
                                    />
                                  </div>

                                  <div className="space-y-1">
                                    <label className="text-[9px] font-black text-slate-400 uppercase font-mono block">Signing Specialist / Pathologist</label>
                                    <input 
                                      type="text" 
                                      value={reportPathologist}
                                      onChange={(e) => setReportPathologist(e.target.value)}
                                      className="w-full bg-slate-50 border border-slate-200 rounded-xl p-2 font-medium text-slate-700"
                                    />
                                  </div>

                                  {/* Signature Toggle */}
                                  <div className="flex justify-between items-center py-1">
                                    <div>
                                      <span className="text-[10px] font-bold text-slate-700 block">Apply Encrypted Digital Signature</span>
                                      <span className="text-[8px] text-slate-400 block">Enables automated BMDC clinical seal</span>
                                    </div>
                                    <input 
                                      type="checkbox" 
                                      checked={isDigitallySigned}
                                      onChange={(e) => setIsDigitallySigned(e.target.checked)}
                                      className="h-4 w-4 accent-purple-600 rounded"
                                    />
                                  </div>
                                </div>

                                <button 
                                  onClick={() => {
                                    const randPdfFile = `${reportOrder.tests[0].replace(/\s+/g, '_').substring(0, 8)}_REPORT_${reportOrder.id}.pdf`;
                                    setDiagnosticOrders(prev => prev.map(o => o.id === reportOrder.id ? {
                                      ...o,
                                      status: 'Report Ready',
                                      reportFile: randPdfFile,
                                      findings: reportFindings,
                                      verifiedBy: reportPathologist
                                    } : o));

                                    // Also update selectedDetail
                                    if (selectedDiagnosticOrder && selectedDiagnosticOrder.id === reportOrder.id) {
                                      setSelectedDiagnosticOrder(prev => ({
                                        ...prev,
                                        status: 'Report Ready',
                                        reportFile: randPdfFile,
                                        findings: reportFindings,
                                        verifiedBy: reportPathologist
                                      }));
                                    }

                                    triggerNotification('Report Generated', `PDF Medical Certificate digitally signed and issued to ${reportOrder.patientName}.`);
                                    setShowReportUploadModal(false);
                                    setReportOrder(null);
                                  }}
                                  className="w-full py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-bold transition-all shadow-md shadow-indigo-500/10"
                                >
                                  🔐 Apply Signature & Disseminate Report
                                </button>
                              </motion.div>
                            </div>
                          )}
                        </AnimatePresence>

                        {/* 4. CLINICAL MEDICAL CERTIFICATE VIEW (PDF PREVIEW DIALOG) */}
                        <AnimatePresence>
                          {showReportDetailModal && (
                            <div className="absolute inset-0 bg-slate-900/60 flex items-center justify-center p-4 z-50">
                              <motion.div 
                                initial={{ opacity: 0, scale: 0.95 }}
                                animate={{ opacity: 1, scale: 1 }}
                                exit={{ opacity: 0, scale: 0.95 }}
                                className="bg-white rounded-3xl p-5 w-full max-w-sm shadow-xl space-y-4 max-h-[90%] overflow-y-auto"
                              >
                                <div className="flex justify-between items-center border-b border-slate-100 pb-2">
                                  <span className="text-[10px] font-mono font-bold text-slate-400">PDF REPORT CERTIFICATE PREVIEW</span>
                                  <button onClick={() => setShowReportDetailModal(null)} className="text-slate-400 hover:text-slate-600">
                                    <X className="h-4 w-4" />
                                  </button>
                                </div>

                                {/* Hospital Letterhead */}
                                <div className="border border-slate-200 rounded-2xl p-4 bg-white space-y-4 text-left shadow-inner">
                                  <div className="text-center pb-2 border-b-2 border-purple-800">
                                    <h5 className="font-extrabold text-[12px] text-purple-950 font-display">POPULAR CLINICAL PATHOLOGY</h5>
                                    <p className="text-[8px] text-slate-400 font-mono uppercase tracking-widest mt-0.5">Dhanmondi • Dhaka, Bangladesh</p>
                                  </div>

                                  <div className="grid grid-cols-2 gap-2 text-[8.5px] text-slate-500 pb-2 border-b border-slate-100 font-mono">
                                    <div>
                                      <strong>PATIENT:</strong> {showReportDetailModal.patientName}<br />
                                      <strong>AGE/SEX:</strong> {showReportDetailModal.age} Yrs / {showReportDetailModal.sex}<br />
                                      <strong>CONTACT:</strong> {showReportDetailModal.patientPhone}
                                    </div>
                                    <div className="text-right">
                                      <strong>REPORT ID:</strong> {showReportDetailModal.id}<br />
                                      <strong>DATE:</strong> {showReportDetailModal.dateString}<br />
                                      <strong>SAMPLE:</strong> {showReportDetailModal.sampleId || 'SMP-2938-A'}
                                    </div>
                                  </div>

                                  {/* Test Results Table */}
                                  <div className="space-y-1">
                                    <strong className="text-[9px] font-black font-mono text-slate-400 block uppercase">Diagnosed Panels & Outcomes:</strong>
                                    <table className="w-full text-left text-[9px] font-mono">
                                      <thead>
                                        <tr className="border-b border-slate-100 text-slate-400 bg-slate-50 font-bold">
                                          <th className="py-1 px-1.5">INVESTIGATION PANEL</th>
                                          <th className="py-1 px-1.5">OBSERVED COUNT</th>
                                          <th className="py-1 px-1.5">BIOLOGICAL VALUE</th>
                                        </tr>
                                      </thead>
                                      <tbody>
                                        {showReportDetailModal.tests.map((test: string, i: number) => (
                                          <tr key={i} className="border-b border-slate-50 text-slate-700">
                                            <td className="py-1.5 px-1.5 font-bold">{test}</td>
                                            <td className="py-1.5 px-1.5 text-purple-700 font-bold">NORMAL (98.4%)</td>
                                            <td className="py-1.5 px-1.5 text-slate-400">Ref: Clinical Range</td>
                                          </tr>
                                        ))}
                                      </tbody>
                                    </table>
                                  </div>

                                  {/* Pathologists comments */}
                                  <div className="bg-slate-50 p-2.5 rounded-xl border border-slate-100 text-[9px] text-slate-600 leading-tight space-y-1 font-mono">
                                    <strong>CLINICAL PATHOLOGIST FINDINGS:</strong>
                                    <p className="font-bold text-slate-800">{showReportDetailModal.findings || 'No physiological anomalies detected during active sample diagnostics.'}</p>
                                  </div>

                                  {/* Digital Signature seal */}
                                  <div className="pt-2 flex justify-between items-center text-[8.5px] border-t border-dashed border-slate-100 font-mono">
                                    <div>
                                      <span className="text-emerald-600 font-extrabold flex items-center gap-0.5">
                                        <ShieldCheck className="h-3 w-3 text-emerald-500" />
                                        <span>DIGITALLY SIGNED</span>
                                      </span>
                                      <p className="text-[8px] text-slate-400 mt-0.5 font-bold">{showReportDetailModal.verifiedBy || 'Prof. Dr. Rafiqul Alam, MD (Pathology)'}</p>
                                    </div>
                                    <div className="text-center h-8 w-8 bg-slate-50 border border-slate-150 rounded flex items-center justify-center text-[10px]" title="Clinical Stamp Seal">
                                      🔬
                                    </div>
                                  </div>
                                </div>

                                <button 
                                  onClick={() => setShowReportDetailModal(null)}
                                  className="w-full py-2 bg-purple-700 text-white rounded-xl text-xs font-bold hover:bg-purple-800 transition-all"
                                >
                                  Close Preview & Archive Report
                                </button>
                              </motion.div>
                            </div>
                          )}
                        </AnimatePresence>

                        {/* 5. PATIENT-FACING "MY LAB RESULTS" SIMULATION OVERLAY */}
                        <AnimatePresence>
                          {showPatientResultsMock && (
                            <div className="absolute inset-0 bg-slate-900/65 flex items-end justify-center z-50">
                              <motion.div 
                                initial={{ y: '100%' }}
                                animate={{ y: 0 }}
                                exit={{ y: '100%' }}
                                transition={{ type: 'spring', damping: 25, stiffness: 220 }}
                                className="bg-white rounded-t-[32px] p-5 w-full h-[85%] shadow-2xl space-y-4 flex flex-col overflow-hidden"
                              >
                                <div className="flex justify-between items-center border-b border-slate-100 pb-3 shrink-0">
                                  <div>
                                    <span className="text-[9px] bg-slate-900 text-slate-200 font-black px-2 py-0.5 rounded-full font-mono">PATIENT APP SIMULATOR</span>
                                    <h4 className="font-extrabold text-sm text-slate-800 mt-1">My Lab Diagnostic Results</h4>
                                  </div>
                                  <button onClick={() => setShowPatientResultsMock(false)} className="bg-slate-100 p-1.5 rounded-full hover:bg-slate-200 text-slate-500">
                                    <X className="h-4 w-4" />
                                  </button>
                                </div>

                                <div className="flex-1 overflow-y-auto space-y-3.5 pr-1 py-1">
                                  <p className="text-[10px] text-slate-400 leading-tight">This view mimics the Hello Doctor patient application, allowing verified patients to track, trace, and download diagnostic certificates issued directly by your center.</p>

                                  {diagnosticOrders.map((order) => (
                                    <div key={order.id} className="bg-slate-50 border border-slate-150 rounded-2xl p-3.5 shadow-sm space-y-3">
                                      <div className="flex justify-between items-start">
                                        <div>
                                          <h5 className="font-extrabold text-xs text-slate-800">{order.tests.join(' + ')}</h5>
                                          <p className="text-[9px] text-purple-600 font-bold mt-0.5">{order.branch} • {order.dateString}</p>
                                        </div>
                                        <span className={`text-[8.5px] font-extrabold px-2 py-0.5 rounded-full font-mono uppercase ${
                                          order.status === 'Pending' ? 'bg-amber-100 text-amber-700' :
                                          order.status === 'Sample Collected' ? 'bg-purple-100 text-purple-700' :
                                          order.status === 'Processing' ? 'bg-blue-100 text-blue-700' :
                                          'bg-emerald-100 text-emerald-800'
                                        }`}>
                                          {order.status === 'Delivered' ? 'Delivered' : order.status}
                                        </span>
                                      </div>

                                      {/* Tracing Steps bar */}
                                      <div className="flex items-center gap-1">
                                        <div className="h-1.5 flex-1 bg-emerald-500 rounded-full"></div>
                                        <div className={`h-1.5 flex-1 rounded-full ${order.status !== 'Pending' ? 'bg-emerald-500' : 'bg-slate-200'}`}></div>
                                        <div className={`h-1.5 flex-1 rounded-full ${['Processing', 'Report Ready', 'Delivered'].includes(order.status) ? 'bg-emerald-500' : 'bg-slate-200'}`}></div>
                                        <div className={`h-1.5 flex-1 rounded-full ${['Report Ready', 'Delivered'].includes(order.status) ? 'bg-emerald-500' : 'bg-slate-200'}`}></div>
                                      </div>

                                      {/* Download button if report is ready */}
                                      {['Report Ready', 'Delivered'].includes(order.status) ? (
                                        <button 
                                          onClick={() => {
                                            setShowReportDetailModal(order);
                                          }}
                                          className="w-full py-2 bg-slate-900 hover:bg-slate-800 text-white rounded-xl text-[10px] font-bold transition-all flex items-center justify-center gap-1"
                                        >
                                          <Download className="h-3.5 w-3.5" />
                                          <span>Download signed PDF Pathology Report</span>
                                        </button>
                                      ) : (
                                        <div className="text-[9.5px] text-slate-400 bg-white p-2 rounded-xl border border-slate-150 font-medium text-center">
                                          🔬 Analyzer processing specimen. Notification triggers upon digital signature.
                                        </div>
                                      )}
                                    </div>
                                  ))}
                                </div>
                              </motion.div>
                            </div>
                          )}
                        </AnimatePresence>

                      </motion.div>
                    );
                  })()}

                </AnimatePresence>
              </div>

              {/* Bottom Navigation Simulated Bar */}
              <div className="h-14 bg-white border-t border-slate-100 px-6 flex items-center justify-around text-[10px] font-medium text-slate-400 shrink-0">
                <button 
                  onClick={() => {
                    setFlutterScreen('role_selection');
                    triggerNotification('Portals Hub', 'Returned to role selection overview.');
                  }}
                  className={`flex flex-col items-center gap-1 ${flutterScreen === 'role_selection' ? 'text-blue-600' : 'hover:text-slate-600'}`}
                >
                  <Hospital className="h-5 w-5" />
                  <span>Roles Hub</span>
                </button>
                <div className="h-1.5 w-1.5 rounded-full bg-slate-200"></div>
                <button 
                  onClick={() => {
                    setFlutterScreen('splash');
                    triggerNotification('Simulating Restart', 'Re-triggering Splash Screen loading state...');
                  }}
                  className="flex flex-col items-center gap-1 hover:text-slate-600 text-slate-400"
                >
                  <RefreshCw className="h-5 w-5" />
                  <span>Re-Splash</span>
                </button>
              </div>

            </div>
          </div>
        </section>

        {/* RIGHT COLUMN: Code Explorer & Flutter Directory Tree */}
        <section className={`lg:col-span-7 flex flex-col bg-slate-950/40 rounded-2xl border border-slate-800/80 overflow-hidden ${activeTab === 'explorer' ? 'block' : 'hidden lg:block'}`}>
          <div className="flex items-center justify-between px-5 py-4 bg-slate-950/80 border-b border-slate-800/80">
            <div className="flex items-center gap-2">
              <Laptop className="h-4 w-4 text-blue-400" />
              <span className="text-xs font-semibold text-slate-300">FLUTTER PROJECT WORKSPACE EXPLORER</span>
            </div>
            
            {/* Quick stats on the workspace */}
            <div className="flex items-center gap-4 text-[11px] text-slate-400 font-mono">
              <span className="flex items-center gap-1">
                <ShieldCheck className="h-3.5 w-3.5 text-emerald-400" /> Valid Flutter Project
              </span>
            </div>
          </div>

          <div className="flex-1 grid grid-cols-1 md:grid-cols-12 overflow-hidden min-h-[500px]">
            
            {/* Folder Tree on left */}
            <div className="md:col-span-5 bg-slate-950/60 border-r border-slate-800/60 p-4 overflow-y-auto space-y-1 select-none">
              <h3 className="text-[10px] font-bold text-slate-500 tracking-wider mb-3">WORKSPACE FILES</h3>
              
              {/* Root hello_doctor */}
              <div className="space-y-1">
                <div className="flex items-center gap-1.5 text-xs text-slate-300 font-semibold py-1">
                  <Folder className="h-4 w-4 text-amber-500 fill-amber-500/20" />
                  <span>hello_doctor/</span>
                </div>
                
                {/* pubspec.yaml */}
                <button
                  onClick={() => setSelectedFileKey('pubspec')}
                  className={`w-full flex items-center gap-1.5 text-xs font-mono py-1.5 pl-6 pr-2 rounded-lg text-left transition-all ${
                    selectedFileKey === 'pubspec' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                  }`}
                >
                  <FileText className="h-3.5 w-3.5 text-slate-500" />
                  <span className="truncate">pubspec.yaml</span>
                </button>

                {/* android folder */}
                <div className="pl-4 space-y-1">
                  <div className="flex items-center gap-1.5 text-xs text-slate-400 py-1">
                    <Folder className="h-3.5 w-3.5 text-amber-500 fill-amber-500/10" />
                    <span>android/app/...</span>
                  </div>
                  
                  {/* AndroidManifest.xml */}
                  <button
                    onClick={() => setSelectedFileKey('manifest')}
                    className={`w-full flex items-center gap-1.5 text-xs font-mono py-1.5 pl-4 pr-2 rounded-lg text-left transition-all ${
                      selectedFileKey === 'manifest' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                    }`}
                  >
                    <FileCode className="h-3.5 w-3.5 text-emerald-500" />
                    <span className="truncate">AndroidManifest.xml</span>
                  </button>
                </div>

                {/* lib/ folder */}
                <div className="pl-4 space-y-1">
                  <button 
                    onClick={() => setIsLibExpanded(!isLibExpanded)}
                    className="w-full flex items-center justify-between text-xs text-slate-300 py-1 hover:text-slate-100"
                  >
                    <div className="flex items-center gap-1.5">
                      <Folder className="h-3.5 w-3.5 text-blue-400 fill-blue-500/10" />
                      <span className="font-semibold">lib/</span>
                    </div>
                    {isLibExpanded ? <ChevronDown className="h-3 w-3 text-slate-500" /> : <ChevronRight className="h-3 w-3 text-slate-500" />}
                  </button>

                  {isLibExpanded && (
                    <div className="pl-4 space-y-1 border-l border-slate-800/80 ml-1.5">
                      {/* main.dart */}
                      <button
                        onClick={() => setSelectedFileKey('main')}
                        className={`w-full flex items-center gap-1.5 text-xs font-mono py-1.5 pl-2 pr-2 rounded-lg text-left transition-all ${
                          selectedFileKey === 'main' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                        }`}
                      >
                        <FileCode className="h-3.5 w-3.5 text-sky-400" />
                        <span className="truncate">main.dart</span>
                      </button>

                      {/* core/ folder */}
                      <button 
                        onClick={() => setIsCoreExpanded(!isCoreExpanded)}
                        className="w-full flex items-center justify-between text-xs text-slate-400 py-1 hover:text-slate-300"
                      >
                        <div className="flex items-center gap-1.5">
                          <Folder className="h-3.5 w-3.5 text-amber-500/80 fill-amber-500/10" />
                          <span>core/</span>
                        </div>
                        {isCoreExpanded ? <ChevronDown className="h-3 w-3 text-slate-500" /> : <ChevronRight className="h-3 w-3 text-slate-500" />}
                      </button>

                      {isCoreExpanded && (
                        <div className="pl-4 space-y-1 border-l border-slate-800/80 ml-1.5">
                          {/* theme.dart */}
                          <button
                            onClick={() => setSelectedFileKey('theme')}
                            className={`w-full flex items-center gap-1.5 text-xs font-mono py-1.5 pl-2 pr-2 rounded-lg text-left transition-all ${
                              selectedFileKey === 'theme' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                            }`}
                          >
                            <FileCode className="h-3.5 w-3.5 text-sky-400" />
                            <span className="truncate">theme.dart</span>
                          </button>

                          {/* routes.dart */}
                          <button
                            onClick={() => setSelectedFileKey('routes')}
                            className={`w-full flex items-center gap-1.5 text-xs font-mono py-1.5 pl-2 pr-2 rounded-lg text-left transition-all ${
                              selectedFileKey === 'routes' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                            }`}
                          >
                            <FileCode className="h-3.5 w-3.5 text-sky-400" />
                            <span className="truncate">routes.dart</span>
                          </button>
                        </div>
                      )}

                      {/* screens/ folder */}
                      <button 
                        onClick={() => setIsScreensExpanded(!isScreensExpanded)}
                        className="w-full flex items-center justify-between text-xs text-slate-400 py-1 hover:text-slate-300"
                      >
                        <div className="flex items-center gap-1.5">
                          <Folder className="h-3.5 w-3.5 text-amber-500/80 fill-amber-500/10" />
                          <span>screens/</span>
                        </div>
                        {isScreensExpanded ? <ChevronDown className="h-3 w-3 text-slate-500" /> : <ChevronRight className="h-3 w-3 text-slate-500" />}
                      </button>

                      {isScreensExpanded && (
                        <div className="pl-4 space-y-1 border-l border-slate-800/80 ml-1.5">
                          {/* splash_screen.dart */}
                          <button
                            onClick={() => setSelectedFileKey('splash')}
                            className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                              selectedFileKey === 'splash' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                            }`}
                          >
                            <FileCode className="h-3.5 w-3.5 text-sky-400" />
                            <span className="truncate">splash_screen.dart</span>
                          </button>

                          {/* role_selection_screen.dart */}
                          <button
                            onClick={() => setSelectedFileKey('role_selection')}
                            className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                              selectedFileKey === 'role_selection' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                            }`}
                          >
                            <FileCode className="h-3.5 w-3.5 text-sky-400" />
                            <span className="truncate">role_selection_screen.dart</span>
                          </button>

                          {/* screens/auth/ folder */}
                          <div className="pl-2 border-l border-slate-800/60 ml-1.5 space-y-1">
                            <div className="text-[10px] text-slate-500 uppercase tracking-wider pl-2 py-0.5">auth/</div>
                            
                            <button
                              onClick={() => setSelectedFileKey('patient_auth')}
                              className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                                selectedFileKey === 'patient_auth' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                              }`}
                            >
                              <FileCode className="h-3.5 w-3.5 text-sky-400/70" />
                              <span className="truncate">patient_auth_screen.dart</span>
                            </button>

                            <button
                              onClick={() => setSelectedFileKey('doctor_register')}
                              className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                                selectedFileKey === 'doctor_register' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                              }`}
                            >
                              <FileCode className="h-3.5 w-3.5 text-sky-400/70" />
                              <span className="truncate">doctor_register_screen.dart</span>
                            </button>

                            <button
                              onClick={() => setSelectedFileKey('pharmacy_register')}
                              className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                                selectedFileKey === 'pharmacy_register' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                              }`}
                            >
                              <FileCode className="h-3.5 w-3.5 text-sky-400/70" />
                              <span className="truncate">pharmacy_register_screen.dart</span>
                            </button>

                            <button
                              onClick={() => setSelectedFileKey('diagnostic_register')}
                              className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                                selectedFileKey === 'diagnostic_register' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                              }`}
                            >
                              <FileCode className="h-3.5 w-3.5 text-sky-400/70" />
                              <span className="truncate">diagnostic_register_screen.dart</span>
                            </button>

                            <button
                              onClick={() => setSelectedFileKey('pending_approval')}
                              className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                                selectedFileKey === 'pending_approval' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                              }`}
                            >
                              <FileCode className="h-3.5 w-3.5 text-sky-400/70" />
                              <span className="truncate">pending_approval_screen.dart</span>
                            </button>

                            <button
                              onClick={() => setSelectedFileKey('admin_login')}
                              className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                                selectedFileKey === 'admin_login' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                              }`}
                            >
                              <FileCode className="h-3.5 w-3.5 text-sky-400/70" />
                              <span className="truncate">admin_login_screen.dart</span>
                            </button>
                          </div>

                          {/* screens/patient/ folder */}
                          <div className="pl-2 border-l border-slate-800/60 ml-1.5 space-y-1">
                            <div className="text-[10px] text-slate-500 uppercase tracking-wider pl-2 py-0.5">patient/</div>
                            <button
                              onClick={() => setSelectedFileKey('patient_home')}
                              className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                                selectedFileKey === 'patient_home' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                              }`}
                            >
                              <FileCode className="h-3.5 w-3.5 text-sky-400" />
                              <span className="truncate">patient_home.dart</span>
                            </button>
                          </div>

                          {/* screens/doctor/ folder */}
                          <div className="pl-2 border-l border-slate-800/60 ml-1.5 space-y-1">
                            <div className="text-[10px] text-slate-500 uppercase tracking-wider pl-2 py-0.5">doctor/</div>
                            <button
                              onClick={() => setSelectedFileKey('doctor_home')}
                              className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                                selectedFileKey === 'doctor_home' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                              }`}
                            >
                              <FileCode className="h-3.5 w-3.5 text-sky-400" />
                              <span className="truncate">doctor_home.dart</span>
                            </button>
                          </div>

                          {/* screens/pharmacy/ folder */}
                          <div className="pl-2 border-l border-slate-800/60 ml-1.5 space-y-1">
                            <div className="text-[10px] text-slate-500 uppercase tracking-wider pl-2 py-0.5">pharmacy/</div>
                            <button
                              onClick={() => setSelectedFileKey('pharmacy_home')}
                              className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                                selectedFileKey === 'pharmacy_home' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                              }`}
                            >
                              <FileCode className="h-3.5 w-3.5 text-sky-400" />
                              <span className="truncate">pharmacy_home.dart</span>
                            </button>
                          </div>

                          {/* screens/diagnostic/ folder */}
                          <div className="pl-2 border-l border-slate-800/60 ml-1.5 space-y-1">
                            <div className="text-[10px] text-slate-500 uppercase tracking-wider pl-2 py-0.5">diagnostic/</div>
                            <button
                              onClick={() => setSelectedFileKey('diagnostic_home')}
                              className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                                selectedFileKey === 'diagnostic_home' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                              }`}
                            >
                              <FileCode className="h-3.5 w-3.5 text-sky-400" />
                              <span className="truncate">diagnostic_home.dart</span>
                            </button>
                          </div>

                          {/* screens/admin/ folder */}
                          <div className="pl-2 border-l border-slate-800/60 ml-1.5 space-y-1">
                            <div className="text-[10px] text-slate-500 uppercase tracking-wider pl-2 py-0.5">admin/</div>
                            <button
                              onClick={() => setSelectedFileKey('admin_home')}
                              className={`w-full flex items-center gap-1.5 text-xs font-mono py-1 pl-2 pr-2 rounded-lg text-left transition-all ${
                                selectedFileKey === 'admin_home' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                              }`}
                            >
                              <FileCode className="h-3.5 w-3.5 text-sky-400" />
                              <span className="truncate">admin_home.dart</span>
                            </button>
                          </div>
                        </div>
                      )}

                      {/* models/ folder */}
                      <button 
                        onClick={() => setIsModelsExpanded(!isModelsExpanded)}
                        className="w-full flex items-center justify-between text-xs text-slate-400 py-1 hover:text-slate-300"
                      >
                        <div className="flex items-center gap-1.5">
                          <Folder className="h-3.5 w-3.5 text-amber-500/80 fill-amber-500/10" />
                          <span>models/</span>
                        </div>
                        {isModelsExpanded ? <ChevronDown className="h-3 w-3 text-slate-500" /> : <ChevronRight className="h-3 w-3 text-slate-500" />}
                      </button>

                      {isModelsExpanded && (
                        <div className="pl-4 space-y-1 border-l border-slate-800/80 ml-1.5">
                          <button
                            onClick={() => setSelectedFileKey('user_model')}
                            className={`w-full flex items-center gap-1.5 text-xs font-mono py-1.5 pl-2 pr-2 rounded-lg text-left transition-all ${
                              selectedFileKey === 'user_model' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                            }`}
                          >
                            <FileCode className="h-3.5 w-3.5 text-sky-400" />
                            <span className="truncate">user_model.dart</span>
                          </button>
                        </div>
                      )}

                      {/* services/ folder */}
                      <button 
                        onClick={() => setIsServicesExpanded(!isServicesExpanded)}
                        className="w-full flex items-center justify-between text-xs text-slate-400 py-1 hover:text-slate-300"
                      >
                        <div className="flex items-center gap-1.5">
                          <Folder className="h-3.5 w-3.5 text-amber-500/80 fill-amber-500/10" />
                          <span>services/</span>
                        </div>
                        {isServicesExpanded ? <ChevronDown className="h-3 w-3 text-slate-500" /> : <ChevronRight className="h-3 w-3 text-slate-500" />}
                      </button>

                      {isServicesExpanded && (
                        <div className="pl-4 space-y-1 border-l border-slate-800/80 ml-1.5">
                          <button
                            onClick={() => setSelectedFileKey('auth_service')}
                            className={`w-full flex items-center gap-1.5 text-xs font-mono py-1.5 pl-2 pr-2 rounded-lg text-left transition-all ${
                              selectedFileKey === 'auth_service' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/15' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/30'
                            }`}
                          >
                            <FileCode className="h-3.5 w-3.5 text-sky-400" />
                            <span className="truncate">auth_service.dart</span>
                          </button>
                        </div>
                      )}

                      {/* widgets/ folder indications */}
                      <div className="flex items-center gap-1.5 text-xs text-slate-500 py-1.5 pl-2 select-none">
                        <Folder className="h-3.5 w-3.5 text-slate-600/80 fill-slate-700/5" />
                        <span>widgets/ <span className="text-[10px] bg-slate-800 text-slate-400 px-1 rounded">empty skeleton</span></span>
                      </div>

                    </div>
                  )}

                </div>
              </div>

            </div>

            {/* Code Content display on right */}
            <div className="md:col-span-7 flex flex-col overflow-hidden bg-slate-950">
              
              {/* File details banner */}
              <div className="px-5 py-3.5 bg-slate-950 border-b border-slate-900 flex items-center justify-between shrink-0">
                <div className="min-w-0">
                  <div className="text-[10px] font-mono text-slate-500 tracking-wider">ACTIVE FILE SOURCE</div>
                  <span className="text-xs font-mono font-bold text-slate-300 truncate block mt-0.5">
                    {FLUTTER_FILES[selectedFileKey].path}
                  </span>
                </div>
                
                <button
                  onClick={handleCopyCode}
                  className="flex items-center gap-1.5 bg-slate-900 border border-slate-800 px-3 py-1.5 rounded-lg text-xs font-medium text-slate-300 hover:text-white hover:bg-slate-800 hover:border-slate-700 transition-all cursor-pointer shrink-0"
                >
                  {copied ? (
                    <>
                      <Check className="h-3.5 w-3.5 text-emerald-400 animate-pulse" />
                      <span className="text-emerald-400 font-semibold">Copied!</span>
                    </>
                  ) : (
                    <>
                      <Copy className="h-3.5 w-3.5" />
                      <span>Copy Code</span>
                    </>
                  )}
                </button>
              </div>

              {/* Code viewer workspace */}
              <div className="flex-1 p-5 overflow-auto font-mono text-xs text-slate-300 leading-relaxed bg-slate-950/80 selection:bg-blue-600/20 selection:text-blue-300">
                <pre className="whitespace-pre overflow-x-auto select-text">
                  <code>{FLUTTER_FILES[selectedFileKey].content}</code>
                </pre>
              </div>

              {/* Status bar */}
              <div className="px-5 py-2.5 bg-slate-950 border-t border-slate-900 text-[10px] text-slate-500 font-mono tracking-wide flex justify-between shrink-0">
                <span>UTF-8 • {FLUTTER_FILES[selectedFileKey].language.toUpperCase()}</span>
                <span>Workspace Verified</span>
              </div>

            </div>

          </div>
        </section>

      </main>

      {/* Info banner footer */}
      <footer className="bg-slate-950 border-t border-slate-900/60 px-6 py-4 mt-auto">
        <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-4 text-xs text-slate-500 font-mono">
          <span>© 2026 Telemedicine Platform Project Framework. All rights reserved.</span>
          <div className="flex items-center gap-4">
            <span className="flex items-center gap-1.5">
              <span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse"></span>
              Workspace Active
            </span>
          </div>
        </div>
      </footer>
    </div>
  );
}
