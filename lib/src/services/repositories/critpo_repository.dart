import 'package:cripto/src/models/cripto_details.dart';

import '../../models/cripto.dart';
import '../datasources/cripto_datasource.dart';

class CriptoRepository {
  final CriptoDataSource dataSource;

  CriptoRepository(this.dataSource);

  Future<List<Cripto>> fetchAllCoins() async {
    return await dataSource.fetchAllCoins();
  }

  Future<CriptoDetails> fetchCriptoDetails(String id) async {
    try {
      final data = await dataSource.fetchCriptoDetails(id);
      return data;
    } catch (e) {
      Exception('Erro no repository: $e');
      rethrow;
    }
  }
}
