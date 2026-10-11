import 'dart:convert';

enum PostMediaType {
  none,
  image,
  video,
}

class PostComment {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String authorRole; // e.g. "Doctor", "Pharmacy", etc.
  final String authorAvatar; // e.g. Emoji or path
  final String text;
  final DateTime timestamp;

  PostComment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'authorAvatar': authorAvatar,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PostComment.fromMap(Map<String, dynamic> map) {
    return PostComment(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      authorRole: map['authorRole'] ?? 'Patient',
      authorAvatar: map['authorAvatar'] ?? '👤',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
    );
  }
}

class HealthPost {
  final String id;
  final String authorId;
  final String authorName;
  final String authorRole; // Doctor / Pharmacy / Diagnostic Centre / Admin / Patient
  final String authorAvatar; // Emoji or asset/file path
  final String content;
  final List<String> mediaUrls; // Image or Video file paths/URLs
  final PostMediaType mediaType;
  final DateTime timestamp;
  final List<String> likedByUids; // User IDs of people who liked this post
  final List<PostComment> comments;

  HealthPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
    required this.content,
    required this.mediaUrls,
    required this.mediaType,
    required this.timestamp,
    required this.likedByUids,
    required this.comments,
  });

  int get likesCount => likedByUids.length;
  int get commentsCount => comments.length;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'authorAvatar': authorAvatar,
      'content': content,
      'mediaUrls': mediaUrls,
      'mediaType': mediaType.name,
      'timestamp': timestamp.toIso8601String(),
      'likedByUids': likedByUids,
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }

  factory HealthPost.fromMap(Map<String, dynamic> map) {
    return HealthPost(
      id: map['id'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      authorRole: map['authorRole'] ?? 'Patient',
      authorAvatar: map['authorAvatar'] ?? '🩺',
      content: map['content'] ?? '',
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      mediaType: PostMediaType.values.byName(map['mediaType'] ?? 'none'),
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
      likedByUids: List<String>.from(map['likedByUids'] ?? []),
      comments: map['comments'] != null
          ? (map['comments'] as List).map((c) => PostComment.fromMap(c)).toList()
          : [],
    );
  }

  HealthPost copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorRole,
    String? authorAvatar,
    String? content,
    List<String>? mediaUrls,
    PostMediaType? mediaType,
    DateTime? timestamp,
    List<String>? likedByUids,
    List<PostComment>? comments,
  }) {
    return HealthPost(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      mediaType: mediaType ?? this.mediaType,
      timestamp: timestamp ?? this.timestamp,
      likedByUids: likedByUids ?? this.likedByUids,
      comments: comments ?? this.comments,
    );
  }
}
