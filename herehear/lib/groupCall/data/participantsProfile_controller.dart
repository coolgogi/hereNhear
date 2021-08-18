import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum reportReasonList {sexual, illigal, insult, privacy, etc, right}

class ParticipantProfileController extends GetxController {
  RxBool isFollow = false.obs;
  RxBool isfavoriteVoice = false.obs;
  Rx<reportReasonList?> reportReason = reportReasonList.etc.obs;

  Rx<MaskFilter?> blur = MaskFilter.blur(BlurStyle.normal, 10.0).obs;
  RxBool isPlayAudio = false.obs;

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
    if(isPlayAudio.value == false)
      blur.value = null;
    else blur.value = MaskFilter.blur(BlurStyle.normal, 10.0);

    isPlayAudio.value = !isPlayAudio.value;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

