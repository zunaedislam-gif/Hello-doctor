import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../models/doctor_model.dart';

class BookingCalendarScreen extends StatefulWidget {
  final String? doctorId;

  const BookingCalendarScreen({super.key, this.doctorId});

  @override
  State<BookingCalendarScreen> createState() => _BookingCalendarScreenState();
}

class _BookingCalendarScreenState extends State<BookingCalendarScreen> {
  late Doctor _doctor;
  late List<Map<String, String>> _days;
  int _selectedDayIndex = 0;
  String? _selectedSlot;

  // Grouped mock slots structure
  final Map<String, List<Map<String, dynamic>>> _slotPeriods = {
    'Morning': [
      {'time': '09:00 AM', 'available': true},
      {'time': '09:30 AM', 'available': false},
      {'time': '10:15 AM', 'available': true},
      {'time': '11:00 AM', 'available': true},
    ],
    'Afternoon': [
      {'time': '02:00 PM', 'available': false},
      {'time': '02:30 PM', 'available': true},
      {'time': '03:45 PM', 'available': true},
      {'time': '04:15 PM', 'available': false},
    ],
    'Evening': [
      {'time': '05:30 PM', 'available': true},
      {'time': '06:15 PM', 'available': true},
      {'time': '07:00 PM', 'available': false},
      {'time': '07:45 PM', 'available': true},
    ],
    'Night': [
      {'time': '08:30 PM', 'available': true},
      {'time': '09:15 PM', 'available': true},
      {'time': '10:00 PM', 'available': false},
      {'time': '10:45 PM', 'available': true},
    ],
  };

  @override
  void initState() {
    super.initState();
    // Resolve doctor details
    _doctor = dummyDoctors.firstWhere(
      (doc) => doc.id == widget.doctorId,
      orElse: () => dummyDoctors[0],
    );
    _days = _getNext7Days();
  }

  List<Map<String, String>> _getNext7Days() {
    final List<Map<String, String>> days = [];
    final now = DateTime.now();
    final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    
    for (int i = 0; i < 7; i++) {
      final day = now.add(Duration(days: i));
      final weekdayName = weekdays[day.weekday - 1];
      final monthName = months[day.month - 1];
      days.add({
        'dayName': weekdayName,
        'dateNum': '${day.day}',
        'fullDate': '$weekdayName, $monthName ${day.day}, ${day.year}',
      });
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final selectedDateStr = _days[_selectedDayIndex]['fullDate']!;

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ClinicalTheme.textDark, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Select Time Slot',
          style: TextStyle(
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
          // Doctor Info Micro-Card
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ClinicalTheme.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.08),
                    child: Text(
                      _doctor.name.split(" ")[1][0],
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: ClinicalTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _doctor.name,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: ClinicalTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '${_doctor.degrees} • ${_doctor.specialty}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: ClinicalTheme.textSecondary.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Next 7 Days Date Selector
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              height: 74,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _days.length,
                itemBuilder: (context, idx) {
                  final isSelected = _selectedDayIndex == idx;
                  final day = _days[idx];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDayIndex = idx;
                        _selectedSlot = null; // reset slot selection upon date change
                      });
                    },
                    child: Container(
                      width: 56,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? ClinicalTheme.primaryBlue : ClinicalTheme.backgroundLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? ClinicalTheme.primaryBlue : Colors.grey.withOpacity(0.06),
                          width: 1.2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: ClinicalTheme.primaryBlue.withOpacity(0.24),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day['dayName']!,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 10.5,
                              color: isSelected ? Colors.white.withOpacity(0.8) : ClinicalTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            day['dateNum']!,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.extrabold,
                              fontSize: 16,
                              color: isSelected ? Colors.white : ClinicalTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Time Slots grouped by Period
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: _slotPeriods.keys.map((period) {
                final slots = _slotPeriods[period]!;
                IconData periodIcon = Icons.wb_sunny_rounded;
                if (period == 'Afternoon') periodIcon = Icons.brightness_5_rounded;
                if (period == 'Evening') periodIcon = Icons.wb_twighlight;
                if (period == 'Night') periodIcon = Icons.nights_stay_rounded;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(periodIcon, color: ClinicalTheme.primaryBlue, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '$period Slots',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: ClinicalTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Grid of slots
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2.3,
                      ),
                      itemCount: slots.length,
                      itemBuilder: (context, sIdx) {
                        final slot = slots[sIdx];
                        final time = slot['time'] as String;
                        final isAvail = slot['available'] as bool;
                        final isSel = _selectedSlot == time;

                        Color bgCol = Colors.white;
                        Color textCol = ClinicalTheme.textDark;
                        BorderSide border = BorderSide(color: Colors.grey.withOpacity(0.12), width: 1.2);

                        if (!isAvail) {
                          bgCol = Colors.grey.shade100;
                          textCol = Colors.grey.shade400;
                          border = BorderSide(color: Colors.grey.shade200);
                        } else if (isSel) {
                          bgCol = ClinicalTheme.primaryBlue;
                          textCol = Colors.white;
                          border = const BorderSide(color: ClinicalTheme.primaryBlue);
                        }

                        return GestureDetector(
                          onTap: isAvail
                              ? () {
                                  setState(() {
                                    _selectedSlot = time;
                                  });
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgCol,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.fromBorderSide(border),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              time,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textCol,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }).toList(),
            ),
          ),
          
          // Bottom sticky confirmation summary bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Schedule',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: ClinicalTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedSlot != null
                            ? '$selectedDateStr • $_selectedSlot'
                            : 'Please pick a slot',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _selectedSlot != null
                              ? ClinicalTheme.primaryBlue
                              : Colors.grey.shade400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _selectedSlot != null
                      ? () {
                          // Navigate to Summary & Payment Screen
                          final encDate = Uri.encodeComponent(selectedDateStr);
                          final encSlot = Uri.encodeComponent(_selectedSlot!);
                          context.push(
                            '/booking-summary?docId=${_doctor.id}&date=$encDate&slot=$encSlot',
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClinicalTheme.primaryBlue,
                    disabledBackgroundColor: Colors.grey.shade200,
                    elevation: 0,
                    minimumSize: const Size(160, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Confirm Slot',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _selectedSlot != null ? Colors.white : Colors.grey.shade400,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
