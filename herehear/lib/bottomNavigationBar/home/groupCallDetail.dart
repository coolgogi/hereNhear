import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/home/scroll_controller.dart';
import 'package:herehear/broadcast/broadcast_list.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/groupCall/data/group_call_model.dart';
import 'package:herehear/groupCall/group_call.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../broadcast/data/broadcast_model.dart' as types;
import 'package:herehear/groupCall/data/group_call_model.dart' as types;
import 'home.dart';

class GroupCallDetailPage extends StatelessWidget {
  // final _scrollController = Get.put(DetailPagesScrollerController());

  @override
  Widget build(BuildContext context) {
    // _scrollController.onInit();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0.w,
        // centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface, size: 22.w),
            onPressed: (() {
              // _scrollController.dispose();
              Get.back();
            })),
        title: Row(
          children: [
            Text('HERE CHAT',
                style: Theme.of(context).appBarTheme.titleTextStyle),
            SizedBox(width: 5.w),
            Image.asset('assets/icons/live.png',
                width: 43.w, height: 18.h),
          ],
        ),
        actions: <Widget>[
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/bell.png', height: 17.0.h)),
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Obx(() => AnimatedOpacity(
            //   // key: widgetKey,
            //     duration: Duration(milliseconds: 1),
            //     opacity: _scrollController.opacity.value,
            //     child: Padding(
            //       padding: EdgeInsets.only(
            //           left: 25.0.w,
            //           top: 20.0.h,
            //           right: 26.0.w,
            //           bottom: 20.h),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Row(
            //             children: [
            //               Text('원하는 카테고리의 ',
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .headline3),
            //               Text(
            //                   'HERE 라이브',
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .headline1),
            //               Text(
            //                   '를',
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .headline3),
            //             ],
            //           ),
            //           Text('찾아보세요.',
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .headline3),
            //         ],
            //       ),
            //     ))),
            Padding(
              padding: EdgeInsets.only(left: 26.0.w, top: 20.0.h, right: 28.w, bottom: 30.h),
              child: StreamBuilder<List<types.GroupCallModel>>(
                stream: MyFirebaseChatCore.instance.groupCallRoomsWithLocation(),
                initialData: const [],
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ));
                  }
                  if (snapshot.data!.isEmpty)
                    return Padding(
                      padding: EdgeInsets.only(top: 50.0.h),
                      child: Container(
                        child: Text('현재 열려있는 방이 없습니다.'),
                      ),
                    );
                  return groupcallRoomList(context, snapshot);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView groupcallRoomList(
      BuildContext context, AsyncSnapshot<List<GroupCallModel>> snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final room = snapshot.data![index];
        return
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 16),
                width: 327.0.w,
                height: 69.0.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () async {
                    firestore.collection('groupcall').doc(room.channelName).update({
                      'currentListener':
                      FieldValue.arrayUnion([UserController.to.myProfile.value.uid]),
                    });
                    await _handleCameraAndMic(Permission.microphone);
                    Get.to(() => GroupCallPage(roomData: room),);
                  },
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 15.0.w),
                        child: Container(
                          // margin: EdgeInsets.all(0.0.w),
                          width: 85.0.w,
                          height: 69.0.h,
                          // child: SizedBox(child: Image.asset(_roomData['image'])),
                          child: Stack(
                            children: [
                              SizedBox(
                                  child: Center(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage('assets/images/mountain.jpg'),
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                            ),
                                          )))),
                              Positioned(
                                  left: 56.0.w,
                                  right: 7.0.w,
                                  top: 40.0.h,
                                  bottom: 4.0.h,
                                  child: Container(
                                    width: 15.w,
                                    height: 15.h,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/she2.jpeg'),
                                        fit: BoxFit.contain,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    // child: Image.asset('assets/images/she2.jpeg'),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            room.roomInfo.title,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          SizedBox(
                            height: 7.0.h,
                          ),
                          Text(
                            room.roomInfo.notice!,
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
                      ),
                      Expanded(child: Container()),
                      Container(
                        height: 20.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(13.r)),
                          border: Border.all(
                              width: 1.5.w,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        child: Center(child: Padding(
                          padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.h),
                          child: Row(
                            children: [
                              Image.asset('assets/icons/book.png', width: 10.w, height: 10.w),
                              SizedBox(width: 2.w),
                              Text('독서', style: Theme.of(context).textTheme.headline4!.copyWith(
                                  fontSize: 11.sp,
                                  color: Theme.of(context).colorScheme.primary),)
                            ],
                          ),
                        ),),
                      ),
                      SizedBox(width: 8.w),
                    ],
                  ),
                ),
              ),
            ],
          );
      },
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
  }
}
