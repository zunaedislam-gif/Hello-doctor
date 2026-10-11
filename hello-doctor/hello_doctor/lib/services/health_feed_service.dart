import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Optional Firestore packages - we catch any NoFirebaseException / platform errors gracefully
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class HealthFeedService extends ChangeNotifier {
  List<HealthPost> _posts = [];
  bool _isLoading = false;
  bool _isUsingFirestore = false;

  List<HealthPost> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isUsingFirestore => _isUsingFirestore;

  static const String _localPostsKey = 'hello_doctor_health_posts';

  // Firestore instance or null
  FirebaseFirestore? _firestore;

  HealthFeedService() {
    _initialize();
  }

  /// Initialize state: first load from local storage cache,
  /// then attempt to link up real-time Firebase Cloud Firestore streams.
  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    // 1. Load offline cache first for instant UI response
    await _loadFromLocalCache();

    // 2. Try connecting to Cloud Firestore
    try {
      // Check if Firebase is initialized. In a Flutter project, Firebase.apps.isNotEmpty 
      // verifies if Firebase Core was bootstrapped successfully.
      if (Firebase.apps.isNotEmpty) {
        _firestore = FirebaseFirestore.instance;
        _isUsingFirestore = true;
        debugPrint("HealthFeedService: Connected to Cloud Firestore successfully.");
        
        // Listen to active realtime Firestore stream of posts
        _listenToFirestorePosts();
      } else {
        debugPrint("HealthFeedService: Firebase Core is not initialized. Using local memory storage.");
        _seedDefaultPostsIfEmpty();
      }
    } catch (e) {
      debugPrint("HealthFeedService: Failed to connect to Firebase Firestore: $e. Falling back to local cache.");
      _isUsingFirestore = false;
      _seedDefaultPostsIfEmpty();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load cached posts from SharedPreferences
  Future<void> _loadFromLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsJson = prefs.getString(_localPostsKey);
      if (postsJson != null) {
        final List<dynamic> decoded = json.decode(postsJson);
        _posts = decoded.map((p) => HealthPost.fromMap(p)).toList();
        // Sort posts descending by timestamp
        _posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        notifyListeners();
      }
    } catch (e) {
      debugPrint("HealthFeedService: Error loading from local cache: $e");
    }
  }

  /// Save current memory posts to SharedPreferences cache
  Future<void> _saveToLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = _posts.map((p) => p.toMap()).toList();
      await prefs.setString(_localPostsKey, json.encode(encoded));
    } catch (e) {
      debugPrint("HealthFeedService: Error saving to local cache: $e");
    }
  }

  /// Seed initial high-quality professional posts if local cache is empty
  void _seedDefaultPostsIfEmpty() {
    if (_posts.isNotEmpty) return;

    _posts = [
      HealthPost(
        id: 'seed-post-1',
        authorId: 'doctor-mock',
        authorName: 'Dr. Sarah Rahman',
        authorRole: 'Doctor',
        authorAvatar: '🩺',
        content: 'Cardiovascular health starts with your morning routine! Try swapping your second cup of sweet milk tea for green tea and complete 30 minutes of brisk walking. Your heart will thank you! 🫀🚶‍♀️\n\nWhat cardiovascular habits are you tracking this week? Let me know in the comments!',
        mediaUrls: [],
        mediaType: PostMediaType.none,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        likedByUids: ['patient_mock'],
        comments: [
          PostComment(
            id: 'seed-comment-1',
            postId: 'seed-post-1',
            authorId: 'patient_mock',
            authorName: 'Karim Uddin',
            authorRole: 'Patient',
            authorAvatar: '👤',
            text: 'I started walking 20 minutes daily, Dr. Sarah! Feeling much lighter already.',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          )
        ],
      ),
      HealthPost(
        id: 'seed-post-2',
        authorId: 'pharmacy-seed',
        authorName: 'Lazz Pharma (Dhanmondi)',
        authorRole: 'Pharmacy',
        authorAvatar: '💊',
        content: 'Stay alert: seasonal flu is on the rise in Dhaka city. We have fully restocked genuine Napa Extend, Fexo, and standard pediatric nebulizer solutions. Home delivery is available via Hello Doctor.\n\nNote: Always consult a verified physician before administering antibiotics!',
        mediaUrls: [],
        mediaType: PostMediaType.none,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        likedByUids: [],
        comments: [],
      ),
      HealthPost(
        id: 'seed-post-3',
        authorId: 'diag-seed',
        authorName: 'Popular Diagnostic Center',
        authorRole: 'Diagnostic Centre',
        authorAvatar: '🔬',
        content: 'Take charge of your health before symptoms arise. Get our Premium Wellness Full Body Checkup (48 Parameters) including Liver Profile, Kidney Function, and Lipid Profiles at an exclusive 15% discount for Hello Doctor subscribers!',
        mediaUrls: [],
        mediaType: PostMediaType.none,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        likedByUids: ['doctor-mock'],
        comments: [
          PostComment(
            id: 'seed-comment-2',
            postId: 'seed-post-3',
            authorId: 'doctor-mock',
            authorName: 'Dr. Sarah Rahman',
            authorRole: 'Doctor',
            authorAvatar: '🩺',
            text: 'An excellent preventative checkup bundle. I highly recommend adults above 35 get this done annually.',
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 22)),
          )
        ],
      )
    ];

    _saveToLocalCache();
  }

  /// Real-time listener for Cloud Firestore
  void _listenToFirestorePosts() {
    if (_firestore == null) return;

    _firestore!
        .collection('health_posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        _posts = snapshot.docs.map((doc) {
          final data = doc.data();
          // inject doc id if empty
          data['id'] = doc.id;
          return HealthPost.fromMap(data);
        }).toList();
        
        _saveToLocalCache(); // Update offline cache with cloud sync
        notifyListeners();
      },
      onError: (error) {
        debugPrint("HealthFeedService Firestore Stream Error: $error");
        // Fall back to local database operations seamlessly if there is a permission error or database isn't provisioned yet
        _seedDefaultPostsIfEmpty();
      },
    );
  }

  /// Create a new post (Only Doctor, Pharmacy, Diagnostic, Admin)
  Future<bool> createPost({
    required UserModel author,
    required String text,
    List<String> mediaPaths = const [],
    PostMediaType mediaType = PostMediaType.none,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Verify authorized role
    if (author.role == UserRole.patient) {
      _isLoading = false;
      notifyListeners();
      return false; // Unauthorized
    }

    // Role display names mapping
    String roleBadge = "Professional";
    String avatar = "🩺";
    if (author.role == UserRole.doctor) {
      roleBadge = "Doctor";
      avatar = "🩺";
    } else if (author.role == UserRole.pharmacy) {
      roleBadge = "Pharmacy";
      avatar = "💊";
    } else if (author.role == UserRole.diagnostic) {
      roleBadge = "Diagnostic Centre";
      avatar = "🔬";
    } else if (author.role == UserRole.admin) {
      roleBadge = "Admin";
      avatar = "🛡️";
    }

    final newPost = HealthPost(
      id: 'post-${DateTime.now().millisecondsSinceEpoch}',
      authorId: author.id,
      authorName: author.name,
      authorRole: roleBadge,
      authorAvatar: avatar,
      content: text,
      mediaUrls: mediaPaths,
      mediaType: mediaType,
      timestamp: DateTime.now(),
      likedByUids: [],
      comments: [],
    );

    if (_isUsingFirestore && _firestore != null) {
      // -------------------------------------------------------------
      // FIRESTORE SYNC BLOCK
      // -------------------------------------------------------------
      // How to plug Firebase config:
      // When your Firebase project is connected on device, this block will write
      // directly to the 'health_posts' collection. Make sure you set up Firestore
      // Security Rules allowing authenticated professional users to write.
      // -------------------------------------------------------------
      try {
        await _firestore!
            .collection('health_posts')
            .doc(newPost.id)
            .set(newPost.toMap());
        
        _isLoading = false;
        notifyListeners();
        return true;
      } catch (e) {
        debugPrint("HealthFeedService: Failed to save to Firestore: $e. Saving to local storage instead.");
      }
    }

    // Fallback/offline write
    _posts.insert(0, newPost);
    await _saveToLocalCache();
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Toggle post like
  Future<void> toggleLike(String postId, String userId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    final List<String> updatedLikes = List.from(post.likedByUids);

    if (updatedLikes.contains(userId)) {
      updatedLikes.remove(userId);
    } else {
      updatedLikes.add(userId);
    }

    final updatedPost = post.copyWith(likedByUids: updatedLikes);

    if (_isUsingFirestore && _firestore != null) {
      try {
        await _firestore!
            .collection('health_posts')
            .doc(postId)
            .update({'likedByUids': updatedLikes});
        return; // Firestore stream will update the UI list automatically
      } catch (e) {
        debugPrint("HealthFeedService: Like Firestore update failed: $e. Doing local update.");
      }
    }

    // Fallback/offline update
    _posts[index] = updatedPost;
    await _saveToLocalCache();
    notifyListeners();
  }

  /// Add a comment to a post
  Future<void> addComment({
    required String postId,
    required UserModel commenter,
    required String commentText,
  }) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];

    String roleBadge = "Patient";
    String avatar = "👤";
    if (commenter.role == UserRole.doctor) {
      roleBadge = "Doctor";
      avatar = "🩺";
    } else if (commenter.role == UserRole.pharmacy) {
      roleBadge = "Pharmacy";
      avatar = "💊";
    } else if (commenter.role == UserRole.diagnostic) {
      roleBadge = "Diagnostic Centre";
      avatar = "🔬";
    } else if (commenter.role == UserRole.admin) {
      roleBadge = "Admin";
      avatar = "🛡️";
    }

    final newComment = PostComment(
      id: 'comment-${DateTime.now().millisecondsSinceEpoch}',
      postId: postId,
      authorId: commenter.id,
      authorName: commenter.name,
      authorRole: roleBadge,
      authorAvatar: avatar,
      text: commentText,
      timestamp: DateTime.now(),
    );

    final List<PostComment> updatedComments = List.from(post.comments)..add(newComment);
    final updatedPost = post.copyWith(comments: updatedComments);

    if (_isUsingFirestore && _firestore != null) {
      try {
        final commentListMap = updatedComments.map((c) => c.toMap()).toList();
        await _firestore!
            .collection('health_posts')
            .doc(postId)
            .update({'comments': commentListMap});
        return; // Firestore stream will update UI automatically
      } catch (e) {
        debugPrint("HealthFeedService: Comment Firestore update failed: $e. Doing local update.");
      }
    }

    // Fallback/offline update
    _posts[index] = updatedPost;
    await _saveToLocalCache();
    notifyListeners();
  }
}
