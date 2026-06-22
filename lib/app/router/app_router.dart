import 'package:go_router/go_router.dart';

import 'package:catalogo_jogos/features/games/presentation/pages/home_page.dart';
import 'package:catalogo_jogos/features/games/presentation/pages/game_details_page.dart';
import 'package:catalogo_jogos/features/favorites/presentation/pages/favorites_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      GoRoute(
        path: '/game/:id',
        name: 'gameDetails',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);

          return GameDetailsPage(gameId: id);
        },
      ),

      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
    ],
  );
}