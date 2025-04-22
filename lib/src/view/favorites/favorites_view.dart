import 'package:cripto/src/resources/app_colors.dart';
import 'package:cripto/src/view/favorites/favorites_controller.dart';
import 'package:cripto/src/view/favorites/widgets/favorite_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesView extends StatelessWidget {
  FavoritesView({super.key});

  final controller = Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgColor,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Obx(
              () => controller.favorites.isEmpty
                  ? const Center(
                      child: Text(
                      'Nenhuma moeda favorita.',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ))
                  : ListView.builder(
                      itemCount: controller.favorites.length,
                      itemBuilder: (context, index) {
                        return FavoriteCard(
                          cripto: controller.favorites[index],
                          controller: controller,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
