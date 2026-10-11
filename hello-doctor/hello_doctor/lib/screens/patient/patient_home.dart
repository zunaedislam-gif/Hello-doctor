import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import './doctor_list_screen.dart';
import '../feed/health_feed_screen.dart';

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
    // Setup promo banner auto scroll every 4 seconds
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

  // Filter doctor list based on selection and query
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
          // Language Switcher UI Toggle
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
          // Standalone Chat / Message Inbox Button
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline_rounded, color: ClinicalTheme.textDark),
                tooltip: 'My Messages',
                onPressed: () {
                  context.push('/chat-list');
                },
              ),
              StreamBuilder<List<ChatThread>>(
                stream: Provider.of<ChatService>(context, listen: false).listenToThreads(
                  Provider.of<AuthService>(context, listen: false).currentUser?.id ?? 'patient_mock',
                  'patient',
                ),
                builder: (context, snapshot) {
                  final threads = snapshot.data ?? [];
                  int totalUnread = 0;
                  for (var t in threads) {
                    totalUnread += t.unreadCount;
                  }
                  if (totalUnread == 0) return const SizedBox.shrink();

                  return Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: ClinicalTheme.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$totalUnread',
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          const SizedBox(width: 4),
          // Notification Bell
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
          // Avatar
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
          : _currentBottomTab == 1
              ? const HealthFeedScreen(isTabMode: true)
              : _currentBottomTab == 2
                  ? const DoctorListScreen(showBackButton: false)
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
            icon: const Icon(Icons.feed_outlined),
            activeIcon: const Icon(Icons.feed),
            label: _isEnglish ? 'Health Feed' : 'হেলথ ফিড',
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

  // Dashboard content
  Widget _buildDashboardView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Search Bar Section
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

          // 2. Promotional Carousel Section
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
          
          // Carousel Indicators
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

          // 3. Quick Action Grid Section
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
                      onTap: () {
                        context.push('/doctor-list');
                      },
                    ),
                    _buildQuickActionCard(
                      title: _isEnglish ? 'Order Medicine' : 'ওষুধ অর্ডার',
                      subtitle: _isEnglish ? 'Prescription home dispatch' : 'কুরিয়ারে ওষুধ কিনুন',
                      icon: Icons.local_pharmacy_rounded,
                      color: Colors.orange.shade700,
                      onTap: () {
                        setState(() {
                          _currentBottomTab = 3; // Link to diagnostic/pharmacy placeholder
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
                          _currentBottomTab = 3; // Link to diagnostic
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 4. Specialties List Section
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
                    context.push('/doctor-list?specialty=${Uri.encodeComponent(spec["name"])}');
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

          // 5. Popular Doctors Card Row Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Text(
                  _isEnglish 
                      ? 'Popular Doctors (${_filteredDoctors.length})' 
                      : 'জনপ্রিয় ডাক্তারবৃন্দ (${_filteredDoctors.length})',
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

  // Banners UI Maker
  Widget _buildPromoCard(Map<String, String> promo) {
    // Determine colors
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
                    _isEnglish ? "Promo Code: ${promo["code"]}" : "কুপন কোড: ${promo["code"]}",
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

  // Quick Action card builder
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

  // Horizontal Card popular doctor
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
                            "${doc["rating"]}",
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                          ),
                          Text(
                            " (${doc["reviews"]})",
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
                      "৳ ${doc["fee"]}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    String docId = "doc_1";
                    final docName = doc["name"] as String;
                    if (docName == "Dr. Sarah Rahman") docId = "doc_1";
                    else if (docName == "Dr. Fahim Anjum") docId = "doc_2";
                    else if (docName == "Dr. Naila Khan") docId = "doc_3";
                    else if (docName == "Dr. Ariful Islam") docId = "doc_4";
                    else if (docName == "Dr. Tasnim Ahmed") docId = "doc_5";
                    context.push('/doctor-profile/$docId');
                  },
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

  // Tabs Placeholder layout for Clips, Doc list, Diagnostics, and More menu
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

  // Tab Details Builders
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
            subtitle: Text("${clip["author"]} • ${clip["views"]} views", style: const TextStyle(fontSize: 10)),
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
            subtitle: Text("${doc["specialty"]} • ${doc["experience"]} yrs Exp"),
            trailing: Text("৳ ${doc["fee"]}", style: const TextStyle(fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue)),
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
                    Text("৳ ${pack["price"]}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Simulated lab booking: ${pack["name"]}')),
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
        _buildMenuTile(
          Icons.person_outline_rounded,
          _isEnglish ? "Patient Profile" : "আমার প্রোফাইল",
          () => context.push('/patient-profile'),
        ),
        _buildMenuTile(
          Icons.shield_outlined,
          _isEnglish ? "Health Insurance" : "স্বাস্থ্য বীমা",
          () => context.push('/insurance'),
        ),
        _buildMenuTile(
          Icons.calendar_month_rounded,
          _isEnglish ? "My Appointments" : "আমার অ্যাপয়েন্টমেন্ট",
          () => context.push('/my-appointments'),
        ),
        _buildMenuTile(
          Icons.medical_information_rounded,
          _isEnglish ? "My Prescriptions" : "আমার প্রেসক্রিপশন ও ফাইল",
          () => context.push('/my-prescriptions'),
        ),
        _buildMenuTile(
          Icons.biotech_rounded,
          _isEnglish ? "My Lab Results" : "ল্যাব পরীক্ষার রিপোর্ট",
          () {
            setState(() {
              _currentBottomTab = 3; // Swaps to Diagnostic Tab
            });
          },
        ),
        _buildMenuTile(
          Icons.notifications_none_rounded,
          _isEnglish ? "Notifications" : "বিজ্ঞপ্তি সমূহ",
          () => context.push('/notifications'),
        ),
        _buildMenuTile(
          Icons.help_outline_rounded,
          _isEnglish ? "Help & Support" : "হেল্প ও সাপোর্ট",
          () => context.push('/help-support'),
        ),
        _buildMenuTile(
          Icons.description_outlined,
          _isEnglish ? "Terms & Conditions" : "শর্তাবলী ও নিয়মাবলী",
          () {
            _showTextDialog("Terms & Conditions", "Welcome to Hello Doctor. By using our platform, you agree to connect with certified doctors for clinical guidance. These sessions do not replace physical emergency care. All information shared is securely stored per data standards.");
          },
        ),
        _buildMenuTile(
          Icons.privacy_tip_outlined,
          _isEnglish ? "Privacy Policy" : "গোপনীয়তা নীতি",
          () {
            _showTextDialog("Privacy Policy", "Hello Doctor is committed to safeguarding patient confidentiality. Your electronic health records (EHR), prescriptions, and diagnostic results are encrypted end-to-end and are only visible to you and your authorized treating physicians.");
          },
        ),
        const Divider(height: 20, thickness: 1),
        ElevatedButton.icon(
          onPressed: () {
            context.go(AppRoutes.roleSelection);
          },
          icon: const Icon(Icons.logout_rounded, size: 18, color: Colors.white),
          label: Text(_isEnglish ? 'Log Out Portal' : 'লগআউট এবং রোল পরিবর্তন'),
          style: ElevatedButton.styleFrom(
            backgroundColor: ClinicalTheme.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minimumSize: const Size(double.infinity, 44),
          ),
        ),
      ],
    );
  }

  void _showTextDialog(String title, String body) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15)),
          content: Text(body, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, height: 1.4, color: ClinicalTheme.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        );
      },
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

  // Interactive Modals and BottomSheets Simulations
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
                            Text("${doc["rating"]} Rating", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark)),
                            const SizedBox(width: 8),
                            Text("${doc["experience"]} yrs Exp", style: const TextStyle(fontSize: 12, color: ClinicalTheme.textSecondary)),
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
                      Text('৳ ${doc["fee"]}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ClinicalTheme.primaryBlue)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Initiating direct video call with ${doc["name"]}...')),
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

  // Simulations triggered by quick actions
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
            SnackBar(content: Text('Appointment requested for slot: $slot')),
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
}
