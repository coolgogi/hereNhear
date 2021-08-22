import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QnAPage extends StatelessWidget {
  const QnAPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Padding(
            padding: EdgeInsets.only(left: 10.0.w),
            child: Icon(Icons.chevron_left, size: 35.w, color: Theme.of(context).colorScheme.onSurface),
          )),
        centerTitle: true,
        title: Text('문의하기', style: Theme.of(context).textTheme.headline1,),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 36.0.w, top: 60.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('모르겠거나 궁금한 점이 있으신가요?', style: Theme.of(context).textTheme.headline5,),
            Text('HERE & HEAR에게 알려주세요.', style: Theme.of(context).textTheme.headline2,),
            Padding(
              padding: EdgeInsets.only(top: 10.0.h),
              child: Container(
                height: 300.h,
                width: 310.w,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 160.0.w),
                      child: Image.asset('assets/images/streamer.png', height: 114.h),
                    ),
                    Positioned(
                      top: 95.h,
                      child: Container(
                        width: 307.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(21.r)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: Offset(0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(37.0.w, 25.h, 21.w, 40.h),
                          child: Column(
                            children: [
                              Text('HERE & HEAR 지원센터', style: Theme.of(context).textTheme.headline4),
                              SizedBox(height: 33.h),
                              Row(
                                children: [
                                  Text('전화번호', style: Theme.of(context).textTheme.headline5),
                                  Expanded(child: Container()),
                                  Text('00-0000-0000', style: Theme.of(context).textTheme.headline5),
                                  SizedBox(width: 58.5.w),
                                ],
                              ),
                              SizedBox(height: 25.h),
                              Row(
                                children: [
                                  Text('상담 가능시간', style: Theme.of(context).textTheme.headline5),
                                  Expanded(child: Container()),
                                  Text('평일 10:00am ~ 6:00pm', style: Theme.of(context).textTheme.headline5),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              width: 307.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 7,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/call.png', height: 16.h),
                  SizedBox(width: 6.w),
                  Text('전화하기', style: Theme.of(context).textTheme.headline5),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: 307.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Color(0xFFF9E401),
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 7,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/kakao.png', height: 20.h),
                  SizedBox(width: 6.w),
                  Text('카카오톡 채널', style: Theme.of(context).textTheme.headline5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
