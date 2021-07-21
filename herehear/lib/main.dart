import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/notification.dart';
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
import 'contest/contest.dart';
import 'etc/invite.dart';
import 'etc/listTest.dart';
import 'test_folder/HomePage2.dart';
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
              initialBinding: AppBinding(),
              title: 'Here & Hear',
              home:  InvitationPage(),
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
                  name: '/upload',
                  page: () => UploadPage(),
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
  late Map<String, dynamic> _data;

  LandingPage.withData(Map<String, dynamic> data) {
    _data = data;
  }

  LandingPage();

  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontWeight: FontWeight.w700,
      fontSize: 12);

  final TextStyle selectedLabelStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12);

  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
          height: 54,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: landingPageController.changeTabIndex,
            currentIndex: landingPageController.tabIndex.value,
            backgroundColor: Theme.of(context).colorScheme.background,
            unselectedItemColor: Color(0xFFB8B8B8),
            selectedItemColor: Theme.of(context).colorScheme.primaryVariant,
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
      body: Obx(() => IndexedStack(
            index: landingPageController.tabIndex.value,
            children: [
              // InfiniteScrollView(),
              // Subscribed22Page(),
              HomePage.withData(_data),
              ContestPage(),
              searchPage.withData(_data),
              // SubscribedPage.withData(_data),
              ChatPage(),
              searchPage(),
              // ChatPage(),
              myPage.withData(_data),
            ],
          )),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.centerDocked, 0, 15),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 2.0.w),
        ),
        child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            elevation: 0.0,
            shape: CircleBorder(
                side: BorderSide(color: Colors.white, width: 2.5.w)),
            child: Image.asset(
              'assets/icons/mic_fill.png',
              height: 32.h,
            ),
            onPressed: () => {
                  _data['uid'] == null
                      ? _showMyDialog2()
                      : _data['uid'] != 'guest'
                          ? showCreateOption(context)
                          : _showMyDialog(),
                }),
      ),
    ));
  }

  Future<void> _showMyDialog() async {
    return Get.defaultDialog(
      title: '로그인이 필요합니다!',
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextButton(
                child: Text(
                  '확인',
                  style: TextStyle(fontSize: 18.sp, color: Colors.black87),
                ),
                onPressed: () => Get.back()),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog2() async {
    return Get.defaultDialog(
      title: '정보를 불러오고 있습니다!',
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextButton(
                child: Text(
                  '확인',
                  style: TextStyle(fontSize: 18.sp, color: Colors.black87),
                ),
                onPressed: () => Get.back()),
          ],
        ),
      ),
    );
  }

  Future<int> initialize() async {
    await Firebase.initializeApp();
    return 0;
  }

  Future<dynamic> showCreateOption(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 35.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.record_voice_over,
                          size: 50.w,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        // podcasts
                        Text('개인 라이브',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onTap: () =>
                        Get.off(() => CreateBroadcastPage.withData(_data)),
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.connect_without_contact,
                          size: 50.w,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text('그룹 대화',
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onTap: () => Get.off(() => CreateGroupCallPage()),
                  )
                ],
              ),
              SizedBox(
                height: 35.h,
              ),
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
