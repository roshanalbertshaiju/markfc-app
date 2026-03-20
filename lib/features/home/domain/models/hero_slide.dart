import 'package:cloud_firestore/cloud_firestore.dart';

class HeroSlideButton {
  final String label;
  final String link;

  HeroSlideButton({
    required this.label,
    required this.link,
  });

  factory HeroSlideButton.fromMap(Map<String, dynamic> map) {
    return HeroSlideButton(
      label: map['text'] ?? '',
      link: map['link'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': label,
      'link': link,
    };
  }
}

class HeroSlide {
  final String tag;
  final String date;
  final String headline;
  final String body;
  final List<HeroSlideButton> buttons;
  final String imageUrl;
  final DateTime? timestamp;

  HeroSlide({
    required this.tag,
    required this.date,
    required this.headline,
    required this.body,
    required this.buttons,
    required this.imageUrl,
    this.timestamp,
  });

  factory HeroSlide.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Parse buttons array
    final List<dynamic> buttonsList = data['buttons'] ?? [];
    final buttons = buttonsList
        .map((b) => HeroSlideButton.fromMap(b as Map<String, dynamic>))
        .toList();

    return HeroSlide(
      tag: data['tag'] ?? 'MIFC', // Default if missing
      date: data['date'] ?? '',
      headline: data['title'] ?? '', // Mapping 'title' from Firestore to 'headline'
      body: data['subtitle'] ?? '', // Mapping 'subtitle' from Firestore to 'body'
      buttons: buttons,
      imageUrl: data['image'] ?? '',
      timestamp: _parseDateTime(data['timestamp']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tag': tag,
      'date': date,
      'title': headline,
      'subtitle': body,
      'buttons': buttons.map((b) => b.toMap()).toList(),
      'image': imageUrl,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : FieldValue.serverTimestamp(),
    };
  }
}
