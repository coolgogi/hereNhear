import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/community/free_board/record_test.dart';
import 'package:herehear/bottomNavigationBar/community/record_controller.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/record_controller.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:record/record.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';


FirebaseFirestore firestore = FirebaseFirestore.instance;
final Record _audioRecorder = Record();

class PostPage extends StatelessWidget {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final locationController = Get.put(LocationController());
  final recorderController = Get.put(RecorderController());
  TextEditingController comment = TextEditingController();
  FlutterTts f_tts = FlutterTts();
  ap.AudioSource? audioSource;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text('HEAR 게시판',
            style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                  fontWeight: FontWeight.w700,
                )),
        actions: <Widget>[
          IconButton(
              onPressed: () => Get.to(recordingPage()),
              icon: Image.asset('assets/icons/bell.png', height: 17.0.h)),
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
        ],
      ),
      body: ListView(
        children: <Widget>[
          // SizedBox(height: 81.0.h),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0.w, 10.0.h, 0.w, 18.h),
            child: Row(
              children: <Widget>[
                Container(
                  width: 32.0.w,
                  height: 32.0.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/she2.jpeg'),
                      fit: BoxFit.contain,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 9.w),
                Column(
                  children: [
                    Text(
                      '유리한 녀석',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text('업로드한 날짜',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0.w, right: 35.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('글 제목ㅇㅇㅇㅇ?', style: Theme.of(context).textTheme.headline1),
                Padding(
                  padding: EdgeInsets.only(top: 13.0.h),
                  child: Text('글 내용 궁시렁 주저리 이러쿵 저러쿵',
                      maxLines: 300,
                      style: Theme.of(context).textTheme.subtitle1),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 35.0.h, bottom: 30.h),
                  child: Row(children: [
                    Image.asset('assets/icons/heart.png', width: 14.w),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text('0', style: Theme.of(context).textTheme.headline6),
                    SizedBox(width: 10.w),
                    Image.asset('assets/icons/chat.png', width: 14.w),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text('0', style: Theme.of(context).textTheme.headline6),
                  ]),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 23.0.w, right: 23.0.w),
            child: Divider(thickness: 1),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 17.h),
            child: Row(
              children: [
                Container(
                  width: 32.0.w,
                  height: 32.0.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/you.png'),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  height: 41.h,
                  width: 280.w,
                  padding: EdgeInsets.fromLTRB(10.w, 1.h, 1.w, 0.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: Offset(1, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 150,
                    controller: comment,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      hintStyle: Theme.of(context).textTheme.headline6,
                      // suffixStyle: ,
                      hintText: '유리한 녀석들로 댓글달기',
                      border: InputBorder.none,
                      suffixText: '녹음 시작',
                      suffixIcon: Padding(
                        padding: EdgeInsets.fromLTRB(0.w, 7.h, 0.w, 7.h),
                        child: GestureDetector(
                          onTap: () => textToSpeech(comment.text),
                          child: Container(
                            width: 32.0.w,
                            height: 32.0.h,
                            child: Padding(
                              padding: EdgeInsets.all(3.0.w),
                              child: Image.asset(
                                'assets/icons/record.png',
                              ),
                            ),
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 20.0.w, top: 31.0.h),
            child: commentList(context),
          ),
        ],
      ),
    );
  }

  Widget commentList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        commentCard(context),
        commentCard(context),
        commentCard(context),
      ],
    );
  }

  Widget commentCard(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w, right: 23.w, bottom: 18.h),
          child: Row(
            children: <Widget>[
              Container(
                width: 27.0.w,
                height: 27.0.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/it.jpg'),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 11.w),
              Text(
                '닉네임',
                style: Theme.of(context).textTheme.headline4,
              ),
              Expanded(child: Container()),
              Container(
                width: 103.w,
                height: 21.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.all(Radius.circular(5.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: null,
                      child: Image.asset('assets/icons/heart_grey.png',
                          width: 14.w),
                    ),
                    Image.asset('assets/icons/line_short.png', height: 8.h),
                    GestureDetector(
                      onTap: null,
                      child: Image.asset('assets/icons/chat_grey.png',
                          width: 14.w),
                    ),
                    Image.asset('assets/icons/line_short.png', height: 8.h),
                    GestureDetector(
                      onTap: null,
                      child: Image.asset('assets/icons/more_grey.png',
                          height: 10.h),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Obx(() => Container(
            width: 302.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(1, 4), // changes position of shadow
                ),
              ],
            ),
            child: Center(child: Container(
                child: Row(
                  children: [
                    InkWell(
                        onTap: () => recorderController.toggleBlur(),
                        child: Container(
                            padding: EdgeInsets.only(left:5.w),
                            width: 50.w,
                            child: Center(child: Image.asset('assets/icons/playButton.png', height: 16.h)))),
                    _buildCard(
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
                        blur: recorderController.blur.value,
                      ),
                      height: 44.h,
                    ),
                  ],
                )
            )))),
        Padding(
          padding: EdgeInsets.only(right: 19.0.w),
          child: Divider(
            thickness: 1,
            height: 30.h,
          ),
        ),
      ],
    );
  }

  _buildCard({
    Config? config,
    Color backgroundColor = Colors.transparent,
    DecorationImage? backgroundImage,
    double height = 152.0,
  }) {
    return Container(
      height: height,
      width: 252.w,
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.all(0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)
            )),
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

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
    locationController.getLocation().obs;
  }

  void textToSpeech(String text) async {
    if (UserController.to.myProfile.value.platform == 'ios') {
      print("hello ios");
      await f_tts.setSharedInstance(true);
      await f_tts
          .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers
      ]);
    }
    await f_tts.speak(text);
  }

  void record_init() async {
    bool permission = await _audioRecorder.hasPermission();
    if (permission) {
    } else {}
  }
}
