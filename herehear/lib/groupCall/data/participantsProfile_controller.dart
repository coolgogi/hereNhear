import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum reportReasonList {sexual, illigal, insult, privacy, etc, right}

class ParticipantProfileController extends GetxController {
  RxBool isFollow = false.obs;
  RxBool isfavoriteVoice = false.obs;
  Rx<reportReasonList?> reportReason = reportReasonList.etc.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

