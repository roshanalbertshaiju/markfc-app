import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/mifc_theme.dart';
import 'core/router/app_router.dart';
import 'core/utils/firebase_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SEED DATA ONCE
  debugPrint('DEBUG: Calling FirebaseSeeder.seedData(force: true)');
  try {
    // We don't await indefinitely to prevent hanging main
    FirebaseSeeder.seedData(force: true).timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        debugPrint('Firebase Seeding Timed Out (20s) - App will continue anyway.');
      },
    ).catchError((e) {
      debugPrint('Firebase Seeding Background Error: $e');
    });
  } catch (e) {
    debugPrint('Firebase Seeding Initial Failure: $e');
  }
  debugPrint('DEBUG: Proceeding to runApp');

  runApp(
    const ProviderScope(
      child: MifcApp(),
    ),
  );
}

class MifcApp extends ConsumerWidget {
  const MifcApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'MIFC',
      debugShowCheckedModeBanner: false,
      theme: MifcTheme.darkTheme,
      routerConfig: router,
    );
  }
}
