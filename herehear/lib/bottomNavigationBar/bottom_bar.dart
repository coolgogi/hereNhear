import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/bottomNavigationBar/bottom_bar_controller.dart';
import 'package:herehear/bottomNavigationBar/search/search.dart';
import 'package:herehear/bottomNavigationBar/myPage/mypage.dart';
import 'contest/contest.dart';
import 'create_broadcast.dart';
import 'create_groupcall.dart';
import 'floating_action_button_location.dart';
import 'home/HomePage.dart';

class BottomBar extends StatelessWidget {
  late Map<String, dynamic> _data;

  BottomBar.withData(Map<String, dynamic> data) {
    _data = data;
  }

  BottomBar();

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
            // backgroundColor: Theme.of(context).colorScheme.background,
            backgroundColor: Colors.white,
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
                icon: Icon(
                  Icons.star_rate_outlined,
                ),
                activeIcon: Icon(
                  Icons.star_rate,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: '소리꾼들',
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
    final BottomBarController landingPageController =
    Get.put(BottomBarController(), permanent: false);
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar:
          buildBottomNavigationMenu(context, landingPageController),
          body: Obx(() => IndexedStack(
            index: landingPageController.tabIndex.value,
            children: [
              HomePage.withData(_data),
              ContestPage(),
              Container(),
              searchPage.withData(_data),
              myPage.withData(_data),
            ],
          )),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(
              FloatingActionButtonLocation.centerDocked, 0, 15),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Theme.of(context).colorScheme.secondary, width: 2.0.w),),
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
    print("======uid======");
    print(_data['uid']);
    print("===============");
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
                height: 35.h,),
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
                                fontSize: 18.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold)),
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
                  ),
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

