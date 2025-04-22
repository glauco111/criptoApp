import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../resources/app_colors.dart';
import 'splash_controller.dart';

class SplashPage extends StatelessWidget {
  final controller = Get.find<SplashController>();

  SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(() {
        if (controller.errorMessage.isNotEmpty) {
          return _buildErrorView();
        }
        return _buildLoadingView();
      }),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/bg.png', fit: BoxFit.cover, width: 200),
          const SizedBox(height: 20),
          const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
          const SizedBox(height: 20),
          const Text(
            'Cripto App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/bg.png', width: 150),
            const SizedBox(height: 30),
            const Icon(
              Icons.wifi_off,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'Você está sem conexão com a internet\nverifique sua conexão e tente novamente.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.bgColor,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(), 
                elevation: 3,
                shadowColor: Colors.black,
              ),
              onPressed: controller.retryConnection,
              child: const Icon(
                Icons.replay,
                color: AppColors.bgColor,
                size: 30,
              ),
            )
          ],
        ),
      ),
    );
  }
}
