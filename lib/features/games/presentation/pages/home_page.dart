import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/games_viewmodel_provider.dart';
import '../../../../app/theme/theme_provider.dart';

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

    final position = _controller.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(gamesViewModelProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gamesViewModelProvider);
    final themeState = ref.watch(themeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Catalog'),

        actions: [
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
          if (state.isLoading && state.games.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.games.isEmpty) {
            return Center(child: Text(state.error!));
          }

          return ListView.builder(
            controller: _controller,
            itemCount: state.games.length + 1,
            itemBuilder: (context, index) {
              if (index < state.games.length) {
                final game = state.games[index];

                return ListTile(
                  title: Text(game.name),
                  leading: game.image.isNotEmpty
                      ? Image.network(game.image, width: 50)
                      : const Icon(Icons.videogame_asset),
                  onTap: () {
                    context.push('/game/${game.id}');
                  },
                );
              }

              // loader pagination
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: state.isLoadingMore
                      ? const CircularProgressIndicator()
                      : const SizedBox(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}