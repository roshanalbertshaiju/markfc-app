import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markfc/features/home/domain/models/poll.dart';
import 'package:markfc/core/providers/firebase_providers.dart';

class PollRepository {
  final FirebaseFirestore _firestore;

  PollRepository(this._firestore);

  Stream<Poll?> watchActivePoll() {
    return _firestore
        .collection('match-polls')
        .where('status', isEqualTo: 'active')
        .limit(1)
        .snapshots()
        .timeout(const Duration(seconds: 30), onTimeout: (sink) {
          debugPrint('Firestore Connection Timeout: match-polls collection');
          sink.addError(TimeoutException('Firestore Connection Timeout: match-polls collection'));
        })
        .map((snapshot) => snapshot.docs.isNotEmpty 
            ? Poll.fromFirestore(snapshot.docs.first) 
            : null);
  }

  Future<void> vote(String pollId, String option) async {
    final docRef = _firestore.collection('match-polls').doc(pollId);
    
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final options = Map<String, int>.from(data['options'] ?? {});
      final currentVotes = options[option] ?? 0;
      final totalVotes = data['totalVotes'] as int? ?? 0;

      options[option] = currentVotes + 1;
      
      transaction.update(docRef, {
        'options': options,
        'totalVotes': totalVotes + 1,
      });
    });
  }
}

final pollRepositoryProvider = Provider<PollRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return PollRepository(firestore);
});

final activePollProvider = StreamProvider<Poll?>((ref) {
  return ref.watch(pollRepositoryProvider).watchActivePoll();
});
