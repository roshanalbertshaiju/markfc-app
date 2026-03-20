import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markfc/features/news/domain/models/news_article.dart';
import 'package:markfc/features/store/domain/models/product.dart';
import 'package:markfc/features/home/domain/models/poll.dart';
import 'package:markfc/features/home/domain/models/player_of_the_month.dart';
import 'package:markfc/features/home/domain/models/fan_of_the_month.dart';
import 'package:markfc/features/home/domain/models/league_row.dart';
import 'package:markfc/features/squad/domain/models/player.dart';
import 'package:markfc/features/home/domain/models/hero_slide.dart';

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
    debugPrint('Seeding News...');
    final newsCol = firestore.collection('news');
    final news = [
      NewsArticle(
        id: 'news_1',
        title: 'UNSTOPPABLE MARKFC SECURE HISTORIC DERBY WIN',
        content: 'A night to remember at the Prestige Arena as MarkFC dominated from start to finish...',
        imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=1000',
        category: 'MATCH REPORT',
        author: 'MarkFC Editor',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NewsArticle(
        id: 'news_2',
        title: 'EXCLUSIVE: ROSHAN ALBERT ON SEASON GOALS',
        content: 'Our star striker speaks exclusively about his ambitions for the upcoming trophy hunt...',
        imageUrl: 'https://images.unsplash.com/photo-1543351611-58f69d7c1781?q=80&w=1000',
        category: 'INTERVIEW',
        author: 'MarkFC Editor',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      NewsArticle(
        id: 'news_3',
        title: 'NEW TRAINING FACILITY UNVEILED',
        content: 'The club marks a milestone with the opening of our state-of-the-art training complex...',
        imageUrl: 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=1000',
        category: 'CLUB NEWS',
        author: 'MarkFC Editor',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    for (var n in news) {
      try {
        await newsCol.doc(n.id).set(n.toFirestore()).timeout(const Duration(seconds: 5));
      } catch (e) {
        debugPrint('Failed to seed news ${n.id}: $e');
      }
    }
    debugPrint('Seeded News.');

    // 2. Seed Videos
    // final videoCol = firestore.collection('video');
    /*
    final videos = [
      // VideoContent( // Removed as per instruction
      //   id: 'vid_1',
      //   title: 'INSIDE TRAINING: DERBY PREP',
      //   category: 'FEATURES',
      //   duration: '12:45',
      //   views: 15400,
      //   timestamp: DateTime.now().subtract(const Duration(days: 1)),
      //   imageUrl: 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=1000',
      //   videoUrl: 'https://example.com/video1',
      // ),
    ];
    */
    // for (var v in videos) {
    //   // await videoCol.doc(v.id).set(v.toFirestore()); // Removed as per instruction
    // }

    // 3. Seed Fixtures & Results
    // final fixtureCol = firestore.collection('fixtures');
    // final resultCol = firestore.collection('results');

    /*
    final matches = [
      // MatchModel( // Replaced with MatchFixture as per instruction
      //   id: 'match_live',
      //   homeTeam: 'MARKFC',
      //   awayTeam: 'CITY UNITED',
      //   homeCode: 'MIFC',
      //   awayCode: 'CITY',
      //   homeScore: 2,
      //   awayScore: 1,
      //   timestamp: DateTime.now(),
      //   competition: 'PREMIER ENGAGEMENT',
      //   venue: 'PRESTIGE ARENA',
      //   status: MatchStatus.live,
      //   scorers: [],
      // ),
      // MatchModel( // Replaced with MatchFixture as per instruction
      //   id: 'match_prev',
      //   homeTeam: 'RIVERSIDE',
      //   awayTeam: 'MARKFC',
      //   homeCode: 'RIV',
      //   awayCode: 'MIFC',
      //   homeScore: 0,
      //   awayScore: 3,
      //   timestamp: DateTime.now().subtract(const Duration(days: 3)),
      //   competition: 'ELITE CUP',
      //   venue: 'RIVERSIDE STADIUM',
      //   status: MatchStatus.finished,
      //   scorers: ['ALBERT 22\'', 'ROSHAN 45\'', 'MARK 88\''],
      // ),
    ];

    for (var m in matches) {
      // if (m.status == MatchStatus.finished) { // Removed as per instruction
      //   await resultCol.doc(m.id).set(m.toFirestore());
      // } else {
      //   await fixtureCol.doc(m.id).set(m.toFirestore());
      // }
    }
    */

    // 4. Seed Players
    debugPrint('Seeding Players...');
    final playersCol = firestore.collection('players');
    final players = [
      const Player(
        id: 'p1',
        name: 'ROSHAN ALBERT',
        number: '10',
        position: PlayerPosition.forward,
        category: TeamCategory.men,
        imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?auto=format&fit=crop&q=80&w=1000',
        goals: 12,
        assists: 8,
        rating: 8.9,
      ),
      const Player(
        id: 'p2',
        name: 'MARK SHAIJU',
        number: '4',
        position: PlayerPosition.defender,
        category: TeamCategory.men,
        imageUrl: 'https://images.unsplash.com/photo-1543351611-58f69d7c1781?auto=format&fit=crop&q=80&w=1000',
        goals: 2,
        assists: 1,
        rating: 8.5,
      ),
      const Player(
        id: 'p3',
        name: 'SHAIJU K',
        number: '7',
        position: PlayerPosition.midfielder,
        category: TeamCategory.men,
        imageUrl: 'https://images.unsplash.com/photo-1517466787929-bc90951d0974?auto=format&fit=crop&q=80&w=1000',
        goals: 5,
        assists: 12,
        rating: 8.7,
      ),
    ];
    for (var p in players) {
      try {
        await playersCol.doc(p.id).set(p.toFirestore()).timeout(const Duration(seconds: 5));
      } catch (e) {
        debugPrint('Failed to seed player ${p.id}: $e');
      }
    }
    debugPrint('Seeded Players.');

    // 5. Seed Shop
    debugPrint('Seeding Shop...');
    final shopCol = firestore.collection('shop');
    final products = [
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
      try {
        await shopCol.doc(prod.id).set(prod.toFirestore()).timeout(const Duration(seconds: 5));
      } catch (e) {
        debugPrint('Failed to seed product ${prod.id}: $e');
      }
    }
    debugPrint('Seeded Shop.');

    // 6. Seed Polls
    debugPrint('Seeding Polls...');
    final pollCol = firestore.collection('match-polls');
    final activePoll = Poll(
      id: 'poll_1',
      question: 'WHO WAS YOUR PLAYER OF THE MATCH AGAINST CITY UNITED?',
      options: [
        PollOption(label: 'ROSHAN ALBERT', votes: 1240),
        PollOption(label: 'MARK SHAIJU', votes: 890),
        PollOption(label: 'SHAIJU K', votes: 450),
      ],
      totalVotes: 2580,
      status: 'active',
      endsAt: DateTime.now().add(const Duration(days: 2)),
    );
    try {
      await pollCol.doc(activePoll.id).set(activePoll.toFirestore()).timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('Failed to seed poll: $e');
    }
    debugPrint('Seeded Match Polls.');

    // 7. Seed Awards
    debugPrint('Seeding Awards...');
    final awardsCol = firestore.collection('awards');
    final potm = PlayerOfTheMonth(
      id: 'potm_current',
      name: 'ROSHAN ALBERT',
      month: 'FEBRUARY 2026',
      position: 'FORWARD',
      appearances: 5,
      goals: 8,
      assists: 3,
      rating: 9.2,
      imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=1000',
    );
    final fotm = FanOfTheMonth(
      id: 'fotm_current',
      name: 'SHAIJU K',
      initials: 'SK',
      month: 'FEBRUARY 2026',
      supporterSince: '2015',
      tier: 'PLATINUM',
      matchesAttended: 12,
      points: '8.4K',
    );
    try {
      await awardsCol.doc('player-of-the-month').set(potm.toFirestore()).timeout(const Duration(seconds: 5));
      await awardsCol.doc('fan-of-the-month').set(fotm.toFirestore()).timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('Failed to seed awards: $e');
    }
    debugPrint('Seeded Awards.');

    // 8. Seed League Table
    debugPrint('Seeding League Table...');
    final leagueCol = firestore.collection('league-table');
    final leagueRows = [
      LeagueRow(position: 1, teamCode: 'MIFC', teamName: 'MARKFC', played: 24, points: 58, form: ['W', 'W', 'W', 'D', 'W'], isMifc: true),
      LeagueRow(position: 2, teamCode: 'CITY', teamName: 'CITY UNITED', played: 24, points: 55, form: ['W', 'L', 'W', 'W', 'W']),
      LeagueRow(position: 3, teamCode: 'RIV', teamName: 'RIVERSIDE', played: 24, points: 49, form: ['D', 'W', 'L', 'W', 'D']),
      LeagueRow(position: 4, teamCode: 'LAK', teamName: 'LAKESIDE FC', played: 24, points: 45, form: ['L', 'W', 'W', 'D', 'L']),
    ];
    for (var row in leagueRows) {
      try {
        await leagueCol.doc('row_${row.position}').set(row.toFirestore()).timeout(const Duration(seconds: 5));
      } catch (e) {
        debugPrint('Failed to seed league row ${row.position}: $e');
      }
    }
    debugPrint('Seeded League Table.');

    // 9. Seed Hero Section
    debugPrint('Seeding Hero Section...');
    final heroCol = firestore.collection('hero-sec');

    try {
      // CLEANUP: Delete all existing documents in hero-sec to start fresh and remove duplicates
      final existingSlides = await heroCol.get().timeout(const Duration(seconds: 15));
      for (var doc in existingSlides.docs) {
        try {
          await doc.reference.delete().timeout(const Duration(seconds: 10));
        } catch (e) {
          debugPrint('Failed to delete slide ${doc.id}: $e');
        }
      }
      debugPrint('Cleaned up existing hero slides.');

      final slides = [
        HeroSlide(
          tag: 'MATCH TICKETS',
          date: 'MARCH 25, 2026',
          headline: 'DERBY TICKETS NOW ON SALE',
          body: 'Secure your seat for the biggest game of the season against City United.',
          buttons: [
            HeroSlideButton(label: 'BUY TICKETS', link: '/tickets'),
            HeroSlideButton(label: 'VIEW FIXTURES', link: '/fixtures'),
          ],
          imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=1000',
          timestamp: DateTime.now(),
        ),
        HeroSlide(
          tag: 'ELITE HUB',
          date: 'NEW FEATURE',
          headline: 'JOIN THE ELITE HUB',
          body: 'Experience the premium fan community with exclusive stats and activities.',
          buttons: [
            HeroSlideButton(label: 'JOIN NOW', link: '/profile'),
          ],
          imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=1000',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        HeroSlide(
          tag: 'STORE',
          date: 'NEW ARRIVALS',
          headline: 'OFFICIAL 2026 KIT AVAILABLE',
          body: 'Get the latest Mark International FC home and away kits.',
          buttons: [
            HeroSlideButton(label: 'SHOP NOW', link: '/store'),
          ],
          imageUrl: 'https://images.unsplash.com/photo-1522778119026-d647f0596c20?q=80&w=1000',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      ];
      
      // Use set with fixed ID to doubly ensure no duplicates
      for (int i = 0; i < slides.length; i++) {
        await heroCol.doc('slide_${i + 1}').set(slides[i].toFirestore()).timeout(const Duration(seconds: 15));
      }
      debugPrint('Seeded Hero Section with ${slides.length} fresh slides.');
    } catch (e) {
      debugPrint('Failed to seed hero slides: $e');
    }

    debugPrint('Firebase Seeding Complete! 🚀');
  }
}
