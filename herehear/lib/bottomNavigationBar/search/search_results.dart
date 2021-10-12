import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/search/searchBar_controller.dart';
import 'package:herehear/bottomNavigationBar/search/search_history_model.dart';
import 'package:herehear/bottomNavigationBar/search/searchfield_widget.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'foundedResult.dart';
import '../../broadcast/data/broadcast_model.dart' as types;
import 'package:herehear/groupCall/data/group_call_model.dart' as types;

FirebaseFirestore firestore = FirebaseFirestore.instance;

class SearchResultsPage extends StatefulWidget {
  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final searchController = Get.put(SearchBarController());
  final locationController = Get.put(LocationController());
  final category = 'searchPageHistory';

  FocusNode searchBarFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadHistory();
  }
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    searchController.history.value = (prefs.getStringList(category) ?? []);
    print(searchController.history);
  }


  @override
  void dispose() {
    // 폼이 삭제되면 myFocusNode도 삭제됨
    // searchController.searchBarFocusNode.value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('searchController.isRoomSearch.value = ${searchController.isRoomSearch.value}');
    print('searchController.isCommunitySearch.value = ${searchController.isCommunitySearch.value}');
    print('searchController.isLocationSearch.value = ${searchController.isLocationSearch.value}');

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25.0.w,
        centerTitle: true,
        title: Text('HEAR 검색',
            style: Theme.of(context).appBarTheme.titleTextStyle),
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
          SearchTextField(category: category,),
          Obx(() {
            if (searchController.text.isEmpty) {
              return searchHistory();
            } else if(searchController.isCommunitySearch.value) {
              return communitySearchResult();
            } else {
              print('searchController.textController.value??????????????? : ${searchController.text.value}');
              return roomSearchResult();
            }
          })
        ],
      ),
    );
  }

  Widget roomSearchResult() {
    return StreamBuilder<List<types.BroadcastModel>>(
        stream: MyFirebaseChatCore.instance.broadcastRoomsForSearchResult(),
        builder: (context, snapshot1) {
          if (!snapshot1.hasData || !searchController.isSearchComplete.value) {
            Future.delayed(Duration(milliseconds: 1000));
            searchController.isSearchComplete.value = true;
            return Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: Column(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("'${searchController.text.value}' 검색중"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return StreamBuilder<List<types.GroupCallModel>>(
              stream: MyFirebaseChatCore.instance.groupCallRoomsForSearchResult(),
              builder: (context, snapshot2) {
                if (!snapshot2.hasData || !searchController.isSearchComplete.value) {
                  Future.delayed(Duration(milliseconds: 1000));
                  searchController.isSearchComplete.value = true;
                  return Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("'${searchController.text.value}' 검색중"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                Future.delayed(Duration(milliseconds: 1000));
                // searchController.isSearchComplete.value = true;
                print('?!: ${searchController.text.value}');
                // print('LIVE검색결과: ${snapshot1.data!.first.roomInfo.title}');
                // print('Call검색결과: ${snapshot2.data!.first.roomInfo.title}');
                return (snapshot1.data!.isNotEmpty || snapshot2.data!.isNotEmpty)?
                FoundedResult(broadcastData: snapshot1, groupcallData: snapshot2)
                    : Padding(
                  padding: EdgeInsets.only(top: 50.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text('검색 결과가 없습니다.', style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        )),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Widget communitySearchResult() {
    return StreamBuilder<List<types.BroadcastModel>>(
        stream: MyFirebaseChatCore.instance.broadcastRoomsForSearchResult(),
        builder: (context, snapshot1) {
          if (!snapshot1.hasData) {
            return Padding(
              padding: EdgeInsets.only(left: 25.0.w, top: 30.h),
              child: Column(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CircularProgressIndicator(),
                        // SizedBox(width: 10.w),
                        Text("'${searchController.text.value}' 검색중"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return StreamBuilder<List<types.GroupCallModel>>(
              stream: MyFirebaseChatCore.instance.groupCallRoomsForSearchResult(),
              builder: (context, snapshot2) {
                if (!snapshot2.hasData) {
                  return Padding(
                    padding: EdgeInsets.only(left: 25.0.w, top: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Row(
                            children: [
                              // CircularProgressIndicator(),
                              SizedBox(width: 10.w),
                              Text("'${searchController.text.value}' 검색중"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                // searchController.isSearchComplete.value = true;
                print('?!: ${searchController.text.value}');
                // print('LIVE검색결과: ${snapshot1.data!.first.roomInfo.title}');
                // print('Call검색결과: ${snapshot2.data!.first.roomInfo.title}');
                return (snapshot1.data!.isNotEmpty || snapshot2.data!.isNotEmpty)?
                FoundedResult(broadcastData: snapshot1, groupcallData: snapshot2)
                    : Padding(
                  padding: EdgeInsets.only(top: 50.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text('검색 결과가 없습니다.', style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        )),
                      ),
                    ],
                  ),
                );
              });
        });
  }


  Widget searchHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(25.0.w, 10.h, 30.w, 15.h),
          child: Text(
            '최근 검색어',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Column(
          children: List.generate(
            searchController.history.length,
            (index) => Padding(
              padding: EdgeInsets.only(left: 25.0.w, right: 13.0.w),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      searchController.text.value =
                      searchController.history[index];
                      searchController.isHistorySearch.value = true;
                      searchController.initialSearchText();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          searchController.history[index],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Expanded(child: Container()),
                        IconButton(
                            onPressed: (){
                              searchController.history.removeAt(index);
                              searchController.saveHistory(category);
                            },
                            icon: Icon(Icons.clear, size: 15.w)),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    height: 0.h,
                  ),
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
