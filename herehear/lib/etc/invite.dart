// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:herehear/main.dart';
//
// class InvitationPage extends StatelessWidget {
//   Map<String, dynamic> _data = new Map();
//   InvitationPage.withData(Map<String, dynamic> data) {
//     _data = data;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(child: Text('익명의 사람으로부터 초대가 왔습니다.')),
//           Container(
//             padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
//             child: Text('수락하시겠습니까?'),
//           ),
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Container(
//               child: ElevatedButton(
//                 onPressed: () => Get.off(
//                   () => LandingPage.withData(_data),
//                 ),
//                 child: Text(
//                   "예",
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//               child: ElevatedButton(
//                 onPressed: () => Get.off(
//                   () => LandingPage.withData(_data),
//                 ),
//                 child: Text(
//                   "아니요",
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//           ]),
//         ],
//       ),
//     ));
//   }
// }
