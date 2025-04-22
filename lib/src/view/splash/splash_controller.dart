import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cripto/src/models/cripto.dart';
import 'package:cripto/src/services/repositories/critpo_repository.dart';
import '../../../bindings/app_pages.dart';

class SplashController extends GetxController {
  final CriptoRepository _repository;
  final Connectivity _connectivity;

  SplashController(this._repository, this._connectivity);

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final hasInternet = true.obs;
  final coins = <Cripto>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      isLoading(true);
      errorMessage('');
      final connectivityResult = await _connectivity.checkConnectivity();
      // ignore: unrelated_type_equality_checks
      hasInternet(connectivityResult != ConnectivityResult.none);

      if (!hasInternet.value) {
        throw Exception('Sem conexão com a internet');
      }

      final result = await _repository.fetchAllCoins();
      coins.assignAll(result);

      await Future.delayed(const Duration(seconds: 2));
      Get.offNamed(Routes.home);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> retryConnection() async {
    hasInternet(true);
    errorMessage('');
    await _loadInitialData();
  }
}
