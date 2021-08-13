import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBarController extends GetxController {
  var textController = TextEditingController().obs;
  var searchBarFocusNode = FocusNode().obs;
  RxString text = ''.obs;
  RxList<String> history = [''].obs;

  RxBool isLocationSearch = false.obs;
  RxBool isRoomSearch = false.obs;
  RxBool isCommunitySearch = false.obs;
  RxBool isHistorySearch = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadHistory();
  }

  @override
  void onClose() {
    // TODO: implement onInit
    super.onClose();
  }

  void initialSearchText() {
    if(!(isHistorySearch.value)) {
      text.value = '';
      print('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE: ${text.value}, ${isHistorySearch.value}');
    }
    textController.value.text = text.value;
    textController.value.selection = TextSelection.fromPosition(TextPosition(offset: textController.value.text.length));
    isHistorySearch.value = false;
    print('WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW: ${text.value}, ${isHistorySearch.value}');
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
