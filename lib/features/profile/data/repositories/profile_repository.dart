import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/mifc_user.dart';
import '../../domain/models/user_activity.dart';
import 'package:markfc/core/providers/firebase_providers.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProfileRepository(this._firestore, this._auth);

  Stream<User?> watchAuthStatus() => _auth.authStateChanges();

  Stream<MifcUser?> watchCurrentUser() {
    return watchAuthStatus().switchMap((user) {
      if (user == null) return Stream.value(null);
      return _firestore
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((doc) => doc.exists ? MifcUser.fromFirestore(doc) : null);
    });
  }

  Stream<List<UserActivity>> watchUserActivities(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('activities')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserActivity.fromFirestore(doc))
            .toList());
  }
}

// Extension to handle switchMap on Stream since rxdart is not added but needed for this logic
extension StreamExtensions<T> on Stream<T> {
  Stream<R> switchMap<R>(Stream<R> Function(T) mapper) {
    return map(mapper).asyncExpand((stream) => stream);
  }
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return ProfileRepository(firestore, auth);
});

final currentUserProvider = StreamProvider<MifcUser?>((ref) {
  return ref.watch(profileRepositoryProvider).watchCurrentUser();
});

final userActivitiesProvider = StreamProvider.family<List<UserActivity>, String>((ref, uid) {
  return ref.watch(profileRepositoryProvider).watchUserActivities(uid);
});
