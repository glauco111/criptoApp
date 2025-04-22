import 'package:cripto/src/models/cripto_details.dart';
import 'package:cripto/src/services/repositories/critpo_repository.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CriptoDetailsController extends GetxController {
  final CriptoRepository _repository;
  
  final Rxn<CriptoDetails> details = Rxn<CriptoDetails>();
  final RxBool isLoading = false.obs;
  final Rxn<Exception> error = Rxn<Exception>();
  final RxString currentCriptoId = RxString('');

  CriptoDetailsController(this._repository);

  Future<void> loadDetails(String criptoId) async {
    try {
      currentCriptoId(criptoId);
      isLoading(true);
      error(null);
      details(null);

      final detailsData = await _repository.fetchCriptoDetails(criptoId);
      
      if (detailsData.marketData == null) {
        throw Exception('Dados incompletos da API');
      }
      
      details(detailsData);
    } on DioException catch (e) {
      error(Exception('Erro de conexão: ${e.message}'));
    } on Exception catch (e) {
      error(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshDetails() async {
    if (currentCriptoId.value.isNotEmpty) {
      await loadDetails(currentCriptoId.value);
    }
  }
}