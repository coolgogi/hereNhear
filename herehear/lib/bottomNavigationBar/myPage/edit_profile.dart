import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/community/free_board/createPost.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {

  RxBool isDefaultImage = true.obs;
  var imageFile = File('').obs;
}

class EditMyPage extends StatelessWidget {
  final _picker = ImagePicker();
  final nameController = TextEditingController();
  final nickNameController = TextEditingController();
  final introduceController = TextEditingController();
  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 25.w, top: 13.h),
          child: InkWell(
            onTap: () => Get.back(),
            child: Text('취소', style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            )),
          ),
        ),
        centerTitle: true,
        title: Text('프로필 편집', style: Theme.of(context).textTheme.headline1!.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
        )),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 13.h, right: 25.w),
            child: InkWell(
              onTap: null,
              child: Text('완료', style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              )),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25.w, 0.h, 30.w, 20.h),
        child: Column(
          children: [
            Container(
              height: 130.h,
              child: Center(
                child: Obx(() => Stack(
                  children: [
                    loadImage(context),
                    Positioned(
                        left: 50.w,
                        top: 50.w,
                        child: InkWell(
                          onTap: () => showDialog(context),
                          child: Container(
                            width: 26.w,
                            height: 26.w,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/icons/addButton_blue.png'),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                        ))
                  ],
                ),)
              ),
            ),
            Divider(thickness: 1.5.w),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  '이름',
                  style: Theme.of(context).textTheme.headline2
                ),
                Expanded(child: Container()),
                Container(
                  width: 220.w,
                  child: TextFormField(
                    controller: nameController,
                    // validator: (value) {
                    //   if (value!.trim().isEmpty) {
                    //     return '제목을 입력해주세요.';
                    //   }
                    //   return null;
                    // },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:  BorderSide(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:  BorderSide(color: Theme.of(context).colorScheme.onBackground),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(10.w, 6.h, 0.w, 6.h),
                      hintText: '이름',
                      hintStyle: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface
                      )
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                    '닉네임',
                    style: Theme.of(context).textTheme.headline2
                ),
                Expanded(child: Container()),
                Container(
                  width: 220.w,
                  child: TextFormField(
                    controller: nickNameController,
                    // validator: (value) {
                    //   if (value!.trim().isEmpty) {
                    //     return '제목을 입력해주세요.';
                    //   }
                    //   return null;
                    // },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:  BorderSide(color: Theme.of(context).colorScheme.onSurface),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:  BorderSide(color: Theme.of(context).colorScheme.onBackground),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(10.w, 6.h, 0.w, 6.h),
                        hintText: '어플에서 사용할 닉네임',
                        hintStyle: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface
                        )
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                    '소개',
                    style: Theme.of(context).textTheme.headline2
                ),
                Expanded(child: Container()),
                Container(
                  width: 220.w,
                  child: TextFormField(
                    controller: introduceController,
                    // validator: (value) {
                    //   if (value!.trim().isEmpty) {
                    //     return '제목을 입력해주세요.';
                    //   }
                    //   return null;
                    // },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:  BorderSide(color: Theme.of(context).colorScheme.onSurface),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:  BorderSide(color: Theme.of(context).colorScheme.onBackground),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(10.w, 6.h, 0.w, 6.h),
                        hintText: '소개글',
                        hintStyle: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface
                        )
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

  Future<String> pickAnImageFromGallery() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    profileController.imageFile.value = File(image!.path);
    profileController.isDefaultImage.value = false;
    return image.path;
  }

  Future pickAnImageFromCamera() async {
    var image = await _picker.getImage(source: ImageSource.camera);

    profileController.imageFile.value = File(image!.path);
    profileController.isDefaultImage.value = false;
    // uploadToFirebase(_imageFile);
  }

  Future<dynamic> showDialog(BuildContext context) {
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
                      print('??: ${profileController.imageFile.value.path}');
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

  Widget loadImage(BuildContext context) {
    if(profileController.isDefaultImage.value)
      return Container(
        width: 80.w,
        height: 78.w,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assets/images/you.png'),
                fit: BoxFit.cover
            )
        ),
      );
    else
      return Container(
        width: 80.w,
        height: 78.w,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: FileImage(profileController.imageFile.value),
                fit: BoxFit.cover
            )
        ),
      );
  }
}
