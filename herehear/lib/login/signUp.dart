import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/login/phone_certification.dart';
import 'package:herehear/login/siginIn_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/login/signUp_controller.dart';


class RegisterPage extends StatelessWidget {
  final loginController = Get.put(LoginController());
  final nickNameController = TextEditingController();
  final idController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmPwdController = TextEditingController();

  final registerController = Get.put(RegisterController());

  final  validNumbers = RegExp(r'(\d+)');
  final  validAlphabet = RegExp(r'[a-zA-Z]');
  final  validSpecial = RegExp(r'^[a-zA-Z0-9 ]+$');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    registerController.isNicknameActive.value = false;
    registerController.isIdActive.value = false;
    registerController.isPwdActive.value = false;
    registerController.isConfirmPwdActive.value = false;

    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Obx(() => Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 40.0.w, top: 60.h, right: 35.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "닉네임",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: registerController.isNicknameActive.value? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30.0.h),
                      child: TextFormField(

                        controller: nickNameController,
                        focusNode: registerController.nickNameFocus.value,
                        decoration: InputDecoration(
                          errorStyle: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error,),
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(0.w, 12.h, 3.w, 0.h),
                            child: GestureDetector(
                              onTap: () => Get.defaultDialog(
                                title: '',
                                middleText: registerController.checkNickname(nickNameController.text) != null? '사용할 수 없는 닉네임입니다'
                                    : registerController.isExistNickname.value? '이미 존재하는 닉네임입니다.' : '사용 가능한 닉네임입니다.',
                                textConfirm: '확인',
                                buttonColor: Theme.of(context).colorScheme.background,
                                confirmTextColor: Theme.of(context).colorScheme.onBackground,
                                onConfirm: () => Get.back(),
                              ),
                              child: Text('중복확인', style:Theme.of(context).textTheme.headline6!.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                            ),
                          ),
                        ),
                        onTap: () {
                          registerController.isNicknameActive.value = true;
                          registerController.isIdActive.value = false;
                          registerController.isPwdActive.value = false;
                          registerController.isConfirmPwdActive.value = false;
                        },
                        validator: (value) => registerController.checkNickname(value!),
                      ),
                    ),
                    Text(
                      "아이디",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: registerController.isIdActive.value? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0.h),
                      child: TextFormField(
                        controller: idController,
                        focusNode: registerController.idFocus.value,
                        onTap: () {
                          registerController.isNicknameActive.value = false;
                          registerController.isIdActive.value = true;
                          registerController.isPwdActive.value = false;
                          registerController.isConfirmPwdActive.value = false;
                        },
                        validator: (value) => registerController.checkPossibleId(value!),
                        decoration: InputDecoration(
                          errorStyle: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error,),
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(0.w, 12.h, 3.w, 0.h),
                            child: GestureDetector(
                              onTap: () => Get.defaultDialog(
                                title: '',
                                middleText: registerController.checkPossibleId(idController.text) != null? '사용할 수 없는 아이디입니다'
                                    : registerController.isExistID.value? '이미 존재하는 아이디입니다.' : '사용 가능한 아이디입니다.',
                                textConfirm: '확인',
                                buttonColor: Theme.of(context).colorScheme.background,
                                confirmTextColor: Theme.of(context).colorScheme.onBackground,
                                onConfirm: () => Get.back(),
                              ),
                              child: Text('중복확인', style:Theme.of(context).textTheme.headline6!.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // registerController.
                    Padding(
                      padding: EdgeInsets.only(bottom: 22.0.h),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, size: 15.w, color: Theme.of(context).colorScheme.onSurface),
                          SizedBox(width: 4.5.w),
                          Text('6~12자 영문, 숫자로 입력해 주세요.', style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          )),
                        ],
                      ),
                    ),
                    Text(
                      "비밀번호",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: registerController.isPwdActive.value? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: TextFormField(
                        controller: pwdController,
                        focusNode: registerController.pwdFocus.value,
                        obscureText: registerController.isObscureText.value,
                        decoration: InputDecoration(
                          errorStyle: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error,),
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(top: 0.5.h),
                            child: IconButton(
                              onPressed: () => registerController.isObscureText.value = !(registerController.isObscureText.value),
                              icon: Image.asset('assets/icons/bigEye.png', width: 30.w,),
                            ),
                          ),
                        ),
                        validator: (value) => registerController.checkPossiblePassword(value!),
                        onTap: () {
                          registerController.isNicknameActive.value = false;
                          registerController.isIdActive.value = false;
                          registerController.isPwdActive.value = true;
                          registerController.isConfirmPwdActive.value = false;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 22.0.h),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 13.0.h),
                            child: Icon(Icons.error_outline, size: 15.w, color: Theme.of(context).colorScheme.onSurface),
                          ),
                          SizedBox(width: 4.5.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('비밀번호는 영문, 숫자, 특수문자(.!@#%)를 혼합하여', style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              )),
                              Text('8~20자로 입력해 주세요.', style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "비밀번호 확인",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: registerController.isConfirmPwdActive.value? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40.h),
                      child: TextFormField(
                        controller: confirmPwdController,
                        focusNode: registerController.confirmPwdFocus.value,
                        obscureText: registerController.isObscureText.value,
                        decoration: InputDecoration(
                          errorStyle: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error,),
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(top: 0.5.h),
                            child: IconButton(
                              onPressed: () => registerController.isObscureText.value = !(registerController.isObscureText.value),
                              icon: Image.asset('assets/icons/bigEye.png', width: 30.w,),
                            ),
                          ),
                        ),
                        validator: (value) => registerController.checkConfirmPassword(value!, pwdController.text),
                        onTap: () {
                          registerController.isNicknameActive.value = false;
                          registerController.isIdActive.value = false;
                          registerController.isPwdActive.value = false;
                          registerController.isConfirmPwdActive.value = true;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(children: <Widget>[
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 16.0.w, right: 5.0.w),
                      child: Divider(
                        thickness: 0.8.h,
                        height: 36,
                      )),
                ),
                Text('또는 다른 서비스 계정으로 로그인', style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                )),
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 5.0.w, right: 16.0.w),
                      child: Divider(
                        thickness: 0.8.h,
                        height: 36,
                      )),
                ),
              ]),
              Padding(
                padding: EdgeInsets.only(top: 15.h, bottom: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: null,
                      child: Image.asset('assets/icons/kakao.png', width: 40.w),
                    ),
                    SizedBox(width: 15.w),
                    GestureDetector(
                      onTap: null,
                      child: Image.asset('assets/icons/naver.png', width: 40.w),
                    ),
                    SizedBox(width: 15.w),
                    GestureDetector(
                      onTap: null,
                      child: Image.asset('assets/icons/facebook.png', width: 40.w),
                    ),
                    SizedBox(width: 15.w),
                    GestureDetector(
                      onTap: () => loginController.loginWithGoogle(),
                      child: Image.asset('assets/icons/google.png', width: 40.w),
                    ),
                    SizedBox(width: 15.w),
                    GestureDetector(
                      onTap: null,
                      child: Image.asset('assets/icons/apple.png', width: 40.w),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40.0.w, right: 30.w, bottom: 55.0.h),
                child: Text('SNS 계정으로 간편하게 가입하여 서비스를 이용하실 수 있습니다. 기존 계정과는 연동되지 않으니 이용에 참고하세요.', style: Theme.of(context).textTheme.bodyText1),
              ),
            ],
          ),
        ),
      )),
      bottomSheet: SizedBox(
        height: 44.h,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: (nickNameController.text.isEmpty || idController.text.isEmpty || pwdController.text.isEmpty || confirmPwdController.text.isEmpty)?
            MaterialStateProperty.all(Theme.of(context).colorScheme.onSurface) : MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
          ),
          onPressed: () {
            if(_formKey.currentState!.validate())
              Get.to(CertificationPage());
          },
          child: Text('다음', style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary
          )),
        ),
      ),
    );
  }
}
