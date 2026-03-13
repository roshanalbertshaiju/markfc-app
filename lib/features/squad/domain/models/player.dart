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

  const Player({
    required this.id,
    required this.name,
    required this.number,
    required this.position,
    required this.category,
    required this.imageUrl,
    this.isOnLoan = false,
  });
}
