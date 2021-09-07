import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'QnA.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: EdgeInsets.only(top: 70.h, right: 15.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15.w, 0.0.h, 17.w, 30.h),
                child: Image.asset('assets/images/logo.png', width: 600.w),
              ),
              searchBarWidget(context),
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 0.h, 25.w, 15.0.h),
                child: InkWell(
                  onTap: null,
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left, size: 25.w, color: Theme.of(context).colorScheme.onSurface),
                      Expanded(child: Container()),
                      Text('내 정보', style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black,
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 0.h, 25.w, 15.0.h),
                child: InkWell(
                  onTap: null,
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left, size: 25.w, color: Theme.of(context).colorScheme.onSurface),
                      Expanded(child: Container()),
                      Text('개인정보 처리방침', style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black,
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 0.h, 25.w, 15.0.h),
                child: InkWell(
                  onTap: null,
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left, size: 25.w, color: Theme.of(context).colorScheme.onSurface),
                      Expanded(child: Container()),
                      Text('이용약관', style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black,
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 0.h, 25.w, 15.0.h),
                child: InkWell(
                  onTap: null,
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left, size: 25.w, color: Theme.of(context).colorScheme.onSurface),
                      Expanded(child: Container()),
                      Text('앱 정보', style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black,
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 0.h, 25.w, 15.0.h),
                child: InkWell(
                  onTap: null,
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left, size: 25.w, color: Theme.of(context).colorScheme.onSurface),
                      Expanded(child: Container()),
                      Text('오픈소스 라이선스', style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black,
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 0.h, 25.w, 15.0.h),
                child: InkWell(
                  onTap: null,
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left, size: 25.w, color: Theme.of(context).colorScheme.onSurface),
                      Expanded(child: Container()),
                      Text('FAQ', style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black,
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 0.h, 25.w, 15.0.h),
                child: InkWell(
                  onTap: () => Get.to(QnAPage()),
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left, size: 25.w, color: Theme.of(context).colorScheme.onSurface),
                      Expanded(child: Container()),
                      Text('문의하기', style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black,
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 130.0.w, top: 15.h, right: 25.w),
                child: Divider(thickness: 1.w),
              ),
              InkWell(
                onTap: () => FirebaseAuth.instance.signOut(),
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h, right: 25.0.w),
                  child: Text('로그아웃', style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBarWidget(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(left: 25.0.w, top: 0.h, right: 22.0.w, bottom: 30.h),
      child: GestureDetector(
        onTap: () {
          // searchController.isRoomSearch.value = true;
          // searchController.isLocationSearch.value = false;
          // searchController.isCommunitySearch.value = false;
          // searchController.isHistorySearch.value = false;
          // searchController.initialSearchText();
          // Get.to(SearchResultsPage(), duration: Duration.zero);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color(0xFFE9E9E9),
          ),
          height: 33.0.h,
          child: Padding(
            padding: EdgeInsets.only(right: 13.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image.asset(
                  'assets/icons/search.png',
                  width: 20.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
