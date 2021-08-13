import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/etc/delete/contest/contest.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'free_board.dart';

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
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16.0.w, 33.h, 17.w, 30.h),
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
                      hintText: '제목을 입력해주세요',
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 11.h),
                    child: Text(
                      '내용',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Container(
                    height: 104.h,
                    child: TextFormField(
                      controller: _notice,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return '제목을 입력해주세요.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      maxLines: 30,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: '내용를 입력해주세요',
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
                        elevation: MaterialStateProperty.all(0),
                          backgroundColor: (_title.text.isEmpty || _notice.text.isEmpty)? MaterialStateProperty.all(Theme.of(context).colorScheme.onSecondary)
                                  : MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () {
                        if(_formKey.currentState!.validate())
                          return null;
                        Get.off(FreeBoardPage()); // 여기서 게시글 생성 함수 넣으시면 됩니다~
                      },
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
}
