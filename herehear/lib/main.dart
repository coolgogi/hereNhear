import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/notification.dart';
import 'package:herehear/bottomNavigationBar/search/search.dart';
import 'package:herehear/bottomNavigationBar/myPage/mypage.dart';
import 'package:herehear/bottomNavigationBar/home/HomePage.dart';
import 'package:herehear/login/signIn.dart';
import 'bottomNavigationBar/bottom_bar.dart';
import 'location/controller/location_controller.dart';
import 'theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(App());

class App extends StatelessWidget {
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
          return GetBuilder<LocationController>(
              init: LocationController(),
              builder: (value) {
                print('위치: ${value.location.obs}');
                return FutureBuilder(
                    future: LocationController()
                        .getLocation(),
                    builder: (context, snapshot) {
                        return MyApp();
                    });
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
              // GetX Controller 등록
              // initialBinding: BindingsBuilder(() {}),
              title: 'Here & Hear',
              home: BottomBar(),
              //home: LandingPage.withData(_data!),
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