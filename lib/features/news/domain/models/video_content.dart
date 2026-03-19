import 'package:cloud_firestore/cloud_firestore.dart';

class VideoContent {
  final String id;
  final String title;
  final String category;
  final String duration;
  final int views;
  final DateTime timestamp;
  final String imageUrl;
  final String videoUrl;

  const VideoContent({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.views,
    required this.timestamp,
    required this.imageUrl,
    required this.videoUrl,
  });

  factory VideoContent.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    return VideoContent(
      id: doc.id,
      title: data['title']?.toString() ?? '',
      category: data['category']?.toString() ?? 'MIFC TV',
      duration: data['duration']?.toString() ?? '00:00',
      views: data['views'] as int? ?? 0,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageUrl: data['imageUrl']?.toString() ?? '',
      videoUrl: data['videoUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category,
      'duration': duration,
      'views': views,
      'timestamp': Timestamp.fromDate(timestamp),
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    };
  }
}
