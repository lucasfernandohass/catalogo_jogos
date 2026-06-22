import 'package:dio/dio.dart';
import 'package:catalogo_jogos/app/constants/api_constants.dart';

class DioClient {
  final Dio dio;

  DioClient(this.dio) {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }
}