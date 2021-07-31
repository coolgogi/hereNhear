// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
//
// class NotificationController extends GetxController {
//   static NotificationController get to => Get.find();
//   FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   RxMap<String, dynamic> message = Map<String, dynamic>().obs;
//
//   @override
//   void onInit() {
//     _initNotification();
//     _getToken();
//     super.onInit();
//   }
//
//   Future<void> _getToken() async {
//     try {
//       String? token = await _messaging.getToken();
//       print(token);
//     } catch (e) {}
//   }
//
//   void _initNotification() {
//     _messaging.requestPermission(sound: true, badge: true, alert: true, provisional: true);
//
//     // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
//     _messaging.getInitialMessage().then((message) => _onLaunch(message!.data));
//
//     // onMessage: When the app is open and it receives a push notification
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("onMessage data: ${message.data}");
//       _onMessage(message!.data);
//     });
//
//     // replacement for onResume: When the app is in the background and opened directly from the push notification.
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('onMessageOpenedApp data: ${message.data}');
//       _onResume(message.data);
//     });
//   }
//
//   Future<void> _onResume(Map<String, dynamic> message) {
//     print("_onResume : $message");
//     return null;
//   }
//
//   Future<void> _onLaunch(Map<String, dynamic> message) {
//     print("_onLaunch : $message");
//     _actionOnNotification(message);
//     return;
//   }
//
//   void _actionOnNotification(Map<String, dynamic> messageMap) {
//     message(messageMap);
//   }
//
//   Future<void> _onMessage(Map<String, dynamic> message) {
//     print("_onMessage : $message");
//     return null;
//   }
//
//   void _showNotification(Map<String, dynamic> message) async {
//     NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//             "sample_channel_id", "Notification Test", ""),
//         iOS: IOSNotificationDetails());
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       message["title"],
//       message["body"],
//       notificationDetails,
//       payload: json.encode(message["data"]),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'appBar/notification/notificatnion_controller.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       initialBinding: BindingsBuilder(
//             () {
//           Get.put(NotificationController());
//         },
//       ),
//       home: Scaffold(
//         appBar: AppBar(),
//         body: Obx(() {
//           if (NotificationController.to.message.isNotEmpty) // 원하는 페이지 or 이벤트 처리
//             return Container();
//           else
//             return Container(
//
//             );
//         }),
//       ),
//     );
//   }
// }