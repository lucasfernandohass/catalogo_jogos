import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorites_viewmodel_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: favorites.isEmpty
          ? const Center(child: Text('Nenhum favorito ainda'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final game = favorites[index];

                return ListTile(
                  leading: Image.network(game.image, width: 50),
                  title: Text(game.name),
                  subtitle: Text("⭐ ${game.rating}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref
                          .read(favoritesViewModelProvider.notifier)
                          .toggleFavorite(game);
                    },
                  ),
                );
              },
            ),
    );
  }
}