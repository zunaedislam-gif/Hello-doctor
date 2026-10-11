/*
================================================================================
FREE TELEMEDICINE SIGNALING SERVICE (WebRTC + Firebase Realtime Database)
================================================================================
Developer Setup Guide:
1. Create a free Firebase project at https://firebase.google.com (No Credit Card needed).
2. Create a Realtime Database in "test mode" (with read/write allowed initially).
3. Add the Google Services configuration files to your Flutter project:
   - For Android: android/app/google-services.json
   - For iOS: ios/Runner/GoogleService-Info.plist
4. Run "flutterfire configure" using the FlutterFire CLI to automatically wire it up.
5. This architecture is 100% FREE with NO per-minute video charges! 
   The video & audio data flows peer-to-peer (P2P) directly between patient and doctor.
================================================================================
*/

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart';

enum SignalingState {
  idle,
  requestingPermissions,
  initializingWebRTC,
  waitingForPeer,
  connecting,
  connected,
  reconnecting,
  disconnected,
  error
}

class SignalingService extends ChangeNotifier {
  SignalingState _state = SignalingState.idle;
  SignalingState get state => _state;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  MediaStream? get localStream => _localStream;
  MediaStream? get remoteStream => _remoteStream;

  bool _isAudioMuted = false;
  bool _isVideoOff = false;
  bool get isAudioMuted => _isAudioMuted;
  bool get isVideoOff => _isVideoOff;

  String? _currentRoomId;
  String? get currentRoomId => _currentRoomId;

  // Realtime Database Reference
  DatabaseReference? _roomRef;
  StreamSubscription<DatabaseEvent>? _offerSubscription;
  StreamSubscription<DatabaseEvent>? _answerSubscription;
  StreamSubscription<DatabaseEvent>? _iceCandidateSubscription;

  // Controller for connection state and duration
  Timer? _callTimer;
  int _callDurationSeconds = 0;
  int get callDurationSeconds => _callDurationSeconds;

  // Local notepad for doctors
  final Map<String, String> _doctorNotes = {}; // appointmentId -> notes

  // ICE Server configuration using free Google STUN servers
  final Map<String, dynamic> _iceServersConfiguration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
          'stun:stun.l.google.com:19302',
          'stun:stun3.l.google.com:19302',
          'stun:stun4.l.google.com:19302',
        ]
      }
    ]
  };

  void _setState(SignalingState newState) {
    _state = newState;
    notifyListeners();
  }

  // Handle local note taking (doctor side)
  void saveDoctorNotes(String appointmentId, String notes) {
    _doctorNotes[appointmentId] = notes;
    notifyListeners();
  }

  String getDoctorNotes(String appointmentId) {
    return _doctorNotes[appointmentId] ?? "";
  }

  // Request camera and microhone permissions
  Future<bool> requestMediaPermissions() async {
    _setState(SignalingState.requestingPermissions);
    
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && micStatus.isGranted) {
      return true;
    } else {
      _setState(SignalingState.error);
      return false;
    }
  }

  // Initialize Local stream
  Future<void> initializeLocalMedia(RTCVideoRenderer localRenderer) async {
    _setState(SignalingState.initializingWebRTC);
    try {
      final Map<String, dynamic> mediaConstraints = {
        'audio': true,
        'video': {
          'mandatory': {
            'minWidth': '640', 
            'minHeight': '480',
            'minFrameRate': '30',
          },
          'facingMode': 'user',
          'optional': [],
        }
      };

      _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      localRenderer.srcObject = _localStream;
      _isAudioMuted = false;
      _isVideoOff = false;
      _setState(SignalingState.idle);
    } catch (e) {
      if (kDebugMode) print("Error obtaining local media stream: $e");
      _setState(SignalingState.error);
    }
  }

  // Clean initialization of connection
  Future<void> _createPeerConnection(RTCVideoRenderer remoteRenderer) async {
    _peerConnection = await createPeerConnection(_iceServersConfiguration);

    // Track onAddStream
    _peerConnection!.onAddStream = (MediaStream stream) {
      _remoteStream = stream;
      remoteRenderer.srcObject = stream;
      _setState(SignalingState.connected);
      _startCallTimer();
    };

    // Track state change
    _peerConnection!.onConnectionState = (state) {
      if (kDebugMode) print("Connection state changed: $state");
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          _setState(SignalingState.connected);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
          _setState(SignalingState.connecting);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
          _setState(SignalingState.disconnected);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
          _setState(SignalingState.error);
          break;
        default:
          break;
      }
    };

    // Add local stream tracks to the connection
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });
    }
  }

  // Create room as host (e.g. Doctor initiates or Patient opens first)
  Future<String> createRoom(String appointmentId, RTCVideoRenderer localRenderer, RTCVideoRenderer remoteRenderer) async {
    _currentRoomId = appointmentId;
    _setState(SignalingState.initializingWebRTC);

    await _createPeerConnection(remoteRenderer);

    // Get DB reference
    _roomRef = FirebaseDatabase.instance.ref().child('rooms').child(appointmentId);

    // Track ICE Candidates to write to Firebase
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate != null) {
        _roomRef!.child('hostCandidates').push().set({
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      }
    };

    // Create SDP Offer
    RTCSessionDescription offer = await _peerConnection!.createOffer({
      'offerToReceiveAudio': true,
      'offerToReceiveVideo': true,
    });
    await _peerConnection!.setLocalDescription(offer);

    // Save Offer to Firebase
    await _roomRef!.set({
      'offer': {
        'sdp': offer.sdp,
        'type': offer.type,
      },
      'status': 'waiting'
    });

    _setState(SignalingState.waitingForPeer);

    // Listen for Answer from Guest
    _answerSubscription = _roomRef!.child('answer').onValue.listen((event) async {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && _peerConnection != null) {
        final answerDescription = RTCSessionDescription(data['sdp'], data['type']);
        await _peerConnection!.setRemoteDescription(answerDescription);
        _setState(SignalingState.connecting);
      }
    });

    // Listen for guest ICE candidates
    _iceCandidateSubscription = _roomRef!.child('guestCandidates').onChildAdded.listen((event) async {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && _peerConnection != null) {
        final candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );
        await _peerConnection!.addCandidate(candidate);
      }
    });

    return appointmentId;
  }

  // Join room as guest (e.g. Patient connecting to the active Doctor stream)
  Future<void> joinRoom(String appointmentId, RTCVideoRenderer localRenderer, RTCVideoRenderer remoteRenderer) async {
    _currentRoomId = appointmentId;
    _setState(SignalingState.initializingWebRTC);

    await _createPeerConnection(remoteRenderer);

    _roomRef = FirebaseDatabase.instance.ref().child('rooms').child(appointmentId);

    // Track ICE Candidates to write to Firebase as guest
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate != null) {
        _roomRef!.child('guestCandidates').push().set({
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      }
    };

    // Update Status
    await _roomRef!.child('status').set('connecting');

    // Retrieve and set host Offer
    final offerSnap = await _roomRef!.child('offer').get();
    if (offerSnap.exists) {
      final offerData = offerSnap.value as Map<dynamic, dynamic>;
      final offerSdp = RTCSessionDescription(offerData['sdp'], offerData['type']);
      await _peerConnection!.setRemoteDescription(offerSdp);

      // Create SDP Answer
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      // Save Answer to Firebase
      await _roomRef!.child('answer').set({
        'sdp': answer.sdp,
        'type': answer.type,
      });

      _setState(SignalingState.connecting);
    } else {
      _setState(SignalingState.error);
      return;
    }

    // Listen for host ICE Candidates
    _iceCandidateSubscription = _roomRef!.child('hostCandidates').onChildAdded.listen((event) async {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && _peerConnection != null) {
        final candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );
        await _peerConnection!.addCandidate(candidate);
      }
    });
  }

  // Timer helper
  void _startCallTimer() {
    _callDurationSeconds = 0;
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _callDurationSeconds++;
      notifyListeners();
    });
  }

  void _stopCallTimer() {
    _callTimer?.cancel();
    _callTimer = null;
  }

  // Toggle Mute Audio
  void toggleMuteAudio() {
    if (_localStream != null) {
      _isAudioMuted = !_isAudioMuted;
      _localStream!.getAudioTracks().forEach((track) {
        track.enabled = !_isAudioMuted;
      });
      notifyListeners();
    }
  }

  // Toggle Camera
  void toggleCamera() {
    if (_localStream != null) {
      _isVideoOff = !_isVideoOff;
      _localStream!.getVideoTracks().forEach((track) {
        track.enabled = !_isVideoOff;
      });
      notifyListeners();
    }
  }

  // Switch between front/back camera
  Future<void> switchCamera() async {
    if (_localStream != null) {
      final videoTrack = _localStream!.getVideoTracks().firstOrNull;
      if (videoTrack != null) {
        await Helper.switchCamera(videoTrack);
      }
    }
  }

  // Hang Up / End Video call
  Future<void> hangUp() async {
    _stopCallTimer();

    _offerSubscription?.cancel();
    _answerSubscription?.cancel();
    _iceCandidateSubscription?.cancel();

    if (_localStream != null) {
      await _localStream!.dispose();
      _localStream = null;
    }
    if (_remoteStream != null) {
      await _remoteStream!.dispose();
      _remoteStream = null;
    }

    if (_peerConnection != null) {
      await _peerConnection!.close();
      _peerConnection = null;
    }

    // Remove room node on complete or disconnect
    if (_roomRef != null) {
      await _roomRef!.remove();
      _roomRef = null;
    }

    _currentRoomId = null;
    _setState(SignalingState.idle);
  }
}
