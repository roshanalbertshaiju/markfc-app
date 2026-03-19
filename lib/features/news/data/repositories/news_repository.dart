import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/news_article.dart';

class NewsRepository {
  final FirebaseFirestore _firestore;

  NewsRepository(this._firestore);

  Stream<List<NewsArticle>> watchLatestNews({int limit = 5}) {
    return _firestore
        .collection('news')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NewsArticle.fromFirestore(doc))
            .toList());
  }

  Stream<NewsArticle?> watchNewsById(String id) {
    return _firestore
        .collection('news')
        .doc(id)
        .snapshots()
        .map((doc) => doc.exists ? NewsArticle.fromFirestore(doc) : null);
  }
}

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return NewsRepository(firestore);
});

final latestNewsProvider = StreamProvider.family<List<NewsArticle>, int>((ref, limit) {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.watchLatestNews(limit: limit).handleError((error) {
    // Log the error for easier debugging in development
    debugPrint('Firestore News Error: $error');
  });
});
