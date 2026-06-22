import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_details_viewmodel_provider.dart';

class GameDetailsPage extends ConsumerStatefulWidget {
  final int gameId;

  const GameDetailsPage({super.key, required this.gameId});

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

    final game = state.game;

    return Scaffold(
      appBar: AppBar(title: Text(game?.name ?? 'Detalhes')),
      body: game == null
          ? const SizedBox()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(game.image),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(game.name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Rating: ${game.rating} ⭐"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(game.description),
                  ),
                ],
              ),
            ),
    );
  }
}