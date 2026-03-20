import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/match_model.dart';
import '../../../news/data/repositories/news_repository.dart'; // To reuse firestoreProvider

class FixturesRepository {
  final FirebaseFirestore _firestore;

  FixturesRepository(this._firestore);

  Stream<List<MatchModel>> watchFixtures() {
    return _firestore
        .collection('fixtures')
        .orderBy('date', descending: false) // Changed from 'timestamp' to 'date'
        .snapshots()
        .timeout(const Duration(seconds: 10), onTimeout: (sink) {
          debugPrint('Firestore Connection Timeout: Fixtures collection');
          sink.addError('Connection Timeout');
        })
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MatchModel.fromFirestore(doc))
          .toList();
    });
  }

  Stream<List<MatchModel>> watchResults() {
    return _firestore
        .collection('results')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MatchModel.fromFirestore(doc))
            .toList());
  }

  Stream<MatchModel?> watchLiveMatch() {
    return _firestore
        .collection('fixtures')
        .where('status', isEqualTo: 'live')
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty 
            ? MatchModel.fromFirestore(snapshot.docs.first) 
            : null);
  }
}

final fixturesRepositoryProvider = Provider<FixturesRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FixturesRepository(firestore);
});

final fixturesStreamProvider = StreamProvider<List<MatchModel>>((ref) {
  return ref.watch(fixturesRepositoryProvider).watchFixtures();
});

final resultsStreamProvider = StreamProvider<List<MatchModel>>((ref) {
  return ref.watch(fixturesRepositoryProvider).watchResults();
});

final liveMatchStreamProvider = StreamProvider<MatchModel?>((ref) {
  return ref.watch(fixturesRepositoryProvider).watchLiveMatch();
});
