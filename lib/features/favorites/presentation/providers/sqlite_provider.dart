import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/sources/favorites_local_source.dart';

final sqliteProvider = Provider<FavoritesLocalSource>(
  (ref) => FavoritesLocalSource(),
);