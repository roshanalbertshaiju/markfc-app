import 'package:cloud_firestore/cloud_firestore.dart';

class LeagueRow {
  final int position;
  final String teamCode;
  final String teamName;
  final int played;
  final int points;
  final List<String> form; // e.g., ['W', 'W', 'W', 'D', 'L']
  final bool isMifc;

  LeagueRow({
    required this.position,
    required this.teamCode,
    required this.teamName,
    required this.played,
    required this.points,
    required this.form,
    this.isMifc = false,
  });

  factory LeagueRow.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LeagueRow(
      position: data['position'] ?? 0,
      teamCode: data['teamCode'] ?? '',
      teamName: data['teamName'] ?? '',
      played: data['played'] ?? 0,
      points: data['points'] ?? 0,
      form: List<String>.from(data['form'] ?? []),
      isMifc: data['isMifc'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'position': position,
      'teamCode': teamCode,
      'teamName': teamName,
      'played': played,
      'points': points,
      'form': form,
      'isMifc': isMifc,
    };
  }
}
