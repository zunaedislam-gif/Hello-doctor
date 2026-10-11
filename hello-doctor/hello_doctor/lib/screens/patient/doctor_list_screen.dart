import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../models/doctor_model.dart';

class DoctorListScreen extends StatefulWidget {
  final String? initialSpecialty;
  final bool showBackButton;

  const DoctorListScreen({
    super.key,
    this.initialSpecialty,
    this.showBackButton = false,
  });

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  
  // Active Filter States
  String _selectedSpecialty = "All";
  String _selectedGender = "All"; // All, Male, Female
  double _maxFee = 1000.0;
  double _minExperience = 0.0;
  bool _availableTodayOnly = false;

  // Sorting
  String _sortBy = "Relevance"; // Relevance, Rating, Lowest Fee, Experience

  final List<String> _specialtiesList = [
    "All",
    "General Physician",
    "Gynecology",
    "Pediatrics",
    "Skin/Derm",
    "Cardiology",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialSpecialty != null) {
      _selectedSpecialty = widget.initialSpecialty!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Get filtered and sorted list
  List<Doctor> get _processedDoctors {
    List<Doctor> list = dummyDoctors.where((doc) {
      // Search matching name or degrees or specialty
      final matchQuery = _searchQuery.isEmpty ||
          doc.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.degrees.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.specialty.toLowerCase().contains(_searchQuery.toLowerCase());

      // Specialty filter
      final matchSpecialty = _selectedSpecialty == "All" ||
          doc.specialty.toLowerCase().contains(_selectedSpecialty.toLowerCase().split("/")[0]);

      // Gender filter
      final matchGender = _selectedGender == "All" || doc.gender == _selectedGender;

      // Fee filter
      final matchFee = doc.consultationFee <= _maxFee;

      // Experience filter
      final matchExp = doc.experience >= _minExperience;

      // Availability filter
      final matchAvailability = !_availableTodayOnly || doc.isAvailableToday;

      return matchQuery && matchSpecialty && matchGender && matchFee && matchExp && matchAvailability;
    }).toList();

    // Sort list
    if (_sortBy == "Rating") {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == "Lowest Fee") {
      list.sort((a, b) => a.consultationFee.compareTo(b.consultationFee));
    } else if (_sortBy == "Experience") {
      list.sort((a, b) => b.experience.compareTo(a.experience));
    }

    return list;
  }

  void _resetFilters() {
    setState(() {
      _selectedSpecialty = "All";
      _selectedGender = "All";
      _maxFee = 1000.0;
      _minExperience = 0.0;
      _availableTodayOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _processedDoctors;

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ClinicalTheme.textDark, size: 20),
                onPressed: () => context.pop(),
              )
            : null,
        title: Text(
          widget.showBackButton ? 'Search Doctors' : 'Doctor Directory',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ClinicalTheme.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search & Filter header segment
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: ClinicalTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.08)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search by name or specialty...',
                            hintStyle: TextStyle(color: ClinicalTheme.textSecondary.withOpacity(0.4), fontSize: 13),
                            prefixIcon: const Icon(Icons.search_rounded, color: ClinicalTheme.primaryBlue, size: 20),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 16),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchQuery = "";
                                      });
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Filter icon button
                    GestureDetector(
                      onTap: () => _openFilterBottomSheet(),
                      child: Container(
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                          color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ClinicalTheme.primaryBlue.withOpacity(0.12)),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: ClinicalTheme.primaryBlue,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Sort Dropdown and Results count
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text(
                      '${filteredList.length} doctors found',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: ClinicalTheme.textSecondary,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.sort_rounded, color: ClinicalTheme.primaryBlue, size: 15),
                        const SizedBox(width: 4),
                        DropdownButton<String>(
                          value: _sortBy,
                          underline: const SizedBox(),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: ClinicalTheme.primaryBlue),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: ClinicalTheme.primaryBlue,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _sortBy = newValue;
                              });
                            }
                          },
                          items: <String>['Relevance', 'Rating', 'Lowest Fee', 'Experience']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          
          // Doctor List Cards
          Expanded(
            child: filteredList.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final doc = filteredList[index];
                      return _buildDoctorCard(doc);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_search_rounded, size: 54, color: ClinicalTheme.textSecondary.withOpacity(0.25)),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Doctors Found',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: ClinicalTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We couldn\'t find any doctors matching your parameters. Try resetting your search filters.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              color: ClinicalTheme.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = "";
                _resetFilters();
              });
            },
            icon: const Icon(Icons.refresh_rounded, size: 16, color: Colors.white),
            label: const Text('Reset All Filters', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: ClinicalTheme.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.12), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Open Doctor Profile screen
          context.push('/doctor-profile/${doc.id}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.08),
                        child: Text(
                          doc.name.split(" ")[1][0],
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: ClinicalTheme.primaryBlue,
                          ),
                        ),
                      ),
                      if (doc.isAvailableToday)
                        Positioned(
                          right: 1,
                          bottom: 1,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: ClinicalTheme.accentGreen,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.name,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: ClinicalTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          doc.degrees,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: ClinicalTheme.textSecondary.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        // Specialty Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: ClinicalTheme.primaryBlue.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            doc.specialty,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: ClinicalTheme.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Rating & Experience row
                        Row(
                          children: [
                            const Icon(Icons.star_rate_rounded, color: Colors.amber, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              "${doc.rating}",
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                            ),
                            Text(
                              " (${doc.reviewsCount} reviews)",
                              style: const TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "•",
                              style: TextStyle(color: Colors.grey.shade300),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${doc.experience} yrs exp",
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: ClinicalTheme.textSecondary),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey.withOpacity(0.08), height: 1),
              const SizedBox(height: 10),
              // Fee & Booking Action
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Consultation Fee",
                        style: TextStyle(fontSize: 10, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        "৳ ${doc.consultationFee.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: ClinicalTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/booking-calendar?docId=${doc.id}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ClinicalTheme.primaryBlue,
                      elevation: 0,
                      minimumSize: const Size(128, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Book Appointment',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Opens interactive filter sheet
  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.72,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          const Text(
                            'Filters',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.extrabold,
                              fontSize: 18,
                              color: ClinicalTheme.textDark,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                _selectedSpecialty = "All";
                                _selectedGender = "All";
                                _maxFee = 1000.0;
                                _minExperience = 0.0;
                                _availableTodayOnly = false;
                              });
                              // Also trigger parent state reset
                              setState(() {});
                            },
                            child: const Text(
                              'Reset All',
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: ClinicalTheme.alertRed),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // 1. Specialty Filter
                      const Text(
                        'Specialty',
                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _specialtiesList.map((spec) {
                          final isSel = _selectedSpecialty == spec;
                          return ChoiceChip(
                            label: Text(spec),
                            selected: isSel,
                            selectedColor: ClinicalTheme.primaryBlue,
                            backgroundColor: ClinicalTheme.backgroundLight,
                            labelStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSel ? Colors.white : ClinicalTheme.textSecondary,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedSpecialty = spec;
                              });
                              setState(() {});
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // 2. Gender Filter
                      const Text(
                        'Gender',
                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ["All", "Male", "Female"].map((gender) {
                          final isSel = _selectedGender == gender;
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: SizedBox(
                                  width: double.infinity,
                                  child: Text(gender, textAlign: TextAlign.center),
                                ),
                                selected: isSel,
                                selectedColor: ClinicalTheme.primaryBlue,
                                backgroundColor: ClinicalTheme.backgroundLight,
                                labelStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSel ? Colors.white : ClinicalTheme.textSecondary,
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                onSelected: (selected) {
                                  setModalState(() {
                                    _selectedGender = gender;
                                  });
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // 3. Fee range
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          const Text(
                            'Max Consultation Fee',
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                          ),
                          Text(
                            '৳ ${_maxFee.toStringAsFixed(0)}',
                            style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.primaryBlue),
                          ),
                        ],
                      ),
                      Slider(
                        value: _maxFee,
                        min: 300,
                        max: 1000,
                        divisions: 7,
                        activeColor: ClinicalTheme.primaryBlue,
                        inactiveColor: ClinicalTheme.primaryBlue.withOpacity(0.12),
                        onChanged: (val) {
                          setModalState(() {
                            _maxFee = val;
                          });
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 12),

                      // 4. Experience range
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          const Text(
                            'Minimum Experience',
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                          ),
                          Text(
                            '${_minExperience.toStringAsFixed(0)}+ Years',
                            style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.primaryBlue),
                          ),
                        ],
                      ),
                      Slider(
                        value: _minExperience,
                        min: 0,
                        max: 15,
                        divisions: 3,
                        activeColor: ClinicalTheme.primaryBlue,
                        inactiveColor: ClinicalTheme.primaryBlue.withOpacity(0.12),
                        onChanged: (val) {
                          setModalState(() {
                            _minExperience = val;
                          });
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),

                      // 5. Available today toggle
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Available Today Only',
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: ClinicalTheme.textDark),
                        ),
                        subtitle: const Text(
                          'Only display doctors currently taking urgent bookings.',
                          style: TextStyle(fontSize: 10.5, color: ClinicalTheme.textSecondary),
                        ),
                        value: _availableTodayOnly,
                        activeColor: ClinicalTheme.primaryBlue,
                        onChanged: (val) {
                          setModalState(() {
                            _availableTodayOnly = val;
                          });
                          setState(() {});
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ClinicalTheme.primaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
