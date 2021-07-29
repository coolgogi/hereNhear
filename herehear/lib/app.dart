import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/notification.dart';
import 'package:herehear/bottomNavigationBar/search/search.dart';
import 'package:herehear/bottomNavigationBar/myPage/mypage.dart';
import 'package:herehear/bottomNavigationBar/home/HomePage.dart';
import 'package:herehear/login/signIn.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'bottomNavigationBar/bottom_bar.dart';
import 'location/controller/location_controller.dart';
import 'theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                Get.lazyPut<UserController>(() => UserController()); //이 부분을 추가하면 된다.
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



class App extends GetView<LocationController> {
  final controller = Get.put(LocationController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Firebase load fail'), // 에러 대응
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
              future: controller.getLocation(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data.toString());
                  return BottomBar();
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
