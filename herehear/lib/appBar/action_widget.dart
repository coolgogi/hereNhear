import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'notification/notification.dart';

List<Widget> action_widget(GlobalKey<ScaffoldState> _key) {
  return <Widget>[
    IconButton(
        onPressed: () => Get.to(() => NotificationPage()),
        icon: Image.asset('assets/icons/bell.png', height: 18.0.h)),
    IconButton(
        onPressed: () => _key.currentState!.openEndDrawer(),
        icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
  ];
}
