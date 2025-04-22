import 'package:cripto/bindings/app_binding.dart';
import 'package:cripto/src/view/search/widgets/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../cripto_details/cripto_details_view.dart';
import '../../favorites/favorites_controller.dart';

class CriptoModal extends StatelessWidget {
  final dynamic cripto; 

  const CriptoModal({super.key, required this.cripto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(cripto.image, width: 40),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cripto.name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Obx(() {
                  final isFavorite =
                      Get.find<FavoritesController>().isCoinFavorite(cripto.id);
                  return IconButton(
                    icon: Icon(
                      isFavorite.value ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      if (isFavorite.value) {
                        Get.find<FavoritesController>().removeFavorite(cripto.id);
                      } else {
                        Get.find<FavoritesController>().addFavorite(cripto);
                      }
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Preço: R\$ ${cripto.currentPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Variação: ${cripto.priceChangePercentage24h.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 16,
                color: cripto.priceChangePercentage24h >= 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Volume: R\$${cripto.totalVolume.toString()}',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gráfico da última semana',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            CryptoSparklineChart(
              cripto: cripto,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.to(
                    () => DetailsPage(criptoId: cripto.id),
                    binding: AppBindings(),
                  );
                },
                child: Text(
                  'Ver mais detalhes',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
