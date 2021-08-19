import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/community/free_board/record_test.dart';
import 'package:herehear/bottomNavigationBar/community/playground/selectedSong.dart';
import 'package:herehear/bottomNavigationBar/search/searchBar_controller.dart';
import 'package:herehear/bottomNavigationBar/search/search_results.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


FirebaseFirestore firestore = FirebaseFirestore.instance;


class KaraokePage extends StatelessWidget {
  final searchController = Get.put(SearchBarController());
  TextEditingController comment = TextEditingController();

  List<String> nickNameList = [
    '노래쟁이',
    '음악대장',
    '노이즈 메이커'
  ];
  List<String> profileList = [
    'assets/images/she2.jpeg',
    'assets/images/me.jpg',
    'assets/images/it.jpg'
  ];
  List<int> scoreList = [
    100, 99, 97
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text('노래방',
            style: Theme
                .of(context)
                .appBarTheme
                .titleTextStyle!
                .copyWith(
              fontWeight: FontWeight.w700,
            )),
        actions: <Widget>[
          IconButton(
              onPressed: () => Get.to(recordingPage()),
              icon: Image.asset('assets/icons/bell.png', height: 17.0.h)),
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 25.0.h, top: 20.h, right: 25.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('당신의 실력을 맘껏 뽐내보세요.', style: Theme
                        .of(context)
                        .textTheme
                        .headline2!
                        .copyWith(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primaryVariant,
                    )),
                    SizedBox(width: 7.w),
                    Image.asset('assets/images/mike.png', width: 13.0.h),
                  ],
                ),
                searchBarWidget(context),
                Padding(
                  padding: EdgeInsets.only(top: 25.h, bottom: 10.h),
                  child: Row(
                    children: [
                      Text('실시간', style: Theme.of(context).textTheme.headline1),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () => Get.to(SelectedSong()),
                          icon: Icon(Icons.arrow_forward_ios, size: 17.h)),
                    ],
                  ),
                ),
                Column(
                  children: realtimeNewList(context),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.h, bottom: 10.h),
                  child: Row(
                    children: [
                      Text('전체 랭킹', style: Theme.of(context).textTheme.headline1),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: null,
                          icon: Icon(Icons.arrow_forward_ios, size: 17.h)),
                    ],
                  ),
                ),
                Column(
                  children: rankingList(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 28.0.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25.h, right: 25.w, bottom: 10.h),
                  child: Row(
                    children: [
                      Text('나의 18번 곡', style: Theme.of(context).textTheme.headline1),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: null,
                          icon: Icon(Icons.arrow_forward_ios, size: 17.h)),
                    ],
                  ),
                ),
                Container(
                  height: 131.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                        5,
                            (index) => Padding(
                              padding: EdgeInsets.only(left: 9.0.w),
                              child: Container(
                                width: 129.h,
                                height: 131.h,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 28.0.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25.h, right: 25.w, bottom: 10.h),
                  child: Row(
                    children: [
                      Text('최근 부른 곡', style: Theme.of(context).textTheme.headline1),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: null,
                          icon: Icon(Icons.arrow_forward_ios, size: 17.h)),
                    ],
                  ),
                ),
                Container(
                  height: 131.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                        5,
                            (index) => Padding(
                              padding: EdgeInsets.only(left: 9.0.w),
                              child: Container(
                          width: 129.h,
                          height: 131.h,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                            )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 28.0.w, bottom: 20.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25.h, right: 25.w, bottom: 10.h),
                  child: Row(
                    children: [
                      Text('추천곡', style: Theme.of(context).textTheme.headline1),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: null,
                          icon: Icon(Icons.arrow_forward_ios, size: 17.h)),
                    ],
                  ),
                ),
                Container(
                  height: 131.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                        5,
                            (index) => Padding(
                              padding: EdgeInsets.only(left: 9.0.w),
                              child: Container(
                          width: 129.h,
                          height: 131.h,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                            )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBarWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 10.h,
      ),
      child: GestureDetector(
        onTap: () {
          searchController.isRoomSearch.value = false;
          searchController.isLocationSearch.value = false;
          searchController.isCommunitySearch.value = true;
          searchController.isHistorySearch.value = false;
          searchController.initialSearchText();
          Get.to(SearchResultsPage(), duration: Duration.zero);
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
                Padding(
                  padding: EdgeInsets.only(left: 12.0.w),
                  child: Text('노래 검색', style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface
                  )),
                ),
                Expanded(child: Container()),
                Image.asset('assets/icons/search.png', width: 20.w,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> realtimeNewList(BuildContext context) {
    return List.generate(
        nickNameList.length,
            (i) => Padding(
              padding: EdgeInsets.only(bottom: 6.0.h),
              child: Container(
                width: 323.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.all(Radius.circular(7.r)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 11.0.w, right: 5.w),
                      child: Container(
                        height: 19.h,
                        width: 19.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(profileList[i]),
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                    ),
                    Text(nickNameList[i], style: Theme.of(context).textTheme.headline5),
                    Expanded(child: Container()),
                    Text('${scoreList[i].toString()}점', style: Theme.of(context).textTheme.headline5),
                    SizedBox(width: 13.w,)
                  ],
                ),
              ),
            )
    );
  }

  List<Widget> rankingList(BuildContext context) {
    String crown = '';
    return List.generate(
        nickNameList.length,
            (i) {
              if(i == 0) crown = 'assets/icons/crown_gold.png';
              if(i == 1) crown = 'assets/icons/crown_silver.png';
              if(i == 2) crown = 'assets/icons/crown_bronze.png';
              return Padding(
                padding: EdgeInsets.only(bottom: 6.0.h),
                child: Container(
                  width: 323.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(7.r)),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0.w),
                        child: Container(
                          child: Image.asset(crown, width: 27.w, height: 20.h),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 11.0.w, right: 5.w),
                        child: Container(
                          height: 19.h,
                          width: 19.h,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(profileList[i]),
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                      ),
                      Text(nickNameList[i], style: Theme.of(context).textTheme.headline5),
                      Expanded(child: Container()),
                      Text('${scoreList[i].toString()}점', style: Theme.of(context).textTheme.headline5),
                      SizedBox(width: 13.w,)
                    ],
                  ),
                ),
              );
            }
    );
  }
}
