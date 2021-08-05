import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/searchBar.dart';
import 'package:herehear/bottomNavigationBar/search/search_results.dart';
import 'package:herehear/broadcast/broadcast_list.dart';
import 'package:herehear/broadcast/broadcast_model.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';

import 'package:herehear/groupCall/groupcallList.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:search_widget/search_widget.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class SearchPage extends StatelessWidget {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final locationController = Get.put(LocationController());
  String current_uid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25.0.w,
        title:
            Text('SEARCH', style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: <Widget>[
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/bell.png', height: 17.0.h)),
          IconButton(
              onPressed: null,
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
                  // padding: EdgeInsets.only(left: 3.0.w),
                  // child: Container(
                  //   width: 43.w,
                  //   height: 18.h,
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //         color: Theme.of(context).colorScheme.secondaryVariant,
                  //         width: 2.0.w),
                  //     borderRadius: BorderRadius.all(Radius.circular(
                  //             9.0.r) //                 <--- border radius here
                  //         ),
                  //   ),
                  //   child: Center(
                  //     child: Row(
                  //       children: [
                  //         Text(
                  //           '   ● ',
                  //           style: TextStyle(
                  //             color: Theme.of(context)
                  //                 .colorScheme
                  //                 .secondaryVariant,
                  //             fontSize: 5.0.sp,
                  //             fontWeight: Theme.of(context)
                  //                 .textTheme
                  //                 .headline6!
                  //                 .fontWeight,
                  //           ),
                  //         ),
                  //         Text(
                  //           'LIVE',
                  //           style: TextStyle(
                  //             color: Theme.of(context)
                  //                 .colorScheme
                  //                 .secondaryVariant,
                  //             fontSize: Theme.of(context)
                  //                 .textTheme
                  //                 .headline6!
                  //                 .fontSize,
                  //             fontWeight: Theme.of(context)
                  //                 .textTheme
                  //                 .headline6!
                  //                 .fontWeight,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  padding: EdgeInsets.only(left: 5.0.w),
                  child: Image.asset('assets/icons/live.png',
                      width: 43.w, height: 18.h),
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 3.0.w),
                //   child: Container(
                //     width: 43.w,
                //     height: 18.h,
                //     decoration: BoxDecoration(
                //       border: Border.all(
                //           color: Theme.of(context)
                //               .colorScheme
                //               .secondaryVariant,
                //           width: 2.0.w),
                //       borderRadius: BorderRadius.all(Radius.circular(9.0
                //           .r) //                 <--- border radius here
                //       ),
                //     ),
                //     child: Center(
                //       child: Row(
                //         children: [
                //           Text(
                //             '   ● ',
                //             style: TextStyle(
                //               color: Theme.of(context)
                //                   .colorScheme
                //                   .secondaryVariant,
                //               fontSize: 5.0.sp,
                //               fontWeight: Theme.of(context)
                //                   .textTheme
                //                   .headline6!
                //                   .fontWeight,
                //             ),
                //           ),
                //           Text(
                //             'LIVE',
                //             style: TextStyle(
                //               color: Theme.of(context)
                //                   .colorScheme
                //                   .secondaryVariant,
                //               fontSize: Theme.of(context)
                //                   .textTheme
                //                   .headline6!
                //                   .fontSize,
                //               fontWeight: Theme.of(context)
                //                   .textTheme
                //                   .headline6!
                //                   .fontWeight,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Expanded(child: Container()),
                IconButton(
                    onPressed: null, icon: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 21.0.w, top: 11.0.h),
            child: Container(
              height: 195.0.h,
              child: StreamBuilder<List<BroadcastModel>>(
                stream: MyFirebaseChatCore.instance.rooms(),
                builder: (context,snapshot) {
                  print('done!!');
                  if (!snapshot.hasData)
                    return Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ));
                  if (snapshot.data!
                      .isEmpty && //snapshot.data!.docs.length == 0
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
            padding: EdgeInsets.only(left: 24.0.w, top: 19.0.h),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    category_card(context),
                    category_card(context),
                  ],
                ),
                Row(
                  children: <Widget>[
                    category_card(context),
                    category_card(context),
                  ],
                ),
                Row(
                  children: <Widget>[
                    category_card(context),
                    category_card(context),
                  ],
                ),
                Row(
                  children: <Widget>[
                    category_card(context),
                    category_card(context),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget category_card(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, right: 16.0.w),
      width: 156.0.w,
      height: 69.0.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)),
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
        onTap: null,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 13.0.w, right: 20.0.w),
              child: Container(
                // margin: EdgeInsets.all(0.0.w),
                width: 41.0.w,
                height: 41.0.h,
                // child: SizedBox(child: Image.asset(_roomData['image'])),
                child: Container(
                    decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/group.png'),
                  ),
                )),
              ),
            ),
            Text(
              '#친목도모',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBarWidget(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 25.0.w, top: 10.h, right: 22.0.w, bottom: 20.h),
      child: GestureDetector(
        onTap: (() => Get.to(SearchResultsPage(), duration: Duration.zero)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
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
