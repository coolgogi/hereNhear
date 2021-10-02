import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/bottomNavigationBar/myPage/edit_profile.dart';
import 'package:herehear/login/agreeToS.dart';
import 'package:herehear/login/signUp_controller.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sms_autofill/sms_autofill.dart';

class setProfilePage extends StatefulWidget {
  @override
  _setProfilePageState createState() => _setProfilePageState();
}

class _setProfilePageState extends State<setProfilePage> {
  final _picker = ImagePicker();
  final nameController = TextEditingController();
  final nickNameController = TextEditingController();
  final introduceController = TextEditingController();
  final pwdController = TextEditingController();
  final profileController = Get.put(ProfileController());
  final _user = FirebaseAuth.instance.currentUser!;
  final UserController userController = Get.put(UserController());

  final registerController = Get.put(RegisterController());

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final validNumbers = RegExp(r'(\d+)');
  final validAlphabet = RegExp(r'[a-zA-Z]');
  final validSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  final SmsAutoFill _autoFill = SmsAutoFill();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    registerController.isPhoneNumActive.value = false;
    registerController.isCertificationNumActive.value = false;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(25.w, 60.h, 30.w, 20.h),
                  child: Column(
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
                    ],
                  ),
                ),
                Expanded(child: Container()),
                SizedBox(
                  height: 44.h,
                  ///////////////////////////////////////////////////////////////////////////
                  width: MediaQuery.of(context).size.width,
                  //이게 왜??? 진짜 절대 모르겠어;;;;
                  ///////////////////////////////////////////////////////////////////////////
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: (nameController.text.isEmpty ||
                              nickNameController.text.isEmpty)
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onSecondary)
                          : MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      //닉네임, 비밀번호가 비어있지 않게 확인하기
                      Map<String, dynamic> _data = new Map();
                      _data['nickName'] = nickNameController.text;
                      _data['des'] = introduceController.text;
                      updatePwd(pwdController.text);
                      updateData(_user.uid, _data);
                      if (_formKey.currentState!.validate()) {
                        Get.to(AgreementTOSPage());
                      }
                    },
                    child: Text('다음',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Theme.of(context).colorScheme.background)),
                  ),
                )
              ],
            )));
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
            Text('비밀번호', style: Theme.of(context).textTheme.headline4),
            Expanded(child: Container()),
            Container(
              width: 220.w,
              child: TextFormField(
                controller: pwdController,
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
                    hintText: '비밀번호',
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

  Future<void> updateData(String _uid, Map<String, dynamic> data) async {
    CollectionReference _firebase =
        FirebaseFirestore.instance.collection('users');
    print("=======set data=======");
    print(data['nickName']);
    print("======================");

    _firebase.doc(_uid).update(data);
    UserController.to.myProfile.value.nickName = data['nickName'];
  }

  Future<void> updatePwd(String pwd) async {
    await _user.updatePassword(pwd);
  }
}
