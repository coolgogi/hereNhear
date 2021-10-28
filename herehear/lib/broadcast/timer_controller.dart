
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerContorller extends GetxController {
  var time = 0.obs;

  callIncrement() {

    time.value++;


  }

  @override
  void onInit() {
    Timer.periodic(Duration(seconds: 1), (timer) => callIncrement());
    super.onInit();
  }
}