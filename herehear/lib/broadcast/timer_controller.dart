
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerContorller extends GetxController {
  var time = 0.obs;
  RxString sec = ''.obs;
  RxString min = ''.obs;
  RxString hour = ''.obs;

  callIncrement() {

    time.value++;
    sec =RxString((time.value % 60).floor().toString().padLeft(2, '0'));
    min =RxString (((time.value / 60) % 60)
        .floor()
        .toString()
        .padLeft(2, '0'));
    hour = RxString(((time.value / (60 * 60)) % 60)
        .floor()
        .toString()
        .padLeft(2, '0'));


  }

  @override
  void onInit() {
    Timer.periodic(Duration(seconds: 1), (timer) => callIncrement());
    super.onInit();
  }
}