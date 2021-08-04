import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/searchBar.dart';
import 'package:herehear/bottomNavigationBar/search/searchBar_controller.dart';
import 'package:herehear/bottomNavigationBar/search/search_history_model.dart';
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
  final searchController = Get.put(SearchBarController());
  final locationController = Get.put(LocationController());

  String current_uid = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // 폼이 삭제되면 myFocusNode도 삭제됨
    searchController.searchBarFocusNode.value.dispose();
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
          SearchTextField(),
          Obx(() {
            if(searchController.text.value.isEmpty) {
              print('searchController.textController.value!!!!!!!!!!!!!! : ${searchController.textController.value.text}');
              return searchHistory();
            }
            else {
              print('searchController.textController.value??????????????? : ${searchController.textController.value.text}');
              return Container(child: Center(child: Text('SomeThing..!!')));
            }
          })
      ],
    ),
    );
  }

  Widget searchHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 25.0.w, right: 13.0.w),
          child: Row(
            children: <Widget>[
              Text(
                '최근 본 HEAR',
                // style: Theme.of(context).textTheme.headline1,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Expanded(child: Container()),
              IconButton(
                  onPressed: null,
                  icon: Icon(Icons.clear, size: 15.w)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 25.0.w, right: 13.0.w, bottom: 5.0.h,),
          child: Container(
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
                  return Container(
                    child: Text('최근 본 HEAR가 없습니다.'),
                  );
                return Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 6.0.w),
                        child: Image.asset('assets/icons/history.png', width: 20.w, height: 17.h,),
                      ),
                      Text('같이 대화하면서 놀아요!'),
                      Expanded(child: Container()),
                      Text('HERO 정보', style: TextStyle(
                          fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
                          fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
                          color: Theme.of(context).colorScheme.primary
                      )),
                      IconButton(
                          onPressed: null,
                          icon: Icon(Icons.navigate_next, size: 18.w))
                    ]
                );
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(25.0.w, 0.h, 30.w, 0.h),
          child: Divider(
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(25.0.w, 10.h, 30.w, 15.h),
          child: Text(
            '최근 검색어',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Column(
          children: List.generate(searchHistoryExample!.length, (index) =>
              Padding(
                padding: EdgeInsets.only(left: 25.0.w, right: 13.0.w),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            searchHistoryExample![index],
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Expanded(child: Container()),
                          IconButton(
                              onPressed: null,
                              icon: Icon(Icons.clear, size: 15.w)),
                        ],
                      ),
                    ),
                    Divider(thickness: 1, height: 0.h,),
                  ],
                ),
              ),
          ),
        )
      ],
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
    locationController.getLocation().obs;
  }
}
