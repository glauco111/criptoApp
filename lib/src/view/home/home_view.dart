import 'package:cripto/src/view/favorites/favorites_view.dart';
import 'package:cripto/src/view/home/home_controller.dart';
import 'package:cripto/src/view/search/search_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../resources/app_colors.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = Get.put(HomeController());
  final List<Widget> pages = [
    SearchView(),
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              controller.appBarTitle,
              style: const TextStyle(color: Colors.white),
            )),
        backgroundColor: AppColors.bgColor,
      ),
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: pages.length,
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.currentIndex.value = index;
        },
        itemBuilder: (context, index) {
          return pages[index];
        },
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            elevation: 0,
            currentIndex: controller.currentIndex.value,
            selectedItemColor: theme,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: controller.changePage,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Favoritos',
              ),
            ],
          )),
    );
  }
}
