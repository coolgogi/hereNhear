import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/notification/notification.dart';
import 'package:herehear/bottomNavigationBar/search/search.dart';
import 'package:herehear/bottomNavigationBar/myPage/mypage.dart';
import 'package:herehear/bottomNavigationBar/home/home.dart';
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
                  page: () => SearchPage(),
                )
              ],
            ),
          );
        });
  }
}



class App extends GetView<UserController> {
  final locationController = Get.put(LocationController());
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
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance
                .authStateChanges(), //firebase 상태가 바뀌었는지 아닌지 체크하는 stream.
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (!snapshot.hasData) {
                return LoginPage(); //data가 없으면 로그인으로
              } else {
                UserController.to.authStateChanges(snapshot.data);
                return FutureBuilder(
                    future: locationController.getLocation(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data.toString());
                        return BottomBar();
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    });// data가 있으면 MainPage로
              }
            },
          );

        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
