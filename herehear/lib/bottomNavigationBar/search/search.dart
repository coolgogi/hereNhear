import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/drawer/drawer.dart';
import 'package:herehear/bottomNavigationBar/search/categoryDetail.dart';
import 'package:herehear/bottomNavigationBar/search/searchBar_controller.dart';
import 'package:herehear/bottomNavigationBar/search/search_results.dart';
import 'package:herehear/broadcast/broadcast_list.dart';
import '../../broadcast/data/broadcast_model.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/drawer/drawer.dart';

class CategoryController extends GetxController {
  RxList<String> categoryList = <String>[].obs;
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class SearchPage extends StatelessWidget {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final locationController = Get.put(LocationController());
  final searchController = Get.put(SearchBarController());
  String current_uid = '';
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> liveCategoryList = [
    '고민상담',
    '수다/챗',
    '유머',
    '홍보',
    '판매',
    '힐링',
    '음악',
    '일상',
    '독서',
    'asmr'
  ];

  List<String> chatCategoryList = [
    '고민상담',
    '수다/챗',
    '유머',
    '홍보',
    '판매',
    '힐링',
    '음악',
    '일상',
  ];

  List<String> categoryImageList = [
    'assets/icons/eyes.png',
    'assets/icons/talk.png',
    'assets/icons/smile.png',
    'assets/icons/advertise.png',
    'assets/icons/healing.png',
    'assets/icons/sale.png',
    'assets/icons/music.png',
    'assets/icons/tree.png',
    'assets/icons/book.png',
    'assets/images/mike2.png',
  ];

  final categoryController = Get.put(CategoryController());
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: DrawerWidget(),
      appBar: AppBar(
        titleSpacing: 25.0.w,
        title:
            Text('SEARCH', style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: <Widget>[
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/bell.png', height: 18.0.h)),
          IconButton(
              onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
              icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
        ],
      ),
      body: ListView(
        children: <Widget>[
          searchBarWidget(context),
          Padding(
            padding: EdgeInsets.only(left: 25.0.w),
            child: Row(
              children: <Widget>[
                Text(
                  'TOP 라이브',
                  // style: Theme.of(context).textTheme.headline1,
                  style: Theme.of(context).textTheme.headline1,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.0.w),
                  child: Image.asset('assets/icons/live.png',
                      width: 43.w, height: 18.h),
                ),
                Expanded(child: Container()),
                IconButton(
                    onPressed: null, icon: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 21.0.w, top: 11.0.h),
            child: Container(
              height: 205.0.h,
              child: StreamBuilder<List<BroadcastModel>>(
                stream: MyFirebaseChatCore.instance.rooms(),
                builder: (context, snapshot) {
                  print('done!!');
                  if (!snapshot.hasData)
                    return Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ));
                  if (snapshot
                          .data!.isEmpty && //snapshot.data!.docs.length == 0
                      locationController.location.value != '')
                    return Padding(
                      padding: EdgeInsets.only(top: 50.0.h),
                      child: Container(
                        child: Text('라이브중인 방송이 없습니다.'),
                      ),
                    );
                  return broadcastRoomList(context, snapshot);
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.0.w),
                child: Text(
                  '카테고리',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Expanded(child: Container()),
              IconButton(onPressed: null, icon: Icon(Icons.arrow_forward_ios)),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.0.w, top: 19.0.h, bottom: 36.h),
            child: Column(
              children: List.generate(liveCategoryList.length, (i) {
                if (i % 2 == 0)
                  return Row(
                    children: <Widget>[
                      category_card(
                          context, liveCategoryList[i], categoryImageList[i]),
                      category_card(context, liveCategoryList[i + 1],
                          categoryImageList[i + 1]),
                    ],
                  );
                else
                  return Container();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget category_card(
      BuildContext context, String category, String categoryImage) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 16, right: 16.0.w),
          width: 156.0.w,
          height: 69.0.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: InkWell(
            onTap: () => Get.to(CategoryDetailPage(category)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10.0.w),
                  child: Image.asset(categoryImage, width: 17.h, height: 17.h),
                ),
                Text(
                  category,
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
        Obx(() => Positioned(
            top: 50.w,
            left: 133.w,
            child: InkWell(
              onTap: () {
                if (categoryController.categoryList.contains(category))
                  categoryController.categoryList.remove(category);
                else
                  categoryController.categoryList.add(category);
              },
              child: Image.asset(
                categoryController.categoryList.contains(category)
                    ? 'assets/icons/heart_blue.png'
                    : 'assets/icons/heart_stroke_blue.png',
                width: 10.h,
                height: 9.h,
              ),
            ))),
      ],
    );
  }

  Widget searchBarWidget(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 25.0.w, top: 10.h, right: 22.0.w, bottom: 20.h),
      child: GestureDetector(
        onTap: () {
          searchController.isRoomSearch.value = true;
          searchController.isLocationSearch.value = false;
          searchController.isCommunitySearch.value = false;
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

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
    locationController.getLocation().obs;
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:herehear/bottomNavigationBar/create/create_broadcast.dart';
// import 'package:herehear/appBar/searchBar.dart';
// import 'package:herehear/broadcast/broadcastList.dart';
// import 'package:herehear/groupCall/group_call.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:herehear/users/controller/user_controller.dart';
//
// class searchPage extends GetView<UserController> {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(44.0.h),
//         child: AppBar(
//           title:
//               Text('탐색', style: Theme.of(context).appBarTheme.titleTextStyle),
//           actions: <Widget>[
//             IconButton(
//               onPressed: null,
//               color: Colors.black87,
//               icon: Image.asset('assets/icons/notification.png'),
//               iconSize: 20.w,
//             ),
//             Padding(
//               padding: EdgeInsets.only(right: 8.0.w),
//               child: IconButton(
//                 icon: Image.asset('assets/icons/search.png'),
//                 iconSize: 20.w,
//                 onPressed: () {
//                   showSearch(
//                     context: context,
//                     delegate: PostSearchDelegate(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: ListView(
//         // padding: EdgeInsets.only(left: 16.0.w, top: 25.0.r),
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(left: 16.0.w, top: 25.0.r),
//             child: Row(
//               children: [
//                 Text(
//                   '전국 TOP 라이브',
//                   // style: Theme.of(context).textTheme.headline1,
//                   style: Theme.of(context).textTheme.headline2,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 3.0.w),
//                   child: Container(
//                     width: 41.w,
//                     height: 17.h,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: Theme.of(context).colorScheme.primaryVariant,
//                           width: 2.0.w),
//                       borderRadius: BorderRadius.all(Radius.circular(
//                               9.0.r) //                 <--- border radius here
//                           ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'LIVE',
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.primaryVariant,
//                           fontSize:
//                               Theme.of(context).textTheme.headline6!.fontSize,
//                           fontWeight:
//                               Theme.of(context).textTheme.headline6!.fontWeight,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(child: Container()),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 16.0.w, top: 12.0.h, bottom: 20.0.h),
//             child: Container(
//               height: 173.0.h,
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("broadcast")
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (!snapshot.hasData)
//                     return Container(
//                       child: Text('라이브중인 방송이 없습니다.'),
//                     );
//                   return ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: broadcastRoomList(context, snapshot),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 16.0.w),
//             child: Text(
//               '테마',
//               style: Theme.of(context).textTheme.headline2,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 16.0.w, top: 16.0.h, bottom: 25.0.h),
//             child: Column(
//               children: [
//                 Container(
//                   height: 27.0.h,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.only(right: 8.0.w),
//                         child: TextButton(
//                           child: Text(
//                             '일상',
//                             style: TextStyle(
//                                 fontSize: 13.13.sp,
//                                 color: Theme.of(context).colorScheme.onPrimary),
//                           ),
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                   Theme.of(context).colorScheme.primary),
//                               shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14.r),
//                                 // side: BorderSide(color: Colors.red),
//                               ))),
//                           onPressed: null,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(right: 8.0.w),
//                         child: TextButton(
//                           child: Text(
//                             '재미',
//                             style: TextStyle(
//                                 fontSize: 13.13.sp,
//                                 color: Theme.of(context).colorScheme.onPrimary),
//                           ),
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                   Theme.of(context).colorScheme.primary),
//                               shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14.r),
//                                 // side: BorderSide(color: Colors.red),
//                               ))),
//                           onPressed: null,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(right: 8.0.w),
//                         child: TextButton(
//                           child: Text(
//                             '중계',
//                             style: TextStyle(
//                                 fontSize: 13.13.sp,
//                                 color: Theme.of(context).colorScheme.onPrimary),
//                           ),
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                   Theme.of(context).colorScheme.primary),
//                               shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14.r),
//                                 // side: BorderSide(color: Colors.red),
//                               ))),
//                           onPressed: null,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(right: 8.0.w),
//                         child: TextButton(
//                           child: Text(
//                             '홍보',
//                             style: TextStyle(
//                                 fontSize: 13.13.sp,
//                                 color: Theme.of(context).colorScheme.onPrimary),
//                           ),
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                   Theme.of(context).colorScheme.primary),
//                               shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14.r),
//                                 // side: BorderSide(color: Colors.red),
//                               ))),
//                           onPressed: null,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 10.0.h),
//                   child: Container(
//                     height: 27.0.h,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Padding(
//                           padding: EdgeInsets.only(right: 8.0.w),
//                           child: TextButton(
//                             child: Text(
//                               '고민&상담',
//                               style: TextStyle(
//                                   fontSize: 13.13.sp,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary),
//                             ),
//                             style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Theme.of(context).colorScheme.primary),
//                                 shape: MaterialStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14.r),
//                                   // side: BorderSide(color: Colors.red),
//                                 ))),
//                             onPressed: null,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(right: 8.0.w),
//                           child: TextButton(
//                             child: Text(
//                               '정보',
//                               style: TextStyle(
//                                   fontSize: 13.13.sp,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary),
//                             ),
//                             style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Theme.of(context).colorScheme.primary),
//                                 shape: MaterialStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14.r),
//                                   // side: BorderSide(color: Colors.red),
//                                 ))),
//                             onPressed: null,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(right: 8.0.w),
//                           child: TextButton(
//                             child: Text(
//                               '책읽어주는 남자',
//                               style: TextStyle(
//                                   fontSize: 13.13.sp,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary),
//                             ),
//                             style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Theme.of(context).colorScheme.primary),
//                                 shape: MaterialStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14.r),
//                                   // side: BorderSide(color: Colors.red),
//                                 ))),
//                             onPressed: null,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(right: 8.0.w),
//                           child: TextButton(
//                             child: Text(
//                               'asmr',
//                               style: TextStyle(
//                                   fontSize: 13.13.sp,
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary),
//                             ),
//                             style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Theme.of(context).colorScheme.primary),
//                                 shape: MaterialStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14.r),
//                                   // side: BorderSide(color: Colors.red),
//                                 ))),
//                             onPressed: null,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 10.0.h),
//                   child: Container(
//                       height: 27.0.h,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         // scrollDirection: Axis.horizontal,
//                         children: <Widget>[
//                           Padding(
//                             padding: EdgeInsets.only(right: 8.0.w),
//                             child: TextButton(
//                               child: Text(
//                                 '산책',
//                                 style: TextStyle(
//                                     fontSize: 13.13.sp,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onPrimary),
//                               ),
//                               style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<
//                                           Color>(
//                                       Theme.of(context).colorScheme.primary),
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14.r),
//                                     // side: BorderSide(color: Colors.red),
//                                   ))),
//                               onPressed: null,
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(right: 8.0.w),
//                             child: TextButton(
//                               child: Text(
//                                 '운동',
//                                 style: TextStyle(
//                                     fontSize: 13.13.sp,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onPrimary),
//                               ),
//                               style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<
//                                           Color>(
//                                       Theme.of(context).colorScheme.primary),
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14.r),
//                                     // side: BorderSide(color: Colors.red),
//                                   ))),
//                               onPressed: null,
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(right: 8.0.w),
//                             child: TextButton(
//                               child: Text(
//                                 '여행',
//                                 style: TextStyle(
//                                     fontSize: 13.13.sp,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onPrimary),
//                               ),
//                               style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<
//                                           Color>(
//                                       Theme.of(context).colorScheme.primary),
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14.r),
//                                     // side: BorderSide(color: Colors.red),
//                                   ))),
//                               onPressed: null,
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(right: 8.0.w),
//                             child: TextButton(
//                               child: Text(
//                                 '음악',
//                                 style: TextStyle(
//                                     fontSize: 13.13.sp,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onPrimary),
//                               ),
//                               style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<
//                                           Color>(
//                                       Theme.of(context).colorScheme.primary),
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14.r),
//                                     // side: BorderSide(color: Colors.red),
//                                   ))),
//                               onPressed: null,
//                             ),
//                           ),
//                         ],
//                       )
//                       // child: ListView(
//                       //     scrollDirection: Axis.horizontal,
//                       //     children: List.generate(3, (int index) {
//                       //       return Padding(
//                       //         padding: EdgeInsets.only(right: 8.0.w),
//                       //         child: TextButton(
//                       //           child: Text(
//                       //             '카테고리 ${index + 1}',
//                       //             style: TextStyle(
//                       //                 fontSize: 13.13.sp,
//                       //                 color: Theme.of(context).colorScheme.onPrimary),
//                       //           ),
//                       //           style: ButtonStyle(
//                       //               backgroundColor: MaterialStateProperty.all<Color>(
//                       //                   Theme.of(context).colorScheme.primary),
//                       //               shape: MaterialStateProperty.all<
//                       //                   RoundedRectangleBorder>(RoundedRectangleBorder(
//                       //                 borderRadius: BorderRadius.circular(14.r),
//                       //                 // side: BorderSide(color: Colors.red),
//                       //               ))),
//                       //           onPressed: null,
//                       //         ),
//                       //       );
//                       //     })),
//                       // child: ListView(
//                       //     scrollDirection: Axis.horizontal,
//                       //     children: List.generate(3, (int index) {
//                       //       return Padding(
//                       //         padding: EdgeInsets.only(right: 8.0.w),
//                       //         child: TextButton(
//                       //           child: Text(
//                       //             '카테고리 ${index + 1}',
//                       //             style: TextStyle(
//                       //                 fontSize: 13.13.sp,
//                       //                 color: Theme.of(context).colorScheme.onPrimary),
//                       //           ),
//                       //           style: ButtonStyle(
//                       //               backgroundColor: MaterialStateProperty.all<Color>(
//                       //                   Theme.of(context).colorScheme.primary),
//                       //               shape: MaterialStateProperty.all<
//                       //                   RoundedRectangleBorder>(RoundedRectangleBorder(
//                       //                 borderRadius: BorderRadius.circular(14.r),
//                       //                 // side: BorderSide(color: Colors.red),
//                       //               ))),
//                       //           onPressed: null,
//                       //         ),
//                       //       );
//                       //     })),
//                       ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 10.0.h),
//                   child: Container(
//                       height: 27.0.h,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         // scrollDirection: Axis.horizontal,
//                         children: <Widget>[
//                           Padding(
//                             padding: EdgeInsets.only(right: 8.0.w),
//                             child: TextButton(
//                               child: Text(
//                                 '먹방 사운드',
//                                 style: TextStyle(
//                                     fontSize: 13.13.sp,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onPrimary),
//                               ),
//                               style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<
//                                           Color>(
//                                       Theme.of(context).colorScheme.primary),
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14.r),
//                                     // side: BorderSide(color: Colors.red),
//                                   ))),
//                               onPressed: null,
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(right: 8.0.w),
//                             child: TextButton(
//                               child: Text(
//                                 '악기',
//                                 style: TextStyle(
//                                     fontSize: 13.13.sp,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onPrimary),
//                               ),
//                               style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<
//                                           Color>(
//                                       Theme.of(context).colorScheme.primary),
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14.r),
//                                     // side: BorderSide(color: Colors.red),
//                                   ))),
//                               onPressed: null,
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(right: 8.0.w),
//                             child: TextButton(
//                               child: Text(
//                                 '노래',
//                                 style: TextStyle(
//                                     fontSize: 13.13.sp,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onPrimary),
//                               ),
//                               style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<
//                                           Color>(
//                                       Theme.of(context).colorScheme.primary),
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14.r),
//                                     // side: BorderSide(color: Colors.red),
//                                   ))),
//                               onPressed: null,
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(right: 8.0.w),
//                             child: TextButton(
//                               child: Text(
//                                 '라디오',
//                                 style: TextStyle(
//                                     fontSize: 13.13.sp,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onPrimary),
//                               ),
//                               style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<
//                                           Color>(
//                                       Theme.of(context).colorScheme.primary),
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14.r),
//                                     // side: BorderSide(color: Colors.red),
//                                   ))),
//                               onPressed: null,
//                             ),
//                           ),
//                         ],
//                       )),
//                 ),
//               ],
//             ),
//           ),
//           //     Padding(
//           //       padding: EdgeInsets.only(left: 16.0.w),
//           //       child: Text(
//           //         '카테고리 ',
//           //         style: Theme.of(context).textTheme.headline2,
//           //       ),
//           //     ),
//           //     Padding(
//           //       padding: EdgeInsets.only(top: 5.0.h),
//           //       child: StreamBuilder<QuerySnapshot>(
//           //           stream: FirebaseFirestore.instance
//           //               .collection("groupcall")
//           //               .snapshots(),
//           //           builder: (BuildContext context,
//           //               AsyncSnapshot<QuerySnapshot> snapshot) {
//           //             if (!snapshot.hasData)
//           //               return Container(
//           //                 child: Center(child: Text('생성된 대화방이 없습니다.')),
//           //               );
//           //             return Column(
//           //               children: groupcallRoomList(context, snapshot),
//           //             );
//           //           }),
//           //     ),
//         ],
//       ),
//       // floatingActionButtonLocation:
//       // FloatingActionButtonLocation.miniCenterFloat,
//       // floatingActionButton: FloatingActionButton.extended(
//       //   onPressed: null, //사용자 위치 기반으로 데이터 다시 불러오기 및 새로고침
//       //   label: Text(
//       //     '새로 고침',
//       //     style: TextStyle(
//       //       color: Colors.black87,
//       //     ),
//       //   ),
//       //   backgroundColor: Colors.white,
//       // ),
//     );
//   }
//
//   // Future<void> _showMyDialog() async {
//   //   return Get.defaultDialog(
//   //     title: '소리 시작하기',
//   //     content: SingleChildScrollView(
//   //       child: Column(
//   //         children: <Widget>[
//   //           TextButton(
//   //             child: Text(
//   //               '개인 라이브',
//   //               style: TextStyle(fontSize: 18.sp, color: Colors.black87),
//   //             ),
//   //             onPressed: () => Get.off(() => CreateBroadcastPage()),
//   //           ),
//   //           TextButton(
//   //             child: Text(
//   //               '그룹 대화',
//   //               style: TextStyle(fontSize: 18.sp, color: Colors.black87),
//   //             ),
//   //             onPressed: () => Get.off(() => CreateGroupCallPage()),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Route _createRoute() {
//     return PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) =>
//           CreateBroadcastPage(),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         var begin = Offset(0.0, 1.0);
//         var end = Offset.zero;
//         var curve = Curves.ease;
//
//         var tween =
//             Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//         return SlideTransition(
//           position: animation.drive(tween),
//           child: child,
//         );
//       },
//     );
//   }
//
//   List<Widget> groupcallRoomList(
//       BuildContext context, AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
//     return broadcastSnapshot.data!.docs.map((room) {
//       return Column(
//         children: [
//           Divider(thickness: 2),
//           Container(
//             // width: MediaQuery.of(context).size.width,
//             height: 80.0.h,
//             child: InkWell(
//               onTap: () {
//                 Get.to(() => GroupCallPage(room['title']),
//                     arguments: room['channelName']);
//               },
//               child: Row(
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(left: 16.0.w, right: 8.0.w),
//                     child: Container(
//                       // margin: EdgeInsets.all(0.0.w),
//                       width: 70.0.h,
//                       height: 70.0.h,
//                       child: SizedBox(
//                         child: Image.asset(room['image']),
//                       ),
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         room['title'],
//                         style: Theme.of(context).textTheme.headline6,
//                       ),
//                       SizedBox(
//                         height: 5.h,
//                       ),
//                       Text(
//                         room['notice'],
//                         style: Theme.of(context).textTheme.subtitle1,
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     }).toList();
//   }
// }
