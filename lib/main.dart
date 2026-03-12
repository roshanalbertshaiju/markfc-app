import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/mifc_theme.dart';
import 'core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Add Firebase.initializeApp() when firebase_options is verified
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
      theme: MifcTheme.lightTheme,
      routerConfig: router,
    );
  }
}
