import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class NewsArticle {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String category;
  final String author;
  final DateTime timestamp;

  NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.author,
    required this.timestamp,
  });

  factory NewsArticle.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    
    // The Firestore console shows 'images' is an array of strings
    final List<dynamic> images = data['images'] ?? [];
    final String firstImage = images.isNotEmpty ? images[0].toString() : '';

    // The Firestore console shows 'paragraphs' is an array of strings
    final List<dynamic> paragraphs = data['paragraphs'] ?? [];
    final String combinedContent = paragraphs.join('\n\n');

    return NewsArticle(
      id: doc.id,
      title: data['headline']?.toString() ?? data['title']?.toString() ?? 'NO TITLE',
      content: data['content']?.toString() ?? combinedContent,
      imageUrl: data['imageUrl']?.toString() ?? firstImage,
      category: data['category']?.toString() ?? 'GENERAL',
      author: data['author']?.toString() ?? 'UNKNOWN AUTHOR',
      timestamp: _parseDateTime(data['date'] ?? data['timestamp']),
    );
  }

  static DateTime _parseDateTime(dynamic field) {
    if (field == null) return DateTime.now();
    if (field is Timestamp) return field.toDate();
    if (field is int) return DateTime.fromMillisecondsSinceEpoch(field);
    if (field is String) {
      try {
        // First try the format seen in Firestore: "January 26, 2026"
        return DateFormat('MMMM d, yyyy').parse(field);
      } catch (e) {
        try {
          return DateTime.parse(field);
        } catch (_) {
          // If both parsing attempts fail, return current time
          return DateTime.now();
        }
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toFirestore() {
    return {
      'headline': title,
      'paragraphs': content.split('\n\n'),
      'images': [imageUrl],
      'category': category,
      'author': author,
      'date': DateFormat('MMMM d, yyyy').format(timestamp),
    };
  }
}
