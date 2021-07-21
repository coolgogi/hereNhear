// import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:just_audio/just_audio.dart';

class StopoController extends GetxController {
  RxBool stopFlag = true.obs;
  RxBool goodFlag = false.obs;
  RxBool funFlag = false.obs;

  // final player = AudioPlayer();

  // Future<void> setPlayer() async {
  //   var duration = await player.setAsset('assets/audio/vj.mp3');
  // }


  void toggleStopFlag() {
    stopFlag.value = !stopFlag.value;
  }

  void toggleGoodFlag() {
    goodFlag.value = !goodFlag.value;
    print(goodFlag.value);
  }

  void toggleFunFlag() {
    funFlag.value = !funFlag.value;
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    // await playAudio();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose

    super.onClose();
  }
}

class EvaluationPage extends StatelessWidget {
  final controller = Get.put(StopoController());
  final player = AudioPlayer();
  // AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  String audioPath = "assets/audio/vj.mp3";

  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  // final player = AudioCache();

  // Future<void> playAudio() async{
  //   try{
  //     await audioPlayer.open(
  //       // Audio(audioPath),
  //         autoStart: false,
  //         showNotification: true
  //     );
  //     print('^________________^');
  //   }catch(t){
  //     print(t);
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                controller.stopFlag.value = true;
                controller.goodFlag.value = false;
                controller.funFlag.value = false;
                Get.back();
                },
              icon: Icon(Icons.close, size: 30, color: Colors.black,)),
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          player.pause();
          Get.back();
          return Future(() => false);
        },
        child: Container(
          color: Colors.white,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 40.0.h, bottom: 60.0.h),
                child: Text('한화 이글스를 찾아간 VJ특공대', style: TextStyle(fontFamily:'Roboto', fontSize: 27, color: Colors.black),),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 60.0.h),
                child: Container(
                  width: 800.0.w,
                  height: 300.0.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/it2.jpg'),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Obx(() =>
                    GestureDetector(
                        onTap: (() async {
                          controller.toggleStopFlag();
                          await player.setAsset('assets/audio/vj.mp3');
                          controller.stopFlag.value == false ? player.play() : player.pause();

                        }),
                        child: Container(
                            child: Center(
                              child: controller.stopFlag.value ? Image.asset('assets/images/playButton2.png', width: 150,) : Image.asset('assets/images/stopButton.png', width: 140,),
                            ),
                        ),
                      ),)
                    ],
                  ),
                ),
              ),
              Text('평가해 주세요!', style: TextStyle(fontFamily:'Roboto', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),),
              Padding(
                padding: EdgeInsets.only(top: 20.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Color(0xFF618051),
                      child: Obx(() => GestureDetector(
                        onTap: controller.toggleGoodFlag,
                        child: CircleAvatar(
                          radius: 45.r,
                          backgroundColor: controller.goodFlag.value? Color(0xFF618051) : Colors.white,
                          child: Text('잘해요', style: TextStyle(fontSize: 27, color: controller.goodFlag.value? Colors.white : Color(0xFF618051), fontWeight: FontWeight.bold),),
                        ),
                      ),)
                    ),
                    CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        child: Obx(() => GestureDetector(
                          onTap: controller.toggleFunFlag,
                          child: CircleAvatar(
                            radius: 45.r,
                            backgroundColor: controller.funFlag.value? Theme.of(context).colorScheme.secondary : Colors.white,
                            child: Text('웃겨요', style: TextStyle(fontSize: 27, color: controller.funFlag.value? Colors.white : Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),),
                          ),
                        ),)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
