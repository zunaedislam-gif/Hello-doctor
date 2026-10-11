import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme.dart';
import '../../models/chat_message_model.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';

class ChatConversationScreen extends StatefulWidget {
  final String threadId;
  final String peerId;
  final String peerName;
  final String peerRole;

  const ChatConversationScreen({
    super.key,
    required this.threadId,
    required this.peerId,
    required this.peerName,
    required this.peerRole,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  
  bool _isTyping = false;
  DateTime? _lastTypeTime;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    // Mark thread messages as read upon entering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthService>(context, listen: false);
      if (auth.currentUser != null) {
        Provider.of<ChatService>(context, listen: false)
            .markAsRead(widget.threadId, auth.currentUser!.id);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  // Handle typing indicator trigger
  void _onTextChanged(String text) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);
    final currentUser = auth.currentUser;
    if (currentUser == null) return;

    if (text.isNotEmpty) {
      _lastTypeTime = DateTime.now();
      if (!_isTyping) {
        _isTyping = true;
        chatService.setTypingStatus(widget.threadId, currentUser.id, true);
      }

      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 2), () {
        if (_isTyping && _lastTypeTime != null) {
          final difference = DateTime.now().difference(_lastTypeTime!);
          if (difference.inSeconds >= 2) {
            _isTyping = false;
            chatService.setTypingStatus(widget.threadId, currentUser.id, false);
          }
        }
      });
    } else {
      if (_isTyping) {
        _isTyping = false;
        chatService.setTypingStatus(widget.threadId, currentUser.id, false);
      }
    }
  }

  // Send textual message
  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final auth = Provider.of<AuthService>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);
    final currentUser = auth.currentUser;
    if (currentUser == null) return;

    final msg = ChatMessage(
      id: "msg_${DateTime.now().millisecondsSinceEpoch}",
      senderId: currentUser.id,
      senderName: currentUser.name,
      senderRole: currentUser.role.name,
      text: text,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    chatService.sendMessage(widget.threadId, msg);
    _textController.clear();
    
    // Stop typing indicator on send
    if (_isTyping) {
      _isTyping = false;
      chatService.setTypingStatus(widget.threadId, currentUser.id, false);
    }

    _scrollToBottom();
  }

  // Support sending images from camera or gallery
  Future<void> _pickAndSendImage(ImageSource source) async {
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70, // compressed for faster telemetry
      );

      if (file == null) return;

      final auth = Provider.of<AuthService>(context, listen: false);
      final chatService = Provider.of<ChatService>(context, listen: false);
      final currentUser = auth.currentUser;
      if (currentUser == null) return;

      // Create a visual indicator that an attachment is uploading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(strokeWidth: 2),
              SizedBox(width: 16),
              Text("Uploading secure diagnostic image...")
            ],
          ),
          duration: Duration(seconds: 1),
        ),
      );

      // In a real production deployment, you would upload the file to Firebase Storage
      // and get the download URL:
      //
      // String remoteUrl = await uploadToFirebaseStorage(file);
      //
      // For this high-fidelity prototype, we'll store the local path or Base64 encoded string
      // so it shows instantly and renders natively in both local and remote devices.
      final bytes = await file.readAsBytes();
      final base64Image = "data:image/png;base64,${base64Encode(bytes)}";

      final msg = ChatMessage(
        id: "msg_${DateTime.now().millisecondsSinceEpoch}",
        senderId: currentUser.id,
        senderName: currentUser.name,
        senderRole: currentUser.role.name,
        text: "", // Empty text for image attachment
        imageUrl: base64Image, // Encoded high-fidelity thumbnail
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      await chatService.sendMessage(widget.threadId, msg);
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error attaching media: $e")),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Opens fullscreen interactive photo review
  void _openFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: _renderImageWidget(imageUrl, fit: BoxFit.contain),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.white24,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final auth = Provider.of<AuthService>(context);
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("Access Denied")));
    }

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: ClinicalTheme.textDark,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.peerRole == 'doctor' ? '👨‍⚕️' : '👨',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.peerName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        height: 6,
                        width: 6,
                        decoration: const BoxDecoration(
                          color: ClinicalTheme.accentGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.peerRole == 'doctor' ? 'Practitioner Online' : 'Patient Active',
                        style: const TextStyle(fontSize: 10, color: ClinicalTheme.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: ClinicalTheme.primaryBlue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Voice calls require WebRTC connection. Use 'Consult Now' to start.")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.video_call_outlined, color: ClinicalTheme.primaryBlue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Video sessions can be initiated from appointment slots.")),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Message stream list
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: chatService.listenToMessages(widget.threadId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data ?? [];
                
                // Read confirmation trigger
                if (messages.isNotEmpty) {
                  chatService.markAsRead(widget.threadId, currentUser.id);
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
                });

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 48, color: ClinicalTheme.primaryBlue.withOpacity(0.15)),
                        const SizedBox(height: 16),
                        const Text(
                          'End-to-End Encrypted Chat',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: ClinicalTheme.textDark),
                        ),
                        const SizedBox(height: 6),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48),
                          child: Text(
                            'All messages, attachments, and prescriptions are stored securely and visible only to you and your practitioner.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUser.id;
                    final dt = DateTime.fromMillisecondsSinceEpoch(msg.timestamp);
                    final timeStr = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMe ? ClinicalTheme.primaryBlue : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                                  bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image Thumbnail render
                                  if (msg.imageUrl != null) ...[
                                    GestureDetector(
                                      onTap: () => _openFullScreenImage(msg.imageUrl!),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          maxHeight: 180,
                                          width: double.infinity,
                                          child: _renderImageWidget(msg.imageUrl!, fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                    if (msg.text.isNotEmpty) const SizedBox(height: 8),
                                  ],
                                  if (msg.text.isNotEmpty)
                                    Text(
                                      msg.text,
                                      style: TextStyle(
                                        color: isMe ? Colors.white : ClinicalTheme.textDark,
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                timeStr,
                                style: const TextStyle(fontSize: 10, color: ClinicalTheme.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Real-time "Typing..." Status Banner
          StreamBuilder<bool>(
            stream: chatService.listenToTyping(widget.threadId, widget.peerId),
            builder: (context, snapshot) {
              final isPeerTyping = snapshot.data ?? false;
              if (!isPeerTyping) return const SizedBox.shrink();

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 1.5, color: ClinicalTheme.primaryBlue),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.peerName} is typing...',
                      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: ClinicalTheme.primaryBlue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            },
          ),

          // Message Input Toolbar
          Container(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              top: 12,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xfff0f2f5))),
            ),
            child: Row(
              children: [
                // Media attachment triggers
                IconButton(
                  icon: const Icon(Icons.sentiment_satisfied_alt_outlined, color: ClinicalTheme.textSecondary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Emojis integrated with keyboard layout")),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined, color: ClinicalTheme.textSecondary),
                  onPressed: () => _pickAndSendImage(ImageSource.camera),
                ),
                IconButton(
                  icon: const Icon(Icons.photo_outlined, color: ClinicalTheme.textSecondary),
                  onPressed: () => _pickAndSendImage(ImageSource.gallery),
                ),
                // Text field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: ClinicalTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: TextField(
                      controller: _textController,
                      onChanged: _onTextChanged,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      style: const TextStyle(fontSize: 14, color: ClinicalTheme.textDark),
                      decoration: const InputDecoration(
                        hintText: 'Ask a clinical question...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Microphone (Voice record placeholder) / Send Button
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    final hasText = _textController.text.trim().isNotEmpty;
                    return InkWell(
                      onTap: hasText ? _sendMessage : _showVoiceNoteBottomSheet,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: ClinicalTheme.primaryBlue,
                        child: Icon(
                          hasText ? Icons.send : Icons.mic,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Voice Note Recording Placeholder Sheet
  void _showVoiceNoteBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: 220,
        child: Column(
          children: [
            const Text(
              "Secure Voice Consultant",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: ClinicalTheme.textDark),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic, size: 48, color: ClinicalTheme.primaryBlue),
                    SizedBox(height: 12),
                    Text(
                      "Release or tap to record clinical voice description.",
                      style: TextStyle(fontSize: 12, color: ClinicalTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Voice recording prototype completed.")),
                );
              },
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

  // Decodes or renders Base64 / local paths / remote URLs
  Widget _renderImageWidget(String url, {required BoxFit fit}) {
    if (url.startsWith('data:image/')) {
      final base64String = url.split(',').last;
      try {
        return Image.memory(base64Decode(base64String), fit: fit);
      } catch (e) {
        return const Icon(Icons.broken_image, color: Colors.grey);
      }
    } else if (url.startsWith('http') || url.startsWith('https')) {
      return Image.network(
        url,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
      );
    } else {
      return Image.file(
        File(url),
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
  }
}
