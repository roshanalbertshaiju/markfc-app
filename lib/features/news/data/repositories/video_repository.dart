import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/video_content.dart';
import '../../../news/data/repositories/news_repository.dart'; // To reuse firestoreProvider

class VideoRepository {
  final FirebaseFirestore _firestore;

  VideoRepository(this._firestore);

  Stream<List<VideoContent>> watchVideos() {
    return _firestore
        .collection('video')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VideoContent.fromFirestore(doc))
            .toList());
  }

  Future<void> incrementViews(String videoId) async {
    await _firestore.collection('video').doc(videoId).update({
      'views': FieldValue.increment(1),
    });
  }
}

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return VideoRepository(firestore);
});

final allVideosProvider = StreamProvider<List<VideoContent>>((ref) {
  return ref.watch(videoRepositoryProvider).watchVideos();
});
