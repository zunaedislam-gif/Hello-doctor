import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../services/notification_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ClinicalTheme.textDark, size: 20),
          onPressed: () => context.go('/patient-home'),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ClinicalTheme.textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: ClinicalTheme.primaryBlue),
            tooltip: 'Mark all as read',
            onPressed: () {
              Provider.of<NotificationService>(context, listen: false).markAllAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read.')),
              );
            },
          )
        ],
      ),
      body: Consumer<NotificationService>(
        builder: (context, service, child) {
          final list = service.notifications;

          return Column(
            children: [
              // Interactive test controls banner
              Container(
                color: ClinicalTheme.primaryBlue.withOpacity(0.05),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.campaign_rounded, color: ClinicalTheme.primaryBlue, size: 20),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Simulate Local Reminders:',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 11.5, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        service.showNotification(
                          id: DateTime.now().millisecondsSinceEpoch % 100000,
                          title: 'Appt Starting Soon',
                          body: 'Your scheduled video consultation with Dr. Sarah Rahman is starting in 5 minutes. Tap to join!',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ClinicalTheme.primaryBlue,
                        minimumSize: const Size(60, 26),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text('Appt Soon', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      onPressed: () {
                        service.showNotification(
                          id: DateTime.now().millisecondsSinceEpoch % 100000 + 1,
                          title: 'Order Completed',
                          body: 'Your diagnostic center test report (Sample: CBC-839) is verified and ready for download!',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        minimumSize: const Size(60, 26),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text('Order Ready', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: list.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final notif = list[index];
                          return _buildNotificationCard(context, notif, service);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ClinicalTheme.primaryBlue.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_none_rounded, size: 60, color: ClinicalTheme.primaryBlue),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Notifications',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: ClinicalTheme.textDark),
            ),
            const SizedBox(height: 6),
            const Text(
              'You have caught up with all clinic updates & diagnostic reminders.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: ClinicalTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, Map<String, dynamic> notif, NotificationService service) {
    final bool isRead = notif["isRead"] == true;
    final String type = notif["type"] ?? 'reminder';
    
    IconData leadingIcon = Icons.notifications_active_rounded;
    Color leadingColor = ClinicalTheme.primaryBlue;

    if (type == 'order') {
      leadingIcon = Icons.shopping_bag_rounded;
      leadingColor = Colors.orange;
    } else if (type == 'feed') {
      leadingIcon = Icons.explore_rounded;
      leadingColor = Colors.purple;
    }

    return Dismissible(
      key: Key(notif["id"]),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: ClinicalTheme.alertRed,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_forever_rounded, color: Colors.white),
      ),
      onDismissed: (direction) {
        service.deleteNotification(notif["id"]);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted.')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : ClinicalTheme.primaryBlue.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead ? Colors.grey.withOpacity(0.08) : ClinicalTheme.primaryBlue.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            service.toggleRead(notif["id"]);
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: leadingColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(leadingIcon, color: leadingColor, size: 18),
                ),
                const SizedBox(width: 12),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Expanded(
                            child: Text(
                              notif["title"],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: isRead ? FontWeight.bold : FontWeight.extrabold,
                                fontSize: 13,
                                color: ClinicalTheme.textDark,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: ClinicalTheme.primaryBlue,
                                shape: BoxShape.circle,
                              ),
                            )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif["body"],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.5,
                          color: isRead ? ClinicalTheme.textSecondary : ClinicalTheme.textDark,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notif["time"],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
