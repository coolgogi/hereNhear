import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class StopController extends GetxController {
  RxBool stopFlag = true.obs;
  RxBool goodFlag = false.obs;
  RxBool funFlag = false.obs;

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
  void onClose() {
    // TODO: implement onClose

    super.onClose();
  }
}

class EvaluationPage3 extends StatelessWidget {
  final player = AudioPlayer();
  final controller = Get.put(StopController());

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
      body: Container(
        color: Colors.white,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40.0.h, bottom: 60.0.h),
              child: Text('사랑비', style: TextStyle(fontFamily:'Roboto', fontSize: 27, color: Colors.black),),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 60.0.h),
              child: Container(
                width: 800.0.w,
                height: 300.0.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/you.png'),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: (() async {
                        controller.toggleStopFlag();
                        await player.setAsset('assets/audio/loveRain.mp3');
                        controller.stopFlag.value == false ? player.play() : player.pause();

                      }),
                      child: Container(
                          child: Obx(() => Center(
                            child: controller.stopFlag.value ? Image.asset('assets/images/playButton2.png', width: 150,) : Image.asset('assets/images/stopButton.png', width: 140,),
                          ),)
                      ),
                    ),
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
    );
  }
}
