import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/login/signIn.dart';
import 'package:herehear/login/signUp_complete.dart';

import 'signUp_controller.dart';

class AgreementTOSPage extends StatelessWidget {
  final registerController = Get.put(RegisterController());

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(40.w, 100.h, 42.w, 0.h),
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('이용약관에 동의하시면',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )),
                      Text('회원가입이 완료됩니다.',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )),
                      SizedBox(height: 130.h),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: Checkbox(
                                value: registerController
                                    .allAgree.value, //처음엔 false
                                onChanged: (value) {
                                  registerController.allAgree.value = value!;
                                  registerController.firstTermAgree.value =
                                      value;
                                  registerController.secondTermAgree.value =
                                      value;
                                  registerController.thirdTermAgree.value =
                                      value;
                                }),
                          ),
                          Text(
                            '전체 약관에 동의합니다.',
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: Checkbox(
                              value: registerController
                                  .firstTermAgree.value, //처음엔 false
                              onChanged: (value) => registerController
                                  .firstTermAgree.value = value!,
                            ),
                          ),
                          Text(
                            '서비스 이용약관',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text('(필수)',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                          Expanded(child: Container()),
                          IconButton(
                              onPressed: null, icon: Icon(Icons.expand_more))
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: Checkbox(
                              value: registerController
                                  .secondTermAgree.value, //처음엔 false
                              onChanged: (value) => registerController
                                  .secondTermAgree.value = value!,
                            ),
                          ),
                          Text(
                            '개인정보처리방침',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text('(필수)',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                          Expanded(child: Container()),
                          IconButton(
                              onPressed: null, icon: Icon(Icons.expand_more))
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: Checkbox(
                              value: registerController
                                  .thirdTermAgree.value, //처음엔 false
                              onChanged: (value) => registerController
                                  .thirdTermAgree.value = value!,
                            ),
                          ),
                          Text(
                            '서비스 이용약관(선택)',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Expanded(child: Container()),
                          IconButton(
                              onPressed: null, icon: Icon(Icons.expand_more))
                        ],
                      ),
                    ],
                  )),
            ),
            Expanded(child: Container()),
            Obx(() => SizedBox(
                  height: 44.h,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          (registerController.firstTermAgree.value &&
                                  registerController.secondTermAgree.value)
                              ? MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary)
                              : MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.onSurface),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate())
                        Get.to(RegisterCompletePage());
                    },
                    child: Text('다음',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
