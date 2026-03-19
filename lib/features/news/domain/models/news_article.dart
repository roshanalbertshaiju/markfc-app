import 'package:cloud_firestore/cloud_firestore.dart';

class NewsArticle {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String category;
  final DateTime timestamp;

  NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.timestamp,
  });

  factory NewsArticle.fromFirestore(DocumentSnapshot doc) {
    // Safely cast data, protecting against null/empty documents
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    
    return NewsArticle(
      id: doc.id,
      title: data['title']?.toString() ?? 'NO TITLE',
      content: data['content']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
      category: data['category']?.toString() ?? 'GENERAL',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'category': category,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
