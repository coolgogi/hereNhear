import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
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
import 'package:intl/intl.dart';
import 'broadcastInfoController/broadcast_info_controller.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';


class TempController extends GetxController {
  RxBool isPrivate = false.obs;
  RxBool isReserve = false.obs;
  RxList tagList = [].obs;
  var selectedDate = DateTime.now().add(Duration(days: 1)).obs;
  var selectedTime = DateTime.now().add(Duration(days: 1)).obs;
}

class CreateGroupCallPage extends StatefulWidget {
  late UserModel userData;

  CreateGroupCallPage.withData(UserModel uData) {
    this.userData = uData;
  }

  CreateGroupCallPage();

  @override
  _CreateGroupCallPageState createState() => _CreateGroupCallPageState();
}

class _CreateGroupCallPageState extends State<CreateGroupCallPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _notice = TextEditingController();
  TextEditingController _privatePwd = TextEditingController();
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  String _docId = '';


  //unused variableselectedDate
  ClientRole _role = ClientRole.Broadcaster;
  bool _validateError = false;
  List<String> categoryTextList = [
    '고민상담',
    '수다/챗',
    '유머',
    '홍보',
    '판매',
    '힐링',
    '음악',
    '일상'
  ];
  List<String> categoryIconList = [
    'assets/icons/eyes.png',
    'assets/icons/talk.png',
    'assets/icons/smile.png',
    'assets/icons/advertise.png',
    'assets/icons/sale.png',
    'assets/icons/healing.png',
    'assets/icons/music.png',
    'assets/icons/tree.png',
  ];

  final broadcastInfoController = Get.put(BroadcastInfoController());
  final agoraController = Get.put(AgoraCreateController());
  final locationController = Get.put(LocationController());

  final controller = Get.put(TempController());

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
        title: Text('HERE CHAT',
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
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 14.h),
              child: Text(
                '방 설정',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),

            Obx(() => privateOption()),
            SizedBox(height: 17.h),

            Obx(() => timeReserveOption()),

            titleAndNoticeInfo(),

            //카테고리 선택 part
            Padding(
              padding: EdgeInsets.only(top: 22.0.h, bottom: 15.h),
              child: Row(
                children: [
                  Text(
                    '카테고리',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                      onTap: () => broadcastInfoController.selectedCategoryList
                          .removeRange(0, broadcastInfoController.selectedCategoryList.length),
                      child: Container(
                        width: 70.w,
                        height: 32.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/reload.png',
                              width: 15.w,
                            ),
                            SizedBox(
                              width: 6.w,
                            ),
                            Text('초기화', style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ),
            Obx(() => categorySelectList()),
            Padding(
              padding: EdgeInsets.only(left: 13.0.w, top: 10.h),
              child: Text(
                '* 카테고리는 최대 3개까지 선택 가능합니다.',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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

  Widget privateOption() {
    return Row(
      children: [
        Container(
          width: 83.w,
          height: 30.h,
          child: ElevatedButton(
            onPressed: () => controller.isPrivate.value = false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(controller.isPrivate.value? 'assets/icons/unlock_grey.png' : 'assets/icons/unlock_white.png', width: 18.w),
                Text(
                    '공개',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: controller.isPrivate.value? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onPrimary
                    )),
              ],
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(controller.isPrivate.value? Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.primary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: controller.isPrivate.value? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.primary)
                    )
                )
            ),
          ),
        ),
        SizedBox(width: 13.w),
        Container(
          width: 83.w,
          height: 30.h,
          child: ElevatedButton(
            onPressed: () => controller.isPrivate.value = true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(controller.isPrivate.value?  'assets/icons/lock_white.png' : 'assets/icons/lock_grey.png', width: 18.w),
                Text(
                    '비공개',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: controller.isPrivate.value? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface
                    )),
              ],
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(controller.isPrivate.value? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.background),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: controller.isPrivate.value? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.background)
                    )
                )
            ),
          ),
        ),
        SizedBox(width: 13.w),
        Text('비밀번호 ', style: Theme.of(context).textTheme.headline6!.copyWith(
            color: controller.isPrivate.value? Theme.of(context).colorScheme.onBackground
                : Theme.of(context).colorScheme.onSurface
        )),
        SizedBox(width: 7.w),
        Container(
          width: 80.w,
          height: 20.h,
          child: TextField(
            controller: _privatePwd,
            enabled: controller.isPrivate.value,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: Theme.of(context).colorScheme.onBackground),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: Theme.of(context).colorScheme.onBackground),
              ),
              contentPadding: EdgeInsets.fromLTRB(7.w, 0.h, 0.w, 0.h),
              hintStyle: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface
              ),
              hintText: '4자리 숫자',
            ),
          ),
        ),
      ],
    );
  }

  Widget timeReserveOption() {
    return Row(
      children: [
        Container(
          width: 110.w,
          height: 30.h,
          child: ElevatedButton(
            onPressed: () => controller.isReserve.value = !(controller.isReserve.value),
            child: Row(
              children: [
                Image.asset(
                    controller.isReserve.value
                        ? 'assets/icons/clock_white.png'
                        : 'assets/icons/clock_grey.png',
                    width: 18.w),
                Padding(
                  padding: EdgeInsets.only(left: 6.0.w),
                  child: Text('예약 설정',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(
                          color: controller.isReserve.value
                              ? Theme.of(context)
                              .colorScheme
                              .onPrimary
                              : Theme.of(context)
                              .colorScheme
                              .onSurface)),
                ),
              ],
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    controller.isReserve.value
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.background),
                shape:
                MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(
                            color: controller.isReserve.value
                                ? Theme.of(context)
                                .colorScheme
                                .primary
                                : Theme.of(context)
                                .colorScheme
                                .background)))),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: () => controller.isReserve.value? showDialog() : null,
          child: Container(
            width: 188.w,
            height: 30.h,
            child: Row(
              children: [
                SizedBox(width: 35.w,),
                Text(
                  DateFormat('yyyy-MM-dd  ').format(controller.selectedDate.value),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: controller.isReserve.value? Theme.of(context).colorScheme.onBackground
                          : Theme.of(context).colorScheme.onSurface
                  ),
                ),
                Text(
                  DateFormat('kk:mm').format(controller.selectedTime.value),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: controller.isReserve.value? Theme.of(context).colorScheme.onBackground
                          : Theme.of(context).colorScheme.onSurface
                  ),
                ),
                SizedBox(width: 16.w,),
                Icon(Icons.expand_more, color: controller.isReserve.value? Theme.of(context).colorScheme.onBackground
                    : Theme.of(context).colorScheme.onSurface
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.all(Radius.circular(4.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 4), // changes position of shadow
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget titleAndNoticeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 40.h, bottom: 11.h),
          child: Text(
            '제목',
            style: Theme.of(context).textTheme.headline3,
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
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:  BorderSide(color: Theme.of(context).colorScheme.onSurface),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:  BorderSide(color: Theme.of(context).colorScheme.onBackground),
            ),
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
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Container(
          height: 104.h,
          child: TextFormField(
            keyboardType: TextInputType.text,
            controller: _notice,
            maxLines: 15,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              hintText: '방의 공지를 입력해주세요(100자 이내)',
              enabledBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: Theme.of(context).colorScheme.onSurface),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.0.h,
        ),
      ],
    );
  }

  Widget categorySelectList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
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
                      fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                      fontFamily:
                      Theme.of(context).textTheme.headline4!.fontFamily,
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
                    .contains(categoryTextList[i + 2])
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                avatar: Image.asset(
                  categoryIconList[i + 2],
                  width: 13.w,
                ),
                label: Text(categoryTextList[i + 2],
                    style: TextStyle(
                      color: broadcastInfoController.selectedCategoryList
                          .contains(categoryTextList[i + 2])
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                      fontFamily:
                      Theme.of(context).textTheme.headline4!.fontFamily,
                    )),
                onPressed: () {
                  if (broadcastInfoController.selectedCategoryList
                      .contains(categoryTextList[i + 2]))
                    broadcastInfoController.selectedCategoryList
                        .remove(categoryTextList[i + 2]);
                  else if (broadcastInfoController.selectedCategoryList.length <
                      3)
                    broadcastInfoController.selectedCategoryList
                        .add(categoryTextList[i + 2]);
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
                    .contains(categoryTextList[i + 5])
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                avatar: Image.asset(
                  categoryIconList[i + 5],
                  width: 13.w,
                ),
                label: Text(categoryTextList[i + 5],
                    style: TextStyle(
                      color: broadcastInfoController.selectedCategoryList
                          .contains(categoryTextList[i + 5])
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                      fontFamily:
                      Theme.of(context).textTheme.headline4!.fontFamily,
                    )),
                onPressed: () {
                  if (broadcastInfoController.selectedCategoryList
                      .contains(categoryTextList[i + 5]))
                    broadcastInfoController.selectedCategoryList
                        .remove(categoryTextList[i + 5]);
                  else if (broadcastInfoController.selectedCategoryList.length <
                      3)
                    broadcastInfoController.selectedCategoryList
                        .add(categoryTextList[i + 5]);
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

  Future<dynamic> showDialog() {
    return Get.dialog(
        Center(
          child: Container(
            width: 330.w,
            height: 334.h,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0.w, top: 18.h, right: 17.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('예약 설정', style: Theme.of(context).textTheme.headline2),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Obx(() => Row(
                    children: [
                      Image.asset('assets/icons/clock_black.png', width: 26.w),
                      Padding(
                        padding: EdgeInsets.only(left: 14.0.w, right: 26.w),
                        child: Text('시간 설정', style: Theme.of(context).textTheme.headline5),
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          width: 100.w,
                          height: 30.h,
                          child: Center(
                            child: Text(
                              DateFormat('yyyy-MM-dd').format(controller.selectedDate.value),
                              style: Theme.of(context).textTheme.headline5!.copyWith(
                                  color: Theme.of(context).colorScheme.onBackground
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.all(Radius.circular(4.r)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: Offset(0, 4), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () => Get.defaultDialog(
                          title: 'SELECT TIME',
                          content: _selectTime(),
                        ),
                        child: Container(
                          width: 54.w,
                          height: 30.h,
                          child: Center(
                            child: Text(
                              DateFormat('kk:mm').format(controller.selectedTime.value),
                              style: Theme.of(context).textTheme.headline5!.copyWith(
                                  color: Theme.of(context).colorScheme.onBackground
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.all(Radius.circular(4.r)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: Offset(0, 4), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Image.asset('assets/icons/addFriend.png', width: 24.w),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0.w),
                        child: Text('친구 초대', style: Theme.of(context).textTheme.headline5),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Material(
                    color: Theme.of(context).colorScheme.background,
                    child: createTagList()),
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget createTagList() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tags(
          key:_tagStateKey,
          textField: TagsTextField(
            hintText: '친구 이름을 입력하세요',
            autofocus: false,
            inputDecoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(7.w, 3.h, 0.w, 0.h),
              focusColor: Theme.of(context).colorScheme.background,
            ),
            textStyle: Theme.of(context).textTheme.headline5,
            // constraintSuggestion: true,
            // suggestions: [],
            onSubmitted: (String str) {
              // Add item to the data source.
              setState(() {
                // required
                controller.tagList.add(str);
              });
            },
          ),
        ),
        SizedBox(height: 15.h),
        Tags(
          itemCount: controller.tagList.length, // required
          itemBuilder: (int index){
            final Item currentItem = Item(title:controller.tagList[index]);

            return ItemTags(
              index: index,
              title: currentItem.title,
              customData: currentItem.customData,
              textColor: Theme.of(context).colorScheme.onPrimary,
              color: Theme.of(context).colorScheme.primary,
              activeColor: Theme.of(context).colorScheme.background,
              textActiveColor: Theme.of(context).colorScheme.primary,
              elevation: 0,
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.0.w
              ),
              active: true,
              pressEnabled: false,
              textStyle: TextStyle(fontSize: 14),
              combine: ItemTagsCombine.withTextBefore,
              removeButton: ItemTagsRemoveButton(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  color: Theme.of(context).colorScheme.primary,
                  onRemoved: () {
                    setState(() {
                      controller.tagList.removeAt(index);
                    });
                    return true;
                  }
              ),
            );
          },
        ),
        // Expanded(child: Container()),
        // GestureDetector(
        //   onTap: ,
        //   child: Container(
        //     child: Text('확인'),
        //   ),
        // )
      ],
    ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: controller.selectedDate.value,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != controller.selectedDate.value)
      setState(() {
        controller.selectedDate.value = picked;
      });
  }

  Widget _selectTime() {
    return TimePickerSpinner(

      is24HourMode: true,
      normalTextStyle: Theme.of(context).textTheme.headline3!.copyWith(
          fontSize: 26,
          color: Theme.of(context).colorScheme.onSurface
      ),
      highlightedTextStyle: Theme.of(context).textTheme.headline3!.copyWith(
          fontSize: 32,
          color: Theme.of(context).colorScheme.onBackground
      ),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      onTimeChange: (time) => controller.selectedTime.value = time,
    );
  }
}



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:herehear/agora/agoraCreateController.dart';
// import 'package:herehear/groupCall/group_call.dart';
// import 'package:herehear/location/controller/location_controller.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:async';
//
// class CreateGroupCallPage extends StatefulWidget {
//   @override
//   _CreateGroupCallPageState createState() => _CreateGroupCallPageState();
// }
//
// class _CreateGroupCallPageState extends State<CreateGroupCallPage> {
//   User? user = FirebaseAuth.instance.currentUser;
//   final _title = TextEditingController();
//   final _notice = TextEditingController();
//   String? _docId;
//   DateTime selectedDate = DateTime.now();
//   final controller = Get.put(AgoraCreateController());
//   final locationController = Get.put(LocationController());
//
//   //unused variable
//   String? _selectedTime;
//   bool _validateError = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('새 그룹 대화방',
//             style: Theme.of(context).appBarTheme.titleTextStyle),
//         leading: IconButton(
//           icon: Icon(Icons.close),
//           onPressed: () => {
//             Get.back(),
//           },
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.only(bottom: 10),
//               child: Text(
//                 '시작시간 예약하기',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             Row(
//               children: <Widget>[
//                 Container(
//                     padding: EdgeInsets.only(bottom: 10, right: 15),
//                     child: GestureDetector(
//                         onTap: () {
//                           _selectDate(context);
//                         },
//                         child: Icon(Icons.calendar_today, size: 30))),
//                 Container(
//                     padding: EdgeInsets.only(bottom: 10),
//                     child: GestureDetector(
//                         onTap: () {
//                           Future<TimeOfDay?> selectedTime = showTimePicker(
//                               context: context, initialTime: TimeOfDay.now());
//                           selectedTime.then((timeOfDay) {
//                             setState(() {
//                               _selectedTime =
//                                   '${timeOfDay!.hour}: ${timeOfDay.minute}';
//                             });
//                           });
//                         },
//                         child: Icon(Icons.access_time, size: 30))),
//               ],
//             ),
//             SizedBox(
//               height: 16.0,
//             ),
//             Container(
//               padding: EdgeInsets.only(bottom: 10),
//               child: Text(
//                 '제목',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             TextFormField(
//               controller: _title,
//               validator: (value) {
//                 if (value!.trim().isEmpty) {
//                   return '제목을 입력해주세요.';
//                 }
//                 return null;
//               },
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.fromLTRB(10, 6, 0, 6),
//                 hintText: '제목을 입력해주세요(15자 이내)',
//               ),
//             ),
//             SizedBox(
//               height: 16.0,
//             ),
//             SizedBox(
//               height: 16.0,
//             ),
//             Container(
//               padding: EdgeInsets.only(bottom: 10),
//               child: Text(
//                 '공지사항',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             Container(
//               height: MediaQuery.of(context).size.height * 0.2,
//               padding: EdgeInsets.fromLTRB(15, 1, 10, 0),
//               decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 border: Border.all(
//                   color: Colors.grey,
//                   width: 0.7,
//                 ),
//               ),
//               child: TextField(
//                 cursorColor: Theme.of(context).primaryColor,
//                 textInputAction: TextInputAction.newline,
//                 keyboardType: TextInputType.multiline,
//                 maxLines: null,
//                 controller: _notice,
//                 textAlign: TextAlign.left,
//                 decoration: InputDecoration(
//                   hintText: '공지를 입력해주세요(100자 이내)',
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 32.0,
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     onJoin();
//                   },
//                   child: Text('방만들기'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<Null> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//       });
//   }
//
//   Future<void> onJoin() async {
//     setState(() {
//       _title.text.isEmpty ? _validateError = true : _validateError = false;
//     });
//     await Permission.microphone.request();
//
//     _docId =
//         (10000000000000 - DateTime.now().millisecondsSinceEpoch).toString();
//     controller.createGroupCallRoom(user, _title.text, _notice.text, _docId,
//         locationController.location.value);
//
//     Get.off(() => GroupCallPage(_title.text), arguments: _docId);
//   }
// }
