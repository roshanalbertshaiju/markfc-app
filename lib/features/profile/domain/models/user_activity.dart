import 'package:cloud_firestore/cloud_firestore.dart';

enum ActivityType {
  purchase,
  vote,
  ticket,
  other
}

class UserActivity {
  final String id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final ActivityType type;

  const UserActivity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.type,
  });

  factory UserActivity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserActivity(
      id: doc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: _parseType(data['type']),
    );
  }

  static ActivityType _parseType(String? type) {
    switch (type?.toLowerCase()) {
      case 'purchase': return ActivityType.purchase;
      case 'vote': return ActivityType.vote;
      case 'ticket': return ActivityType.ticket;
      default: return ActivityType.other;
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'subtitle': subtitle,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type.name,
    };
  }
}
