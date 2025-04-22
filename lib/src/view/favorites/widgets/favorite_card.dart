import 'package:cripto/bindings/app_binding.dart';
import 'package:cripto/src/view/cripto_details/cripto_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cripto/src/models/cripto.dart';
import 'package:cripto/src/view/favorites/favorites_controller.dart';

class FavoriteCard extends StatelessWidget {
  final Cripto cripto;
  final FavoritesController controller;

  const FavoriteCard({
    required this.cripto,
    required this.controller,
    super.key,
  });

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Remover dos favoritos',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Text('Tem certeza que deseja remover ${cripto.name} dos seus favoritos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Remover',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _removeFavorite(BuildContext context) {
    controller.removeFavorite(cripto.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${cripto.name} removido dos favoritos'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () => controller.addFavorite(cripto),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Dismissible(
        key: Key('favorite_card_${cripto.id}'),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) => _showDeleteConfirmation(context),
        onDismissed: (direction) => _removeFavorite(context),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 20),
            ],
          ),
        ),
        child: InkWell(
          onTap: () => Get.to(
                    () => DetailsPage(criptoId: cripto.id),
                    binding: AppBindings(),
                  ),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Obx(() {
                    final isFavorite = controller.isCoinFavorite(cripto.id);
                    return IconButton(
                      icon: Icon(
                        isFavorite.value ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () async {
                        final confirm = await _showDeleteConfirmation(context);
                        if (confirm == true) {
                          // ignore: use_build_context_synchronously
                          _removeFavorite(context);
                        }
                      },
                    );
                  }),
                  Expanded(
                    child: Text(
                      cripto.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Image.network(cripto.image, width: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}