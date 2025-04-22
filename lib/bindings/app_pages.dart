import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cripto/src/view/cripto_details/cripto_details_view.dart';
import 'package:cripto/src/view/home/home_view.dart';
import 'package:get/get.dart';
import '../src/services/repositories/critpo_repository.dart';
import '../src/view/splash/splash_controller.dart';
import '../src/view/splash/splash_view.dart';

abstract class Routes {
  // ignore: constant_identifier_names
  static const splash = '/splash';
  // ignore: constant_identifier_names
  static const home = '/home';
  // ignore: constant_identifier_names
  static const details = '/details';
}

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => SplashPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SplashController(
            Get.find<CriptoRepository>(), Get.find<Connectivity>()));
      }),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
    ),
    GetPage(
      name: Routes.details,
      page: () {
        final cripto = Get.arguments as String;
        return DetailsPage(criptoId: cripto);
      },
    ),
  ];
}
