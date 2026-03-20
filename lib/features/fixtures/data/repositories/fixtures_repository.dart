import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/match_model.dart';
import 'package:markfc/core/providers/firebase_providers.dart';

class FixturesRepository {
  final FirebaseFirestore _firestore;

  FixturesRepository(this._firestore);

  Stream<List<MatchModel>> watchFixtures() {
    return _firestore
        .collection('fixtures')
        // .orderBy('date', descending: false)
        .snapshots()
        .timeout(const Duration(seconds: 30), onTimeout: (sink) {
          debugPrint('Firestore Connection Timeout: Fixtures collection');
          sink.addError(TimeoutException('Firestore Connection Timeout: Fixtures collection'));
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
        // .orderBy('timestamp', descending: true)
        .snapshots()
        .timeout(const Duration(seconds: 30), onTimeout: (sink) {
          debugPrint('Firestore Connection Timeout: Results collection');
          sink.addError(TimeoutException('Firestore Connection Timeout: Results collection'));
        })
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MatchModel.fromFirestore(doc))
          .toList();
    });
  }

  Stream<MatchModel?> watchLiveMatch() {
    return _firestore
        .collection('fixtures')
        .where('status', isEqualTo: 'live')
        .limit(1)
        .snapshots()
        .timeout(const Duration(seconds: 30), onTimeout: (sink) {
          debugPrint('Firestore Connection Timeout: Live Match query');
          sink.addError(TimeoutException('Firestore Connection Timeout: Live Match query'));
        })
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
