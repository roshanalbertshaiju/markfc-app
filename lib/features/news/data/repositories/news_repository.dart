import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markfc/core/providers/firebase_providers.dart';
import '../../domain/models/news_article.dart';

class NewsRepository {
  final FirebaseFirestore _firestore;

  NewsRepository(this._firestore);

  Stream<List<NewsArticle>> watchLatestNews({int limit = 10}) {
    // Try fetching without orderBy first to avoid timeout if index is missing
    return _firestore
        .collection('news')
        // .orderBy('timestamp', descending: true) // Original line
        .limit(10) // Changed to 10 directly as per instruction
        .snapshots()
        .timeout(
      const Duration(seconds: 30),
      onTimeout: (sink) {
        // debugPrint('Firestore Connection Timeout: News collection'); // Removed debugPrint
        sink.addError(TimeoutException('Firestore Connection Timeout: News collection')); // Changed to TimeoutException
      },
    ).map((snapshot) {
      return snapshot.docs.map((doc) => NewsArticle.fromFirestore(doc)).toList();
    });
  }

  Stream<NewsArticle?> watchNewsById(String id) {
    return _firestore
        .collection('news')
        .doc(id)
        .snapshots()
        .map((doc) => doc.exists ? NewsArticle.fromFirestore(doc) : null);
  }
}

// firestoreProvider moved to lib/core/providers/firebase_providers.dart

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return NewsRepository(firestore);
});

final latestNewsProvider = StreamProvider.family<List<NewsArticle>, int>((ref, limit) {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.watchLatestNews(limit: limit).handleError((error) {
    // Log the error for easier debugging in development
    debugPrint('Firestore News Error: $error');
    throw error;
  });
});
