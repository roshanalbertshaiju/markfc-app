import 'package:cloud_firestore/cloud_firestore.dart';

class MifcUser {
  final String uid;
  final String name;
  final String email;
  final String memberStatus;
  final DateTime joinDate;
  final int matchesAttended;
  final int loyaltyPoints;
  final String? photoUrl;

  const MifcUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.memberStatus,
    required this.joinDate,
    required this.matchesAttended,
    required this.loyaltyPoints,
    this.photoUrl,
  });

  factory MifcUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MifcUser(
      uid: doc.id,
      name: data['name'] ?? 'User',
      email: data['email'] ?? '',
      memberStatus: data['memberStatus'] ?? 'MEMBER',
      joinDate: _parseDateTime(data['joinDate']),
      matchesAttended: data['matchesAttended'] ?? 0,
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      photoUrl: data['photoUrl'],
    );
  }

  static DateTime _parseDateTime(dynamic field) {
    if (field is Timestamp) return field.toDate();
    if (field is int) return DateTime.fromMillisecondsSinceEpoch(field);
    return DateTime.now();
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'memberStatus': memberStatus,
      'joinDate': Timestamp.fromDate(joinDate),
      'matchesAttended': matchesAttended,
      'loyaltyPoints': loyaltyPoints,
      'photoUrl': photoUrl,
    };
  }
}
