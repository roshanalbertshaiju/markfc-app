import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markfc/features/home/domain/models/league_row.dart';
import 'package:markfc/core/providers/firebase_providers.dart';

class LeagueRepository {
  final FirebaseFirestore _firestore;

  LeagueRepository(this._firestore);

  Stream<List<LeagueRow>> watchLeagueTable() {
    return _firestore
        .collection('league-table')
        .orderBy('position')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeagueRow.fromFirestore(doc))
            .toList());
  }
}

final leagueRepositoryProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return LeagueRepository(firestore);
});

final leagueTableStreamProvider = StreamProvider<List<LeagueRow>>((ref) {
  return ref.watch(leagueRepositoryProvider).watchLeagueTable();
});
