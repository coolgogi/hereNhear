import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/app.dart';
import 'package:herehear/theme/theme.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:overlay_support/overlay_support.dart';

import 'appBar/notification/notification.dart';
import 'bottomNavigationBar/home/home.dart';
import 'bottomNavigationBar/myPage/mypage.dart';
import 'bottomNavigationBar/search/search.dart';
import 'login/signIn.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static ThemeController get to => Get.find();
  @override
  Widget build(BuildContext context) {
    // GetX 등록
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return MaterialApp(home: Splash());
        else {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
            child: GetBuilder<ThemeController>(
                init: ThemeController(),
                builder: (value) {
                  return ScreenUtilInit(
                    designSize: Size(375, 667),
                    builder: () => GetMaterialApp(
                      theme: value.isDarkTheme.value ? darkTheme : lightTheme,
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
                          page: () => MyPage(),
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
                }),
          );
        }
      }
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('assets/images/mainLogo.png', width: 144.h,)),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(Duration(seconds: 3));
  }
}
