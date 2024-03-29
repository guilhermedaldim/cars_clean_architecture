import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_teste/data/models/car_model.dart';
import 'package:clean_teste/domain/entities/car_entity.dart';
import 'package:clean_teste/presentation/controllers/home_controller.dart';
import 'package:clean_teste/presentation/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cars'),
        actions: [
          GetX<ThemeController>(
            builder: (themeController) {
              return IconButton(
                onPressed: controller.onChagedTheme,
                icon: themeController.theme ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: controller.listenableBox(),
        builder: (context, Box<CarModel> box, child) {
          if (box.values.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => controller.getCars(showLoading: false),
            child: Scrollbar(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(thickness: 1.0, height: 0.0);
                },
                shrinkWrap: true,
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  CarEntity car = box.getAt(index) as CarEntity;

                  return ListTile(
                    leading: SizedBox(
                      width: 120.0,
                      child: CachedNetworkImage(
                        imageUrl: car.photoUrl ?? '',
                        errorWidget: (context, url, error) {
                          return Container();
                        },
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(car.id.toString()),
                        const Text(' - '),
                        Text(car.type ?? ''),
                      ],
                    ),
                    subtitle: Text(car.description?.replaceAll('Desc', '') ?? ''),
                    onTap: () => controller.onActionClick(car.id),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
