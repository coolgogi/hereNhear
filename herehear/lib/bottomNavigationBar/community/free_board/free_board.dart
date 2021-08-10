import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/community/free_board/post.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FreeBoardPage extends StatelessWidget {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final locationController = Get.put(LocationController());

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
              onPressed: null,
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
            padding: EdgeInsets.only(left: 30.0.w, top: 32.0.h),
            child: Row(
              children: <Widget>[
                Text(
                  '당신의 하루를 위로할 HEAR',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.0.w, bottom: 2.h),
                  child: Image.asset(
                    'assets/icons/leaf2.png',
                    width: 15.0.w,
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 92.w, height: 27.h),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () => Get.to(PostPage()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/pen.png', width: 18.w),
                            SizedBox(width: 3.w),
                            Text('글쓰기',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 13.5.sp,
                                    ))
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0.w, top: 27.0.h),
            child: postList(context),
          ),
        ],
      ),
    );
  }

  Widget postList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            postCard(context),
            postCard(context),
          ],
        ),
        Row(
          children: [
            postCard(context),
            postCard(context),
          ],
        ),
        Row(
          children: [
            postCard(context),
            postCard(context),
          ],
        ),
        Row(
          children: [
            postCard(context),
            postCard(context),
          ],
        ),
      ],
    );
  }

  Widget postCard(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 16.0.h, right: 15.0.w),
          width: 160.0.w,
          height: 135.0.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.black,
              ],
            ),
            image: DecorationImage(
                image: AssetImage('assets/images/sora.jpg'), fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 16.0.h, right: 15.0.w),
          width: 160.0.w,
          height: 135.0.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF000000).withOpacity(0.5),
                Color(0xFF747474).withOpacity(0.0),
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(1, 4), // changes position of shadow
              ),
            ],
          ),
          child: InkWell(
            onTap: null,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 51.0.h),
                  child: Center(
                      child: Text('연애 상담 해드려요.',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.white))),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: EdgeInsets.only(right: 11.0.w, bottom: 11.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.people,
                        size: 14.w,
                        color: Colors.white,
                      ),
                      Text(
                          // _roomData['currentListener'] == null
                          //     ? ' 0'
                          //     : ' ${_roomData['currentListener'].length.toString()}',
                          ' 26',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.white)),
                      SizedBox(width: 8.0.w),
                      Icon(
                        Icons.favorite,
                        size: 12.w,
                        color: Colors.white,
                      ),
                      Text(
                          // ' ${_roomData['like'].toString()}',
                          ' 35',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .fontSize,
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .fontFamily,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
    locationController.getLocation().obs;
  }
}
