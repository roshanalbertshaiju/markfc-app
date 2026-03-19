import 'package:cloud_firestore/cloud_firestore.dart';

enum PlayerPosition { goalkeeper, defender, midfielder, forward }

enum TeamCategory { men, women, u21, u18 }

class Player {
  final String id;
  final String name;
  final String number;
  final PlayerPosition position;
  final TeamCategory category;
  final String imageUrl;
  final bool isOnLoan;
  final String nationality;
  final int goals;
  final int assists;
  final double rating;

  const Player({
    required this.id,
    required this.name,
    required this.number,
    required this.position,
    required this.category,
    required this.imageUrl,
    this.isOnLoan = false,
    this.nationality = '',
    this.goals = 0,
    this.assists = 0,
    this.rating = 0.0,
  });

  factory Player.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    return Player(
      id: doc.id,
      name: data['name']?.toString() ?? '',
      number: data['number']?.toString() ?? '',
      position: _parsePosition(data['position']?.toString()),
      category: _parseCategory(data['category']?.toString()),
      imageUrl: data['imageUrl']?.toString() ?? '',
      isOnLoan: data['isOnLoan'] as bool? ?? false,
      nationality: data['nationality']?.toString() ?? '',
      goals: data['goals'] as int? ?? 0,
      assists: data['assists'] as int? ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static PlayerPosition _parsePosition(String? position) {
    switch (position?.toLowerCase()) {
      case 'goalkeeper':
      case 'gk':
        return PlayerPosition.goalkeeper;
      case 'defender':
      case 'df':
        return PlayerPosition.defender;
      case 'midfielder':
      case 'mf':
        return PlayerPosition.midfielder;
      case 'forward':
      case 'fw':
        return PlayerPosition.forward;
      default:
        return PlayerPosition.midfielder;
    }
  }

  static TeamCategory _parseCategory(String? category) {
    switch (category?.toLowerCase()) {
      case 'men':
        return TeamCategory.men;
      case 'women':
        return TeamCategory.women;
      case 'u21':
        return TeamCategory.u21;
      case 'u18':
        return TeamCategory.u18;
      default:
        return TeamCategory.men;
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'number': number,
      'position': position.name,
      'category': category.name,
      'imageUrl': imageUrl,
      'isOnLoan': isOnLoan,
      'nationality': nationality,
      'goals': goals,
      'assists': assists,
      'rating': rating,
    };
  }
}
