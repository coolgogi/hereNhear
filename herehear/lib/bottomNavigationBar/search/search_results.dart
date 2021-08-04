import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/searchBar.dart';
import 'package:herehear/bottomNavigationBar/search/searchfield_widget.dart';

import 'package:herehear/broadcast/broadcastList.dart';
import 'package:herehear/etc/delete/contest/contest.dart';
import 'package:herehear/groupCall/groupcallList.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/users/controller/user_controller.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';


FirebaseFirestore firestore = FirebaseFirestore.instance;

class SearchResultsPage extends StatefulWidget {
  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  FocusNode? searchBarFocusNode;
  final _textController = TextEditingController();
  final locationController = Get.put(LocationController());

  String current_uid = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchBarFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // 폼이 삭제되면 myFocusNode도 삭제됨
    searchBarFocusNode!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25.0.w,
        centerTitle: true,
        title: Text('HEAR 검색', style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: <Widget>[
          IconButton(onPressed: null, icon: Image.asset('assets/icons/bell.png', height: 17.0.h)),
          IconButton(onPressed: null, icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
        ],
      ),
      body: ListView(
        children: <Widget>[
          // TextField(
          //   controller: _textController,
          //   focusNode: searchBarFocusNode,
          //   keyboardType: TextInputType.text,
          //   onChanged: (text){
          //     // _streamSearch.add(text);
          //   },
          //   decoration: InputDecoration(
          //       hintText: '검색어를 입력하세요',
          //       border: InputBorder.none,
          //       filled: true,
          //       fillColor: Color(0xFFE9E9E9),
          //       suffixIcon: Icon(Icons.search),
          //   ),
          // ),
          SearchTextField(_textController, searchBarFocusNode),
      Padding(
        padding: EdgeInsets.only(left: 25.0.w),
        child: Row(
          children: <Widget>[
            Text(
              'TOP 라이브 ',
              // style: Theme.of(context).textTheme.headline1,
              style: Theme.of(context).textTheme.headline1,
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.0.w),
              child: Container(
                width: 43.w,
                height: 18.h,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryVariant,
                      width: 2.0.w),
                  borderRadius: BorderRadius.all(Radius.circular(9.0
                      .r) //                 <--- border radius here
                  ),
                ),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        '   ● ',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryVariant,
                          fontSize: 5.0.sp,
                          fontWeight: Theme.of(context)
                              .textTheme
                              .headline6!
                              .fontWeight,
                        ),
                      ),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryVariant,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headline6!
                              .fontSize,
                          fontWeight: Theme.of(context)
                              .textTheme
                              .headline6!
                              .fontWeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            IconButton(
                onPressed: null,
                icon: Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: 21.0.w, top: 11.0.h),
        child: Container(
          height: 195.0.h,
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection("broadcast")
            // .where('location',
            // isEqualTo: locationController.location.value)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              print('done!!');
              if (!snapshot.hasData)
                return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ));
              if (snapshot.data!.docs.length == 0 &&
                  locationController.location.value != '')
                return Padding(
                  padding: EdgeInsets.only(top: 50.0.h),
                  child: Container(
                    child: Text('라이브중인 방송이 없습니다.'),
                  ),
                );
              return ListView(
                scrollDirection: Axis.horizontal,
                children: broadcastRoomList(
                    context, snapshot),
              );
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
          IconButton(
              onPressed: null,
              icon: Icon(Icons.arrow_forward_ios)),
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
            bottomRight: Radius.circular(15)
        ),
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

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
    locationController.getLocation().obs;
  }
}
