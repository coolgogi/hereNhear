import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/login/setProfile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../record_controller.dart';

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
  final recorderController = Get.put(RecorderController());

  List<String> themeList = [
    '한동대',
    '유리한 녀석들',
    '졸업',
    '하고싶다',
    '간바레마쇼',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 25.w, top: 13.h),
          child: InkWell(
            onTap: () => Get.back(),
            child: Text('취소',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
          ),
        ),
        centerTitle: true,
        title: Text('프로필 편집',
            style: Theme.of(context).textTheme.headline1!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                )),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 13.h, right: 25.w),
            child: InkWell(
              onTap: null,
              child: Text('완료',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      )),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25.w, 0.h, 25.w, 20.h),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 130.h,
                  child: Center(
                      child: Obx(
                    () => Stack(
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
                                        image: AssetImage(
                                            'assets/icons/addButton_blue.png'),
                                        fit: BoxFit.cover)),
                              ),
                            ))
                      ],
                    ),
                  )),
                ),
                Divider(
                    color: Theme.of(context).colorScheme.onSurface,
                    thickness: 1.w),
                Padding(
                  padding: EdgeInsets.only(
                      left: 10.w, top: 5.h, right: 5.0.w, bottom: 8.h),
                  child: textInputList(context),
                ),
                Divider(
                    color: Theme.of(context).colorScheme.onSurface,
                    thickness: 1.w),
                SizedBox(height: 20.h),
                Text(
                  '보이스 프로필',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0.h, bottom: 32.h),
                  child: Row(
                    children: [
                      Obx(() => Row(
                            children: [
                              Container(
                                  width: 47.w,
                                  height: 42.h,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.r)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(
                                            1, 4), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () =>
                                              recorderController.toggleBlur(),
                                          child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 5.w),
                                              width: 45.w,
                                              child: Center(
                                                  child: Image.asset(
                                                      recorderController
                                                              .isPlayAudio.value
                                                          ? 'assets/icons/pause.png'
                                                          : 'assets/icons/playButton.png',
                                                      height: 16.h)))),
                                    ],
                                  )),
                              SizedBox(width: 5.w),
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.r)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 0,
                                      blurRadius: 4,
                                      offset: Offset(
                                          1, 4), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: _buildCard(
                                  // backgroundColor: Theme.of(context).colorScheme.secondary,
                                  config: CustomConfig(
                                    colors: [
                                      Color(0xFF4BACEF).withOpacity(0.2),
                                      Color(0xFF4BACEF).withOpacity(0.1),
                                      Color(0xFF634CED).withOpacity(0.1),
                                      Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.15),
                                    ],
                                    durations: [35000, 19440, 10800, 6000],
                                    heightPercentages: [0.20, 0.23, 0.25, 0.30],
                                    blur: recorderController.blur.value,
                                  ),
                                  height: 42.h,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(width: 8.w),
                      Container(
                          width: 47.w,
                          height: 42.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset:
                                    Offset(1, 4), // changes position of shadow
                              ),
                            ],
                          ),
                          child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () => recorderController.toggleBlur(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 3.0.h),
                                    child: Center(
                                        child: Image.asset(
                                            'assets/icons/reload_blue.png',
                                            height: 16.h)),
                                  ),
                                  Text('재등록',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          )),
                                ],
                              ))),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '팔로잉 카테고리',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(width: 11.w),
                    Container(
                        width: 52.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(8.r)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset:
                                  Offset(1, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () => Get.to(() => setProfilePage()),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/icons/edit.png',
                                    height: 12.h),
                                SizedBox(width: 4.w),
                                Text('편집',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                              ],
                            )))),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0.h),
              child: Container(
                height: 25.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: followingThemeList(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textInputList(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('닉네임', style: Theme.of(context).textTheme.headline4),
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
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10.w, 6.h, 0.w, 6.h),
                    hintText: '어플에서 사용할 닉네임',
                    hintStyle: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text('소개', style: Theme.of(context).textTheme.headline4),
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
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(10.w, 6.h, 0.w, 6.h),
                    hintText: '소개글',
                    hintStyle: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
              ),
            ),
          ],
        ),
      ],
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

  Widget loadImage(BuildContext context) {
    if (profileController.isDefaultImage.value)
      return Container(
        width: 80.w,
        height: 78.w,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assets/images/you.png'), fit: BoxFit.cover)),
      );
    else
      return Container(
        width: 80.w,
        height: 78.w,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: FileImage(profileController.imageFile.value),
                fit: BoxFit.cover)),
      );
  }

  _buildCard({
    Config? config,
    Color backgroundColor = Colors.transparent,
    DecorationImage? backgroundImage,
    double height = 152.0,
  }) {
    return Container(
      height: height,
      width: 216.w,
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.all(0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: WaveWidget(
          config: config!,
          backgroundColor: backgroundColor,
          backgroundImage: backgroundImage,
          size: Size(double.infinity, double.infinity),
          waveAmplitude: 0,
        ),
      ),
    );
  }

  List<Widget> followingThemeList(BuildContext context) {
    return List.generate(
        themeList.length,
        (i) => Padding(
              padding: EdgeInsets.only(right: 6.0.w),
              child: Container(
                padding: EdgeInsets.only(left: 7.w, right: 7.0.w),
                child: Center(
                    child: Text('#${themeList[i]}',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Theme.of(context).colorScheme.primary))),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  border: Border.all(
                      width: 1.5.w,
                      color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.all(Radius.circular(13.5)),
                ),
              ),
            ));
  }
}
