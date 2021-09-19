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
    init();
  }

  @override
  void onClose() {
    scrollController.value.dispose();
    super.onClose();
  }

  void init() {
    opacity.value = 1.0;
    _currentPosition.value = 1.0;
  }

  _scrollListener() {
    _currentPosition.value = 100 - scrollController.value.offset;

    print("widget position: $_currentPosition against: 100");

    if(95 <= _currentPosition.value) {
      opacity.value = 1;
    } else if(_currentPosition < 75) {
        opacity.value = 0;
    } else if(82 <= _currentPosition.value) {
      opacity.value = (_currentPosition - scrollController.value.offset*1.3) / 100;
    } else {
        opacity.value = (_currentPosition - scrollController.value.offset*2.5) / 100;
    }
    print("opacity is: $opacity");
  }
}


class DetailPagesScrollerController extends GetxController {
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
    init();
  }

  @override
  void onClose() {
    scrollController.value.dispose();
    super.onClose();
  }

  void init() {
    opacity.value = 1.0;
    _currentPosition.value = 1.0;
  }

  _scrollListener() {
    _currentPosition.value = 100 - scrollController.value.offset;

    print("widget position: $_currentPosition against: 100");

    if(95 <= _currentPosition.value) {
      opacity.value = 1;
    } else if(_currentPosition < 75) {
      opacity.value = 0;
    } else if(82 <= _currentPosition.value) {
      opacity.value = (_currentPosition - scrollController.value.offset*1.3) / 100;
    } else {
      opacity.value = (_currentPosition - scrollController.value.offset*2.5) / 100;
    }
    print("opacity is: $opacity");
  }
}

