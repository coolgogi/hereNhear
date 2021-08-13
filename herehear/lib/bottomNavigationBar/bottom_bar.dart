import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/bottomNavigationBar/bottom_bar_controller.dart';
import 'package:herehear/bottomNavigationBar/search/search.dart';
import 'package:herehear/bottomNavigationBar/myPage/mypage.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'community/community.dart';
import 'create/create_broadcast.dart';
import 'create/create_groupcall.dart';
import 'floating_action_button_location.dart';
import 'home/home.dart';

class BottomBar extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final BottomBarController bottomBarController =
        Get.put(BottomBarController(), permanent: false);
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar:
          buildBottomNavigationMenu(context, bottomBarController),
          body: Obx(() => IndexedStack(
            index: bottomBarController.tabIndex.value,
            children: [
              HomePage(),
              SearchPage(),
              Container(),
              CommunityPage(),
              MyPage(),
            ],
          )),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(
              FloatingActionButtonLocation.centerDocked, 0, 15),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 0.0,
              child: Image.asset(
                'assets/icons/add.png',
                width: 23.0.w,
              ),
              onPressed: () => {
                print(
                    '*******************************************************************************8'),
                print(userController.myProfile.value.uid),
                print(
                    '*******************************************************************************8'),
                userController.myProfile.value.uid == 'Guest'
                    ? _showMyDialog()
                    : showCreateOption(context),
              }),
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

  // Future<void> _showMyDialog2() async {
  //   return Get.defaultDialog(
  //     title: '정보를 불러오고 있습니다!',
  //     content: SingleChildScrollView(
  //       child: Column(
  //         children: <Widget>[
  //           TextButton(
  //               child: Text(
  //                 '확인',
  //                 style: TextStyle(fontSize: 18.sp, color: Colors.black87),
  //               ),
  //               onPressed: () => Get.back()),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<dynamic> showCreateOption(BuildContext context) async {
    return Get.dialog(
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 17.0.w, bottom: 10.h),
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, size: 25.w, color: Colors.white,)
                    )
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 14.0.w),
                  child: GestureDetector(
                    onTap: () => Get.off(() => CreateBroadcastPage()),
                    child: Container(
                      width: 161.w,
                      height: 177.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 18.0.h),
                            child: Text('HERE 라이브',
                                style: Theme.of(context).textTheme.headline4),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 11.0.h),
                            child: Text('HERE 라이브를 통해',
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          Text('원하는 주제로 대화해보세요!',
                              style: Theme.of(context).textTheme.headline6),
                          Padding(
                            padding: EdgeInsets.only(top: 13.h),
                            child: Image.asset('assets/images/streamer.png',
                                height: 75.h),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.off(() => CreateGroupCallPage()),
                  child: Container(
                    width: 161.w,
                    height: 177.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 18.0.h),
                          child: Text('HERE CHAT',
                              style: Theme.of(context).textTheme.headline4),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 11.0.h),
                          child: Text('사람들과 자유로운 대화를',
                              style: Theme.of(context).textTheme.headline6),
                        ),
                        Text('즐겨보세요!',
                            style: Theme.of(context).textTheme.headline6),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/voiceCopy.png',
                                height: 62.h,
                              ),
                              Image.asset('assets/images/liveImage.png',
                                height: 65.h,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 13.h)
          ],
        ),
      ),
    );
  }

  // Future<dynamic> showCreateOption(BuildContext context) async {
  //   return showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             SizedBox(
  //               height: 35.h,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: <Widget>[
  //                 InkWell(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       Icon(
  //                         Icons.record_voice_over,
  //                         size: 50.w,
  //                         color: Theme.of(context).colorScheme.primary,
  //                       ),
  //                       SizedBox(
  //                         height: 20.h,
  //                       ),
  //                       // podcasts
  //                       Text('개인 라이브',
  //                           style: TextStyle(
  //                               fontSize: 18.sp,
  //                               color: Colors.black87,
  //                               fontWeight: FontWeight.bold)),
  //                     ],
  //                   ),
  //                   onTap: () => Get.off(() => CreateBroadcastPage()),
  //                 ),
  //                 InkWell(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       Icon(
  //                         Icons.connect_without_contact,
  //                         size: 50.w,
  //                         color: Theme.of(context).colorScheme.primary,
  //                       ),
  //                       SizedBox(
  //                         height: 20.h,
  //                       ),
  //                       Text('그룹 대화',
  //                           style: TextStyle(
  //                               fontSize: 18.sp,
  //                               color: Colors.black87,
  //                               fontWeight: FontWeight.bold)),
  //                     ],
  //                   ),
  //                   onTap: () => Get.off(() => CreateGroupCallPage()),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(
  //               height: 35.h,
  //             ),
  //           ],
  //         );
  //       });
  // }

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
            selectedItemColor: Theme.of(context).colorScheme.onSurface,
            unselectedLabelStyle: unselectedLabelStyle,
            selectedLabelStyle: selectedLabelStyle,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/home_stroke.png',
                    width: 20.w, height: 20.w),
                activeIcon: Image.asset('assets/icons/home_active.png',
                    width: 20.w, height: 20.w),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/search_stroke.png',
                    width: 20.w, height: 20.w),
                activeIcon: Image.asset('assets/icons/search_active.png',
                    width: 20.w, height: 20.w),
                label: 'SEARCH',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  size: 5,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/people_stroke.png',
                    width: 20.w, height: 20.w),
                activeIcon: Image.asset('assets/icons/people_active.png',
                    width: 20.w, height: 20.w),
                label: 'COMMUNITY',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/profile_stroke.png',
                    width: 20.w, height: 20.w),
                activeIcon: Image.asset('assets/icons/profile_active.png',
                    width: 20.w, height: 20.w),
                label: 'MY PAGE',
              ),
            ],
          ),
        )));
  }
}
