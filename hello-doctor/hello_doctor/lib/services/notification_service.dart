import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  final List<Map<String, dynamic>> _notifications = [
    {
      "id": "1",
      "title": "Appointment Reminder",
      "body": "Your video consultation with Dr. Sarah Rahman starts in 15 minutes.",
      "time": "Just now",
      "type": "reminder",
      "isRead": false
    },
    {
      "id": "2",
      "title": "Order Status Changed",
      "body": "Your medicine order (ID: RX-84920) is packaged and dispatched.",
      "time": "2 hours ago",
      "type": "order",
      "isRead": false
    },
    {
      "id": "3",
      "title": "New Feed Activity",
      "body": "Dr. Sarah Rahman posted a new medical tip about Hypertension control.",
      "time": "Today, 10:00 AM",
      "type": "feed",
      "isRead": true
    }
  ];

  List<Map<String, dynamic>> get notifications => _notifications;

  Future<void> init() async {
    if (_initialized) return;

    try {
      const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Handle notification click if needed
        },
      );
      _initialized = true;
    } catch (e) {
      debugPrint("Local Notifications failed to init (running in Web/Simulator mode): $e");
    }
  }

  Future<void> showNotification({required int id, required String title, required String body}) async {
    // Also push to our live list so the UI displays it immediately!
    _notifications.insert(0, {
      "id": id.toString(),
      "title": title,
      "body": body,
      "time": "Just now",
      "type": "reminder",
      "isRead": false
    });
    notifyListeners();

    try {
      if (!_initialized) await init();

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'hello_doctor_channel',
        'Hello Doctor Notifications',
        channelDescription: 'Clinical reminders & status alerts',
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      await _localNotificationsPlugin.show(id, title, body, platformDetails);
    } catch (e) {
      debugPrint("Local Notification trigger skipped (web/mock environment fallback): $e");
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n["isRead"] = true;
    }
    notifyListeners();
  }

  void toggleRead(String id) {
    final idx = _notifications.indexWhere((n) => n["id"] == id);
    if (idx != -1) {
      _notifications[idx]["isRead"] = !_notifications[idx]["isRead"];
      notifyListeners();
    }
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n["id"] == id);
    notifyListeners();
  }
}
