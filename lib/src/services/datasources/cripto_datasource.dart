import 'package:cripto/src/models/cripto.dart';
import 'package:cripto/src/services/datasources/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/cripto_details.dart';

class CriptoDataSource {
  final Dio dio;
  final apiKey = dotenv.env['API_KEY'];

  CriptoDataSource(this.dio);

  Future<List<Cripto>> fetchAllCoins() async {
    try {
      final response = await dio.get(
        'https://api.coingecko.com/api/v3/coins/markets',
        options: Options(
          headers: {
            'x-cg-demo-api-key': apiKey,
          },
        ),
        queryParameters: {
          'vs_currency': 'brl',
          'precision': 2,
          'order': 'market_cap_desc',
          'sparkline': true,
          'price_change_percentage': '24h',
        },
      );

      return (response.data as List)
          .map((json) => Cripto.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Falha na busca: ${e.message}');
    }
  }

  Future<CriptoDetails> fetchCriptoDetails(String id) async {
    try {
      final response = await dio.get(
        'https://api.coingecko.com/api/v3/coins/$id',
        options: Options(
          headers: {
            'x-cg-demo-api-key': apiKey,
            'Accept': 'application/json',
          },
        ),
        queryParameters: {
          'vs_currency': 'brl',
          'market_data': true,
          'tickers': false,
          'price_change_percentage': '24h',
          'sparkline': true
        },
      );

      if (response.statusCode == 200) {
        return CriptoDetails.fromJson(response.data);
      } else {
        throw ApiException(
          'Falha ao carregar detalhes $id: Status ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e, 'fetchCriptoDetails');
    } catch (e) {
      throw ApiException('Ocorreu um erro: ${e.toString()}');
    }
  }

  ApiException _handleDioError(DioException e, String methodName) {
    if (e.response != null) {
      final data = e.response?.data;
      final message = data is Map
          ? data['error'] ?? data['message'] ?? e.message
          : e.message;

      return ApiException(
        'API Error in $methodName: $message',
        e.response?.statusCode,
      );
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return ApiException('Connection timeout in $methodName', 408);
    } else if (e.type == DioExceptionType.cancel) {
      return ApiException('Request to $methodName was cancelled', -1);
    } else if (e.type == DioExceptionType.badCertificate) {
      return ApiException('Bad certificate in $methodName', 495);
    } else if (e.type == DioExceptionType.connectionError) {
      return ApiException('Connection error in $methodName', 502);
    } else {
      return ApiException('Network error in $methodName: ${e.message}');
    }
  }
}
