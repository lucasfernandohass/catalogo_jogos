import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/features/favorites/presentation/providers/favorites_viewmodel_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesViewModelProvider);
    final favVM = ref.read(favoritesViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),

      body: favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Nenhum favorito ainda",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final game = favorites[index];

                return Card(
                  child: ListTile(
                    leading: game.image.isNotEmpty
                        ? Image.network(game.image, width: 50, fit: BoxFit.cover)
                        : const Icon(Icons.videogame_asset),

                    title: Text(game.name),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        favVM.toggleFavorite(game);
                      },
                    ),

                    onTap: () {
                      context.push('/game/${game.id}');
                    },
                  ),
                );
              },
            ),
    );
  }
}