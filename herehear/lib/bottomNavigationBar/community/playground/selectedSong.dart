import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedSong extends StatelessWidget {
  const SelectedSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ));
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                width: 376.w,
                height: 360.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                    image: AssetImage('assets/images/IU.png')
                  )
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.background),
                            onPressed: () => Get.back(),
                          ),
                          Expanded(child: Container()),
                          IconButton(
                              onPressed: null,
                              icon: Image.asset('assets/icons/bell_white.png', height: 17.0.h)),
                          IconButton(
                              onPressed: null,
                              icon: Image.asset('assets/icons/more_white.png', height: 17.0.h)),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 37.h),
                        child: Image.asset('assets/images/IU.png', width: 211.h, height: 200.h),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 55.h, top: 9.h),
                        child: Row(
                          children: [
                            Image.asset('assets/icons/heart_white.png', width: 22.h, height: 22.h,),
                            SizedBox(width: 5.w),
                            Text('1000+', style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Theme.of(context).colorScheme.background,
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0.w, 25.h, 25.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LILAC(노래제목)', style: Theme.of(context).textTheme.headline1),
                Text('아이유(가수이름)', style: Theme.of(context).textTheme.headline5),
                Padding(
                  padding: EdgeInsets.only(top: 25.0.h, bottom: 21.h),
                  child: Row(
                    children: [
                      Container(
                        width: 152.w,
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 23.0.w, right: 9.w),
                              child: Image.asset('assets/icons/profile_black.png', height: 24.h),
                            ),
                            Text('혼자 부르기', style: Theme.of(context).textTheme.headline4)
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        width: 152.w,
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0.w, right: 9.w),
                              child: Image.asset('assets/icons/people_black.png', height: 24.h),
                            ),
                            Text('친구들과 부르기', style: Theme.of(context).textTheme.headline4)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text('친구들과 부르기', style: Theme.of(context).textTheme.headline4),
                SizedBox(height: 11.h),
                Container(
                  width: 314.w,
                  height: 125.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 14.w, right: 16.w, bottom: 10.h),
                            child: Container(
                              width: 80.h,
                              height: 81.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.r)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/images/IU.png')
                                )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('LILAC(노래제목)', style: Theme.of(context).textTheme.headline4),
                                Text('아이유(가수이름)', style: Theme.of(context).textTheme.headline6),
                                Padding(
                                  padding: EdgeInsets.only(top: 9.0.h, bottom: 9.h),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/icons/playButton_grey.png', height: 8.h),
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.0.w, right: 15.w),
                                        child: Text('12', style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface
                                        )),
                                      ),
                                      Image.asset('assets/icons/chat_grey.png', height: 11.h),
                                      Padding(
                                        padding: EdgeInsets.only(left: 3.0.w, right: 22.w),
                                        child: Text('11', style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                            color: Theme.of(context).colorScheme.onSurface
                                        )),
                                      ),
                                      Image.asset('assets/icons/line_short.png', height: 7.h),
                                      SizedBox(width: 20.w),
                                      Text('10시간 전(????)', style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface
                                      )),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 19.h,
                                      height: 19.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/she2.jpeg'),
                                          fit: BoxFit.cover,
                                        )
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text('nickName', style: Theme.of(context).textTheme.headline6),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 314.w,
                            height: 23.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.r),
                                  bottomRight: Radius.circular(10.r)),
                            ),
                            child: Center(
                              child: Text('현재 3명이 참여했습니다.', style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
