import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:herehear/agora/agoraCreateController.dart';
import 'package:herehear/bottomNavigationBar/community/free_board/createPost.dart';

import 'package:herehear/groupCall/data/group_call_model.dart' as types;
import 'package:herehear/broadcast/data/broadcast_room_info.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/groupCall/group_call.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'broadcastInfoController/broadcast_info_controller.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'groupCallInfocontroller.dart';


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
  String channelName = '';
  final _picker = ImagePicker();

  //unused variableselectedDate
  ClientRole _role = ClientRole.Broadcaster;
  bool _validateError = false;
  List<String> categoryTextList = [
    '????????????',
    '??????/???',
    '??????',
    '??????',
    '??????',
    '??????',
    '??????',
    '??????'
  ];
  List<String> categoryIconList = [
    'assets/icons/categoryIcon/eyes.png',
    'assets/icons/categoryIcon/talk.png',
    'assets/icons/categoryIcon/smile.png',
    'assets/icons/categoryIcon/advertise.png',
    'assets/icons/categoryIcon/sale.png',
    'assets/icons/categoryIcon/healing.png',
    'assets/icons/categoryIcon/music.png',
    'assets/icons/categoryIcon/tree.png',
  ];

  final broadcastInfoController = Get.put(BroadcastInfoController());
  final agoraController = Get.put(AgoraCreateController());
  final locationController = Get.put(LocationController());
  final postController = Get.put(PostController());
  final groupCallController = Get.put(GroupCallInfoController());


  @override
  void dispose() {
    groupCallController.selectedCategoryList.value.removeRange(0, groupCallController.selectedCategoryList.length);
    _title.dispose();
    _notice.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    // ??? ???????????? ????????? ??????
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
      body: Obx(() => Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.fromLTRB(16.0.w, 20.h, 17.w, 0.h),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 14.h),
                child: Text(
                  '??? ??????',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),

              privateOption(),
              SizedBox(height: 17.h),

             // timeReserveOption(),

              titleAndNoticeInfo(),

              //???????????? ?????? part
              Padding(
                padding: EdgeInsets.only(top: 22.0.h, bottom: 15.h),
                child: Row(
                  children: [
                    Text(
                      '????????????',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Expanded(child: Container()),
                    GestureDetector(
                        onTap: () => groupCallController.selectedCategoryList
                            .removeRange(0, groupCallController.selectedCategoryList.length),
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
                              Text('?????????', style: Theme.of(context).textTheme.headline5!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              )),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              ),
              categorySelectList(),
              Padding(
                padding: EdgeInsets.only(left: 13.0.w, top: 10.h),
                child: Text(
                  '* ??????????????? ?????? 3????????? ?????? ???????????????.',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 18.h),
                child: Text(
                  '????????? ?????????',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Theme.of(context).colorScheme.background,
                  border: Border.all(color: Theme.of(context).colorScheme.onSurface),
                ),
                child: Obx(() => Column(
                  children: [
                    loadImage(),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0.h, bottom: 21.h),
                      child: Container(
                        width: 90.w,
                        height: 25.h,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                              padding: MaterialStateProperty.all(EdgeInsets.only(left: 0.w, right: 0.w)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0.r),
                                      side: BorderSide(color: Theme.of(context).colorScheme.primary,)
                                  )
                              )
                          ),
                          onPressed: showDialog,
                          child: Text(postController.isDefaultImage.value? '????????? ?????????' : '????????? ??????', style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              SizedBox(
                height: 32.0.h,
              ),
              SizedBox(
                height: 44.h,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate())
                      onJoin();
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: (_title.text.isEmpty || groupCallController.selectedCategoryList.isEmpty)? MaterialStateProperty.all(Theme.of(context).colorScheme.onSecondary)
                        : MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                  ),
                  child: Text('??????'),
                ),
              ),
              SizedBox(
                height: 10.0.h,
              ),
            ],
          ),
        ),
      ))
    );
  }

  Widget privateOption() {
    return Row(
      children: [
        Container(
          width: 90.w,
          height: 30.h,
          child: ElevatedButton(
            onPressed: () => groupCallController.isPrivate.value = false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(groupCallController.isPrivate.value? 'assets/icons/unlock_grey.png' : 'assets/icons/unlock_white.png', width: 18.w),
                SizedBox(width: 4.h),
                Text(
                    '??????',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: groupCallController.isPrivate.value? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onPrimary
                    )),
              ],
            ),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.only(left: 7.0.w, right: 7.0.w)),
                backgroundColor: MaterialStateProperty.all<Color>(groupCallController.isPrivate.value? Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.primary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: groupCallController.isPrivate.value? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.primary)
                    )
                )
            ),
          ),
        ),
        SizedBox(width: 9.w),
        Container(
          width: 90.w,
          height: 30.h,
          child: ElevatedButton(
            onPressed: () => groupCallController.isPrivate.value = true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(groupCallController.isPrivate.value?  'assets/icons/lock_white.png' : 'assets/icons/lock_grey.png', width: 18.w),
                SizedBox(width: 4.h),
                Text(
                    '?????????',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: groupCallController.isPrivate.value? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface
                    )),
              ],
            ),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.only(left: 7.0.w, right: 7.0.w)),
                backgroundColor: MaterialStateProperty.all<Color>(groupCallController.isPrivate.value? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.background),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: groupCallController.isPrivate.value? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.background)
                    )
                )
            ),
          ),
        ),
        SizedBox(width: 11.w),
        Text('???????????? ', style: Theme.of(context).textTheme.headline6!.copyWith(
            color: groupCallController.isPrivate.value? Theme.of(context).colorScheme.onBackground
                : Theme.of(context).colorScheme.onSurface
        )),
        SizedBox(width: 5.w),
        Container(
          width: 60.w,
          height: 20.h,
          child: TextField(
            controller: _privatePwd,
            enabled: groupCallController.isPrivate.value,
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
                  fontSize: 10.sp,
                  color: Theme.of(context).colorScheme.onSurface
              ),
              hintText: '4?????? ??????',
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
          width: 90.w,
          height: 30.h,
          child: ElevatedButton(
            onPressed: () => groupCallController.isReserve.value = !(groupCallController.isReserve.value),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    groupCallController.isReserve.value
                        ? 'assets/icons/clock_white.png'
                        : 'assets/icons/clock_grey.png',
                    width: 18.w),
                Padding(
                  padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                  child: Text('?????? ??????',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(
                          color: groupCallController.isReserve.value
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
                padding: MaterialStateProperty.all(EdgeInsets.only(left: 5.0.w)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    groupCallController.isReserve.value
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.background),
                shape:
                MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(
                            color: groupCallController.isReserve.value
                                ? Theme.of(context)
                                .colorScheme
                                .primary
                                : Theme.of(context)
                                .colorScheme
                                .background)))),
          ),
        ),
        SizedBox(width: 9.w),
        Container(
          width: 212.w,
          height: 30.h,
          child: ElevatedButton(
            onPressed: () => groupCallController.isReserve.value? showDialogForReservation() : null,
            child: Row(
              children: [
                SizedBox(width: 50.w,),
                Text(
                  DateFormat('yyyy-MM-dd  ').format(groupCallController.selectedDate.value),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: groupCallController.isReserve.value? Theme.of(context).colorScheme.onBackground
                          : Theme.of(context).colorScheme.onSurface
                  ),
                ),
                Text(
                  DateFormat('kk:mm').format(groupCallController.selectedTime.value),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: groupCallController.isReserve.value? Theme.of(context).colorScheme.onBackground
                          : Theme.of(context).colorScheme.onSurface
                  ),
                ),
                SizedBox(width: 40.w,),
                groupCallController.isReserve.value? Image.asset('assets/icons/expand_black.png', width: 12.w) : Image.asset('assets/icons/expand_grey.png', width: 12.w)
              ],
            ),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.only(left: 0.0.w)),
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.background),
                shape:
                MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        ))),
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
            '??????',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        TextFormField(
          controller: _title,
          validator: (value) {
            if (value!.trim().isEmpty) {
              return '????????? ??????????????????.';
            }
            return null;
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:  BorderSide(color: Theme.of(context).colorScheme.onSurface),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:  BorderSide(color: Theme.of(context).colorScheme.onBackground),
            ),
            contentPadding: EdgeInsets.fromLTRB(10.w, 6.h, 0.w, 6.h),
            hintText: '????????? ??????????????????(15??? ??????)',
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Container(
          padding: EdgeInsets.only(bottom: 11.h),
          child: Text(
            '????????????',
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
              hintText: '?????? ????????? ??????????????????(100??? ??????)',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:  BorderSide(color: Theme.of(context).colorScheme.onSurface),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
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
                backgroundColor: groupCallController.selectedCategoryList
                    .contains(categoryTextList[i])
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                avatar: Image.asset(
                  categoryIconList[i],
                  width: 13.w,
                ),
                label: Text(categoryTextList[i],
                    style: TextStyle(
                      color: groupCallController.selectedCategoryList
                          .contains(categoryTextList[i])
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                      fontFamily:
                      Theme.of(context).textTheme.headline4!.fontFamily,
                    )),
                onPressed: () {
                  if (groupCallController.selectedCategoryList
                      .contains(categoryTextList[i]))
                    groupCallController.selectedCategoryList
                        .remove(categoryTextList[i]);
                  else if (groupCallController.selectedCategoryList.length <
                      3)
                    groupCallController.selectedCategoryList
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
                backgroundColor: groupCallController.selectedCategoryList
                    .contains(categoryTextList[i + 2])
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                avatar: Image.asset(
                  categoryIconList[i + 2],
                  width: 13.w,
                ),
                label: Text(categoryTextList[i + 2],
                    style: TextStyle(
                      color: groupCallController.selectedCategoryList
                          .contains(categoryTextList[i + 2])
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                      fontFamily:
                      Theme.of(context).textTheme.headline4!.fontFamily,
                    )),
                onPressed: () {
                  if (groupCallController.selectedCategoryList
                      .contains(categoryTextList[i + 2]))
                    groupCallController.selectedCategoryList
                        .remove(categoryTextList[i + 2]);
                  else if (groupCallController.selectedCategoryList.length <
                      3)
                    groupCallController.selectedCategoryList
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
                backgroundColor: groupCallController.selectedCategoryList
                    .contains(categoryTextList[i + 5])
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                avatar: Image.asset(
                  categoryIconList[i + 5],
                  width: 13.w,
                ),
                label: Text(categoryTextList[i + 5],
                    style: TextStyle(
                      color: groupCallController.selectedCategoryList
                          .contains(categoryTextList[i + 5])
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                      fontFamily:
                      Theme.of(context).textTheme.headline4!.fontFamily,
                    )),
                onPressed: () {
                  if (groupCallController.selectedCategoryList
                      .contains(categoryTextList[i + 5]))
                    groupCallController.selectedCategoryList
                        .remove(categoryTextList[i + 5]);
                  else if (groupCallController.selectedCategoryList.length <
                      3)
                    groupCallController.selectedCategoryList
                        .add(categoryTextList[i + 5]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget loadImage() {
    if(postController.isDefaultImage.value)
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 21.0.h, bottom: 11.2.h),
            child: Image.asset('assets/icons/camera.png', width: 33.5.w),
          ),
          Text('????????? ????????? ????????????.', style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          )),
          Text('??? ???????????? ?????? ???????????? ???????????????.', style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          )),
        ],
      );
    else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0.h, bottom: 8.0.h),
            child: Image.file(
              postController.imageFile.value,
              height: 210.w,
            ),
          ),
        ],
      );
  }

  Future<dynamic> showDialog() {
    return Get.dialog(
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 17.0.w, bottom: 10.h),
                    child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(Icons.close, size: 25.w, color: Colors.white,)
                    )
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 14.0.w),
                  child: GestureDetector(
                    onTap: () {
                      pickAnImageFromCamera();
                      Get.back();
                      print('??: ${postController.imageFile.value.path}');
                    },
                    child: Container(
                      width: 161.w,
                      height: 129.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 22.0.h, bottom: 21.h),
                            child: Text('?????? ??????',
                                style: Theme.of(context).textTheme.headline4),
                          ),
                          Image.asset('assets/icons/camera_blue.png',
                              width: 50.w),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pickAnImageFromGallery();
                    Get.back();
                  },
                  child: Container(
                    width: 161.w,
                    height: 129.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 22.0.h, bottom: 21.h),
                          child: Text('???????????? ????????????',
                              style: Theme.of(context).textTheme.headline4),
                        ),
                        Image.asset('assets/icons/gallery.png',
                            width: 50.w),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 13.h)
          ],
        ),
      ),
    );
  }

  Future<String> pickAnImageFromGallery() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    postController.imageFile.value = File(image!.path);
    postController.isDefaultImage.value = false;
    return image.path;
  }

  Future pickAnImageFromCamera() async {
    var image = await _picker.getImage(source: ImageSource.camera);

    postController.imageFile.value = File(image!.path);
    postController.isDefaultImage.value = false;
    // uploadToFirebase(_imageFile);
  }


  Future<void> onJoin() async {
    setState(() {
      _title.text.isEmpty ? _validateError = true : _validateError = false;
    });
    await Permission.microphone.request();

    channelName =
        (10000000000000 - DateTime.now().millisecondsSinceEpoch).toString();

    RoomInfoModel roomInfo = RoomInfoModel(
        hostInfo: UserController.to.myProfile.value,
        title: _title.text,
        roomCategory: groupCallController.selectedCategoryList,
        channelName: channelName,
        notice: _notice.text,
        private:  groupCallController.isPrivate.value,
        thumbnail: 'assets/images/mic1.jpg');
    late List<UserModel> userList = [];
    userList.add(UserController.to.myProfile.value);


    types.GroupCallModel roomData = await MyFirebaseChatCore.instance.createGroupCallRoom(roomInfo: roomInfo, hostInfo: UserController.to.myProfile.value);

    // agoraController.createBroadcastRoom(
    //   UserController.to.myProfile.value,
    //   _title.text,
    //   _notice.text,
    //   broadcastInfoController.selectedCategoryList,
    //   _docId,
    //   List<String>.filled(0, '', growable: true),
    //   locationController.location.value,
    // );

    Get.off(() => GroupCallPage(roomData: roomData),);

    // Get.off(
    //       () => BroadCastPage.broadcaster(
    //     //  channelName: _docId,
    //     role: ClientRole.Broadcaster,
    //     roomData : roomData,
    //     //  userData: UserController.to.myProfile.value,
    //   ),
    // );
  }

  Future<dynamic> showDialogForReservation() {
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
                      Text('?????? ??????', style: Theme.of(context).textTheme.headline2),
                      Expanded(child: Container()),
                      GestureDetector(
                          onTap: () => Get.back(),
                          child: Icon(Icons.close, size: 25.w, color: Theme.of(context).colorScheme.onBackground,)
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Obx(() => Row(
                    children: [
                      Image.asset('assets/icons/clock_black.png', width: 26.w),
                      Padding(
                        padding: EdgeInsets.only(left: 14.0.w, right: 26.w),
                        child: Text('?????? ??????', style: Theme.of(context).textTheme.headline5),
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          width: 100.w,
                          height: 30.h,
                          child: Center(
                            child: Text(
                              DateFormat('yyyy-MM-dd').format(groupCallController.selectedDate.value),
                              style: Theme.of(context).textTheme.headline5!.copyWith(
                                  color: Theme.of(context).colorScheme.onBackground
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            // shape: BoxShape.rectangle,
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
                              DateFormat('kk:mm').format(groupCallController.selectedTime.value),
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
                        child: Text('?????? ??????', style: Theme.of(context).textTheme.headline5),
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
            hintText: '?????? ????????? ???????????????',
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
              groupCallController.tagList.add(str);
            },
          ),
        ),
        SizedBox(height: 15.h),
        Tags(
          itemCount: groupCallController.tagList.length, // required
          itemBuilder: (int index){
            final Item currentItem = Item(title:groupCallController.tagList[index]);

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
                    groupCallController.tagList.removeAt(index);
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
        //     child: Text('??????'),
        //   ),
        // )
      ],
    ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: groupCallController.selectedDate.value,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != groupCallController.selectedDate.value)
      groupCallController.selectedDate.value = picked;
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
      onTimeChange: (time) => groupCallController.selectedTime.value = time,
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
//         title: Text('??? ?????? ?????????',
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
//                 '???????????? ????????????',
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
//                 '??????',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             TextFormField(
//               controller: _title,
//               validator: (value) {
//                 if (value!.trim().isEmpty) {
//                   return '????????? ??????????????????.';
//                 }
//                 return null;
//               },
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.fromLTRB(10, 6, 0, 6),
//                 hintText: '????????? ??????????????????(15??? ??????)',
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
//                 '????????????',
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
//                   hintText: '????????? ??????????????????(100??? ??????)',
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
//                   child: Text('????????????'),
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
