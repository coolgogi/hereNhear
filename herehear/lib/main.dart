import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/chatting/chatList.dart';
import 'package:herehear/location_data/location.dart';
import 'package:herehear/search/search.dart';
import 'package:herehear/subscribed/subscribed.dart';
import 'package:herehear/home/HomePage.dart';
import 'package:herehear/myPage/mypage.dart';
import 'package:herehear/etc/upload.dart';
import 'package:herehear/login/signIn.dart';
import 'package:herehear/chatting/ChatPage.dart';
import 'package:herehear/test_folder/subscribed_test_connect_firebase.dart';
import 'appBar/create_broadcast.dart';
import 'appBar/create_groupcall.dart';
import 'etc/listTest.dart';
import 'test_folder/HomePage2.dart';
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
                    future: LocationController().getLocation(),
                    builder: (context, snapshot) {
                      return MyApp();
                    }
                );
              }
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
            builder: () =>
                GetMaterialApp(
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
                      page: () => HomePage(),
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
                ),
          );
        });
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
      fontWeight: FontWeight.w700,
      fontSize: 12);

  final TextStyle selectedLabelStyle =
  TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12);

  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() =>
        MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: SizedBox(
              height: 54,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                showSelectedLabels: true,
                onTap: landingPageController.changeTabIndex,
                currentIndex: landingPageController.tabIndex.value,
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .background,
                unselectedItemColor: Color(0xFFB8B8B8),
                selectedItemColor: Theme
                    .of(context)
                    .colorScheme
                    .primaryVariant,
                unselectedLabelStyle: unselectedLabelStyle,
                selectedLabelStyle: selectedLabelStyle,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/home_stroke.png',
                        width: 20.w, height: 20.w),
                    activeIcon: Image.asset('assets/icons/home_active.png',
                        width: 20.w, height: 20.w),
                    label: '홈',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/favorite_stroke.png',
                        width: 20.w, height: 20.w),
                    activeIcon: Image.asset('assets/icons/favorite_active.png',
                        width: 20.w, height: 20.w),
                    label: '구독',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add,
                      size: 5,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/search_stroke.png',
                        width: 20.w, height: 20.w),
                    activeIcon: Image.asset('assets/icons/search_active.png',
                        width: 20.w, height: 20.w),
                    label: '탐색',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/profile_stroke.png',
                        width: 20.w, height: 20.w),
                    activeIcon: Image.asset('assets/icons/profile_active.png',
                        width: 20.w, height: 20.w),
                    label: '마이 페이지',
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
          body: Obx(() =>
              IndexedStack(
                index: landingPageController.tabIndex.value,
                children: [
                  // InfiniteScrollView(),
                  HomePage(),
                  SubscribedPage(),
                  // Subscribed22Page(),
                  ChatPage(),
                  searchPage(),
                  // ChatPage(),
                  myPage(),
                ],
              )),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(
              FloatingActionButtonLocation.centerDocked, 0, 15),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary, width: 2.0.w),
            ),
            child: FloatingActionButton(
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              elevation: 0.0,
              shape:
              CircleBorder(side: BorderSide(color: Colors.white, width: 2.5.w)),
              child: Icon(Icons.add),
              onPressed: () => showCreateOption(context),
            ),
          ),
        ));
  }

  Future<void> _showMyDialog() async {
    return Get.defaultDialog(
      title: '소리 시작하기',
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextButton(
              child: Text(
                '개인 라이브',
                style: TextStyle(fontSize: 18.sp, color: Colors.black87),
              ),
              onPressed: () => Get.off(() => CreateBroadcastPage()),
            ),
            TextButton(
              child: Text(
                '그룹 대화',
                style: TextStyle(fontSize: 18.sp, color: Colors.black87),
              ),
              onPressed: () => Get.off(() => CreateGroupCallPage()),
            ),
          ],
        ),
      ),
    );
  }

  Future<int> initialize() async {
    await Firebase.initializeApp();
    return 0;
  }

  Future<dynamic> showCreateOption(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 35.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.record_voice_over, size: 50.w, color: Theme
                            .of(context)
                            .colorScheme
                            .primary,),
                        SizedBox(height: 20.h,),
                        // podcasts
                        Text('개인 라이브', style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onTap: () => Get.off(() => CreateBroadcastPage()),
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.connect_without_contact, size: 50.w,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,),
                        SizedBox(height: 20.h,),
                        Text('그룹 대화', style: TextStyle(fontSize: 18.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onTap: () => Get.off(() => CreateGroupCallPage()),
                  )
                ],
              ),
              SizedBox(height: 35.h,),
            ],
          );
        });
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // Offset in X direction
  double offsetY; // Offset in Y direction
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
