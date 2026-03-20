import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerOfTheMonth {
  final String id;
  final String name;
  final String month;
  final String position;
  final int appearances;
  final int goals;
  final int assists;
  final double rating;
  final String? imageUrl;

  PlayerOfTheMonth({
    required this.id,
    required this.name,
    required this.month,
    required this.position,
    required this.appearances,
    required this.goals,
    required this.assists,
    required this.rating,
    this.imageUrl,
  });

  factory PlayerOfTheMonth.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlayerOfTheMonth(
      id: doc.id,
      name: data['name'] ?? '',
      month: data['month'] ?? '',
      position: data['position'] ?? '',
      appearances: data['appearances'] ?? 0,
      goals: data['goals'] ?? 0,
      assists: data['assists'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'month': month,
      'position': position,
      'appearances': appearances,
      'goals': goals,
      'assists': assists,
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }
}
