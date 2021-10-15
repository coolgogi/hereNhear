import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:record/record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RecorderController extends GetxController {
  Rx<MaskFilter?> blur = MaskFilter.blur(BlurStyle.normal, 10.0).obs;
  RxBool isPlayAudio = false.obs;
  RxBool showPlayer = false.obs;

  //////////////////////////////////////////////////////////
  late ap.AudioSource source;
  String? path;
  String? downloadPath;
  RxString? minutes;
  RxString? seconds;

  ap.AudioSource? audioSource;
  RxBool isRecording = false.obs;
  RxBool isPaused = false.obs;
  RxInt recordDuration = 0.obs;
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();
  Amplitude? _amplitude;
  late UploadTask _upload;
  late String docId;
  String recordId =
  (10000000000000 - DateTime.now().millisecondsSinceEpoch).toString();


  late File _file;

  var audioPlayer = ap.AudioPlayer();

  late StreamSubscription<ap.PlayerState> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;

  /////////////////////////////////////////////////////////

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
  void stopAnimation() {
    isPlayAudio.value = false;
    blur.value = MaskFilter.blur(BlurStyle.normal, 10.0);
  }
  void toggleBlurList(int i) {
    eachAudionPlay[i] = !eachAudionPlay[i];

    if(eachAudionPlay[i] == true)
      blurList[i] = null;
    else blurList[i] = MaskFilter.blur(BlurStyle.normal, 10.0);
  }

  @override
  void onInit() {
    isRecording.value = false;
    super.onInit();
  }

  @override
  void onClose() {
    isPlayAudio.value = false;
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    audioPlayer.dispose();
    super.onClose();
  }

  ////////////////////////////////////////
  Future<void> setAudioSourse(source) async {
    await audioPlayer.setAudioSource(source);
    update();
  }

  void toggleRecordFlag() {
    isRecording.value = !isRecording.value;
  }

  Future<void> start() async {
    _playerStateChangedSubscription =
        audioPlayer.playerStateStream.listen((state) async {
          if (state.processingState == ap.ProcessingState.completed) {
            await stop();
          }
          update();
        });
    _positionChangedSubscription =
        audioPlayer.positionStream.listen((position) => update());
    _durationChangedSubscription =
        audioPlayer.durationStream.listen((duration) => update());

    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();

        bool Recording = await _audioRecorder.isRecording();
          isRecording.value = Recording;
          recordDuration.value = 0;

        _startTimer();
      }
    } catch (e) {
      print(e);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      recordDuration.value++;
      print(recordDuration.value);
      update();
    });

    _ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
          _amplitude = await _audioRecorder.getAmplitude();
          update();
        });
  }

  Future<void> recordComplete() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    path = await _audioRecorder.stop();
    print("~~~~~~~~~~~~~~~~");
    print('path: ${path}');

    isRecording.value = false;
    audioSource = ap.AudioSource.uri(Uri.parse(path!));
    setAudioSourse(audioSource);
    print('audioSource: ${audioSource}');
    print("^^^^^^^^^^^^^^^^");

    // _file = File(path!);
    // recordPath = await uploadFile();
    // print("=======recordPath=======");
    // print('@@@@@@@@@@@@@: ${recordPath}');
    // audioSource = ap.AudioSource.uri(Uri.parse(recordPath!));
    showPlayer.value = true;
  }

  Future<void> uploadFile() async {
    _file = File(path!);

    print("==========");
    print('upload');
    if (_file == null) {
      print("null file exception");
      return;
    } else {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('community')
      // .child(docId)
          .child('$recordId.m4a');

      SettableMetadata metadata = SettableMetadata(
        contentType: 'audio/m4a',
        customMetadata: <String, String>{'file': 'audio'},
      );

      _upload = storageRef.putFile(_file, metadata);
      await _upload.whenComplete(() => {print("Complete")});
      downloadPath = await storageRef.getDownloadURL();
      // String downloadPath = await storageRef.getDownloadURL();
      print("=======recordPath=======");
      print('@@@@@@@@@@@@@: ${downloadPath}');

      audioSource = ap.AudioSource.uri(Uri.parse(downloadPath!));
    }
  }

  Future<void> play() {
    print('playing...');
    return audioPlayer.play();
  }

  Future<void> pause() {
    print('pause...');
    return audioPlayer.pause();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    return audioPlayer.seek(const Duration(milliseconds: 0));
  }

  void deleteSource() {
    showPlayer.value = false;
  }

  // String countTimer() {
  //   print('***');
  //   if (isRecording.value || isPaused.value) {
  //     minutes!.value = _formatNumber(recordDuration.value ~/ 60);
  //     seconds!.value = _formatNumber(recordDuration.value % 60);
  //     print('%%%');
  //
  //     update();
  //
  //     return '${minutes!.value} : ${seconds!.value}';
  //   }
  //   else return '65158465';
  // }

  Widget timerText(BuildContext context) {
    if (isRecording.value || isPaused.value) {
      return _buildTimer(context);
    }

    return Container();
  }

  Widget _buildTimer(BuildContext context) {
    final String minutes = _formatNumber(recordDuration.value ~/ 60);
    final String seconds = _formatNumber(recordDuration.value % 60);

    return Padding(
      padding: EdgeInsets.only(bottom: 5.0.h),
      child: Text(
        '$minutes : $seconds',
        style: Theme.of(context).textTheme.headline5!.copyWith(
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }
  /////////////////////////////////////////
}