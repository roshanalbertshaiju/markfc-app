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
  // try {
  //   await FirebaseSeeder.seedData(force: true);
  // } catch (e) {
  //   debugPrint('Firebase Seeding failed: $e');
  // }

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
