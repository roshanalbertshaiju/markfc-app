import 'package:cloud_firestore/cloud_firestore.dart';

class FanOfTheMonth {
  final String id;
  final String name;
  final String initials;
  final String month;
  final String supporterSince;
  final String tier;
  final int matchesAttended;
  final String points; // e.g., "6.7K"

  FanOfTheMonth({
    required this.id,
    required this.name,
    required this.initials,
    required this.month,
    required this.supporterSince,
    required this.tier,
    required this.matchesAttended,
    required this.points,
  });

  factory FanOfTheMonth.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FanOfTheMonth(
      id: doc.id,
      name: data['name'] ?? '',
      initials: data['initials'] ?? '',
      month: data['month'] ?? '',
      supporterSince: data['supporterSince'] ?? '',
      tier: data['tier'] ?? '',
      matchesAttended: data['matchesAttended'] ?? 0,
      points: data['points'] ?? '0',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'initials': initials,
      'month': month,
      'supporterSince': supporterSince,
      'tier': tier,
      'matchesAttended': matchesAttended,
      'points': points,
    };
  }
}
