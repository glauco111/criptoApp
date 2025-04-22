// modules/home/home_controller.dart
import 'package:cripto/src/models/cripto.dart';
import 'package:cripto/src/view/splash/splash_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final allCoins = <Cripto>[].obs; 
  final filteredCoins = <Cripto>[].obs;
  final searchQuery = ''.obs; 
  final RxInt currentIndex = 0.obs;
  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    allCoins.assignAll(Get.find<SplashController>().coins);
    filteredCoins.assignAll(allCoins); 
  }

  void filterCoins(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredCoins.assignAll(allCoins);
    } else {
      filteredCoins.assignAll(
        allCoins
            .where(
              (coin) => coin.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  String get appBarTitle {
    switch (currentIndex.value) {
      case 0:
        return 'Pesquisar Criptomoedas';
      case 1:
        return 'Criptos Favoritas';
      default:
        return 'Cripto App';
    }
  }
}
