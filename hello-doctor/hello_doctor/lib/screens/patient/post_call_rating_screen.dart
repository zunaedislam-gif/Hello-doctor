import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../services/appointment_service.dart';

class PostCallRatingScreen extends StatefulWidget {
  final String appId;

  const PostCallRatingScreen({super.key, required this.appId});

  @override
  State<PostCallRatingScreen> createState() => _PostCallRatingScreenState();
}

class _PostCallRatingScreenState extends State<PostCallRatingScreen> {
  int _selectedRating = 5;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appService = Provider.of<AppointmentService>(context, listen: false);
    final app = appService.appointments.firstWhere(
      (a) => a.id == widget.appId,
      orElse: () => appService.appointments.isNotEmpty
          ? appService.appointments.last
          : throw Exception("Appointment not found"),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Consultation Feedback',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: ClinicalTheme.textDark),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Doctor profile visual
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                    ),
                  ),
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      app.doctorName.split(" ").last.substring(0, 1),
                      style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 28, color: ClinicalTheme.primaryBlue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                app.doctorName,
                style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.extrabold, fontSize: 18, color: ClinicalTheme.textDark),
              ),
              Text(
                '${app.doctorDegrees} • ${app.doctorSpecialty}',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: ClinicalTheme.textSecondary),
              ),
              const SizedBox(height: 36),
              
              const Text(
                'How was your consultation experience?',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15, color: ClinicalTheme.textDark),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Your feedback helps us maintain high-quality teleconsultation standards and coordinates care protocols with doctors.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: ClinicalTheme.textSecondary, height: 1.4),
                ),
              ),
              const SizedBox(height: 24),

              // Five stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starVal = index + 1;
                  final isSelected = starVal <= _selectedRating;
                  return IconButton(
                    iconSize: 42,
                    icon: Icon(
                      isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: isSelected ? Colors.amber : Colors.grey.shade300,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRating = starVal;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 28),

              // Comment block
              TextField(
                controller: _commentController,
                maxLines: 4,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: ClinicalTheme.textDark),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ClinicalTheme.backgroundLight,
                  hintText: 'Describe your consultation (e.g., doctor friendliness, clarity of instructions, call quality)...',
                  hintStyle: TextStyle(color: ClinicalTheme.textSecondary.withOpacity(0.4), fontSize: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.08)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ClinicalTheme.primaryBlue),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  // Submit logic - optional snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you for your valuable feedback!'), duration: Duration(seconds: 1)),
                  );
                  // Push to Post Visit Summary page
                  context.pushReplacement('/post-visit-summary?appId=${widget.appId}');
                },
                child: const Text('Submit Feedback'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  context.pushReplacement('/post-visit-summary?appId=${widget.appId}');
                },
                child: const Text(
                  'Skip feedback',
                  style: TextStyle(color: ClinicalTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
