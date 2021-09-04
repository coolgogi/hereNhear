// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:herehear/bottomNavigationBar/community/record.dart';
// import 'package:herehear/etc/delete/contest/contest.dart';
// import 'package:just_audio/just_audio.dart' as ap;
// import 'package:record/record.dart';
// import 'package:wave/config.dart';
// import 'package:wave/wave.dart';
// import '../../record_controller.dart';
// import './record.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
//
// // class Controller extends GetxController {
// //   RxBool showPlayer = false.obs;
// // // Rx<> audioSource =
// // }
//
//
// String? recordPath;
//
// // class AudioRecorder extends GetxController {
// //   final void Function(String path) onStop;
// //
// //   const AudioRecorder({required this.onStop});
// //
// //   @override
// //   _AudioRecorderState createState() => _AudioRecorderState();
// // }
//
// class AudioRecorder {
//   ap.AudioSource? audioSource;
//   Timer? _timer;
//   Timer? _ampTimer;
//   final _audioRecorder = Record();
//   Amplitude? _amplitude;
//   late UploadTask _upload;
//   late String docId;
//   String recordId =
//   (10000000000000 - DateTime.now().millisecondsSinceEpoch).toString();
//
//   final recorderController = Get.put(RecorderController());
//
//   // Future<String?> onStop(String path) async {
//   //   File _file = File(path);
//   //   recordPath = await uploadFile(_file);
//   //   print("=======recordPath=======");
//   //   print('@@@@@@@@@@@@@: ${recordPath}');
//   //   audioSource = ap.AudioSource.uri(Uri.parse(recordPath!));
//   //   showPlayer.value = true;
//   //
//   //   return recordPath;
//   // }
//
//   // String? recordPath;
//
//   Future<dynamic> recordDiolog(BuildContext context) {
//     return Get.dialog(
//         Material(
//           color: Colors.transparent,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 padding: EdgeInsets.fromLTRB(26.w, 10.h, 26.r, 10.h),
//                 width: MediaQuery.of(context).size.width,
//                 height: 282.h,
//                 decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.background,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30.r),
//                       topRight: Radius.circular(30.r),
//                     )
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         IconButton(
//                           onPressed: () => Get.back(),
//                           icon: Icon(Icons.close, size: 20.h),
//                         )
//                       ],
//                     ),
//                     SizedBox(height: 13.h),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.background,
//                         borderRadius: BorderRadius.all(Radius.circular(10.r)),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.3),
//                             spreadRadius: 0,
//                             blurRadius: 4,
//                             offset: Offset(1, 4), // changes position of shadow
//                           ),
//                         ],
//                       ),
//                       child: _buildCard(
//                         // backgroundColor: Theme.of(context).colorScheme.secondary,
//                         config: CustomConfig(
//                           colors: [
//                             Color(0xFF4BACEF).withOpacity(0.2),
//                             Color(0xFF4BACEF).withOpacity(0.1),
//                             Color(0xFF634CED).withOpacity(0.1),
//                             Theme.of(context).colorScheme.primary.withOpacity(0.15),
//                           ],
//                           durations: [35000, 19440, 10800, 6000],
//                           heightPercentages: [0.20, 0.23, 0.25, 0.30],
//                           blur: recorderController.blur.value,
//                         ),
//                         height: 44.h,
//                         width: 280.w,
//                       ),
//                     ),
//                     SizedBox(height: 35.h),
//                     Obx(() =>
//                       recorderController.showPlayer.value?
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(10.h),
//                               width: 64.w,
//                               height: 64.w,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.background,
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.3),
//                                     spreadRadius: 0,
//                                     blurRadius: 8,
//                                     offset: Offset(
//                                         0, 4), // changes position of shadow
//                                   ),
//                                 ],
//                               ),
//                               child: Image.asset('assets/icons/trashbox.png', width: 34.h, height: 34.h),
//                             ),
//                             SizedBox(width: 40.w),
//                             Container(
//                               width: 78.h,
//                               height: 78.h,
//                               padding: EdgeInsets.all(10.h),
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.primary ,
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.3),
//                                     spreadRadius: 0,
//                                     blurRadius: 8,
//                                     offset: Offset(
//                                         0, 4), // changes position of shadow
//                                   ),
//                                 ],
//                               ),
//                               child: Image.asset('assets/icons/record_white.png', width: 30.h, height: 30.h),
//                             ),
//                             SizedBox(width: 40.w),
//                             Container(
//                               width: 64.w,
//                               height: 64.w,
//                               padding: EdgeInsets.all(10.h),
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.background,
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.3),
//                                     spreadRadius: 0,
//                                     blurRadius: 8,
//                                     offset: Offset(
//                                         0, 4), // changes position of shadow
//                                   ),
//                                 ],
//                               ),
//                               child: Image.asset('assets/icons/upload.png', width: 34.h, height: 34.h),
//                             ),
//                           ],
//                         )
//                           : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(10.h),
//                             width: 64.w,
//                             height: 64.w,
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.background,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.3),
//                                   spreadRadius: 0,
//                                   blurRadius: 8,
//                                   offset: Offset(
//                                       0, 4), // changes position of shadow
//                                 ),
//                               ],
//                             ),
//                             child: Image.asset('assets/icons/trashbox.png', width: 34.h, height: 34.h),
//                           ),
//                           SizedBox(width: 40.w),
//                           Container(
//                             width: 78.h,
//                             height: 78.h,
//                             padding: EdgeInsets.all(10.h),
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.primary ,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.3),
//                                   spreadRadius: 0,
//                                   blurRadius: 8,
//                                   offset: Offset(
//                                       0, 4), // changes position of shadow
//                                 ),
//                               ],
//                             ),
//                             child: Image.asset('assets/icons/record_white.png', width: 30.h, height: 30.h),
//                           ),
//                           SizedBox(width: 40.w),
//                           Container(
//                             width: 64.w,
//                             height: 64.w,
//                             padding: EdgeInsets.all(10.h),
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.background,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.3),
//                                   spreadRadius: 0,
//                                   blurRadius: 8,
//                                   offset: Offset(
//                                       0, 4), // changes position of shadow
//                                 ),
//                               ],
//                             ),
//                             child: Image.asset('assets/icons/upload.png', width: 34.h, height: 34.h),
//                           ),
//                         ],
//                       )
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         )
//     );
//     return MaterialApp(
//       home: Scaffold(
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 _buildRecordStopControl(context),
//                 const SizedBox(width: 20),
//                 _buildPauseResumeControl(context),
//                 const SizedBox(width: 20),
//                 _buildText(),
//               ],
//             ),
//             if (_amplitude != null) ...[
//               const SizedBox(height: 40),
//               Text('Current: ${_amplitude?.current ?? 0.0}'),
//               Text('Max: ${_amplitude?.max ?? 0.0}'),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   _buildCard({
//     Config? config,
//     Color backgroundColor = Colors.transparent,
//     DecorationImage? backgroundImage,
//     double height = 152.0,
//     double? width,
//   }) {
//     return Container(
//       height: height,
//       width: width,
//       child: Card(
//         elevation: 0.0,
//         margin: EdgeInsets.all(0),
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10.0))),
//         child: WaveWidget(
//           config: config!,
//           backgroundColor: backgroundColor,
//           backgroundImage: backgroundImage,
//           size: Size(double.infinity, double.infinity),
//           waveAmplitude: 0,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRecordStopControl(BuildContext context) {
//     late Icon icon;
//     late Color color;
//
//     if (recorderController.isRecording.value || recorderController.isPaused.value) {
//       icon = Icon(Icons.stop, color: Colors.red, size: 30);
//       color = Colors.red.withOpacity(0.1);
//     } else {
//       final theme = Theme.of(context);
//       icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
//       color = theme.primaryColor.withOpacity(0.1);
//     }
//
//     return ClipOval(
//       child: Material(
//         color: color,
//         child: InkWell(
//           child: SizedBox(width: 56, height: 56, child: icon),
//           onTap: () {
//             recorderController.isRecording.value? _stop() : _start();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPauseResumeControl(BuildContext context) {
//     if (!recorderController.isRecording.value && !recorderController.isPaused.value) {
//       return const SizedBox.shrink();
//     }
//
//     late Icon icon;
//     late Color color;
//
//     if (!recorderController.isPaused.value) {
//       icon = Icon(Icons.pause, color: Colors.red, size: 30);
//       color = Colors.red.withOpacity(0.1);
//     } else {
//       final theme = Theme.of(context);
//       icon = Icon(Icons.play_arrow, color: Colors.red, size: 30);
//       color = theme.primaryColor.withOpacity(0.1);
//     }
//
//     return ClipOval(
//       child: Material(
//         color: color,
//         child: InkWell(
//           child: SizedBox(width: 56, height: 56, child: icon),
//           onTap: () {
//             recorderController.isPaused.value ? _resume() : _pause();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildText() {
//     if (recorderController.isRecording.value || recorderController.isPaused.value) {
//       return _buildTimer();
//     }
//
//     return Text("Waiting to record");
//   }
//
//   Widget _buildTimer() {
//     final String minutes = _formatNumber(recorderController.recordDuration.value ~/ 60);
//     final String seconds = _formatNumber(recorderController.recordDuration.value % 60);
//
//     return Text(
//       '$minutes : $seconds',
//       style: TextStyle(color: Colors.red),
//     );
//   }
//
//   String _formatNumber(int number) {
//     String numberStr = number.toString();
//     if (number < 10) {
//       numberStr = '0' + numberStr;
//     }
//
//     return numberStr;
//   }
//
//   Future<void> _start() async {
//     try {
//       if (await _audioRecorder.hasPermission()) {
//         await _audioRecorder.start();
//
//         bool isRecording = await _audioRecorder.isRecording();
//         recorderController.isRecording.value = isRecording;
//         recorderController.recordDuration.value = 0;
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
//     // onStop(path!);
//
//     File _file = File(path!);
//     recordPath = await uploadFile(_file);
//     print("=======recordPath=======");
//     print('@@@@@@@@@@@@@: ${recordPath}');
//     audioSource = ap.AudioSource.uri(Uri.parse(recordPath!));
//     recorderController.showPlayer.value = true;
//     recorderController.isRecording.value = false;
//   }
//
//   Future<void> _pause() async {
//     _timer?.cancel();
//     _ampTimer?.cancel();
//     await _audioRecorder.pause();
//
//     recorderController.isPaused.value = true;
//   }
//
//   Future<void> _resume() async {
//     _startTimer();
//     await _audioRecorder.resume();
//
//     recorderController.isPaused.value = false;
//   }
//
//   Future<String> uploadFile(File file) async {
//     print("==========");
//     print('upload');
//     if (file == null) {
//       print("null file exception");
//       return '';
//     } else {
//       Reference storageRef = FirebaseStorage.instance
//           .ref()
//           .child('community')
//       // .child(docId)
//           .child('$recordId.m4a');
//
//       SettableMetadata metadata = SettableMetadata(
//         contentType: 'audio/m4a',
//         customMetadata: <String, String>{'file': 'audio'},
//       );
//
//       _upload = storageRef.putFile(file, metadata);
//       await _upload.whenComplete(() => {print("Complete")});
//       String downloadPath = await storageRef.getDownloadURL();
//       // String downloadPath = await storageRef.getDownloadURL();
//       print('??????????????: ${downloadPath}');
//       return downloadPath;
//     }
//   }
//
//   void _startTimer() {
//     _timer?.cancel();
//     _ampTimer?.cancel();
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
//       recorderController.recordDuration.value++;
//     });
//
//     _ampTimer =
//         Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
//           _amplitude = await _audioRecorder.getAmplitude();
//         });
//   }
// }
//
// class recordingPage extends StatelessWidget {
//
//   final controller = Get.put(AudioRecorder());
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Obx (() {
//           if(recorderController.showPlayer.value)
//             return Center(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 25),
//                   child: AudioPlayer(
//                     source: audioSource!,
//                     onDelete: () {
//                       recorderController.showPlayer.value = false;
//                     },
//                   ),
//                 )
//             );
//           else Center(
//             child: AudioRecorder(
//               onStop: (path) async {
//                 audioSource = ap.AudioSource.uri(Uri.parse(recordPath!));
//                 controller.showPlayer.value = true;
//               },
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
