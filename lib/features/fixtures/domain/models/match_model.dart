import 'package:cloud_firestore/cloud_firestore.dart';

enum MatchStatus { upcoming, live, finished }

class MatchModel {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final String homeCode;
  final String awayCode;
  final int homeScore;
  final int awayScore;
  final DateTime timestamp;
  final String competition;
  final String venue;
  final MatchStatus status;
  final List<String> scorers;
  final String? liveMinute;

  MatchModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeCode,
    required this.awayCode,
    required this.homeScore,
    required this.awayScore,
    required this.timestamp,
    required this.competition,
    required this.venue,
    required this.status,
    required this.scorers,
    this.liveMinute,
  });

  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    return MatchModel(
      id: doc.id,
      homeTeam: data['homeTeam']?.toString() ?? '',
      awayTeam: data['awayTeam']?.toString() ?? '',
      homeCode: data['homeCode']?.toString() ?? '',
      awayCode: data['awayCode']?.toString() ?? '',
      homeScore: data['homeScore'] as int? ?? 0,
      awayScore: data['awayScore'] as int? ?? 0,
      timestamp: _parseDateTime(data['timestamp']),
      competition: data['competition']?.toString() ?? 'PREMIER LEAGUE',
      venue: data['venue']?.toString() ?? '',
      status: _parseStatus(data['status']?.toString()),
      scorers: List<String>.from(data['scorers'] ?? []),
      liveMinute: data['liveMinute']?.toString(),
    );
  }

  static MatchStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'live':
        return MatchStatus.live;
      case 'finished':
        return MatchStatus.finished;
      case 'upcoming':
      default:
        return MatchStatus.upcoming;
    }
  }

  static DateTime _parseDateTime(dynamic field) {
    if (field is Timestamp) return field.toDate();
    if (field is int) return DateTime.fromMillisecondsSinceEpoch(field);
    return DateTime.now();
  }

  Map<String, dynamic> toFirestore() {
    return {
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeCode': homeCode,
      'awayCode': awayCode,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'timestamp': Timestamp.fromDate(timestamp),
      'competition': competition,
      'venue': venue,
      'status': status.name,
      'scorers': scorers,
      'liveMinute': liveMinute,
    };
  }
}
