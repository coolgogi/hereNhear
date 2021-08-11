import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/login/siginIn_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/login/signUp.dart';



class LoginPage extends StatelessWidget {
  final controller = Get.put(LoginController());
  final idController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Padding(
        padding: EdgeInsets.only(left: 40.0.w, right: 55.w),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 85.0.h, bottom: 50.0.h),
              child: Text(
                "반갑습니다.",
                style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            Obx(() => Text(
              "아이디",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: controller.isIdActive.value? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w400,
              ),
            )),
            Padding(
              padding: EdgeInsets.only(top: 10.0.h, bottom: 43.0.h),
              child: TextFormField(
                controller: idController,
                onTap: () {
                  controller.isIdActive.value = true;
                  controller.isPwdActive.value = false;
                },
                decoration: InputDecoration(
                  hintText: "아이디를 입력하세요.",
                ),
              ),
            ),
            Obx(() => Text(
              "패스워드",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: controller.isPwdActive.value? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w400,
              ),
            )),
            Obx(() => Padding(
              padding: EdgeInsets.only(top: 10.0.h, bottom: 17.h),
              child: TextFormField(
                controller: pwdController,
                obscureText: controller.isObscureText.value,
                onTap: () {
                  controller.isPwdActive.value = true;
                  controller.isIdActive.value = false;
                },
                decoration: InputDecoration(
                  hintText: "비밀번호를 입력하세요.",
                  // isDense: true,
                  // contentPadding: EdgeInsets.fromLTRB(0, 0.h, 0, 0.h),
                  suffixIcon: IconButton(
                    onPressed: () => controller.isObscureText.value = !(controller.isObscureText.value),
                    icon: Image.asset('assets/icons/bigEye.png', width: 30.w,),
                  ),
                ),
              ),
            )),
            Padding(
              padding: EdgeInsets.only(bottom: 55.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: null,
                    child: Text('비밀번호를 잊으셨나요?', style: Theme.of(context).textTheme.headline6!.copyWith(
                     color: Theme.of(context).colorScheme.onSurface,
                    )),
                  )
                ],
              ),
            ),
            Container(
              height: 44.h,
              decoration: BoxDecoration(
              ),
              child: ElevatedButton(
                onPressed: () => controller.loginWithGoogle(),
                child: Text(
                  '로그인',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary
                  )),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            side: BorderSide(color: Theme.of(context).colorScheme.primary)
                        )
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0.h, bottom: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Get.to(RegisterPage()),
                    child: Text('계정 생성', style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 100.0.w, right: 100.w, bottom: 15.h),
              child: Divider(thickness: 0.6.h,),
            ),
            Center(
              child: Text('또는 다른 서비스 계정으로 로그인', style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 27.h, bottom: 20.h),
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
                    onTap: () => controller.loginWithGoogle(),
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
          ],
        ),
      ),
    );
  }
}
