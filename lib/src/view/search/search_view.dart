import 'package:cripto/src/view/home/home_controller.dart';
import 'package:cripto/src/view/search/widgets/cripto_modal.dart';
import 'package:cripto/src/view/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});
  final controller = Get.put(HomeController());
  final splashController = Get.find<SplashController>();

  void _showCriptoModal(BuildContext context, dynamic cripto) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite rolagem no modal
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).viewInsets.top + 20,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: CriptoModal(cripto: cripto),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await splashController.retryConnection();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: controller.filterCoins,
                decoration: InputDecoration(
                  labelText: 'Digite o nome da moeda',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.filteredCoins.isEmpty &&
                    controller.searchQuery.isNotEmpty) {
                  return Center(child: Text('Nenhuma moeda encontrada.'));
                }
                return ListView.builder(
                  itemCount: controller.filteredCoins.length,
                  itemBuilder: (context, index) {
                    final cripto = controller.filteredCoins[index];
                    return ListTile(
                      title: Text(cripto.name),
                      subtitle: Text(cripto.symbol.toUpperCase()),
                      leading: Image.network(cripto.image, width: 30),
                      onTap: () => _showCriptoModal(
                          context, cripto), 
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
