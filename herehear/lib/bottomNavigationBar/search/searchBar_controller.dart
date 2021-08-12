import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBarController extends GetxController {
  var textController = TextEditingController().obs;
  var searchBarFocusNode = FocusNode().obs;
  RxString text = ''.obs;
  RxList<String> history = [''].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    print('_loadCounter()');
    final prefs = await SharedPreferences.getInstance();
    history.value = (prefs.getStringList('history') ?? []);
  }

  Future<void> saveHistory() async {
    print('saveCounter');
    final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('history', history);

  }

}
