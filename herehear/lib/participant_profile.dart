import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/record_controller.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'groupCall/data/participantsProfile_controller.dart';


class ParticipantProfilePage extends StatelessWidget {
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Padding(
          padding: EdgeInsets.only(top: 15.0.h),
          child: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Get.back()),
            title: Text('Speaker 프로필', style: Theme.of(context).textTheme.headline1),
            titleSpacing: 0.0,
            actions: <Widget>[
              InkWell(
                onTap: () => showReportDialog(context),
                child: Padding(
                  padding: EdgeInsets.only(top: 3.h, right: 33.w),
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/icons/report.png', height: 18.h),
                      SizedBox(height: 3.5.h),
                      Text(
                        '신고하기',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 44.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.0.h),
                      child: Text(
                        'NickName',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 24.0.h, bottom: 17.h),
                          child: Container(
                            width: 80.h,
                            height: 80.h,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/images/you.png'),
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 33.w),
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
                    Text('이름', style: Theme.of(context).textTheme.headline5),
                    SizedBox(height: 1.h),
                    Text('상태 메세지(ex. 앨범 많이 사랑해주세요)', style: Theme.of(context).textTheme.headline6),
                    Padding(
                      padding: EdgeInsets.only(top: 28.h, bottom: 29.h),
                      child: Row(
                          children: [
                            Obx(() => InkWell(
                              onTap: () => toggleIsFollow(),
                              child: Container(
                                  width: 142.w,
                                  height: 35.h,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.background,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.25),
                                        spreadRadius: 0,
                                        blurRadius: 8,
                                        offset: Offset(0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(child: Text(profileController.isFollow.value? '팔로잉' : '팔로우', style: Theme.of(context).textTheme.headline5!.copyWith(
                                    color: profileController.isFollow.value? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground,
                                  )))
                              ),
                            )),
                            SizedBox(width: 11.w),
                            InkWell(
                              onTap: null,
                              child: Container(
                                  width: 142.w,
                                  height: 35.h,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.background,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.25),
                                        spreadRadius: 0,
                                        blurRadius: 8,
                                        offset: Offset(0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(child: Text('메세지', style: Theme.of(context).textTheme.headline5,))),
                            ),
                          ]
                      ),
                    ),
                    Text('보이스 프로필', style: Theme.of(context).textTheme.headline4,),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0.h, bottom: 32.h),
                      child: Row(
                        children: [
                          Obx(() => Container(
                              width: 260.w,
                              height: 44.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.25),
                                    spreadRadius: 0,
                                    blurRadius: 8,
                                    offset: Offset(0, 0), // changes position of shadow
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
                                              child: Center(child: Image.asset('assets/icons/playButton.png', height: 20.h)))),
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
              )
            ],
          ),
        ],
      ),
      bottomSheet: bottomBar(context),
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
      width: 210.w,
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

  void toggleIsFollow() {
    profileController.isFollow.value = !profileController.isFollow.value;
  }

  void toggleIsFavoriteVoice() {
    profileController.isfavoriteVoice.value = !profileController.isfavoriteVoice.value;
  }

  Future<dynamic> showReportDialog(BuildContext context) {
    return Get.dialog(
        Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 330.w,
                height: 370.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(126.w, 16.63.h, 20.w, 12.h),
                      child: Row(
                        children: [
                          Text('신고하기', style: Theme.of(context).textTheme.headline2),
                          Expanded(child: Container()),
                          InkWell(
                              onTap: () {
                                profileController.onClose();
                                Get.back();
                              },
                              child: Icon(Icons.close)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0.w),
                      child: Obx(() => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                child: Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      horizontalTitleGap: 0.0.w,
                                      title: Text('음란/선정성'),
                                      leading: Radio(
                                        value: reportReasonList.sexual,
                                        groupValue: profileController.reportReason.value,
                                        onChanged: (reportReasonList? value) {
                                          profileController.reportReason.value = value;
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      horizontalTitleGap: 0.0.w,
                                      title: Text('욕설/인신공격'),
                                      leading: Radio(
                                        value: reportReasonList.insult,
                                        groupValue: profileController.reportReason.value,
                                        onChanged: (reportReasonList? value) {
                                          profileController.reportReason.value = value;
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      horizontalTitleGap: 0.0.w,
                                      title: Text('기타'),
                                      leading: Radio(
                                        value: reportReasonList.etc,
                                        groupValue: profileController.reportReason.value,
                                        onChanged: (reportReasonList? value) {
                                          profileController.reportReason.value = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      horizontalTitleGap: 0.0.w,
                                      title: Text('불법정보'),
                                      leading: Radio(
                                        value: reportReasonList.illigal,
                                        groupValue: profileController.reportReason.value,
                                        onChanged: (reportReasonList? value) {
                                          profileController.reportReason.value = value;
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      horizontalTitleGap: 0.0.w,
                                      title: Text('개인정보 노출'),
                                      leading: Radio(
                                        value: reportReasonList.privacy,
                                        groupValue: profileController.reportReason.value,
                                        onChanged: (reportReasonList? value) {
                                          profileController.reportReason.value = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(10.w, 0.h, 0.w, 5.h),
                                focusedBorder: InputBorder.none,
                              ),
                              enabled: profileController.reportReason.value == reportReasonList.etc? true : false,
                              autofocus: false,
                            ),
                            width: 246.w,
                            height: 36.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                                border: Border.all(color: profileController.reportReason.value == reportReasonList.etc? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface)
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0.h),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0.w),
                              horizontalTitleGap: 0.0.w,
                              title: Text('권리침해 신고'),
                              leading: Radio(
                                value: reportReasonList.right,
                                groupValue: profileController.reportReason.value,
                                onChanged: (reportReasonList? value) {
                                  profileController.reportReason.value = value;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 30.w, bottom: 10.h),
                            child: Text('사생활 침해/명예훼손으로 피해를 받으신 경우 신고해 주세요.', style: Theme.of(context).textTheme.headline6,),
                          )
                        ],
                      )),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: null, // <-- 여기에 신고 완료 funtion ㅇㅇ..
                              child: Container(
                                width: 160.w,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/icons/report_red.png', height: 18.h),
                                      SizedBox(width: 6.47),
                                      Text('신고하기', style: Theme.of(context).textTheme.headline5!.copyWith(
                                          color: Theme.of(context).colorScheme.secondaryVariant
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            VerticalDivider(thickness: 1),
                            InkWell(
                              onTap: () => Get.back(),
                              child: Container(
                                width: 150.5.w,
                                child: Center(
                                  child: Text('취소', style: Theme.of(context).textTheme.headline5!.copyWith(
                                      color: Theme.of(context).colorScheme.primaryVariant
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget bottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, -4), // changes position of shadow
          ),
        ],
      ),
      child: BottomAppBar(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.0.w, 8.0.h, 10.0.w, 8.0.h),
              child: InkWell(
                child: Container(
                  width: 80.w,
                  height: 28.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/icons/goOut_red.png', width: 20.w),
                      Text('방 나가기 ', style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Theme.of(context).colorScheme.secondaryVariant
                      ))
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.r)),
                      border: Border.all(color: Theme.of(context).colorScheme.secondaryVariant)
                  ),
                ),
                onTap: null,
              ),
            ),
            Expanded(
              child: Container(
                height: 50.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0.w, 6.0.h, 0.0.w, 6.0.h),
              child: InkWell(
                splashColor: Colors.transparent,
                child: Container(
                  width: 37.w,
                  child: Padding(
                    padding: EdgeInsets.all(7.0.w),
                    child: Image.asset('assets/icons/chat_black.png', width: 15.w),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                onTap: null,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15.0.w, 8.0.w, 21.0.w, 8.0.w),
              child: Container(
                child: InkWell(
                  splashColor: Colors.transparent,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    child: Padding(
                      padding: EdgeInsets.all(7.0.w),
                      child: Image.asset('assets/icons/hand.png', width: 22.w),
                    ),
                  ),
                  onTap: null,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}