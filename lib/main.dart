import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'bindings/app_binding.dart';
import 'bindings/app_pages.dart';
import 'src/resources/app_colors.dart';

void main() async {
  await dotenv.load(fileName: '.env'); 

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cripto App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bgColor),
        useMaterial3: true,
      ),
      initialRoute: Routes.splash,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
    );
  }
}
