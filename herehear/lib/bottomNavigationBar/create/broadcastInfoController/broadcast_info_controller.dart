import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BroadcastInfoController extends GetxController {
  late TextEditingController title = TextEditingController();
  late TextEditingController notice = TextEditingController();

  bool value = true;
  int index = -1;


  //
  // void apiLogin() async {
  //   Get.dialog(Center(child: CircularProgressIndicator()),
  //       barrierDismissible: false);
  //   Request request = Request(url: urlLogin, body: {
  //     'email': emailTextController.text,
  //     'password': passwordTextController.text
  //   });
  //   request.post().then((value) {
  //     Get.back();
  //     Get.offNamed('homeView');
  //   }).catchError((onError) {});
  // }

  @override
  void onClose() {
    title?.dispose();
    notice?.dispose();
    super.onClose();
  }
}