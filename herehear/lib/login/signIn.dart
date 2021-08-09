import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/login/siginIn_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
              padding: EdgeInsets.only(top: 100.0.h, bottom: 60.0.h),
              child: Text(
                "반갑습니다.",
                style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            Text(
              "아이디",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0.h, bottom: 60.0.h),
              child: TextFormField(
                controller: idController,
                decoration: InputDecoration(
                  hintText: "아이디를 입력하세요.",
                ),
              ),
            ),
            Text(
              "패스워드",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
            Obx(() => Padding(
              padding: EdgeInsets.only(top: 10.0.h, bottom: 17.h),
              child: TextFormField(
                controller: pwdController,
                obscureText: controller.is_obscureText.value,
                decoration: InputDecoration(
                  hintText: "비밀번호를 입력하세요.",
                  // isDense: true,
                  // contentPadding: EdgeInsets.fromLTRB(0, 0.h, 0, 0.h),
                  suffixIcon: IconButton(
                    onPressed: () => controller.is_obscureText.value = !(controller.is_obscureText.value),
                    icon: Image.asset('assets/icons/bigEye.png', width: 30.w,),
                  ),
                ),
              ),
            )),
            Padding(
              padding: EdgeInsets.only(bottom: 65.0.h),
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
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.all(Radius.circular(14.r)),
              ),
              child: ElevatedButton(
                onPressed: null,
                child: Text(
                  '로그인',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary
                  )),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: null,
                    child: Text('계정 생성', style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
