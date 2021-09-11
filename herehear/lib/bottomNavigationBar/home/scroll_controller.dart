import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrollOpacityController extends GetxController {
  Rx<ScrollController> scrollController = ScrollController().obs;
  var opacity = 1.0.obs;
  var _currentPosition = 1.0.obs;

  Rx<ScrollController> chatScrollController = ScrollController().obs;
  var chatOpacity = 1.0.obs;
  var _currentChatPosition = 1.0.obs;

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


class ChatScrollerController extends GetxController {
  Rx<ScrollController> chatScrollController = ScrollController().obs;
  var chatOpacity = 1.0.obs;
  var _currentChatPosition = 1.0.obs;

  @override
  void onInit() {
    super.onInit();
    chatScrollController.value.addListener(() {
      _chatScrollListener();
      print('offset = ${chatScrollController.value.offset}');
    });
  }

  @override
  void onClose() {
    chatScrollController.value.dispose();
    super.onClose();
  }

  _chatScrollListener() {
    _currentChatPosition.value = 100 - chatScrollController.value.offset;

    print("widget position: $_currentChatPosition against: 100");

    if(30 <= _currentChatPosition.value) {
      chatOpacity.value = 1;
    } else if(_currentChatPosition < 20) {
      chatOpacity.value = 0;
    } else {
      chatOpacity.value = (_currentChatPosition - chatScrollController.value.offset*1.8) / 100;
    }
    print("opacity is: $chatOpacity");
    print("opacity is: $chatOpacity");
    print("opacity is: $chatOpacity");
    print("opacity is: $chatOpacity");
    print("opacity is: $chatOpacity");
    print("opacity is: $chatOpacity");
    print("opacity is: $chatOpacity");
    print("opacity is: $chatOpacity");
    print("opacity is: $chatOpacity");
    print("opacity is: $chatOpacity");
    print("opacity is: $chatOpacity");
  }
}

