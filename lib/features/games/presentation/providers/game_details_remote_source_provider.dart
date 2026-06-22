import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/sources/game_details_remote_source.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final dioClientProvider = Provider<DioClient>((ref) {
  final dio = ref.watch(dioProvider);
  return DioClient(dio);
});

final gameDetailsRemoteSourceProvider =
    Provider<GameDetailsRemoteSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return GameDetailsRemoteSource(dioClient.dio);
});