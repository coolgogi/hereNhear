import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BroadcastInfoController extends GetxController {
  late TextEditingController title = TextEditingController();
  late TextEditingController notice = TextEditingController();

  bool x = true;
  int index = -1.obs;
  List<String> categoryList = ['소통', '힐링', 'ASMR', '연애', '음악'];
  RxList<String> selectedCategoryList = <String>[].obs;


  int setCategory(bool value, int categoryIndex){
    index = value ? categoryIndex : index;
    update();
    return index;
  }

  bool setSelected(int categoryIndex){
   x = index == categoryIndex;
   update();
   return x;
  }

  Widget category(){
    return Row(
      children: List.generate(categoryList.length, (categoryIndex) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(3),
            child: ChoiceChip(
              label: Text(
                categoryList[categoryIndex],
              ),
              labelStyle: TextStyle(color: Colors.black),
              shape: StadiumBorder(
                  side: BorderSide(color: Colors.grey, width: 0.5)),
              backgroundColor: Colors.white,
              selected: index == categoryIndex,
              selectedColor: Colors.grey[500],
              onSelected: (value) {
                  index = value ? categoryIndex : index;
                  update();
              },
              // backgroundColor: color,
            ),
          ),
        );
      }),
    );
  }


  //
  // void apiLogin() async {
  //   Get.dialog(Center(child: CircularProgressIndicator()),
  //       barrierDismissible: false);
  //   Request request = Request(url: urlLogin, body: {
  //     'email': emailTextController.text,
  //     'password': passwordTextController.text
  //   });
  //   request.post().then((value) {
  //     Get.back();
  //     Get.offNamed('homeView');
  //   }).catchError((onError) {});
  // }

  @override
  void onClose() {
    selectedCategoryList.value.removeRange(0, selectedCategoryList.length);
    title.dispose();
    notice.dispose();
    super.onClose();
  }
}