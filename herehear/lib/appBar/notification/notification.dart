import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationController extends GetxController {
  RxList<Notification> unclickedDataList = <Notification>[].obs;
  RxList<Notification> alreadyClickedDataList = <Notification>[].obs;
}

class NotificationPage extends StatelessWidget {
  late NotificationList dataList;
  var dummydata = [
    {"profileImg": "assets/images/she2.jpeg", "text": "john님이 팔로우하였습니다", "backImg": null, "isClicked": false},
    {"profileImg": "assets/images/she2.jpeg", "text": "노닐다님이 라이브 방송중입니다", "backImg": "assets/images/groupcall/fish.jpg", "isClicked": false},
    {"profileImg": "assets/images/she2.jpeg", "text": "shee님이 팔로우하였습니다", "backImg": "assets/images/groupcall/fish.jpg", "isClicked": true},
    {"profileImg": "assets/images/she2.jpeg", "text": "이어폰폰이 라이브 방송중입니다", "backImg": "assets/images/groupcall/fish.jpg", "isClicked": false},
    {"profileImg": "assets/images/she2.jpeg", "text": "john님이 팔로우하였습니다", "backImg": null, "isClicked": true},
    {"profileImg": "assets/images/she2.jpeg", "text": "john님이 팔로우하였습니다", "backImg": "assets/images/groupcall/fish.jpg", "isClicked": true},
    {"profileImg": "assets/images/she2.jpeg", "text": "john님이 팔로우하였습니다", "backImg": "assets/images/groupcall/fish.jpg", "isClicked": true},
  ];
  final notificationController = Get.put(NotificationController());
  
  Future<void> fetchDummyData() async {
    dataList = await NotificationList.fromJson(dummydata);
    print('???: ${dataList.NotificationNumList!.first.isClicked}');
    dataList.NotificationNumList!.forEach((element) {
      print('!!!: ${element.isClicked}');
      if(element.isClicked == false)
        notificationController.unclickedDataList.add(element);
      else notificationController.alreadyClickedDataList.add(element);
    });
    print('unclickedDataList: ${notificationController.unclickedDataList.length}');
    print('alreadyClickedDataList: ${notificationController.alreadyClickedDataList.length}');
  }

  // Future<void> changeConditionClickedDate() async {
  //   dataList.NotificationNumList!.forEach((element) {
  //     if((element.isClicked )== false && !(notificationController.unclickedDataList.contains(element)))
  //       notificationController.unclickedDataList.add(element);
  //     else if(!notificationController.alreadyClickedDataList.contains(element))
  //       notificationController.alreadyClickedDataList.add(element);
  //   });
  //   print('unclickedDataList: ${notificationController.unclickedDataList.length}');
  //   print('alreadyClickedDataList: ${notificationController.alreadyClickedDataList.length}');
  // }

  @override
  Widget build(BuildContext context) {
    fetchDummyData();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface, size: 22.w),
        ),
        titleSpacing: 0.w,
        title: Text(
          '알림',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 35.h),
        child: Obx(() => ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Text('최근 알림', style: Theme.of(context).textTheme.headline4),
            ),
            notificationController.unclickedDataList.isNotEmpty? Column(
                children: List.generate(notificationController.unclickedDataList.length, (i) => ListItem(context, i, notificationController.unclickedDataList))
            ) : Text('최근 알림이 없습니다.', style: Theme.of(context).textTheme.headline6!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            )),
            Padding(
              padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
              child: Text('이번주', style: Theme.of(context).textTheme.headline4),
            ),
            Column(
                children: List.generate(notificationController.alreadyClickedDataList.length, (i) => ListItem(context, i, notificationController.alreadyClickedDataList))
            ),
          ],
        )),
      ),
    );
  }

  Widget ListItem(BuildContext context, int i, List<Notification>? notificationList) {
    return InkWell(
      onTap: () {
        notificationList![i].isClicked = true;
        notificationController.alreadyClickedDataList.add(notificationList[i]);
        notificationController.unclickedDataList.remove(notificationList[i]);
      },
      child: Container(
        color: notificationList![i].isClicked == false ? Colors.blue[50] : Colors.blue[0],
        child: Column(
          children: [
            Container(
              // color: controller.check ? Colors.blue[50] : Colors.blue[0],
              child: ListTile(
                onTap: null,
                horizontalTitleGap: 5.w,
                leading: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(notificationList[i].profileImg!),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notificationList[i].text!, style: Theme.of(context).textTheme.headline6),
                    Text('1시간', style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
                trailing: notificationList[i].backImg != null ? Container(
                  width: 46.w,
                  height: 43.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.r)),
                      image:  DecorationImage(
                        image: AssetImage(notificationList[i].backImg!),
                        fit: BoxFit.cover,
                      ),
                  ),
                ) : null,
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}


class NotificationList {
  final List<Notification>? NotificationNumList;

  NotificationList({
    this.NotificationNumList,
  });

  factory NotificationList.fromJson(List<dynamic> parsedJson) {
    print('1');

    List<Notification> NotificationNumList = <Notification>[];
    NotificationNumList = parsedJson.map((i)=>Notification.fromJson(i)).toList();

    return NotificationList(
        NotificationNumList: NotificationNumList
    );
  }
}

class Notification{
  final String? profileImg;
  final String? text;
  final String? backImg;
  late bool? isClicked;

  Notification({
    this.profileImg,
    this.text,
    this.backImg,
    this.isClicked,
  }) ;

  factory Notification.fromJson(Map<String, dynamic> json){
    return Notification(
      profileImg : json['profileImg'],
      text : json['text'],
      backImg : json['backImg'],
      isClicked : json['isClicked'],
    );
  }
}

