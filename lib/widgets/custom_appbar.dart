import 'package:flutfest/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar customAppBar(BuildContext context, String title, {TextStyle? textStyle}) {
  return AppBar(
    title: Text(
      title,
      style: textStyle ?? Theme.of(context).textTheme.headlineSmall,
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () {
          Get.toNamed(Routes.notifications);
        },
      ),
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          Get.toNamed(Routes.search);
        },
      ),
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Get.toNamed(Routes.settings);

        },
      ),
    ],
  );
}