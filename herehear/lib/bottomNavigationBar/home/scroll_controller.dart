import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrollOpacityController extends GetxController {
  Rx<ScrollController> scrollController = ScrollController().obs;
  var opacity = 1.0.obs;
  var _currentPosition = 1.0.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.value.addListener(() {
      _scrollListener();
      print('offset = ${scrollController.value.offset}');
    });
  }

  @override
  void onClose() {
    scrollController.value.dispose();
    super.onClose();
  }

  _scrollListener() {
    _currentPosition.value = 100 - scrollController.value.offset;

    print("widget position: $_currentPosition against: 100");

    if(95 <= _currentPosition.value) {
      opacity.value = 1;
    } else if(_currentPosition < 65) {
        opacity.value = 0;
    } else {
        opacity.value = (_currentPosition - scrollController.value.offset*1.8) / 100;
    }
    print("opacity is: $opacity");
  }
}