import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RecorderController extends GetxController {
  Rx<MaskFilter?> blur = MaskFilter.blur(BlurStyle.normal, 10.0).obs;
  RxBool isPlayAudio = false.obs;
  RxBool showPlayer = false.obs;

  RxList<MaskFilter?> blurList = [
    MaskFilter.blur(BlurStyle.normal, 10.0),
    MaskFilter.blur(BlurStyle.normal, 10.0),
    MaskFilter.blur(BlurStyle.normal, 10.0),
    MaskFilter.blur(BlurStyle.normal, 10.0),
    MaskFilter.blur(BlurStyle.normal, 10.0),
  ].obs;
  RxList<bool> eachAudionPlay = [
    false, false, false, false, false
  ].obs;



  final List<MaskFilter?> _blurs = [
    MaskFilter.blur(BlurStyle.normal, 10.0),
    // MaskFilter.blur(BlurStyle.inner, 10.0),
    // MaskFilter.blur(BlurStyle.outer, 10.0),
    // MaskFilter.blur(BlurStyle.solid, 16.0),
    null,
  ];
  int _blurIndex = 0;



  // MaskFilter? nextBlur() {
  //   if (_blurIndex == _blurs.length - 1) {
  //     _blurIndex = 0;
  //   } else {
  //     _blurIndex = _blurIndex + 1;
  //   }
  //   print(_blurs[_blurIndex]);
  //   blur.value = _blurs[_blurIndex];
  //   return _blurs[_blurIndex];
  // }




  void toggleBlur() {
    isPlayAudio.value = !isPlayAudio.value;

    if(isPlayAudio.value == true)
      blur.value = null;
    else blur.value = MaskFilter.blur(BlurStyle.normal, 10.0);
  }
  void toggleBlurList(int i) {
    eachAudionPlay[i] = !eachAudionPlay[i];

    if(eachAudionPlay[i] == true)
      blurList[i] = null;
    else blurList[i] = MaskFilter.blur(BlurStyle.normal, 10.0);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    isPlayAudio.value = false;
    super.dispose();
  }
}