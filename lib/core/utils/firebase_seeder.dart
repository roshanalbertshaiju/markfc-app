import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markfc/features/news/domain/models/news_article.dart';
import 'package:markfc/features/news/domain/models/video_content.dart';
import 'package:markfc/features/fixtures/domain/models/match_model.dart';
import 'package:markfc/features/squad/domain/models/player.dart';
import 'package:markfc/features/store/domain/models/product.dart';
import 'package:markfc/features/profile/domain/models/mifc_user.dart';

class FirebaseSeeder {
  static Future<void> seedData({bool force = false}) async {
    final firestore = FirebaseFirestore.instance;

    // GUARD: Only seed if news is empty (unless forced)
    if (!force) {
      final newsCheck = await firestore
        .collection('news')
        .limit(1)
        .get()
        .timeout(const Duration(seconds: 5));
      if (newsCheck.docs.isNotEmpty) {
        debugPrint('Firebase Seeding skipped: Data already exists.');
        return;
      }
    }

    // 1. Seed News
    final newsCol = firestore.collection('news');
    final news = [
      NewsArticle(
        id: 'news_1',
        title: 'UNSTOPPABLE MARKFC SECURE HISTORIC DERBY WIN',
        content: 'A night to remember at the Prestige Arena as MarkFC dominated from start to finish...',
        imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=1000',
        category: 'MATCH REPORT',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NewsArticle(
        id: 'news_2',
        title: 'EXCLUSIVE: ROSHAN ALBERT ON SEASON GOALS',
        content: 'Our star striker speaks exclusively about his ambitions for the upcoming trophy hunt...',
        imageUrl: 'https://images.unsplash.com/photo-1543351611-58f69d7c1781?q=80&w=1000',
        category: 'INTERVIEW',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      NewsArticle(
        id: 'news_3',
        title: 'NEW TRAINING FACILITY UNVEILED',
        content: 'The club marks a milestone with the opening of our state-of-the-art training complex...',
        imageUrl: 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=1000',
        category: 'CLUB NEWS',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    for (var n in news) {
      await newsCol.doc(n.id).set(n.toFirestore());
    }

    // 2. Seed Videos
    final videoCol = firestore.collection('video');
    final videos = [
      VideoContent(
        id: 'vid_1',
        title: 'INSIDE TRAINING: DERBY PREP',
        category: 'FEATURES',
        duration: '12:45',
        views: 15400,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        imageUrl: 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=1000',
        videoUrl: 'https://example.com/video1',
      ),
    ];
    for (var v in videos) {
      await videoCol.doc(v.id).set(v.toFirestore());
    }

    // 3. Seed Fixtures & Results
    final fixtureCol = firestore.collection('fixtures');
    final resultCol = firestore.collection('results');

    final matches = [
      MatchModel(
        id: 'match_live',
        homeTeam: 'MARKFC',
        awayTeam: 'CITY UNITED',
        homeCode: 'MIFC',
        awayCode: 'CITY',
        homeScore: 2,
        awayScore: 1,
        timestamp: DateTime.now(),
        competition: 'PREMIER ENGAGEMENT',
        venue: 'PRESTIGE ARENA',
        status: MatchStatus.live,
        scorers: [],
      ),
      MatchModel(
        id: 'match_prev',
        homeTeam: 'RIVERSIDE',
        awayTeam: 'MARKFC',
        homeCode: 'RIV',
        awayCode: 'MIFC',
        homeScore: 0,
        awayScore: 3,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        competition: 'ELITE CUP',
        venue: 'RIVERSIDE STADIUM',
        status: MatchStatus.finished,
        scorers: ['ALBERT 22\'', 'ROSHAN 45\'', 'MARK 88\''],
      ),
    ];

    for (var m in matches) {
      if (m.status == MatchStatus.finished) {
        await resultCol.doc(m.id).set(m.toFirestore());
      } else {
        await fixtureCol.doc(m.id).set(m.toFirestore());
      }
    }

    // 4. Seed Players
    final playersCol = firestore.collection('players');
    final players = [
      Player(
        id: 'p1',
        name: 'ROSHAN ALBERT',
        number: '10',
        position: PlayerPosition.forward,
        category: TeamCategory.men,
        imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=1000',
        goals: 12,
        assists: 8,
        rating: 8.9,
      ),
      Player(
        id: 'p2',
        name: 'MARK SHAIJU',
        number: '4',
        position: PlayerPosition.defender,
        category: TeamCategory.men,
        imageUrl: 'https://images.unsplash.com/photo-1543351611-58f69d7c1781?q=80&w=1000',
        goals: 2,
        assists: 1,
        rating: 8.5,
      ),
    ];
    for (var p in players) {
      await playersCol.doc(p.id).set(p.toFirestore());
    }

    // 5. Seed Shop
    final shopCol = firestore.collection('shop');
    final products = [
      Product(
        id: 'kit_1',
        name: '24/25 HOME KIT',
        price: '£75.00',
        emoji: '👕',
        category: 'MATCH KITS',
        isNew: true,
        hasGoldBorder: true,
        gradientHexColors: ['#D41414', '#7A0C0C'],
      ),
      Product(
        id: 'acc_1',
        name: 'ELITE SCARF',
        price: '£15.00',
        emoji: '🧣',
        category: 'ACCESSORIES',
        gradientHexColors: ['#1A1A1A', '#000000'],
      ),
    ];
    for (var prod in products) {
      await shopCol.doc(prod.id).set(prod.toFirestore());
    }

    print('Firebase Seeding Complete! 🚀');
  }
}
