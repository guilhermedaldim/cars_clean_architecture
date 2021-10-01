import 'package:clean_teste/presentation/pages/detail_page.dart';
import 'package:clean_teste/presentation/pages/home_page.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage<HomePage>(
      name: Routes.home,
      page: () => const HomePage(),
    ),
    GetPage<DetailPage>(
      name: Routes.detail,
      page: () => const DetailPage(),
    ),
  ];
}
