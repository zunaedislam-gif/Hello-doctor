import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../../services/health_feed_service.dart';
import '../../models/post_model.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  List<String> _attachedImagePaths = [];
  String? _attachedVideoPath;
  PostMediaType _mediaType = PostMediaType.none;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  /// Picker for multiple images
  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _attachedImagePaths.addAll(images.map((img) => img.path));
          _mediaType = PostMediaType.image;
          // Clear video if image is selected to keep layout clean
          _attachedVideoPath = null;
        });
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  /// Picker for video (ImagePicker or FilePicker)
  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _attachedVideoPath = video.path;
          _mediaType = PostMediaType.video;
          // Clear images if video is picked
          _attachedImagePaths = [];
        });
      }
    } catch (e) {
      debugPrint("Error picking video: $e");
    }
  }

  /// Alternate file-based video picker (Free resource)
  Future<void> _pickVideoFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _attachedVideoPath = result.files.single.path;
          _mediaType = PostMediaType.video;
          _attachedImagePaths = [];
        });
      }
    } catch (e) {
      debugPrint("Error picking video file: $e");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _attachedImagePaths.removeAt(index);
      if (_attachedImagePaths.isEmpty) {
        _mediaType = PostMediaType.none;
      }
    });
  }

  void _removeVideo() {
    setState(() {
      _attachedVideoPath = null;
      _mediaType = PostMediaType.none;
    });
  }

  Future<void> _submitPost() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final feedService = Provider.of<HealthFeedService>(context, listen: false);
    final user = authService.currentUser;

    if (user == null) return;
    if (_captionController.text.trim().isEmpty && _attachedImagePaths.isEmpty && _attachedVideoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add some text or attach media before posting.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final mediaList = _mediaType == PostMediaType.image 
        ? _attachedImagePaths 
        : (_attachedVideoPath != null ? [_attachedVideoPath!] : <String>[]);

    final success = await feedService.createPost(
      author: user,
      text: _captionController.text.trim(),
      mediaPaths: mediaList,
      mediaType: _mediaType,
    );

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: ClinicalTheme.accentGreen,
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text('Post shared successfully on Health Feed!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
        context.pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Failed to share post. Only verified professionals can create posts.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    final isEnglish = true; // Default or can fetch from language controller

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please sign in first")),
      );
    }

    // Assign appropriate badge coloring & role label
    Color roleColor = ClinicalTheme.primaryBlue;
    String roleLabel = "Professional";
    String avatarEmoji = "🩺";

    if (user.role == UserRole.doctor) {
      roleColor = ClinicalTheme.primaryBlue;
      roleLabel = isEnglish ? "Doctor" : "ডাক্তার";
      avatarEmoji = "🩺";
    } else if (user.role == UserRole.pharmacy) {
      roleColor = ClinicalTheme.accentGreen;
      roleLabel = isEnglish ? "Pharmacy" : "ফার্মেসি";
      avatarEmoji = "💊";
    } else if (user.role == UserRole.diagnostic) {
      roleColor = Colors.purple;
      roleLabel = isEnglish ? "Diagnostic Centre" : "ডায়াগনস্টিক";
      avatarEmoji = "🔬";
    } else if (user.role == UserRole.admin) {
      roleColor = Colors.redAccent;
      roleLabel = isEnglish ? "Admin" : "অ্যাডমিন";
      avatarEmoji = "🛡️";
    }

    final canPost = _captionController.text.trim().isNotEmpty || 
                     _attachedImagePaths.isNotEmpty || 
                     _attachedVideoPath != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Create Post' : 'পোস্ট তৈরি করুন',
          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.extrabold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        foregroundColor: ClinicalTheme.textDark,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: _isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: ClinicalTheme.primaryBlue),
                  )
                : TextButton(
                    onPressed: canPost ? _submitPost : null,
                    style: TextButton.styleFrom(
                      backgroundColor: canPost ? ClinicalTheme.primaryBlue : Colors.grey.shade100,
                      foregroundColor: canPost ? Colors.white : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    child: Text(
                      isEnglish ? 'Post' : 'পোস্ট',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author Info Header Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: roleColor.withOpacity(0.08),
                        child: Text(avatarEmoji, style: const TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              color: ClinicalTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: roleColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              roleLabel,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.extrabold,
                                color: roleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Caption Input Area
                  TextField(
                    controller: _captionController,
                    maxLines: null,
                    onChanged: (val) {
                      setState(() {}); // Rebuild button state
                    },
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(fontSize: 15, color: ClinicalTheme.textDark, height: 1.45),
                    decoration: InputDecoration(
                      hintText: isEnglish ? "What's on your mind?" : "আপনি এখন কী ভাবছেন?",
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400, fontWeight: FontWeight.normal),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // live Preview for Multiple Images
                  if (_attachedImagePaths.isNotEmpty) ...[
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Text(
                      'ATTACHED IMAGES (${_attachedImagePaths.length})',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _attachedImagePaths.length,
                        itemBuilder: (ctx, idx) {
                          final path = _attachedImagePaths[idx];
                          return Container(
                            width: 110,
                            margin: const EdgeInsets.only(right: 10),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(path),
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(idx),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  // Live Preview for Video
                  if (_attachedVideoPath != null) ...[
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Text(
                      'ATTACHED VIDEO',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.12)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.movie_creation_outlined, color: Colors.blue),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _attachedVideoPath!.split('/').last,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Ready to upload and attach',
                                  style: TextStyle(fontSize: 10.5, color: ClinicalTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel_rounded, color: Colors.grey),
                            onPressed: _removeVideo,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Attachment action bar at the bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1.2)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Text(
                    isEnglish ? "Add to your post:" : "পোস্টে যোগ করুন:",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ClinicalTheme.textSecondary),
                  ),
                  const Spacer(),
                  
                  // Pick Photos Button
                  IconButton(
                    icon: const Icon(Icons.photo_library_rounded, color: Colors.green, size: 24),
                    tooltip: isEnglish ? "Attach Photos" : "ছবি যোগ করুন",
                    onPressed: _pickImages,
                  ),
                  
                  // Pick Video Button (using Image Picker video selector)
                  IconButton(
                    icon: const Icon(Icons.video_library_rounded, color: Colors.redAccent, size: 24),
                    tooltip: isEnglish ? "Attach Video (Gallery)" : "ভিডিও যোগ করুন (গ্যালারি)",
                    onPressed: _pickVideo,
                  ),

                  // Pick Video via File Picker
                  IconButton(
                    icon: const Icon(Icons.folder_open_rounded, color: Colors.orange, size: 24),
                    tooltip: isEnglish ? "Attach Video (File)" : "ভিডিও ফাইল সিলেক্ট করুন",
                    onPressed: _pickVideoFile,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
