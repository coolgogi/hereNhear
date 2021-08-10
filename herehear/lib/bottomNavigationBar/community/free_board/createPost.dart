import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/etc/delete/contest/contest.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController {
  RxBool isDefaultImage = true.obs;
  var imageFile = File('').obs;
}


class CreatePostPage extends StatefulWidget {
  late UserModel userData;

  CreatePostPage.withData(UserModel uData) {
    this.userData = uData;
  }

  CreatePostPage();

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _notice = TextEditingController();
  String _docId = '';

  //unused variable
  bool _validateError = false;

  final locationController = Get.put(LocationController());
  final postController = Get.put(PostController());

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
        title: Text('HERE 게시판 글쓰기',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => {
            Get.back(),
          },
        ),
      ),
      body: ListView(
        children: [
          Container(
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
                      hintText: '공지를 입력해주세요(100자 이내)',
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
                  height: 22.h,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 18.h),
                  child: Text(
                    '사진',
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
                            child: Text(postController.isDefaultImage.value? '이미지 업로드' : '이미지 변경', style: Theme.of(context).textTheme.headline6!.copyWith(
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
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSecondary),
                    ),
                    onPressed: null,
                    child: Text('완료', style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Theme.of(context).colorScheme.background
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Future<dynamic> showDialog() {
    return Get.dialog(
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 14.0.w),
                  child: GestureDetector(
                    onTap: () {
                      pickAnImageFromCamera().then((value) => Get.back());
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
                          Image.asset('assets/images/camera_blue.png',
                              width: 50.w),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pickAnImageFromGallery().whenComplete(() => Get.back());
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
                        Image.asset('assets/icons/gallery.png',
                            width: 50.w),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
          Text('사진을 업로드 해주세요.', style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          )),
          Text('미 업로드시 자동 이미지가 적용됩니다.', style: Theme.of(context).textTheme.bodyText1!.copyWith(
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

  // Future<void> onJoin() async {
  //   setState(() {
  //     _title.text.isEmpty ? _validateError = true : _validateError = false;
  //   });
  //   await Permission.microphone.request();
  //
  //   _docId =
  //       (10000000000000 - DateTime.now().millisecondsSinceEpoch).toString();
  //
  //   RoomInfoModel roomInfo = RoomInfoModel(
  //       hostInfo: UserController.to.myProfile.value,
  //       title: _title.text,
  //       roomCategory: broadcastInfoController.selectedCategoryList,
  //       docId: _docId,
  //       notice: _notice.text,
  //       thumbnail: 'assets/images/mic1.jpg');
  //   late List<UserModel> userList = [];
  //   userList.add(UserController.to.myProfile.value);
  //
  //
  //   types.BroadcastModel roomData = await MyFirebaseChatCore.instance.createGroupRoom(roomInfo: roomInfo, hostInfo: UserController.to.myProfile.value);
  //
  //   Get.off(
  //         () => BroadCastPage.myBroadcaster(
  //       //  channelName: _docId,
  //       role: ClientRole.Broadcaster,
  //       roomData : roomData,
  //       //  userData: UserController.to.myProfile.value,
  //     ),
  //   );
  // }
}
