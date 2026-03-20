import 'package:cloud_firestore/cloud_firestore.dart';

class PollOption {
  final String label;
  final int votes;

  PollOption({
    required this.label,
    required this.votes,
  });

  factory PollOption.fromMap(String label, int votes) {
    return PollOption(
      label: label,
      votes: votes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'votes': votes,
    };
  }
}

class Poll {
  final String id;
  final String question;
  final List<PollOption> options;
  final int totalVotes;
  final DateTime? endsAt;
  final String status;

  Poll({
    required this.id,
    required this.question,
    required this.options,
    required this.totalVotes,
    this.endsAt,
    required this.status,
  });

  factory Poll.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    final optionsMap = Map<String, int>.from(data['options'] ?? {});
    
    final options = optionsMap.entries
        .map((e) => PollOption.fromMap(e.key, e.value))
        .toList();

    return Poll(
      id: doc.id,
      question: data['question'] ?? '',
      options: options,
      totalVotes: data['totalVotes'] as int? ?? 0,
      endsAt: (data['endsAt'] as Timestamp?)?.toDate(),
      status: data['status'] ?? 'active',
    );
  }

  bool get isActive => status == 'active' && (endsAt == null || endsAt!.isAfter(DateTime.now()));

  Map<String, dynamic> toFirestore() {
    return {
      'question': question,
      'options': {for (var opt in options) opt.label: opt.votes},
      'totalVotes': totalVotes,
      'endsAt': endsAt != null ? Timestamp.fromDate(endsAt!) : null,
      'status': status,
    };
  }
}
