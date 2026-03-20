import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markfc/features/home/domain/models/player_of_the_month.dart';
import 'package:markfc/features/home/domain/models/fan_of_the_month.dart';
import 'package:markfc/core/providers/firebase_providers.dart';

class AwardsRepository {
  final FirebaseFirestore _firestore;

  AwardsRepository(this._firestore);

  Stream<PlayerOfTheMonth?> watchPlayerOfTheMonth() {
    return _firestore
        .collection('awards')
        .doc('player-of-the-month')
        .snapshots()
        .timeout(const Duration(seconds: 30), onTimeout: (sink) {
          debugPrint('Firestore Connection Timeout: player-of-the-month doc');
          sink.addError(TimeoutException('Firestore Connection Timeout: player-of-the-month doc'));
        })
        .map((snapshot) => snapshot.exists ? PlayerOfTheMonth.fromFirestore(snapshot) : null);
  }

  Stream<FanOfTheMonth?> watchFanOfTheMonth() {
    return _firestore
        .collection('awards')
        .doc('fan-of-the-month')
        .snapshots()
        .timeout(const Duration(seconds: 30), onTimeout: (sink) {
          debugPrint('Firestore Connection Timeout: fan-of-the-month doc');
          sink.addError(TimeoutException('Firestore Connection Timeout: fan-of-the-month doc'));
        })
        .map((snapshot) => snapshot.exists ? FanOfTheMonth.fromFirestore(snapshot) : null);
  }
}

final awardsRepositoryProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return AwardsRepository(firestore);
});

final potmStreamProvider = StreamProvider<PlayerOfTheMonth?>((ref) {
  return ref.watch(awardsRepositoryProvider).watchPlayerOfTheMonth();
});

final fotmStreamProvider = StreamProvider<FanOfTheMonth?>((ref) {
  return ref.watch(awardsRepositoryProvider).watchFanOfTheMonth();
});
