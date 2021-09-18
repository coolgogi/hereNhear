import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/groupCall/data/participantsProfile_controller.dart';
import 'package:herehear/record_controller.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'edit_profile.dart';


class MyPage extends StatelessWidget {
  final profileController = Get.put(ParticipantProfileController());
  final recorderController = Get.put(RecorderController());
  List<String> themeList = [
    '한동대',
    '유리한 녀석들',
    '졸업',
    '하고싶다',
    '간바레마쇼',
  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25.0.w,
        title:
        Text('NickName', style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: <Widget>[
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/bell.png', height: 18.0.h)),
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 25.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 23.0.h, bottom: 17.h),
                          child: Container(
                            width: 77.h,
                            height: 77.h,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/images/you.png'),
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 46.w),
                        Column(
                          children: [
                            Text('30', style: Theme.of(context).textTheme.headline2),
                            Text('팔로워', style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                        SizedBox(width: 23.w),
                        Column(
                          children: [
                            Text('348', style: Theme.of(context).textTheme.headline2),
                            Text('팔로잉', style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                        SizedBox(width: 23.w),
                        Column(
                          children: [
                            Text('50', style: Theme.of(context).textTheme.headline2),
                            Text('라이브', style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                      ],
                    ),
                    Text('이름', style: Theme.of(context).textTheme.headline4),
                    SizedBox(height: 1.h),
                    Text('상태 메세지(ex. 앨범 많이 사랑해주세요)', style: Theme.of(context).textTheme.headline6),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                      child: InkWell(
                        onTap: () => Get.to(() => EditMyPage()),
                        child: Container(
                            width: 252.w,
                            height: 36.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.all(Radius.circular(6.r)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 8,
                                  offset: Offset(0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Center(child: Text('프로필 편집', style: Theme.of(context).textTheme.headline4)),
                        ),
                      )
                    ),
                    Text('보이스 프로필', style: Theme.of(context).textTheme.headline4,),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0.h, bottom: 32.h),
                      child: Row(
                        children: [
                          Obx(() => Row(
                            children: [
                              Container(
                                  width: 50.w,
                                  height: 44.h,
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
                                  child: Row(
                                    children: [
                                      InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () => recorderController.toggleBlur(),
                                          child: Container(
                                              padding: EdgeInsets.only(left:5.w),
                                              width: 50.w,
                                              child: Center(child: Image.asset(recorderController.isPlayAudio.value? 'assets/icons/pause.png' : 'assets/icons/playButton.png', height: 16.h)))),
                                    ],
                                  )),
                              SizedBox(width: 8.w),
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
                                    blur: recorderController.blur.value,
                                  ),
                                  height: 44.h,
                                ),
                              )
                            ],
                          )),
                          SizedBox(width: 11.w),
                          Obx(() => Column(
                            children: [
                              GestureDetector(
                                  onTap: () => toggleIsFavoriteVoice(),
                                  child: Image.asset(profileController.isfavoriteVoice.value? 'assets/icons/heart_fill.png' : 'assets/icons/heart.png', height: 22.h)),
                              Text('105', style: Theme.of(context).textTheme.headline6,),
                            ],
                          )),
                        ],
                      ),
                    ),
                    Text('팔로잉 카테고리', style: Theme.of(context).textTheme.headline4,),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0.h),
                child: Container(
                  height: 25.h,
                  child: ListView(
                    padding: EdgeInsets.only(left: 44.0.w),
                    scrollDirection: Axis.horizontal,
                    children: followingThemeList(context),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w, top: 37.0.h, bottom: 17.0.h),
                child: Text('내 HERE LIVE', style: Theme.of(context).textTheme.headline4),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w, bottom: 20.h),
                child: Container(
                  height: 131.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                        5,
                            (i) => Padding(
                              padding: EdgeInsets.only(right: 9.0.w),
                              child: Container(
                                width: 129.h,
                                height: 131.h,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            )),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
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
      width: 216.w,
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

  List<Widget> followingThemeList(BuildContext context) {
    return List.generate(
        themeList.length,
            (i) => Padding(
          padding: EdgeInsets.only(right: 6.0.w),
          child: Container(
            padding: EdgeInsets.only(left: 7.w, right: 7.0.w),
            child: Center(
                child: Text('#${themeList[i]}', style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).colorScheme.primary
                ))),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border.all(width: 1.5.w, color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.all(Radius.circular(13.5)),
            ),
          ),
        ));
  }

  void toggleIsFavoriteVoice() {
    profileController.isfavoriteVoice.value = !profileController.isfavoriteVoice.value;
  }
}