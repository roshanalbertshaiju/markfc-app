import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/player.dart';
import '../../../news/data/repositories/news_repository.dart'; // To reuse firestoreProvider

class SquadRepository {
  final FirebaseFirestore _firestore;

  SquadRepository(this._firestore);

  Stream<List<Player>> watchPlayers({TeamCategory? category}) {
    Query query = _firestore.collection('players');
    
    if (category != null) {
      query = query.where('category', isEqualTo: category.name);
    }
    
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Player.fromFirestore(doc))
        .toList()
      ..sort((a, b) => int.parse(a.number).compareTo(int.parse(b.number))));
  }

  Stream<List<Player>> watchTopPlayers({int limit = 5}) {
    return _firestore
        .collection('players')
        .orderBy('rating', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Player.fromFirestore(doc))
            .toList());
  }
}

final squadRepositoryProvider = Provider<SquadRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return SquadRepository(firestore);
});

final playersStreamProvider = StreamProvider.family<List<Player>, TeamCategory?>((ref, category) {
  return ref.watch(squadRepositoryProvider).watchPlayers(category: category);
});

final topPlayersStreamProvider = StreamProvider<List<Player>>((ref) {
  return ref.watch(squadRepositoryProvider).watchTopPlayers();
});
