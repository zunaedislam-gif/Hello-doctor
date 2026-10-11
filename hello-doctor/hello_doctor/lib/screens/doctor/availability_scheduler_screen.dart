import 'package:flutter/material.dart';
import '../../core/theme.dart';

class AvailabilitySchedulerScreen extends StatefulWidget {
  const AvailabilitySchedulerScreen({super.key});

  @override
  State<AvailabilitySchedulerScreen> createState() => _AvailabilitySchedulerScreenState();
}

class _AvailabilitySchedulerScreenState extends State<AvailabilitySchedulerScreen> {
  // Weekly list
  final List<String> _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  int _selectedDayIndex = 0; // Monday selected by default

  // Availability schedule per day. In production, this would be retrieved/saved in Cloud DB.
  final Map<String, List<Map<String, dynamic>>> _schedules = {
    'Monday': [
      {"slot": "09:00 AM - 10:00 AM", "active": true, "type": "Morning"},
      {"slot": "10:00 AM - 11:00 AM", "active": true, "type": "Morning"},
      {"slot": "11:00 AM - 12:00 PM", "active": false, "type": "Morning"},
      {"slot": "04:00 PM - 05:00 PM", "active": true, "type": "Evening"},
      {"slot": "05:00 PM - 06:00 PM", "active": true, "type": "Evening"},
      {"slot": "06:00 PM - 07:00 PM", "active": false, "type": "Evening"},
      {"slot": "08:00 PM - 09:00 PM", "active": true, "type": "Night"},
    ],
    'Tuesday': [
      {"slot": "09:00 AM - 10:00 AM", "active": true, "type": "Morning"},
      {"slot": "10:00 AM - 11:00 AM", "active": true, "type": "Morning"},
      {"slot": "04:00 PM - 05:00 PM", "active": false, "type": "Evening"},
      {"slot": "05:00 PM - 06:00 PM", "active": true, "type": "Evening"},
      {"slot": "08:00 PM - 09:00 PM", "active": true, "type": "Night"},
    ],
    'Wednesday': [
      {"slot": "09:00 AM - 10:00 AM", "active": true, "type": "Morning"},
      {"slot": "10:00 AM - 11:00 AM", "active": true, "type": "Morning"},
      {"slot": "11:00 AM - 12:00 PM", "active": true, "type": "Morning"},
      {"slot": "04:00 PM - 05:00 PM", "active": true, "type": "Evening"},
      {"slot": "05:00 PM - 06:00 PM", "active": true, "type": "Evening"},
      {"slot": "08:00 PM - 09:00 PM", "active": false, "type": "Night"},
    ],
    'Thursday': [
      {"slot": "09:00 AM - 10:00 AM", "active": false, "type": "Morning"},
      {"slot": "10:00 AM - 11:00 AM", "active": true, "type": "Morning"},
      {"slot": "04:00 PM - 05:00 PM", "active": true, "type": "Evening"},
      {"slot": "05:00 PM - 06:00 PM", "active": true, "type": "Evening"},
      {"slot": "08:00 PM - 09:00 PM", "active": true, "type": "Night"},
    ],
    'Friday': [
      {"slot": "09:00 AM - 10:00 AM", "active": false, "type": "Morning"},
      {"slot": "10:00 AM - 11:00 AM", "active": false, "type": "Morning"},
      {"slot": "04:00 PM - 05:00 PM", "active": true, "type": "Evening"},
      {"slot": "05:00 PM - 06:00 PM", "active": true, "type": "Evening"},
      {"slot": "08:00 PM - 09:00 PM", "active": false, "type": "Night"},
    ],
    'Saturday': [
      {"slot": "10:00 AM - 11:00 AM", "active": true, "type": "Morning"},
      {"slot": "11:00 AM - 12:00 PM", "active": true, "type": "Morning"},
      {"slot": "02:00 PM - 03:00 PM", "active": true, "type": "Evening"},
      {"slot": "03:00 PM - 04:00 PM", "active": true, "type": "Evening"},
    ],
    'Sunday': [
      {"slot": "10:00 AM - 11:00 AM", "active": true, "type": "Morning"},
      {"slot": "11:00 AM - 12:00 PM", "active": true, "type": "Morning"},
      {"slot": "02:00 PM - 03:00 PM", "active": false, "type": "Evening"},
      {"slot": "03:00 PM - 04:00 PM", "active": true, "type": "Evening"},
    ]
  };

  @override
  Widget build(BuildContext context) {
    final activeDay = _days[_selectedDayIndex];
    final activeSlots = _schedules[activeDay] ?? [];

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Availability Scheduler',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: ClinicalTheme.textDark,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All time blocks copied to other working days.'),
                  backgroundColor: ClinicalTheme.accentGreen,
                ),
              );
            },
            child: const Text(
              'Copy All',
              style: TextStyle(color: ClinicalTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // 1. Weekly Calendar Slider Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: SizedBox(
              height: 64,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 16),
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  final day = _days[index];
                  final isSelected = index == _selectedDayIndex;
                  final shortName = day.substring(0, 3);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDayIndex = index;
                      });
                    },
                    child: Container(
                      width: 56,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? ClinicalTheme.primaryBlue : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? ClinicalTheme.primaryBlue : Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            shortName.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white70 : ClinicalTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Dot indicator if any active block exists
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : ClinicalTheme.accentGreen,
                              shape: BoxShape.circle,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. Info Banner
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: ClinicalTheme.primaryBlue.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ClinicalTheme.primaryBlue.withOpacity(0.12)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: ClinicalTheme.primaryBlue, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Toggle the time blocks for $activeDay below. Patients can book slots highlighted in blue.',
                      style: const TextStyle(fontSize: 11, color: ClinicalTheme.primaryBlue, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Time Slots List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: activeSlots.length,
              itemBuilder: (context, index) {
                final slot = activeSlots[index];
                final isActive = slot['active'] as bool;
                final type = slot['type'] as String;

                IconData getIcon() {
                  switch (type) {
                    case "Morning": return Icons.light_mode_outlined;
                    case "Evening": return Icons.wb_twilight_rounded;
                    default: return Icons.nightlight_outlined;
                  }
                }

                Color getColor() {
                  switch (type) {
                    case "Morning": return Colors.orange;
                    case "Evening": return Colors.indigo;
                    default: return Colors.blueGrey;
                  }
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isActive ? ClinicalTheme.primaryBlue.withOpacity(0.3) : Colors.grey.shade200,
                      width: isActive ? 1.5 : 1,
                    ),
                  ),
                  color: isActive ? Colors.white : Colors.grey.shade50.withOpacity(0.7),
                  child: SwitchListTile(
                    activeColor: ClinicalTheme.primaryBlue,
                    value: isActive,
                    onChanged: (val) {
                      setState(() {
                        activeSlots[index]['active'] = val;
                      });
                    },
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: getColor().withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(getIcon(), size: 18, color: getColor()),
                    ),
                    title: Text(
                      slot['slot'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isActive ? ClinicalTheme.textDark : Colors.grey.shade400,
                        decoration: isActive ? TextDecoration.none : TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Text(
                      type,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isActive ? getColor() : Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 4. Action Bottom Sheet
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Reset to all enabled
                      setState(() {
                        for (var element in activeSlots) {
                          element['active'] = true;
                        }
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ClinicalTheme.textSecondary,
                      side: BorderSide(color: Colors.grey.shade300),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Reset Today'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Schedule updated successfully.'),
                          backgroundColor: ClinicalTheme.accentGreen,
                        ),
                      );
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ClinicalTheme.primaryBlue,
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Schedule', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
