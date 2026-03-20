import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markfc/features/home/domain/models/hero_slide.dart';
import 'package:markfc/core/providers/firebase_providers.dart';

class HeroRepository {
  final FirebaseFirestore _firestore;

  HeroRepository(this._firestore);

  Stream<List<HeroSlide>> watchHeroSlides() {
    return _firestore
        .collection('hero-sec')
        // .orderBy('timestamp', descending: true)
        .snapshots()
        .timeout(const Duration(seconds: 30), onTimeout: (sink) {
          debugPrint('Firestore Connection Timeout: hero-sec collection');
          sink.addError(TimeoutException('Firestore Connection Timeout: hero-sec collection'));
        })
        .map((snapshot) {
      return snapshot.docs.map((doc) => HeroSlide.fromFirestore(doc)).toList();
    });
  }
}

final heroRepositoryProvider = Provider<HeroRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return HeroRepository(firestore);
});

final heroSlidesStreamProvider = StreamProvider<List<HeroSlide>>((ref) {
  return ref.watch(heroRepositoryProvider).watchHeroSlides();
});
