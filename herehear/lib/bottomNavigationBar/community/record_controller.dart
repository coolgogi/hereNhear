// import 'dart:async';
//
// import 'package:get/get.dart';
// import 'package:record/record.dart';
//
// class RecordConroller extends GetxController {
//   RxBool _isRecording = false.obs;
//   RxBool _isPaused = false.obs;
//   RxInt _recordDuration = 0.obs;
//   Timer? _timer;
//   Timer? _ampTimer;
//   var _audioRecorder = Record();
//
//
//   RxBool isRecording = false.obs;
//
//   @override
//     void onInit() {
//       super.onInit();
//     }
//
//     @override
//   void onClose() {
//     _timer?.cancel();
//     _ampTimer?.cancel();
//     _audioRecorder.dispose();
//     super.onClose();
//   }
//
//
//   Future<void> _start() async {
//     try {
//       if (await _audioRecorder.hasPermission()) {
//         await _audioRecorder.start();
//
//         bool isRecording = await _audioRecorder.isRecording();
//         _isRecording.value = isRecording;
//         _recordDuration.value = 0;
//
//         _startTimer();
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Future<void> _stop() async {
//     _timer?.cancel();
//     _ampTimer?.cancel();
//     final path = await _audioRecorder.stop();
//
//     // onStop(path!);
//
//     _isRecording.value = false;
//   }
//
//   Future<void> _pause() async {
//     _timer?.cancel();
//     _ampTimer?.cancel();
//     await _audioRecorder.pause();
//
//     _isPaused.value = true;
//   }
//
//   Future<void> _resume() async {
//     _startTimer();
//     await _audioRecorder.resume();
//
//     _isPaused.value = false;
//   }
//
//   void _startTimer() {
//     _timer?.cancel();
//     _ampTimer?.cancel();
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
//       _recordDuration.value++;
//     });
//
//     // _ampTimer =
//     //     Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
//     //       _amplitude = await _audioRecorder.getAmplitude();
//     //     });
//   }
// }