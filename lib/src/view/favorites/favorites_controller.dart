import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/cripto.dart'; 

class FavoritesController extends GetxController {
  final RxList<Cripto> _favoriteCoins = <Cripto>[].obs;
  final String _prefsKey = 'favorite_coins';

  List<Cripto> get favorites => _favoriteCoins;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFavoritesJson = prefs.getStringList(_prefsKey) ?? [];
    
    _favoriteCoins.assignAll(
      savedFavoritesJson.map((json) => Cripto.fromJson(jsonDecode(json))).toList()
    );
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _prefsKey,
      _favoriteCoins.map((cripto) => jsonEncode(cripto.toJson())).toList()
    );
  }

  void addFavorite(Cripto cripto) {
    if (!_favoriteCoins.any((c) => c.id == cripto.id)) {
      _favoriteCoins.add(cripto);
      _saveFavorites();
    }
  }

  void removeFavorite(String criptoId) {
    _favoriteCoins.removeWhere((c) => c.id == criptoId);
    _saveFavorites();
  }

  bool isFavorite(String criptoId) {
    return _favoriteCoins.any((c) => c.id == criptoId);
  }

    RxBool isCoinFavorite(String criptoId) {
    return _favoriteCoins.any((c) => c.id == criptoId).obs;
  }
}