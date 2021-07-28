import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/notification.dart';
import 'package:herehear/location_data/location.dart';
import 'package:herehear/bottomNavigationBar/search/search.dart';
import 'package:herehear/bottomNavigationBar/myPage/mypage.dart';
import 'package:herehear/bottomNavigationBar/home/HomePage.dart';
import 'package:herehear/etc/upload.dart';
import 'package:herehear/login/signIn.dart';
import 'bottomNavigationBar/bottom_bar.dart';
import 'bottomNavigationBar/create/create_broadcast.dart';
import 'bottomNavigationBar/create/create_groupcall.dart';
import 'bottomNavigationBar/contest/contest.dart';
import 'theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  Map<String, dynamic> _data = new Map();

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
                        .getLocation()
                        .whenComplete(() => getData().whenComplete(() => {
                              print("===============Complete==============="),
                              print(_data['uid']),
                              print(_data['nickName']),
                              print(_data['profile']),
                              print("======================================"),
                            })),
                    builder: (context, snapshot) {
                      if (_data == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else
                        return MyApp(_data);
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

  Future<void> getData() async {
    String uid = '';
    User? _user = FirebaseAuth.instance.currentUser;

    if (_user != null)
      uid = _user.uid;
    else if (_user == null) uid = 'Guest';

    var _data =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    this._data = _data.data()!;
  }
}

class MyApp extends StatelessWidget {
  static ThemeController get to => Get.find();
  Map<String, dynamic>? _data;
  MyApp(Map<String, dynamic> data) {
    this._data = data;
  }
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
              home: BottomBar.withData(_data!),
              //home: LandingPage.withData(_data!),
              getPages: [
                GetPage(
                  name: '/',
                  page: () => HomePage.withData(_data!),
                ),
                GetPage(
                  name: '/myPage',
                  page: () => myPage.withData(_data!),
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
                  page: () => searchPage.withData(_data!),
                )
              ],
            ),
          );
        });
  }
}
