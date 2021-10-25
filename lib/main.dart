import 'package:clean_teste/bindings/app_bindings.dart';
import 'package:clean_teste/core/cache/cache_car_model.dart';
import 'package:clean_teste/core/theme/theme.dart';
import 'package:clean_teste/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheCarModelImpl().initialize();
  CacheCarModelImpl().registerAdapter();
  await CacheCarModelImpl().open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Cars Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
    );
  }
}
