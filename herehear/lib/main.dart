import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/app.dart';
import 'package:herehear/theme/theme.dart';
import 'package:herehear/users/controller/user_controller.dart';

import 'appBar/notification/notification.dart';
import 'bottomNavigationBar/home/HomePage.dart';
import 'bottomNavigationBar/myPage/mypage.dart';
import 'bottomNavigationBar/search/search.dart';
import 'login/signIn.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static ThemeController get to => Get.find();
  @override
  Widget build(BuildContext context) {
    // GetX 등록
    return GetBuilder<ThemeController>(
        init: ThemeController(),
        builder: (value) {
          return ScreenUtilInit(
            designSize: Size(375, 667),
            builder: () => GetMaterialApp(
              theme: value.isDarkTheme.value ? dark_theme : light_theme,
              debugShowCheckedModeBanner: false,
              initialBinding: BindingsBuilder(() {
                Get.lazyPut<UserController>(
                        () => UserController()); //이 부분을 추가하면 된다.
              }),
              title: 'Here & Hear',
              home: App(),
              getPages: [
                GetPage(
                  name: '/',
                  page: () => HomePage(),
                ),
                GetPage(
                  name: '/myPage',
                  page: () => myPage(),
                ),
                GetPage(
                  name: '/login',
                  page: () => LoginPage(),
                ),
                GetPage(
                  name: '/notification',
                  page: () => NotificationPage(),
                ),
                GetPage(
                  name: '/search',
                  page: () => searchPage(),
                )
              ],
            ),
          );
        });
  }
}