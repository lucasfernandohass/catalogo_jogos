import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/games_viewmodel_provider.dart';
import '../../../../app/theme/theme_provider.dart';
import '/features/favorites/presentation/providers/favorites_viewmodel_provider.dart';
import '/features/favorites/data/models/favorite_game_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(gamesViewModelProvider.notifier).loadGames();
    });

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients) return;

    final state = ref.read(gamesViewModelProvider);

    if (state.isLoadingMore || state.hasReachedEnd) return;

    final position = _controller.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(gamesViewModelProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  FavoriteGameModel _toFavorite(dynamic game) {
    return FavoriteGameModel(
      id: game.id,
      name: game.name,
      image: game.image,
      rating: game.rating,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gamesViewModelProvider);
    final themeState = ref.watch(themeViewModelProvider);

    final favState = ref.watch(favoritesViewModelProvider);
    final favVM = ref.read(favoritesViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Jogos'),

        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              context.push('/favorites');
            },
          ),

          IconButton(
            icon: Icon(
              themeState.isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              ref.read(themeViewModelProvider.notifier).toggleTheme();
            },
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar jogos...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                ref
                    .read(gamesViewModelProvider.notifier)
                    .searchGames(value);
              },
            ),
          ),
        ),
      ),

      body: Builder(
        builder: (_) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.games.isEmpty) {
            return Center(child: Text(state.error!));
          }

          return GridView.builder(
            controller: _controller,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: state.games.length + 1,
            itemBuilder: (context, index) {
              if (index == state.games.length) {
                if (state.hasReachedEnd) {
                  return const Center(child: Text("Fim dos jogos"));
                }

                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }

              final game = state.games[index];
              final isFav = favState.any((g) => g.id == game.id);

              return GestureDetector(
                onTap: () {
                  context.push('/game/${game.id}');
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: game.image.isNotEmpty
                                  ? Image.network(
                                      game.image,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.videogame_asset),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              game.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text("${game.rating}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          favVM.toggleFavorite(_toFavorite(game));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}