import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/contest/evaluation2.dart';

import 'evaluation.dart';
import 'evaluation3.dart';
import 'evaluation4.dart';

class controller extends GetxController {
  RxBool flag1 = false.obs;
  RxBool flag2 = false.obs;
  RxBool flag3 = false.obs;
}

class ContestPage extends StatelessWidget {
  const ContestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44.0.h),
        child: AppBar(
          title: Text('소리꾼들',
              style: Theme.of(context).appBarTheme.titleTextStyle),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0.w, top: 25.0.r),
            child: Text('자유 컨테스트', style: Theme.of(context).textTheme.headline2),
          ),
          Container(
            height: 150.0.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 6.0.w, top: 12.0.h, bottom: 10.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0.h),
                        child: GestureDetector(
                          onTap: (){
                            Get.to(() => EvaluationPage());
                          },
                          child: Container(
                            width: 120.0.w,
                            height: 120.0.w,
                            child: Card(
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/it2.jpg'),
                                    Image.asset('assets/images/playButton.png', width: 80.0.w,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.sp),
                        child: Center(child: Text('한화 이글스를 찾아간 \n VJ특공대', style: Theme.of(context).textTheme.subtitle1,)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.0.w, top: 12.0.h, bottom: 10.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0.h),
                        child: GestureDetector(
                          onTap: (){
                            Get.to(() => EvaluationPage2());
                          },
                          child: Container(
                            width: 120.0.w,
                            height: 120.0.w,
                            child: Card(
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/she2.jpeg'),
                                    Image.asset('assets/images/playButton.png', width: 80.0.w,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.sp),
                        child: Text('여자 목소리', style: Theme.of(context).textTheme.subtitle1,),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.0.w, top: 12.0.h, bottom: 10.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0.h),
                        child: GestureDetector(
                          onTap: (){
                            Get.to(() => EvaluationPage());
                          },
                          child: Container(
                            width: 120.0.w,
                            height: 120.0.w,
                            child: Card(
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/you2.jpg'),
                                    Image.asset('assets/images/playButton.png', width: 80.0.w,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.sp),
                        child: Text('이륙하는 비행기', style: Theme.of(context).textTheme.subtitle1,),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.0.w, top: 12.0.h, bottom: 10.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0.h),
                        child: GestureDetector(
                          onTap: (){
                            Get.to(() => EvaluationPage());
                          },
                          child: Container(
                            width: 120.0.w,
                            height: 120.0.w,
                            child: Card(
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/hamster.jpg'),
                                    Image.asset('assets/images/playButton.png', width: 80.0.w,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.sp),
                        child: Text('중구가 시키드나', style: Theme.of(context).textTheme.subtitle1,),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.0.w, top: 12.0.h, bottom: 10.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0.h),
                        child: GestureDetector(
                          onTap: (){
                            Get.to(() => EvaluationPage());
                          },
                          child: Container(
                            width: 120.0.w,
                            height: 120.0.w,
                            child: Card(
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/me.jpg'),
                                    Image.asset('assets/images/playButton.png', width: 80.0.w,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.sp),
                        child: Text('도라에몽', style: Theme.of(context).textTheme.subtitle1,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(right: 14.0.w,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('기간: 7월 19일 ~ 7월 23일', style: Theme.of(context).textTheme.bodyText2,),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0.w, top: 10.0.h),
            child: Row(
              children: [
                Text('우리동네 음악대장', style: Theme.of(context).textTheme.headline2),
                Expanded(child: Container()),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: null,
                ),
              ],
            ),
          ),
          Container(
            height: 100.0.h,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0.w,),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Get.to(() => EvaluationPage3()),
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0.w),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8.0.h),
                              child: CircleAvatar(
                                radius: 48.r,
                                backgroundImage: AssetImage('assets/images/you.png'),
                                child: CircleAvatar(
                                  radius: 49.r,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage('assets/images/playButton3.png'),
                                ),
                              ),
                          ),
                          Positioned(
                            left: 12,
                            right: 5,
                            top: -105,
                            bottom: 0,
                            child:Image.asset('assets/images/goldCrown.png', width: 100,),
                          ),
                          Positioned(
                            left: 0,
                            right: 55,
                            top: -73,
                            bottom: 3,
                            child:Container(
                              width: 20.r,
                              decoration: BoxDecoration(
                                color: Color(0xFF618051),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            right: 0,
                            top: 12,
                            bottom: 0,
                            child:Text('1위', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto',),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => EvaluationPage4()),
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0.w),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8.0.h),
                              child: CircleAvatar(
                                radius: 48.r,
                                backgroundImage: AssetImage('assets/images/me.jpg'),
                                child: CircleAvatar(
                                  radius: 49.r,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage('assets/images/playButton3.png'),
                                ),
                              ),
                          ),
                          Positioned(
                            left: 12,
                            right: 5,
                            top: -105,
                            bottom: 0,
                            child:Image.asset('assets/images/silverCrown.png', width: 100,),
                          ),
                          Positioned(
                            left: 0,
                            right: 55,
                            top: -73,
                            bottom: 3,
                            child:Container(
                              width: 20.r,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            right: 0,
                            top: 12,
                            bottom: 0,
                            child:Text('2위', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto',),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.0.h),
                          child: CircleAvatar(
                              radius: 48.r,
                              backgroundImage: AssetImage('assets/images/he.jpg'),
                              child: GestureDetector(
                                onTap: () => Get.to(() => EvaluationPage2()),
                                child: CircleAvatar(
                                  radius: 49.r,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage('assets/images/playButton3.png'),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          left: 12,
                          right: 5,
                          top: -105,
                          bottom: 0,
                          child:Image.asset('assets/images/bronzeCrown.png', width: 100,),
                        ),
                        Positioned(
                          left: 0,
                          right: 55,
                          top: -73,
                          bottom: 3,
                          child:Container(
                            width: 20.r,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryVariant,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          right: 0,
                          top: 12,
                          bottom: 0,
                          child:Text('3위', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto',),),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Container(
                      width: 90.r,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/images/dog.jpg'),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Container(
                      width: 90.r,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/images/cat.jpg'),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Divider(),
          Padding(
            padding: EdgeInsets.only(left: 16.0.w, top: 10.0.h),
            child: Row(
              children: [
                Text('우리동네 꿀보이스', style: Theme.of(context).textTheme.headline2),
                Expanded(child: Container()),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: null,
                ),
              ],
            ),
          ),
          Container(
            height: 100.0.h,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0.w,),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[

    GestureDetector(
    onTap: () => Get.to(() => EvaluationPage4()),
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0.w),
                      child: Stack(
                        children: [
                          Container(
                              width: 90.r,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/hamster.jpg'),
                                      fit: BoxFit.fill
                                  )
                              ),
                            ),

                          Positioned(
                            left: 15,
                            right: 5,
                            top: -105,
                            bottom: 0,
                            child:Image.asset('assets/images/goldCrown.png', width: 100,),
                          ),
                          Positioned(
                            left: 0,
                            right: 50,
                            top: -75,
                            bottom: 3,
                            child:Container(
                              width: 20.r,
                              decoration: BoxDecoration(
                                color: Color(0xFF618051),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            right: 0,
                            top: 11,
                            bottom: 0,
                            child:Text('1위', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto',),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Stack(
                      children: [
                        Container(
                          width: 90.r,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage('assets/images/cat.jpg'),
                                  fit: BoxFit.fill
                              )
                          ),
                        ),
                        Positioned(
                          left: 15,
                          right: 5,
                          top: -105,
                          bottom: 0,
                          child:Image.asset('assets/images/silverCrown.png', width: 100,),
                        ),
                        Positioned(
                          left: 0,
                          right: 50,
                          top: -75,
                          bottom: 3,
                          child:Container(
                            width: 20.r,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          right: 0,
                          top: 11,
                          bottom: 0,
                          child:Text('2위', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto',),),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Stack(
                      children: [
                        Container(
                          width: 90.r,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage('assets/images/it.jpg'),
                                  fit: BoxFit.fill
                              )
                          ),
                        ),
                        Positioned(
                          left: 15,
                          right: 5,
                          top: -105,
                          bottom: 0,
                          child:Image.asset('assets/images/bronzeCrown.png', width: 100,),
                        ),
                        Positioned(
                          left: 0,
                          right: 50,
                          top: -75,
                          bottom: 3,
                          child: Container(
                            width: 20.r,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryVariant,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          right: 0,
                          top: 11,
                          bottom: 0,
                          child:Text('3위', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto',),),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Container(
                      width: 90.r,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/images/it2.jpg'),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Container(
                      width: 90.r,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/images/you.png'),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0.w, top: 10.0.h),
            child: Row(
              children: [
                Text('우리동네 웃음 전도사', style: Theme.of(context).textTheme.headline2),
                Expanded(child: Container()),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: null,
                ),
              ],
            ),
          ),
          Container(
            height: 100.0.h,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0.w,),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Stack(
                      children: [
                        Container(
                          width: 90.r,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage('assets/images/she.jpg'),
                                  fit: BoxFit.fill
                              )
                          ),
                        ),
                        Positioned(
                          left: 15,
                          right: 5,
                          top: -105,
                          bottom: 0,
                          child:Image.asset('assets/images/goldCrown.png', width: 100,),
                        ),
                        Positioned(
                          left: 0,
                          right: 50,
                          top: -75,
                          bottom: 3,
                          child:Container(
                            width: 20.r,
                            decoration: BoxDecoration(
                              color: Color(0xFF618051),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          right: 0,
                          top: 11,
                          bottom: 0,
                          child:Text('1위', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto',),),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Stack(
                      children: [
                        Container(
                          width: 90.r,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage('assets/images/she2.jpeg'),
                                  fit: BoxFit.fill
                              )
                          ),
                        ),
                        Positioned(
                          left: 15,
                          right: 5,
                          top: -105,
                          bottom: 0,
                          child:Image.asset('assets/images/silverCrown.png', width: 100,),
                        ),
                        Positioned(
                          left: 0,
                          right: 50,
                          top: -75,
                          bottom: 3,
                          child:Container(
                            width: 20.r,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          right: 0,
                          top: 11,
                          bottom: 0,
                          child:Text('2위', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto',),),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Stack(
                      children: [
                        Container(
                          width: 90.r,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage('assets/images/you2.jpg'),
                                  fit: BoxFit.fill
                              )
                          ),
                        ),
                        Positioned(
                          left: 15,
                          right: 5,
                          top: -105,
                          bottom: 0,
                          child:Image.asset('assets/images/bronzeCrown.png', width: 100,),
                        ),
                        Positioned(
                          left: 0,
                          right: 50,
                          top: -75,
                          bottom: 3,
                          child: Container(
                            width: 20.r,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryVariant,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          right: 0,
                          top: 11,
                          bottom: 0,
                          child:Text('3위', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto',),),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Container(
                      width: 90.r,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/images/you.png'),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Container(
                      width: 90.r,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/images/cat.jpg'),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
