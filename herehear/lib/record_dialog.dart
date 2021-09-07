import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/record_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class RecordingPage {

  final recordController = Get.put(RecorderController());

  Future<dynamic> recordDialog(BuildContext context) {
    return Get.dialog(
      Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(26.w, 10.h, 26.r, 10.h),
                width: MediaQuery.of(context).size.width,
                height: 282.h,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    )
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(Icons.close, size: 20.h),
                        )
                      ],
                    ),
                    SizedBox(height: 13.h),
                    GetBuilder<RecorderController>(
                      init: recordController,
                      builder: (_) => Column(
                        children: [
                          Obx(() {
                            // print('minutes: ${recordController.minutes!.value}');
                            // print('seconds: ${recordController.seconds!.value}');
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.background,
                                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(1, 4), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: _buildCard(
                                    // backgroundColor: Theme.of(context).colorScheme.secondary,
                                    config: CustomConfig(
                                      colors: [
                                        Color(0xFF4BACEF).withOpacity(0.2),
                                        Color(0xFF4BACEF).withOpacity(0.1),
                                        Color(0xFF634CED).withOpacity(0.1),
                                        Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                      ],
                                      durations: [35000, 19440, 10800, 6000],
                                      heightPercentages: [0.20, 0.23, 0.25, 0.30],
                                      blur: recordController.blur.value,
                                    ),
                                    height: 44.h,
                                    width: 280.w,
                                  ),
                                ),
                                recordController.timerText(context),
                              ],
                            );
                          }),
                          SizedBox(height: 35.h),
                          Obx(() => recordController.showPlayer.value?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  recordController.audioPlayer.stop().then((value) => recordController.deleteSource());
                                  recordController.stopAnimation();
                                  recordController.onClose();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.h),
                                  width: 64.w,
                                  height: 64.w,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.background,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 0,
                                        blurRadius: 8,
                                        offset: Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Image.asset('assets/icons/trashbox.png', width: 34.h, height: 34.h),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () {
                                  if (recordController.audioPlayer.playerState.playing) {
                                    recordController.pause().whenComplete(() => print('@@@'));
                                  } else {
                                    recordController.play().whenComplete(() => print('###'));
                                  }
                                  recordController.toggleBlur();
                                },
                                child: Image.asset(recordController.audioPlayer.playerState.playing? 'assets/icons/pause_white.png' : 'assets/icons/play_white.png', width: 65.h, height: 65.h),
                              ),
                              SizedBox(width: 5.w),
                              GestureDetector(
                                onTap: () {
                                  recordController.stop();
                                  recordController.stopAnimation();
                                },
                                child: Image.asset('assets/icons/stop_white.png', width: 65.h, height: 65.h),
                              ),
                              SizedBox(width: 8.w), 
                              GestureDetector(
                                onTap: () {
                                  recordController.uploadFile();
                                  recordController.stopAnimation();
                                },
                                child: Container(
                                  width: 64.w,
                                  height: 64.w,
                                  padding: EdgeInsets.all(10.h),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.background,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 0,
                                        blurRadius: 8,
                                        offset: Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Image.asset('assets/icons/upload.png', width: 34.h, height: 34.h),
                                ),
                              ),
                            ],
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.h),
                                width: 64.w,
                                height: 64.w,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 0,
                                      blurRadius: 8,
                                      offset: Offset(
                                          0, 4), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Image.asset('assets/icons/trashbox.png', width: 34.h, height: 34.h),
                              ),
                              SizedBox(width: 40.w),
                              GestureDetector(
                                onTap: () {
                                  recordController.isRecording.value ? recordController.recordComplete() : recordController.start();
                                  recordController.toggleRecordFlag();
                                  recordController.toggleBlur();
                                },
                                child: Image.asset(recordController.isRecording.value? 'assets/icons/stop_white.png' : 'assets/icons/record_white.png', width: 78.h, height: 78.h),
                              ),
                              SizedBox(width: 40.w),
                              Container(
                                width: 64.w,
                                height: 64.w,
                                padding: EdgeInsets.all(10.h),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 0,
                                      blurRadius: 8,
                                      offset: Offset(
                                          0, 4), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Image.asset('assets/icons/upload.png', width: 34.h, height: 34.h),
                              ),
                            ],
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }

  _buildCard({
    Config? config,
    Color backgroundColor = Colors.transparent,
    DecorationImage? backgroundImage,
    double height = 152.0,
    double? width,
  }) {
    return Container(
      height: height,
      width: width,
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.all(0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: WaveWidget(
          config: config!,
          backgroundColor: backgroundColor,
          backgroundImage: backgroundImage,
          size: Size(double.infinity, double.infinity),
          waveAmplitude: 0,
        ),
      ),
    );
  }
}