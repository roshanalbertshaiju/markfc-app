import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/news/presentation/pages/news_screen.dart';
import '../../features/news/presentation/pages/article_detail_screen.dart';
import '../../shared/widgets/mifc_bottom_nav_bar.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/squad/presentation/pages/squad_screen.dart';
import '../../features/store/presentation/pages/store_screen.dart';


final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MifcShellPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/news',
                builder: (context, state) => const NewsScreen(),
                routes: [
                  GoRoute(
                    path: 'article/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '1';
                      return ArticleDetailScreen(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/squad',
                builder: (context, state) => const SquadScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/store',
                builder: (context, state) => const StoreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (context, state) => const SizedBox.shrink(), // Opened via BottomSheet
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/fixtures',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Fixtures'))),
      ),
    ],
  );
});

class MifcShellPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MifcShellPage({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: MifcBottomNavBar(navigationShell: navigationShell),
    );
  }
}
