// lib/app/bindings/app_bindings.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cripto/src/services/datasources/cripto_datasource.dart';
import 'package:cripto/src/services/repositories/critpo_repository.dart';
import 'package:cripto/src/view/cripto_details/cripto_details_controller.dart';
import 'package:cripto/src/view/favorites/favorites_controller.dart';
import 'package:cripto/src/view/splash/splash_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart'; // Verifique o nome real do arquivo

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio());
    Get.lazyPut(() => CriptoDataSource(Get.find<Dio>()));
    Get.lazyPut(() => CriptoRepository(Get.find<CriptoDataSource>()));
    Get.lazyPut(() => Connectivity());
    Get.lazyPut(() => CriptoRepository(Get.find()));
    Get.lazyPut(() => SplashController(Get.find(), Get.find()));
    Get.lazyPut(() => FavoritesController());
    Get.lazyPut(() => CriptoDetailsController(Get.find<CriptoRepository>()));
  }
}
