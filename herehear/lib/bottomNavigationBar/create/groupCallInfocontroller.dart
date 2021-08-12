import 'package:get/get.dart';

class GroupCallInfoController extends GetxController {
  RxBool isPrivate = false.obs;
  RxBool isReserve = false.obs;
  RxList tagList = [].obs;
  RxList<String> selectedCategoryList = <String>[].obs;
  var selectedDate = DateTime.now().add(Duration(days: 1)).obs;
  var selectedTime = DateTime.now().add(Duration(days: 1)).obs;

  @override
  void onClose() {
    // TODO: implement onClose
    selectedCategoryList.value.removeRange(0, selectedCategoryList.length);
    super.onClose();
  }
}