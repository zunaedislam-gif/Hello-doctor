import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/chat_message_model.dart';
import '../models/doctor_model.dart';

class ChatService extends ChangeNotifier {
  bool _isFirebaseAvailable = false;
  DatabaseReference? _dbRef;

  // Local state for Simulation Fallback
  final Map<String, List<ChatMessage>> _simulatedMessages = {};
  final Map<String, Map<String, bool>> _simulatedTyping = {}; // threadId -> {userId: bool}
  final List<ChatThread> _simulatedThreads = [];

  bool get isFirebaseAvailable => _isFirebaseAvailable;

  // Stream controllers to feed the UI with real-time updates
  final Map<String, StreamController<List<ChatMessage>>> _messageStreamControllers = {};
  final Map<String, StreamController<bool>> _typingStreamControllers = {};
  StreamController<List<ChatThread>>? _threadsStreamController;

  ChatService() {
    _initializeFirebase();
  }

  // Attempt lazy Firebase initialization
  void _initializeFirebase() {
    try {
      // Check if Firebase is already initialized
      if (Firebase.apps.isNotEmpty) {
        _dbRef = FirebaseDatabase.instance.ref();
        _isFirebaseAvailable = true;
        if (kDebugMode) print("ChatService: Firebase Realtime Database successfully wired.");
      } else {
        if (kDebugMode) print("ChatService: Firebase is not initialized yet. Using Local Simulation Fallback.");
        _setupMockData();
      }
    } catch (e) {
      if (kDebugMode) print("ChatService Init Error (using local simulation fallback): $e");
      _setupMockData();
    }
  }

  // Set up mock threads and messages for high-fidelity offline development/testing
  void _setupMockData() {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Doctor 1 Thread
    final t1Id = "patient_doc_1";
    _simulatedMessages[t1Id] = [
      ChatMessage(
        id: "msg_1",
        senderId: "doc_1",
        senderName: "Dr. Sarah Rahman",
        senderRole: "doctor",
        text: "Hello! Thank you for scheduling your appointment. Do you have any specific symptoms you'd like to share beforehand?",
        timestamp: now - 3600000 * 2, // 2 hours ago
        isRead: true,
      ),
      ChatMessage(
        id: "msg_2",
        senderId: "patient_mock",
        senderName: "Karim",
        senderRole: "patient",
        text: "Yes doctor, I have had a mild fever and throat irritation since yesterday morning.",
        timestamp: now - 3600000 * 1.5,
        isRead: true,
      ),
      ChatMessage(
        id: "msg_3",
        senderId: "doc_1",
        senderName: "Dr. Sarah Rahman",
        senderRole: "doctor",
        text: "I see. Please stay hydrated and rest. We will discuss this in detail during our scheduled video consultation today. You can send over any previous prescriptions or lab reports here as well.",
        timestamp: now - 3600000 * 1.2,
        isRead: false,
      ),
    ];

    // Doctor 3 Thread
    final t2Id = "patient_doc_3";
    _simulatedMessages[t2Id] = [
      ChatMessage(
        id: "msg_4",
        senderId: "doc_3",
        senderName: "Dr. Naila Khan",
        senderRole: "doctor",
        text: "Hi! How is your son doing today? Did the cough syrup help with his sleep?",
        timestamp: now - 3600000 * 24, // 1 day ago
        isRead: true,
      ),
      ChatMessage(
        id: "msg_5",
        senderId: "patient_mock",
        senderName: "Karim",
        senderRole: "patient",
        text: "He is doing much better today! The dry cough has significantly reduced.",
        timestamp: now - 3600000 * 23,
        isRead: true,
      ),
      ChatMessage(
        id: "msg_6",
        senderId: "doc_3",
        senderName: "Dr. Naila Khan",
        senderRole: "doctor",
        text: "Wonderful news! Continue the dose for 2 more days and keep me updated.",
        timestamp: now - 3600000 * 22,
        isRead: true,
      ),
    ];

    _rebuildSimulatedThreads();
  }

  void _rebuildSimulatedThreads() {
    _simulatedThreads.clear();

    _simulatedMessages.forEach((threadId, messages) {
      if (messages.isEmpty) return;
      final lastMsg = messages.last;
      final isDoc1 = threadId.contains("doc_1");
      final isDoc3 = threadId.contains("doc_3");

      String docId = isDoc1 ? "doc_1" : "doc_3";
      String docName = isDoc1 ? "Dr. Sarah Rahman" : "Dr. Naila Khan";
      String specialty = isDoc1 ? "General Physician" : "Pediatrics";

      int unread = messages.where((m) => !m.isRead && m.senderId != "patient_mock").length;

      _simulatedThreads.add(
        ChatThread(
          id: threadId,
          participantId: docId,
          participantName: docName,
          participantRole: "doctor",
          lastMessage: lastMsg.text,
          timestamp: lastMsg.timestamp,
          unreadCount: unread,
          participantSpecialty: specialty,
        ),
      );
    });

    // Sort by timestamp descending
    _simulatedThreads.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Update stream if active
    if (_threadsStreamController != null && !_threadsStreamController!.isClosed) {
      _threadsStreamController!.add(List.from(_simulatedThreads));
    }
  }

  // --- PUBLIC API: LISTEN TO CHAT THREADS LIST ---
  Stream<List<ChatThread>> listenToThreads(String userId, String userRole) {
    if (_threadsStreamController != null && !_threadsStreamController!.isClosed) {
      _threadsStreamController!.close();
    }
    _threadsStreamController = StreamController<List<ChatThread>>.broadcast();

    if (_isFirebaseAvailable && _dbRef != null) {
      // ----------------- FIREBASE REALTIME DB PATH -----------------
      // Real-time listener on active user threads
      final userThreadsRef = _dbRef!.child('user_threads').child(userId);
      
      final subscription = userThreadsRef.onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data == null) {
          _threadsStreamController?.add([]);
          return;
        }

        List<ChatThread> threads = [];
        data.forEach((key, val) {
          final map = val as Map<dynamic, dynamic>;
          threads.add(
            ChatThread(
              id: key,
              participantId: map['participantId'] ?? '',
              participantName: map['participantName'] ?? '',
              participantRole: map['participantRole'] ?? '',
              lastMessage: map['lastMessage'] ?? '',
              timestamp: map['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
              unreadCount: map['unreadCount'] ?? 0,
              participantSpecialty: map['participantSpecialty'],
            ),
          );
        });

        threads.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        _threadsStreamController?.add(threads);
      });

      _threadsStreamController!.onCancel = () {
        subscription.cancel();
      };
    } else {
      // ----------------- SIMULATED REAL-TIME STREAM -----------------
      // Instantly inject existing simulated threads
      Timer(const Duration(milliseconds: 50), () {
        if (_threadsStreamController != null && !_threadsStreamController!.isClosed) {
          _threadsStreamController!.add(List.from(_simulatedThreads));
        }
      });
    }

    return _threadsStreamController!.stream;
  }

  // --- PUBLIC API: LISTEN TO CHAT MESSAGES ---
  Stream<List<ChatMessage>> listenToMessages(String threadId) {
    if (_messageStreamControllers.containsKey(threadId)) {
      _messageStreamControllers[threadId]!.close();
    }
    final controller = StreamController<List<ChatMessage>>.broadcast();
    _messageStreamControllers[threadId] = controller;

    if (_isFirebaseAvailable && _dbRef != null) {
      // ----------------- FIREBASE REALTIME DB PATH -----------------
      final messagesRef = _dbRef!.child('chats').child(threadId).child('messages');
      
      final subscription = messagesRef.onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data == null) {
          controller.add([]);
          return;
        }

        List<ChatMessage> msgs = [];
        data.forEach((key, val) {
          msgs.add(ChatMessage.fromMap(val as Map<dynamic, dynamic>));
        });

        msgs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        controller.add(msgs);
      });

      controller.onCancel = () {
        subscription.cancel();
        _messageStreamControllers.remove(threadId);
      };
    } else {
      // ----------------- SIMULATED REAL-TIME STREAM -----------------
      Timer(const Duration(milliseconds: 100), () {
        if (!controller.isClosed) {
          final list = _simulatedMessages[threadId] ?? [];
          controller.add(List.from(list));
        }
      });
    }

    return controller.stream;
  }

  // --- PUBLIC API: LISTEN TO TYPING STATUS ---
  Stream<bool> listenToTyping(String threadId, String peerId) {
    if (_typingStreamControllers.containsKey(threadId)) {
      _typingStreamControllers[threadId]!.close();
    }
    final controller = StreamController<bool>.broadcast();
    _typingStreamControllers[threadId] = controller;

    if (_isFirebaseAvailable && _dbRef != null) {
      // ----------------- FIREBASE REALTIME DB PATH -----------------
      final typingRef = _dbRef!.child('chats').child(threadId).child('typing').child(peerId);
      final subscription = typingRef.onValue.listen((event) {
        final val = event.snapshot.value as bool?;
        controller.add(val ?? false);
      });

      controller.onCancel = () {
        subscription.cancel();
        _typingStreamControllers.remove(threadId);
      };
    } else {
      // ----------------- SIMULATED REAL-TIME STREAM -----------------
      Timer(const Duration(milliseconds: 50), () {
        if (!controller.isClosed) {
          final isTyping = _simulatedTyping[threadId]?[peerId] ?? false;
          controller.add(isTyping);
        }
      });
    }

    return controller.stream;
  }

  // --- PUBLIC API: SEND MESSAGE ---
  Future<void> sendMessage(String threadId, ChatMessage message) async {
    if (_isFirebaseAvailable && _dbRef != null) {
      // ----------------- FIREBASE REALTIME DB PATH -----------------
      final chatsNode = _dbRef!.child('chats').child(threadId);
      
      // 1. Push message
      await chatsNode.child('messages').child(message.id).set(message.toMap());

      // 2. Update user threads for both sender and receiver to show preview
      await _dbRef!.child('user_threads').child(message.senderId).child(threadId).set({
        'participantId': threadId.replaceAll(message.senderId, "").replaceAll("_", ""),
        'participantName': 'Chat Partner', // Can be refined
        'participantRole': message.senderRole == 'patient' ? 'doctor' : 'patient',
        'lastMessage': message.text.isNotEmpty ? message.text : '📷 Sent an image',
        'timestamp': message.timestamp,
        'unreadCount': 0,
      });

      final receiverId = threadId.replaceAll(message.senderId, "").replaceAll("_", "");
      final receiverThreadRef = _dbRef!.child('user_threads').child(receiverId).child(threadId);
      final currentUnreadSnap = await receiverThreadRef.child('unreadCount').get();
      int currentUnread = (currentUnreadSnap.value as int?) ?? 0;

      await receiverThreadRef.set({
        'participantId': message.senderId,
        'participantName': message.senderName,
        'participantRole': message.senderRole,
        'lastMessage': message.text.isNotEmpty ? message.text : '📷 Sent an image',
        'timestamp': message.timestamp,
        'unreadCount': currentUnread + 1,
      });

    } else {
      // ----------------- SIMULATED REAL-TIME PATH -----------------
      if (!_simulatedMessages.containsKey(threadId)) {
        _simulatedMessages[threadId] = [];
      }
      _simulatedMessages[threadId]!.add(message);
      _rebuildSimulatedThreads();

      // Trigger message stream refresh
      if (_messageStreamControllers.containsKey(threadId)) {
        _messageStreamControllers[threadId]!.add(List.from(_simulatedMessages[threadId]!));
      }

      // If sent by patient, simulate doctor response
      if (message.senderRole == 'patient') {
        _triggerMockDoctorReply(threadId, message);
      }
    }
  }

  // --- PUBLIC API: UPDATE TYPING STATUS ---
  Future<void> setTypingStatus(String threadId, String userId, bool isTyping) async {
    if (_isFirebaseAvailable && _dbRef != null) {
      // ----------------- FIREBASE REALTIME DB PATH -----------------
      await _dbRef!.child('chats').child(threadId).child('typing').child(userId).set(isTyping);
    } else {
      // ----------------- SIMULATED REAL-TIME PATH -----------------
      if (!_simulatedTyping.containsKey(threadId)) {
        _simulatedTyping[threadId] = {};
      }
      _simulatedTyping[threadId]![userId] = isTyping;

      if (_typingStreamControllers.containsKey(threadId)) {
        _typingStreamControllers[threadId]!.add(isTyping);
      }
    }
  }

  // --- PUBLIC API: MARK MESSAGES AS READ ---
  Future<void> markAsRead(String threadId, String userId) async {
    if (_isFirebaseAvailable && _dbRef != null) {
      // ----------------- FIREBASE REALTIME DB PATH -----------------
      // Reset unread count for user thread
      await _dbRef!.child('user_threads').child(userId).child(threadId).child('unreadCount').set(0);
    } else {
      // ----------------- SIMULATED REAL-TIME PATH -----------------
      final list = _simulatedMessages[threadId];
      if (list != null) {
        for (var i = 0; i < list.length; i++) {
          if (list[i].senderId != userId) {
            list[i] = list[i].copyWith(isRead: true);
          }
        }
        _rebuildSimulatedThreads();
        if (_messageStreamControllers.containsKey(threadId)) {
          _messageStreamControllers[threadId]!.add(List.from(list));
        }
      }
    }
  }

  // --- PRIVATE HELPERS: MOCK DOCTOR CONVERSATIONAL ENGINE ---
  void _triggerMockDoctorReply(String threadId, ChatMessage patientMsg) {
    final doctorId = threadId.replaceAll("patient_", "");
    String docName = doctorId == "doc_1" ? "Dr. Sarah Rahman" : "Dr. Naila Khan";
    String docRole = "doctor";

    // Start doctor typing simulation after 800ms
    Timer(const Duration(milliseconds: 800), () {
      _simulatedTyping[threadId] ??= {};
      _simulatedTyping[threadId]![doctorId] = true;
      if (_typingStreamControllers.containsKey(threadId)) {
        _typingStreamControllers[threadId]!.add(true);
      }

      // Send doctor reply after 3 seconds of typing
      Timer(const Duration(milliseconds: 2500), () {
        _simulatedTyping[threadId]![doctorId] = false;
        if (_typingStreamControllers.containsKey(threadId)) {
          _typingStreamControllers[threadId]!.add(false);
        }

        String responseText = "Understood. I have logged this description in your record. Let's make sure we review this during our call today.";
        final pText = patientMsg.text.toLowerCase();

        if (pText.contains("fever") || pText.contains("temperature")) {
          responseText = "For your fever, please monitor your temperature every 6 hours. You may take Paracetamol 500mg if it exceeds 100°F. Rest well.";
        } else if (pText.contains("pain") || pText.contains("hurt")) {
          responseText = "Pain noted. Where is it located precisely? Please avoid heavy physical exertion until our consultation call.";
        } else if (pText.contains("cough") || pText.contains("throat")) {
          responseText = "Warm saline gargles 3-4 times a day will soothe your throat irritation. I will prescribe an appropriate syrup during our consult.";
        } else if (patientMsg.imageUrl != null) {
          responseText = "Thank you for sending the image attachment. I am reviewing the symptom photo now and will keep it reference-ready for our slot!";
        }

        final docMsg = ChatMessage(
          id: "msg_sim_${DateTime.now().millisecondsSinceEpoch}",
          senderId: doctorId,
          senderName: docName,
          senderRole: docRole,
          text: responseText,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          isRead: false,
        );

        if (!_simulatedMessages.containsKey(threadId)) {
          _simulatedMessages[threadId] = [];
        }
        _simulatedMessages[threadId]!.add(docMsg);
        _rebuildSimulatedThreads();

        if (_messageStreamControllers.containsKey(threadId)) {
          _messageStreamControllers[threadId]!.add(List.from(_simulatedMessages[threadId]!));
        }
      });
    });
  }
}
