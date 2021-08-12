import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/login/signIn.dart';

import 'signUp_controller.dart';

class RegisterCompletePage extends StatelessWidget {

  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(40.w, 100.h, 42.w, 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('회원가입이 성공적으로', style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                )),
                Text('완료되었습니다!', style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                )),
              ],
            ),
          ),
          Expanded(child: Container()),
          SizedBox(
            height: 44.h,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary)),
              onPressed: () => Get.to(LoginPage()),
              child: Text('완료', style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary
              )),
            ),
          ),
        ],
      ),
    );
  }
}
