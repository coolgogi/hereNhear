import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/chatting/chatList.dart';
import 'package:herehear/search/search.dart';
import 'package:herehear/subscribed/subscribed.dart';
import 'package:herehear/home/HomePage.dart';
import 'package:herehear/myPage/mypage.dart';
import 'package:herehear/etc/upload.dart';
import 'package:herehear/login/signIn.dart';
import 'package:herehear/chatting/ChatPage.dart';
import 'package:herehear/subscribed/subscribed_test_connect_firebase.dart';

import 'etc/listTest.dart';
import 'theme/theme.dart';

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
          return MyApp();
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
        return GetMaterialApp(
          theme: value.isDarkTheme.value ? dark_theme : light_theme,
          debugShowCheckedModeBanner: false,
          // GetX Controller 등록
          // initialBinding: BindingsBuilder(() {}),
          initialBinding: AppBinding(),
          title: 'Flutter Basic',
          home: LandingPage(),
          getPages: [
            GetPage(
              name: '/',
              page: () => LandingPage(),
            ),
            GetPage(
              name: '/myPage',
              page: () => myPage(),
            ),
            GetPage(
              name: '/upload',
              page: () => UploadPage(),
            ),
            GetPage(
              name: '/login',
              page: () => LoginPage(),
            )
          ],
        );
      }
    );
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InfiniteScrollController());
  }
}

class LandingPageController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class LandingPage extends StatelessWidget {
  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontWeight: FontWeight.w500,
      fontSize: 12);

  final TextStyle selectedLabelStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);

  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
          height: 54,
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: landingPageController.changeTabIndex,
            currentIndex: landingPageController.tabIndex.value,
            backgroundColor: Color.fromRGBO(0, 0, 0, 1.0),
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedItemColor: Colors.white,
            unselectedLabelStyle: unselectedLabelStyle,
            selectedLabelStyle: selectedLabelStyle,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 7),
                  child: Icon(
                    Icons.home,
                    size: 20.0,
                  ),
                ),
                label: 'Home',
                backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 7),
                  child: Icon(
                    Icons.star,
                    size: 20.0,
                  ),
                ),
                label: 'Subscribed',
                backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 7),
                  child: Icon(
                    Icons.comment,
                    size: 20.0,
                  ),
                ),
                label: 'Chatting',
                backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 7),
                  child: Icon(
                    Icons.account_circle_sharp,
                    size: 20.0,
                  ),
                ),
                label: 'MyPage',
                backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
              ),
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    final LandingPageController landingPageController =
        Get.put(LandingPageController(), permanent: false);
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar:
          buildBottomNavigationMenu(context, landingPageController),
      body: Obx(() => IndexedStack(
            index: landingPageController.tabIndex.value,
            children: [
              InfiniteScrollView(),
              HomePage(),
              // SubscribedPage(),
              // searchPage(),
              Subscribed22Page(),
              // ChatPage(),
              myPage(),
            ],
          )),
    ));
  }

  Future<int> initialize() async {
    await Firebase.initializeApp();
    return 0;
  }
}
