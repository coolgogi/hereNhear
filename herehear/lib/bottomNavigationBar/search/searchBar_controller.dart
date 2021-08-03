import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarController extends GetxController {
  var textController = TextEditingController().obs;
  var searchBarFocusNode = FocusNode().obs;
  RxString text = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}