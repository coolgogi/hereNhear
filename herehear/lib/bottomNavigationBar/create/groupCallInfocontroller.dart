import 'package:get/get.dart';

class GroupCallInfoController extends GetxController {
  RxBool isPrivate = false.obs;
  RxBool isReserve = false.obs;
  RxList tagList = [].obs;
  var selectedDate = DateTime.now().add(Duration(days: 1)).obs;
  var selectedTime = DateTime.now().add(Duration(days: 1)).obs;
}