import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/health_feed_service.dart';
import '../../widgets/post_video_player.dart';
import 'create_post_screen.dart';

class HealthFeedScreen extends StatelessWidget {
  final bool isTabMode; // Set to true if loaded inside bottom navigation tab

  const HealthFeedScreen({super.key, this.isTabMode = false});

  String _formatTimestamp(DateTime timestamp, bool isEnglish) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return isEnglish ? 'Just now' : 'এইমাত্র';
    } else if (difference.inMinutes < 60) {
      return isEnglish 
          ? '${difference.inMinutes} mins ago' 
          : '${difference.inMinutes} মিনিট আগে';
    } else if (difference.inHours < 24) {
      return isEnglish 
          ? '${difference.inHours} hrs ago' 
          : '${difference.inHours} ঘণ্টা আগে';
    } else if (difference.inDays < 7) {
      return isEnglish 
          ? '${difference.inDays} days ago' 
          : '${difference.inDays} দিন আগে';
    } else {
      return "${timestamp.day.toString().padLeft(2, '0')}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.year}";
    }
  }

  void _showProfessionalOnlyDialog(BuildContext context, bool isEnglish) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.gpp_maybe_rounded, color: Colors.amber.shade800, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isEnglish ? 'Verified Posts Only' : 'শুধুমাত্র যাচাইকৃত পোস্ট',
                style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(
          isEnglish 
              ? 'Only verified medical professionals, diagnostic labs, and licensed pharmacies can create posts to prevent medical misinformation.' 
              : 'চিকিৎসা সংক্রান্ত ভুল তথ্য প্রতিরোধ করতে শুধুমাত্র যাচাইকৃত ডাক্তার, ল্যাব এবং নিবন্ধিত ফার্মেসি পোস্ট শেয়ার করতে পারেন।',
          style: const TextStyle(fontSize: 13, height: 1.45, color: ClinicalTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              backgroundColor: ClinicalTheme.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(isEnglish ? 'Understood' : 'বুঝতে পেরেছি', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, HealthPost post, UserModel currentUser, bool isEnglish) {
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return ChangeNotifierProvider.value(
          value: Provider.of<HealthFeedService>(context),
          child: Consumer<HealthFeedService>(
            builder: (context, feedService, child) {
              // Retrieve updated post details in real time from provider
              final currentPost = feedService.posts.firstWhere((p) => p.id == post.id, orElse: () => post);
              
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle Bar / Drag indicator
                    const SizedBox(height: 10),
                    Container(
                      width: 44,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Title Header Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Text(
                            isEnglish 
                                ? 'Comments (${currentPost.commentsCount})' 
                                : 'মন্তব্য সমূহ (${currentPost.commentsCount})',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.extrabold,
                              fontSize: 15,
                              color: ClinicalTheme.textDark,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),

                    // Scrollable Comments List
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.45,
                        minHeight: 120,
                      ),
                      child: currentPost.comments.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.forum_outlined, color: Colors.grey.shade300, size: 40),
                                  const SizedBox(height: 8),
                                  Text(
                                    isEnglish ? 'No comments yet. Start the discussion!' : 'কোনো মন্তব্য নেই। প্রথম মন্তব্যটি করুন!',
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(16),
                              itemCount: currentPost.comments.length,
                              itemBuilder: (context, index) {
                                final comm = currentPost.comments[index];
                                final badgeColor = _getBadgeColor(comm.authorRole);
                                
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: badgeColor.withOpacity(0.08),
                                        child: Text(comm.authorAvatar, style: const TextStyle(fontSize: 12)),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(color: Colors.grey.withOpacity(0.05)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    comm.authorName,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      color: ClinicalTheme.textDark,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                                    decoration: BoxDecoration(
                                                      color: badgeColor.withOpacity(0.08),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      comm.authorRole,
                                                      style: TextStyle(
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.extrabold,
                                                        color: badgeColor,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    _formatTimestamp(comm.timestamp, isEnglish),
                                                    style: TextStyle(fontSize: 8.5, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                comm.text,
                                                style: const TextStyle(fontSize: 12.5, color: ClinicalTheme.textDark, height: 1.35),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const Divider(height: 1),

                    // Keyboard input text bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              style: const TextStyle(fontSize: 13.5),
                              decoration: InputDecoration(
                                hintText: isEnglish ? 'Write a comment...' : 'একটি মন্তব্য লিখুন...',
                                hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1.2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1.2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: const BorderSide(color: ClinicalTheme.primaryBlue, width: 1.2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send_rounded, color: ClinicalTheme.primaryBlue),
                            onPressed: () async {
                              final text = commentController.text.trim();
                              if (text.isEmpty) return;

                              await feedService.addComment(
                                postId: currentPost.id,
                                commenter: currentUser,
                                commentText: text,
                              );
                              commentController.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color _getBadgeColor(String role) {
    switch (role) {
      case 'Doctor':
        return ClinicalTheme.primaryBlue;
      case 'Pharmacy':
        return ClinicalTheme.accentGreen;
      case 'Diagnostic Centre':
        return Colors.purple;
      case 'Admin':
        return Colors.redAccent;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final feedService = Provider.of<HealthFeedService>(context);
    final user = authService.currentUser;
    final isEnglish = true; // Bilingual check

    if (user == null) {
      return Scaffold(
        backgroundColor: ClinicalTheme.backgroundLight,
        body: const Center(child: Text("Please login to see the Health Feed.")),
      );
    }

    final isPatient = user.role == UserRole.patient;

    // Outer shell Scaffold only if we are in normal route mode.
    // If we are nested inside patient bottom bar tab, don't nest scaffold unless preferred.
    final feedWidget = _buildFeedBody(context, feedService, user, isPatient, isEnglish);

    if (isTabMode) {
      return feedWidget;
    }

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Health Feed',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.extrabold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        foregroundColor: ClinicalTheme.textDark,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: feedWidget,
    );
  }

  Widget _buildFeedBody(
    BuildContext context, 
    HealthFeedService feedService, 
    UserModel user, 
    bool isPatient, 
    bool isEnglish
  ) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Create Post Header Bar Box
        _buildCreatePostHeader(context, user, isPatient, isEnglish),
        const SizedBox(height: 16),

        // 2. Real-time Database Posts list
        if (feedService.isLoading && feedService.posts.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 48.0),
              child: CircularProgressIndicator(color: ClinicalTheme.primaryBlue),
            ),
          )
        else if (feedService.posts.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0),
              child: Column(
                children: [
                  Icon(Icons.dynamic_feed_rounded, color: Colors.grey.shade300, size: 50),
                  const SizedBox(height: 12),
                  const Text(
                    'No posts available on Health Feed.',
                    style: TextStyle(color: ClinicalTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        else
          ...feedService.posts.map((post) {
            return _buildPostCard(context, feedService, post, user, isEnglish);
          }),
      ],
    );
  }

  /// Interactive top bar to write e-posts
  Widget _buildCreatePostHeader(BuildContext context, UserModel user, bool isPatient, bool isEnglish) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.08),
                  child: Text(
                    isPatient ? "👤" : (user.role == UserRole.doctor ? "🩺" : user.role == UserRole.pharmacy ? "💊" : "🔬"), 
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (isPatient) {
                        _showProfessionalOnlyDialog(context, isEnglish);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => const CreatePostScreen()),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.withOpacity(0.08)),
                      ),
                      child: Text(
                        isPatient 
                            ? (isEnglish ? "Only verified professionals can post..." : "শুধুমাত্র স্বাস্থ্য পেশাদাররা পোস্ট করতে পারবেন...")
                            : (isEnglish ? "What's on your mind?" : "আপনি এখন কী ভাবছেন?"),
                        style: TextStyle(
                          fontSize: 12, 
                          color: isPatient ? Colors.grey.shade400 : Colors.grey.shade600,
                          fontWeight: isPatient ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isPatient) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.lock_outline_rounded, color: Colors.grey.shade400, size: 18),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Facebook-style Social Feed Post Card Layout
  Widget _buildPostCard(
    BuildContext context, 
    HealthFeedService feedService, 
    HealthPost post, 
    UserModel currentUser,
    bool isEnglish
  ) {
    final hasLiked = post.likedByUids.contains(currentUser.id);
    final badgeColor = _getBadgeColor(post.authorRole);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0.5,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header block
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: badgeColor.withOpacity(0.08),
                  child: Text(post.authorAvatar, style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            post.authorName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: ClinicalTheme.textDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: badgeColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              post.authorRole,
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.extrabold,
                                color: badgeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatTimestamp(post.timestamp, isEnglish),
                        style: const TextStyle(fontSize: 9.5, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz_rounded, size: 18, color: ClinicalTheme.textSecondary),
                  onPressed: () {
                    // Quick post context options
                  },
                ),
              ],
            ),
          ),

          // Post Text Caption content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, bottom: 12.0),
            child: Text(
              post.content,
              style: const TextStyle(
                fontSize: 13, 
                color: ClinicalTheme.textDark, 
                height: 1.4,
              ),
            ),
          ),

          // Attached media section (images or video player)
          if (post.mediaUrls.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, bottom: 14.0),
              child: post.mediaType == PostMediaType.video
                  ? PostVideoPlayer(videoPath: post.mediaUrls.first)
                  : _buildImageGallery(post.mediaUrls),
            ),
          ],

          // Footer action counters summary row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                if (post.likesCount > 0) ...[
                  const Icon(Icons.favorite, size: 12, color: Colors.redAccent),
                  const SizedBox(width: 4),
                  Text(
                    '${post.likesCount}',
                    style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                  ),
                ],
                const Spacer(),
                if (post.commentsCount > 0) ...[
                  Text(
                    '${post.commentsCount} ${isEnglish ? 'comments' : 'মন্তব্য'}',
                    style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 16, thickness: 0.8),

          // Action Toolbar Bar: Like, Comment, Share
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // LIKE BUTTON
                TextButton.icon(
                  onPressed: () => feedService.toggleLike(post.id, currentUser.id),
                  style: TextButton.styleFrom(
                    foregroundColor: hasLiked ? Colors.redAccent : ClinicalTheme.textSecondary,
                  ),
                  icon: Icon(
                    hasLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 18,
                  ),
                  label: Text(
                    isEnglish ? 'Like' : 'লাইক',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
                  ),
                ),

                // COMMENT BUTTON
                TextButton.icon(
                  onPressed: () => _showCommentsBottomSheet(context, post, currentUser, isEnglish),
                  style: TextButton.styleFrom(
                    foregroundColor: ClinicalTheme.textSecondary,
                  ),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                  label: Text(
                    isEnglish ? 'Comment' : 'কমেন্ট',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
                  ),
                ),

                // SHARE BUTTON
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: ClinicalTheme.primaryBlue,
                        duration: const Duration(seconds: 1),
                        content: Row(
                          children: [
                            const Icon(Icons.check_rounded, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(isEnglish ? 'Post link copied to clipboard!' : 'পোস্ট লিংকটি কপি করা হয়েছে!'),
                          ],
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: ClinicalTheme.textSecondary,
                  ),
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: Text(
                    isEnglish ? 'Share' : 'শেয়ার',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Gallery grid for images
  Widget _buildImageGallery(List<String> paths) {
    if (paths.isEmpty) return const SizedBox();

    if (paths.length == 1) {
      final path = paths.first;
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: path.startsWith('http')
            ? Image.network(path, fit: BoxFit.cover, width: double.infinity, height: 200)
            : Image.file(File(path), fit: BoxFit.cover, width: double.infinity, height: 200),
      );
    }

    // Render multiple in a nice split row
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 180,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: paths[0].startsWith('http')
                  ? Image.network(paths[0], fit: BoxFit.cover)
                  : Image.file(File(paths[0]), fit: BoxFit.cover),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: paths[1].startsWith('http')
                        ? Image.network(paths[1], fit: BoxFit.cover)
                        : Image.file(File(paths[1]), fit: BoxFit.cover),
                  ),
                  if (paths.length > 2) ...[
                    const SizedBox(height: 4),
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          paths[2].startsWith('http')
                              ? Image.network(paths[2], fit: BoxFit.cover)
                              : Image.file(File(paths[2]), fit: BoxFit.cover),
                          if (paths.length > 3)
                            Container(
                              color: Colors.black54,
                              alignment: Alignment.center,
                              child: Text(
                                '+${paths.length - 2}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
