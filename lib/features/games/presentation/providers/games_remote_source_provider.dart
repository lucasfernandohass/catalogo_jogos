import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/sources/games_remote_source.dart';


final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final dioClientProvider = Provider<DioClient>((ref) {
  final dio = ref.watch(dioProvider);
  return DioClient(dio);
});

final gamesRemoteSourceProvider = Provider<GamesRemoteSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return GamesRemoteSource(dioClient.dio);
});