import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'data/group_call_model.dart';
import 'group_call.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/home/home.dart';

Column groupcallRoomList(
    BuildContext context, AsyncSnapshot<List<GroupCallModel>> snapshot) {
  return Column(
    children: List.generate(
      snapshot.data!.length,
      (index) {
        final room = snapshot.data![index];
        return Column(
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
                  firestore
                      .collection('groupcall')
                      .doc(room.channelName)
                      .update({
                    'listeners': FieldValue.arrayUnion(
                        [UserController.to.myProfile.value.uid]),
                  });

                  await _handleCameraAndMic(Permission.microphone);
                  Get.to(
                    () => GroupCallPage(roomData: room),
                  );
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
                                      image:
                                          AssetImage('assets/images/she2.jpeg'),
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
                    Container(
                      width: 170.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 7.h),
                          Text(
                            room.roomInfo.title,
                            maxLines: 2,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Expanded(child: Container()),
                          // Text(
                          //   room.roomInfo.notice!,
                          //   style: Theme.of(context).textTheme.headline6,
                          // )
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                size: 15.w,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                              ),
                              Text(
                                ' ${room.users.length.toString()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                      fontSize: 12.sp,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7.h),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 20.h,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(13.r)),
                            border: Border.all(
                                width: 1.5.w,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.h),
                            child: Row(
                              children: [
                                Image.asset(
                                    'assets/icons/categoryIcon/book.png',
                                    width: 10.w,
                                    height: 10.w),
                                SizedBox(width: 2.w),
                                Text(
                                  '??????',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                          fontSize: 11.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                )
                              ],
                            ),
                          )),
                        ),
                      ],
                    ),
                    SizedBox(width: 8.w),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

Future<void> _handleCameraAndMic(Permission permission) async {
  final status = await permission.request();
}
