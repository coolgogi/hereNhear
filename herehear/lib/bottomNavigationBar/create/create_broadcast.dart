import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/agora/agoraCreateController.dart';
import 'package:herehear/broadcast/broadcast.dart';
import 'package:herehear/broadcast/data/broadcast_model.dart' as types;
import 'package:herehear/broadcast/data/broadcast_room_info.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'broadcastInfoController/broadcast_info_controller.dart';

class CreateBroadcastPage extends StatefulWidget {
  late UserModel userData;

  CreateBroadcastPage.withData(UserModel uData) {
    this.userData = uData;
  }

  CreateBroadcastPage();

  @override
  _CreateBroadcastPageState createState() => _CreateBroadcastPageState();
}

class _CreateBroadcastPageState extends State<CreateBroadcastPage> {
  int _index = -1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _notice = TextEditingController();
  String _docId = '';

  //unused variable
  ClientRole _role = ClientRole.Broadcaster;
  bool _validateError = false;
  List<String> categoryTextList = [
    '독서',
    '고민상담',
    '수다/챗',
    '유머',
    '홍보',
    '판매',
    '음악',
    '힐링',
    'asmr',
    '일상'
  ];
  List<String> categoryIconList = [
    'assets/icons/book.png',
    'assets/icons/eyes.png',
    'assets/icons/talk.png',
    'assets/icons/smile.png',
    'assets/icons/advertise.png',
    'assets/icons/sale.png',
    'assets/icons/music.png',
    'assets/icons/healing.png',
    'assets/images/mike2.png',
    'assets/icons/tree.png',
  ];

  final broadcastInfoController = Get.put(BroadcastInfoController());
  final agoraController = Get.put(AgoraCreateController());
  final locationController = Get.put(LocationController());

  @override
  void dispose() {
    _title.dispose();
    _notice.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    // 이 클래스애 리스너 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('HERE 라이브',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => {
            Get.back(),
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16.0.w, 33.h, 17.w, 0.h),
        key: _formKey,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 11.h),
              child: Text(
                '제목',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            TextFormField(
              controller: _title,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return '제목을 입력해주세요.';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(10.w, 6.h, 0.w, 6.h),
                hintText: '제목을 입력해주세요(15자 이내)',
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 11.h),
              child: Text(
                '공지사항',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Container(
              height: 104.h,
              padding: EdgeInsets.fromLTRB(15.w, 1.h, 10.w, 0.h),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: TextField(
                cursorColor: Theme.of(context).primaryColor,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _notice,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: '공지를 입력해주세요(100자 이내)',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 15.0.h,
            ),
            Padding(
              padding: EdgeInsets.only(top: 22.0.h, bottom: 15.h),
              child: Row(
                children: [
                  Text(
                    '카테고리',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () => broadcastInfoController.selectedCategoryList
                        .removeRange(0, 3),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/reload.png',
                          width: 13.w,
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Text('초기화'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => categorySelectList(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 13.0.w, top: 10.h),
              child: Text(
                '* 카테고리는 최대 3개까지 선택 가능합니다.',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            SizedBox(
              height: 32.0.h,
            ),
            SizedBox(
              height: 44.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onJoin();
                },
                child: Text('완료'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categorySelectList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (i) => Padding(
              padding: EdgeInsets.only(left: 13.0.w),
              child: ActionChip(
                labelPadding: EdgeInsets.fromLTRB(0.w, 0.h, 6.w, 0.h),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                backgroundColor: broadcastInfoController.selectedCategoryList
                        .contains(categoryTextList[i])
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                avatar: Image.asset(
                  categoryIconList[i],
                  width: 13.w,
                ),
                label: Text(categoryTextList[i],
                    style: TextStyle(
                      color: broadcastInfoController.selectedCategoryList
                              .contains(categoryTextList[i])
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
                      fontFamily:
                          Theme.of(context).textTheme.bodyText1!.fontFamily,
                    )),
                onPressed: () {
                  if (broadcastInfoController.selectedCategoryList
                      .contains(categoryTextList[i]))
                    broadcastInfoController.selectedCategoryList
                        .remove(categoryTextList[i]);
                  else if (broadcastInfoController.selectedCategoryList.length <
                      3)
                    broadcastInfoController.selectedCategoryList
                        .add(categoryTextList[i]);
                },
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (i) => Padding(
              padding: EdgeInsets.only(left: 13.0.w),
              child: ActionChip(
                labelPadding: EdgeInsets.fromLTRB(0.w, 0.h, 6.w, 0.h),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                backgroundColor: broadcastInfoController.selectedCategoryList
                        .contains(categoryTextList[i + 3])
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                avatar: Image.asset(
                  categoryIconList[i + 3],
                  width: 13.w,
                ),
                label: Text(categoryTextList[i + 3],
                    style: TextStyle(
                      color: broadcastInfoController.selectedCategoryList
                              .contains(categoryTextList[i + 3])
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
                      fontFamily:
                          Theme.of(context).textTheme.bodyText1!.fontFamily,
                    )),
                onPressed: () {
                  if (broadcastInfoController.selectedCategoryList
                      .contains(categoryTextList[i + 3]))
                    broadcastInfoController.selectedCategoryList
                        .remove(categoryTextList[i + 3]);
                  else if (broadcastInfoController.selectedCategoryList.length <
                      3)
                    broadcastInfoController.selectedCategoryList
                        .add(categoryTextList[i + 3]);
                },
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (i) => Padding(
              padding: EdgeInsets.only(left: 13.0.w),
              child: ActionChip(
                labelPadding: EdgeInsets.fromLTRB(0.w, 0.h, 6.w, 0.h),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                backgroundColor: broadcastInfoController.selectedCategoryList
                        .contains(categoryTextList[i + 7])
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                avatar: Image.asset(
                  categoryIconList[i + 7],
                  width: 13.w,
                ),
                label: Text(categoryTextList[i + 7],
                    style: TextStyle(
                      color: broadcastInfoController.selectedCategoryList
                              .contains(categoryTextList[i + 7])
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
                      fontFamily:
                          Theme.of(context).textTheme.bodyText1!.fontFamily,
                    )),
                onPressed: () {
                  if (broadcastInfoController.selectedCategoryList
                      .contains(categoryTextList[i + 7]))
                    broadcastInfoController.selectedCategoryList
                        .remove(categoryTextList[i + 7]);
                  else if (broadcastInfoController.selectedCategoryList.length <
                      3)
                    broadcastInfoController.selectedCategoryList
                        .add(categoryTextList[i + 7]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _title.text.isEmpty ? _validateError = true : _validateError = false;
    });
    await Permission.microphone.request();

    _docId =
        (10000000000000 - DateTime.now().millisecondsSinceEpoch).toString();

    RoomInfoModel roomInfo = RoomInfoModel(
        hostInfo: UserController.to.myProfile.value,
        title: _title.text,
        roomCategory: broadcastInfoController.selectedCategoryList,
        docId: _docId,
        notice: _notice.text,
        thumbnail: 'assets/images/mic1.jpg');
    late List<UserModel> userList = [];
    userList.add(UserController.to.myProfile.value);


    types.BroadcastModel roomData = await MyFirebaseChatCore.instance.createGroupRoom(roomInfo: roomInfo, hostInfo: UserController.to.myProfile.value);

    // agoraController.createBroadcastRoom(
    //   UserController.to.myProfile.value,
    //   _title.text,
    //   _notice.text,
    //   broadcastInfoController.selectedCategoryList,
    //   _docId,
    //   List<String>.filled(0, '', growable: true),
    //   locationController.location.value,
    // );

    Get.off(
      () => BroadCastPage.myBroadcaster(
      //  channelName: _docId,
        role: ClientRole.Broadcaster,
      roomData : roomData,
      //  userData: UserController.to.myProfile.value,
      ),
    );
  }
}
