import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_teste/domain/entities/car_entity.dart';
import 'package:clean_teste/domain/helpers/loading_status.dart';
import 'package:clean_teste/presentation/controllers/detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Detail'),
      ),
      body: Obx(() {
        if (controller.loadingStatus == LoadingStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        CarEntity car = controller.car;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: CircleAvatar(
                  child: CachedNetworkImage(
                    imageUrl: car.photoUrl ?? '',
                    errorWidget: (context, url, error) {
                      return Container();
                    },
                  ),
                  radius: 120.0,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(),
            Text(
              car.description?.replaceAll('Desc', '') ?? '',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }),
    );
  }
}
