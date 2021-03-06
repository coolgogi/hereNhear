import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/search/searchBar_controller.dart';
import 'package:herehear/bottomNavigationBar/search/search_history_model.dart';
import 'package:herehear/bottomNavigationBar/search/searchfield_widget.dart';
import 'package:herehear/etc/delete/contest/contest.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class SetLocationPage extends StatefulWidget {
  @override
  _SetLocationPageState createState() => _SetLocationPageState();
}

class _SetLocationPageState extends State<SetLocationPage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  GlobalKey globalKey = GlobalKey();
  final searchController = Get.put(SearchBarController());
  final locationController = Get.put(LocationController());

  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    loadHistory();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // executes after build
    });
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    searchController.history.value = (prefs.getStringList('history') ?? []);
    print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
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
    searchController.isRoomSearch.value = false;
    searchController.isLocationSearch.value = true;
    searchController.isCommunitySearch.value = false;
    searchController.isHistorySearch.value = false;
    // searchController.text.value = '';
    print('searchController.isRoomSearch.value = ${searchController.isRoomSearch.value}');
    print('searchController.isCommunitySearch.value = ${searchController.isCommunitySearch.value}');
    print('searchController.isLocationSearch.value = ${searchController.isLocationSearch.value}');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
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
          Padding(
            padding: EdgeInsets.fromLTRB(25.w, 25.h, 0.w, 10.h),
            child: Row(
              children: <Widget>[
                Text('당신의 ', style: Theme.of(context).textTheme.headline3),
                Text('HERE', style: Theme.of(context).textTheme.headline1),
                Text('는 어디인가요?', style: Theme.of(context).textTheme.headline3),
              ],
            ),
          ),
          SearchTextField(key: globalKey,category: 'history',),
          Obx(() {
            if (searchController.text.value.isEmpty) {
              print(
                  'searchController.textController.value!!!!!!!!!!!!!! : ${searchController.text.value}');
              return searchHistory();
            } else {
              print(
                  'searchController.textController.value??????????????? : ${searchController.text.value}');
              return Column(
                children: List.generate(
                    3,
                      (i) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(36.w, 10.h, 36.w, 10.h),
                          child: Text('경북 포항시 북구', style: Theme.of(context).textTheme.headline2,),
                        ),
                        Divider(),
                      ],
                    )),
              );
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
          padding: EdgeInsets.only(left: 25.0.w, right: 25.0.w),
          child: Container(
            height: 38.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 4), // changes position of shadow
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                searchController.text.value =
                    locationController.location.value;
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // side: BorderSide(color: Colors.red)
                  )),
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/location.png',
                    width: 17.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0.w),
                    child: Text(
                      '현 위치로 주소 설정',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyText1!.fontSize,
                          fontFamily:
                              Theme.of(context).textTheme.bodyText2!.fontFamily,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(25.0.w, 28.h, 30.w, 0.h),
          child: Divider(
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(25.0.w, 26.h, 30.w, 15.h),
          child: Text(
            '최근 주소',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Column(
          children: List.generate(
            searchController.history.length,
            //   locationHistoryExample!.length,
            (index) => Padding(
              padding: EdgeInsets.only(left: 25.0.w, right: 13.0.w),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
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
                          //locationHistoryExample![index],
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Expanded(child: Container()),
                        IconButton(
                            onPressed: () {
                              print('****************************************************************');
                              searchController.history.removeAt(index);
                              searchController.saveHistory('history');
                              print(searchController.history);
                              print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                            },
                            icon: Icon(Icons.clear, size: 15.w)),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    height: 2.h,
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
