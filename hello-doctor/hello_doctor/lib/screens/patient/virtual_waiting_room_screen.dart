import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../services/appointment_service.dart';

class VirtualWaitingRoomScreen extends StatefulWidget {
  final String appId;

  const VirtualWaitingRoomScreen({super.key, required this.appId});

  @override
  State<VirtualWaitingRoomScreen> createState() => _VirtualWaitingRoomScreenState();
}

class _VirtualWaitingRoomScreenState extends State<VirtualWaitingRoomScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  String _statusText = "Waiting for doctor";
  String _statusSubText = "The doctor is wrapping up another consult and will join shortly.";
  int _timerCount = 0;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation setup
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Dynamic sequence for simulation
    _statusTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      
      setState(() {
        _timerCount++;
        if (_timerCount == 1) {
          _statusText = "Doctor joined";
          _statusSubText = "Establishing a secure WebRTC peer connection...";
        } else if (_timerCount == 2) {
          _statusText = "Connecting";
          _statusSubText = "Handshaking ICE audio/video descriptors...";
        } else {
          _statusTimer?.cancel();
          // Navigate to active Video Call
          context.pushReplacement('/video-call?appId=${widget.appId}&role=patient');
        }
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _statusTimer?.cancel();
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
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: ClinicalTheme.textDark),
          onPressed: () {
            _showExitWarning(context);
          },
        ),
        title: const Text(
          'Virtual Waiting Room',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ClinicalTheme.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Pulsing WebRTC signal visual
            ScaleTransition(
              scale: _pulseAnimation,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ClinicalTheme.primaryBlue.withOpacity(0.06),
                    ),
                  ),
                  Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ClinicalTheme.primaryBlue.withOpacity(0.12),
                    ),
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: ClinicalTheme.primaryBlue,
                    child: const Icon(
                      Icons.video_camera_front_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Connection texts
            Text(
              'Please wait, connecting you to',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: ClinicalTheme.textSecondary.withOpacity(0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              app.doctorName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.extrabold,
                fontSize: 20,
                color: ClinicalTheme.textDark,
              ),
            ),
            Text(
              '${app.doctorDegrees} • ${app.doctorSpecialty}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: ClinicalTheme.textSecondary.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Connection Status micro indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ClinicalTheme.backgroundLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.08)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(ClinicalTheme.primaryBlue),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _statusText,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: ClinicalTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _statusSubText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.5,
                color: ClinicalTheme.textSecondary,
                height: 1.4,
              ),
            ),

            const Spacer(),

            // Tech specs block at bottom
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ClinicalTheme.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.04)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline_rounded, color: ClinicalTheme.accentGreen, size: 16),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'P2P WebRTC connection. Audio, video, and prescription notes are encrypted and 100% free with zero platform consulting surcharges.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: ClinicalTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showExitWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Exit Waiting Room?', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15)),
          content: const Text('Exiting now will terminate your queue slot. If you leave, you can rejoin later from your Appointments tab.', style: TextStyle(fontFamily: 'Inter', fontSize: 12.5, height: 1.4)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dContext),
              child: const Text('Stay Here', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dContext);
                context.go('/patient-home');
              },
              child: const Text('Exit Queue', style: TextStyle(color: ClinicalTheme.alertRed, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
