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








ListView groupcallRoomList(
    BuildContext context, AsyncSnapshot<List<GroupCallModel>> snapshot) {
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
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
                  )
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

//
// List<Widget> groupcallRoomList(
//     BuildContext context, AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
//   return broadcastSnapshot.data!.docs.map((_roomData) {
//     return Column(
//       children: [
//         Container(
//           margin: EdgeInsets.only(bottom: 16),
//           width: 327.0.w,
//           height: 69.0.h,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(Radius.circular(15)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 spreadRadius: 0,
//                 blurRadius: 8,
//                 offset: Offset(0, 4), // changes position of shadow
//               ),
//             ],
//           ),
//           child: InkWell(
//             onTap: () async {
//               firestore.collection('groupcall').doc(_roomData['docId']).update({
//                 'currentListener':
//                 FieldValue.arrayUnion([UserController.to.myProfile.value.uid]),
//               });
//               await _handleCameraAndMic(Permission.microphone);
//               Get.to(() => GroupCallPage(_roomData['title']),
//                   arguments: _roomData['channelName']);
//             },
//             child: Row(
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(right: 15.0.w),
//                   child: Container(
//                     // margin: EdgeInsets.all(0.0.w),
//                     width: 85.0.w,
//                     height: 69.0.h,
//                     // child: SizedBox(child: Image.asset(_roomData['image'])),
//                     child: Stack(
//                       children: [
//                         SizedBox(
//                             child: Center(
//                                 child: Container(
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         fit: BoxFit.cover,
//                                         image: AssetImage('assets/images/mountain.jpg'),
//                                       ),
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(15),
//                                         bottomLeft: Radius.circular(15),
//                                       ),
//                                     )))),
//                         Positioned(
//                             left: 56.0.w,
//                             right: 7.0.w,
//                             top: 40.0.h,
//                             bottom: 4.0.h,
//                             child: Container(
//                               width: 15.w,
//                               height: 15.h,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: AssetImage('assets/images/she2.jpeg'),
//                                   fit: BoxFit.contain,
//                                 ),
//                                 shape: BoxShape.circle,
//                               ),
//                               // child: Image.asset('assets/images/she2.jpeg'),
//                             ))
//                       ],
//                     ),
//                   ),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       _roomData['title'],
//                       style: Theme.of(context).textTheme.headline4,
//                     ),
//                     SizedBox(
//                       height: 7.0.h,
//                     ),
//                     Text(
//                       _roomData['notice'],
//                       style: Theme.of(context).textTheme.headline6,
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }).toList();
// }
//
// Future<void> _handleCameraAndMic(Permission permission) async {
//   final status = await permission.request();
//   print(status);
// }