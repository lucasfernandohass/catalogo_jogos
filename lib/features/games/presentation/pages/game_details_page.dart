import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_details_viewmodel_provider.dart';
import '/features/favorites/presentation/providers/favorites_viewmodel_provider.dart';
import '/features/favorites/data/models/favorite_game_model.dart';

class GameDetailsPage extends ConsumerStatefulWidget {
  final int gameId;

  const GameDetailsPage({
    super.key,
    required this.gameId,
  });

  @override
  ConsumerState<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends ConsumerState<GameDetailsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(gameDetailsViewModelProvider.notifier)
          .loadGame(widget.gameId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameDetailsViewModelProvider);
    final favVM = ref.watch(favoritesViewModelProvider.notifier);
    final favState = ref.watch(favoritesViewModelProvider);

    final game = state.game;

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Scaffold(
        body: Center(child: Text(state.error!)),
      );
    }

    if (game == null) {
      return const Scaffold(
        body: Center(child: Text("Jogo não encontrado")),
      );
    }

    final isFavorite = favState.any((g) => g.id == game.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                game.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    game.image,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  favVM.toggleFavorite(
                    FavoriteGameModel(
                      id: game.id,
                      name: game.name,
                      image: game.image,
                      rating: game.rating,
                    ),
                  );
                },
              )
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text("${game.rating}"),
                      const SizedBox(width: 12),
                      Text("(${game.ratingCount} reviews)"),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Descrição",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    game.description,
                    style: const TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}