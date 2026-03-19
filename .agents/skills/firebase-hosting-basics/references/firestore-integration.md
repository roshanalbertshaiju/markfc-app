---
name: firestore-integration
description: "Use this skill when replacing hardcoded mock data with real Firestore data. Covers repository pattern, Riverpod StreamProvider setup, and connecting UI widgets to live data."
---

# Firestore Integration Skill

## Overview

All data must flow through the Riverpod provider layer. Never call Firestore directly in a widget. Follow this 3-layer pattern for every collection:

```
Firestore DB → Repository → Riverpod Provider → Widget
```

---

## Layer 1 — Model

Create a model in `lib/features/{feature}/domain/models/`:

```dart
class Fixture {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final DateTime matchDate;
  final String competition;
  final String? score;
  final String? venue;

  const Fixture({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.matchDate,
    required this.competition,
    this.score,
    this.venue,
  });

  factory Fixture.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Fixture(
      id: doc.id,
      homeTeam: data['homeTeam'] ?? '',
      awayTeam: data['awayTeam'] ?? '',
      matchDate: (data['matchDate'] as Timestamp).toDate(),
      competition: data['competition'] ?? '',
      score: data['score'],
      venue: data['venue'],
    );
  }
}
```

---

## Layer 2 — Repository

Create a repository in `lib/features/{feature}/data/repositories/`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FixturesRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Fixture>> watchFixtures() {
    return _db
        .collection('fixtures')
        .orderBy('matchDate')
        .snapshots()
        .map((snap) => snap.docs.map(Fixture.fromFirestore).toList());
  }

  Future<Fixture?> getFixtureById(String id) async {
    final doc = await _db.collection('fixtures').doc(id).get();
    if (!doc.exists) return null;
    return Fixture.fromFirestore(doc);
  }
}
```

---

## Layer 3 — Riverpod Provider

Create providers in `lib/features/{feature}/presentation/providers/`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository provider
final fixturesRepositoryProvider = Provider<FixturesRepository>((ref) {
  return FixturesRepository();
});

// Stream provider — auto-updates UI when Firestore changes
final fixturesProvider = StreamProvider<List<Fixture>>((ref) {
  return ref.watch(fixturesRepositoryProvider).watchFixtures();
});
```

---

## Layer 4 — Widget (ConsumerWidget)

Replace mock data usage in the screen with:

```dart
class FixturesScreen extends ConsumerWidget {
  const FixturesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fixturesAsync = ref.watch(fixturesProvider);

    return fixturesAsync.when(
      data: (fixtures) => ListView.builder(
        itemCount: fixtures.length,
        itemBuilder: (context, index) => FixtureCard(fixture: fixtures[index]),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
```

---

## Collection Integration Checklist

Apply the above pattern to every collection. Track progress here:

| Collection | Model | Repository | Provider | Widget Connected |
|------------|-------|------------|----------|-----------------|
| fixtures   | [ ]   | [ ]        | [ ]      | [ ]             |
| results    | [ ]   | [ ]        | [ ]      | [ ]             |
| players    | [ ]   | [ ]        | [ ]      | [ ]             |
| news       | [ ]   | [ ]        | [ ]      | [ ]             |
| hero-sec   | [ ]   | [ ]        | [ ]      | [ ]             |
| video      | [ ]   | [ ]        | [ ]      | [ ]             |
| faqs       | [ ]   | [ ]        | [ ]      | [ ]             |
| shop       | [ ]   | [ ]        | [ ]      | [ ]             |

---

## Rules

- NEVER use `FutureBuilder` or `StreamBuilder` directly in widgets — use Riverpod providers
- NEVER call `FirebaseFirestore.instance` inside a widget
- ALWAYS use `.when(data, loading, error)` on `AsyncValue`
- Use `StreamProvider` for live data, `FutureProvider` for one-time fetches
