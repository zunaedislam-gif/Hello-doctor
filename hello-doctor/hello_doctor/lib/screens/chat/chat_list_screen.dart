import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../models/chat_message_model.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final chatService = Provider.of<ChatService>(context);
    final currentUser = authService.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Chats'),
          backgroundColor: Colors.white,
          foregroundColor: ClinicalTheme.textDark,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 64, color: ClinicalTheme.textSecondary.withOpacity(0.5)),
              const SizedBox(height: 16),
              const Text(
                'Please log in to view chats',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go('/patient-auth'),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }

    final userId = currentUser.id;
    final userRoleName = currentUser.role.name;

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          currentUser.role == UserRole.doctor ? 'Patient Inbox' : 'Doctor Messages',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: ClinicalTheme.textDark,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_chat_read_outlined, color: ClinicalTheme.primaryBlue),
            tooltip: 'Mark all as read',
            onPressed: () {
              // Mark all as read action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All chats marked as read')),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<ChatThread>>(
        stream: chatService.listenToThreads(userId, userRoleName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading chats: ${snapshot.error}',
                style: const TextStyle(color: ClinicalTheme.alertRed),
              ),
            );
          }

          final threads = snapshot.data ?? [];

          if (threads.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 96,
                          width: 96,
                          decoration: BoxDecoration(
                            color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.forum_outlined,
                            size: 40,
                            color: ClinicalTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'No conversations yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ClinicalTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            currentUser.role == UserRole.doctor
                                ? 'When patients connect with you or schedule consultations, they will appear here.'
                                : 'Select a doctor from the specialist portal to initiate an e-consultation chat.',
                            textAlign: Center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: ClinicalTheme.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.separated(
              itemCount: threads.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Color(0xfff0f2f5),
                indent: 80,
              ),
              itemBuilder: (context, index) {
                final thread = threads[index];
                final hasUnread = thread.unreadCount > 0;

                // Format timestamp
                final dt = DateTime.fromMillisecondsSinceEpoch(thread.timestamp);
                final timeStr = _formatTimestamp(dt);

                return InkWell(
                  onTap: () {
                    // Navigate to conversation screen
                    context.push(
                      '/chat-conversation?threadId=${thread.id}&peerId=${thread.participantId}&peerName=${Uri.encodeComponent(thread.participantName)}&peerRole=${thread.participantRole}',
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar
                        Stack(
                          children: [
                            Container(
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  thread.participantRole == 'doctor' ? '👨‍⚕️' : '👨',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            // Green Active Indicator
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 14,
                                width: 14,
                                decoration: BoxDecoration(
                                  color: ClinicalTheme.accentGreen,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                justifyAxisAlignment: MainAxisAlignment.between,
                                children: [
                                  Expanded(
                                    child: Text(
                                      thread.participantName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                                        color: ClinicalTheme.textDark,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    timeStr,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                                      color: hasUnread ? ClinicalTheme.primaryBlue : ClinicalTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              if (thread.participantSpecialty != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  thread.participantSpecialty!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: ClinicalTheme.primaryBlue,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                thread.lastMessage,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                                  color: hasUnread ? ClinicalTheme.textDark : ClinicalTheme.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (hasUnread) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: ClinicalTheme.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${thread.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inDays == 0) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }
}
