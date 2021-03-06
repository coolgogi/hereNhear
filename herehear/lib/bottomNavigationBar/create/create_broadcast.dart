import 'dart:io';
import 'dart:math';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/agora/agoraCreateController.dart';
import 'package:herehear/bottomNavigationBar/community/free_board/createPost.dart';
import 'package:herehear/broadcast/broadcast.dart';
import 'package:herehear/broadcast/data/broadcast_model.dart' as types;
import 'package:herehear/broadcast/data/broadcast_room_info.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:image_picker/image_picker.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _notice = TextEditingController();
  String channelName = '';
  late int randomNum;
  final _picker = ImagePicker();

  List<String> defaultImgURL = [
    'assets/images/broadcast/asmr.jpg',
    'assets/images/broadcast/bread.jpg',
    'assets/images/broadcast/food.jpg',
    'assets/images/broadcast/piano.png',
    'assets/images/broadcast/sea.jpg',
    'assets/images/broadcast/talk.jpg',
    'assets/images/broadcast/gs.png',
  ];

  //unused variable
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
    'assets/icons/categoryIcon/book.png',
    'assets/icons/categoryIcon/eyes.png',
    'assets/icons/categoryIcon/talk.png',
    'assets/icons/categoryIcon/smile.png',
    'assets/icons/categoryIcon/advertise.png',
    'assets/icons/categoryIcon/sale.png',
    'assets/icons/categoryIcon/music.png',
    'assets/icons/categoryIcon/healing.png',
    'assets/icons/categoryIcon/mike2.png',
    'assets/icons/categoryIcon/tree.png',
  ];

  final broadcastInfoController = Get.put(BroadcastInfoController());
  final agoraController = Get.put(AgoraCreateController());
  final locationController = Get.put(LocationController());
  final postController = Get.put(PostController());

  @override
  void dispose() {
    broadcastInfoController.selectedCategoryList.value
        .removeRange(0, broadcastInfoController.selectedCategoryList.length);
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
    // broadcastInfoController.selectedCategoryList!.value.removeRange(0, broadcastInfoController.selectedCategoryList!.length);

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
        body: Obx(() => ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16.0.w, 20.h, 17.w, 0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 11.h),
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
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                            ),
                            contentPadding:
                                EdgeInsets.fromLTRB(10.w, 6.h, 0.w, 6.h),
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
                            keyboardType: TextInputType.multiline,
                            controller: _notice,
                            textInputAction: TextInputAction.newline,
                            maxLines: 20,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              hintText: '공지를 입력해주세요(100자 이내)',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
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
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              Expanded(child: Container()),
                              GestureDetector(
                                  onTap: () => broadcastInfoController
                                      .selectedCategoryList
                                      .removeRange(
                                          0,
                                          broadcastInfoController
                                              .selectedCategoryList.length),
                                  child: Container(
                                    width: 70.w,
                                    height: 32.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/reload.png',
                                          width: 15.w,
                                        ),
                                        SizedBox(
                                          width: 6.w,
                                        ),
                                        Text('초기화',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                )),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        categorySelectList(),
                        Padding(
                          padding: EdgeInsets.only(left: 13.0.w, top: 10.h),
                          child: Text(
                            '* 카테고리는 최대 3개까지 선택 가능합니다.',
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 22.h,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 18.h),
                          child: Text(
                            '썸네일 이미지',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Theme.of(context).colorScheme.background,
                            border: Border.all(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          child: Obx(() => Column(
                                children: [
                                  loadImage(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 10.0.h, bottom: 21.h),
                                    child: Container(
                                      width: 90.w,
                                      height: 25.h,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.only(
                                                    left: 0.w, right: 0.w)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0.r),
                                                    side: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    )))),
                                        onPressed: showDialog,
                                        child: Text(
                                            postController.isDefaultImage.value
                                                ? '이미지 업로드'
                                                : '이미지 변경',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
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
                              if (_formKey.currentState!.validate()) onJoin();
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: (_title.text.isEmpty ||
                                      broadcastInfoController
                                          .selectedCategoryList.isEmpty)
                                  ? MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.onSecondary)
                                  : MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary),
                            ),
                            child: Text('완료'),
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
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
                      fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                      fontFamily:
                          Theme.of(context).textTheme.headline4!.fontFamily,
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
                      fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                      fontFamily:
                          Theme.of(context).textTheme.headline4!.fontFamily,
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

  Widget loadImage() {
    if (postController.isDefaultImage.value) {
      randomNum = Random().nextInt(7);
      print('defaultImgURL[$randomNum]: ${defaultImgURL[randomNum]}');
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 21.0.h, bottom: 11.2.h),
            child: Image.asset('assets/icons/camera.png', width: 33.5.w),
          ),
          Text('사진을 업로드 해주세요.',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
          Text('미 업로드시 자동 이미지가 적용됩니다.',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
        ],
      );
    } else
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
                        child: Icon(
                          Icons.close,
                          size: 25.w,
                          color: Colors.white,
                        ))),
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
                            child: Text('사진 촬영',
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
                          child: Text('앨범에서 가져오기',
                              style: Theme.of(context).textTheme.headline4),
                        ),
                        Image.asset('assets/icons/gallery.png', width: 50.w),
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
        roomCategory: broadcastInfoController.selectedCategoryList,
        channelName: channelName,
        notice: _notice.text,
        thumbnail: 'assets/images/mic1.jpg');
    late List<UserModel> userList = [];
    userList.add(UserController.to.myProfile.value);

    types.BroadcastModel roomData = await MyFirebaseChatCore.instance
        .createGroupRoom(
            roomInfo: roomInfo, hostInfo: UserController.to.myProfile.value);

    await _handleCameraAndMic(Permission.microphone);
    Get.off(
      () => BroadCastPage.broadcaster(
        role: ClientRole.Broadcaster,
        roomData: roomData,
      ),
    );
  }
}

Future<void> _handleCameraAndMic(Permission permission) async {
  final status = await permission.request();
}
