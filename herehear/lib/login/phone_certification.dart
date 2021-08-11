import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/login/agreeToS.dart';
import 'package:herehear/login/signUp.dart';
import 'package:herehear/login/signUp_controller.dart';


class CertificationPage extends StatelessWidget {
  TextEditingController phoneNumController = TextEditingController();

  TextEditingController certificationController = TextEditingController();

  final registerController = Get.put(RegisterController());

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final  validNumbers = RegExp(r'(\d+)');
  final  validAlphabet = RegExp(r'[a-zA-Z]');
  final  validSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  @override
  Widget build(BuildContext context) {
    registerController.isPhoneNumActive.value = false;
    registerController.isCertificationNumActive.value = false;

    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Obx(() => Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 40.0.w, top: 75.h, right: 40.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "휴대번호",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: registerController.isNicknameActive.value? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30.0.h),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: phoneNumController,
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
                                  middleText: registerController.isExistID.value? '이미 존재하는 아이디입니다.' : '사용 가능한 아이디입니다.',
                                  textConfirm: '확인',
                                  buttonColor: Theme.of(context).colorScheme.background,
                                  confirmTextColor: Theme.of(context).colorScheme.onBackground,
                                  onConfirm: () => Get.back(),
                                ),
                                child: Text('인증받기', style:Theme.of(context).textTheme.headline6!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                              ),
                            ),
                          ),
                          onTap: () {
                            registerController.isPhoneNumActive.value = true;
                            registerController.isCertificationNumActive.value = false;
                          },
                          validator: (value) => registerController.checkPhoneNumber(value!),
                        ),
                      ),
                      Text(
                        "인증번호 6자리",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: registerController.isIdActive.value? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.0.h),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: certificationController,
                          decoration: InputDecoration(
                              errorStyle: Theme.of(context).textTheme.headline6!.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.error,),
                              )
                          ),
                          onTap: () {
                            registerController.isPhoneNumActive.value = false;
                            registerController.isCertificationNumActive.value = true;
                          },
                          validator: (value) => registerController.checkCertificationNumber(value!),
                        ),
                      ),
                      // registerController.
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.0.h),
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
                    ])),
            Expanded(child: Container()),
            // GestureDetector(
            //     onTap: () {
            //       if(_formKey.currentState!.validate())
            //         Get.to(CertificationPage());
            //     },
            //     child: Container(
            //       color: certificationController.text.isEmpty?
            //       Theme.of(context).colorScheme.onSurface
            //           : Theme.of(context).colorScheme.primary,
            //       width: 375.w,
            //       height: 44.h,
            //       child: Center(child: Text('다음', style: Theme.of(context).textTheme.headline4!.copyWith(
            //           color: Theme.of(context).colorScheme.onPrimary
            //       ))),
            //     )),
            SizedBox(
              height: 44.h,
              ///////////////////////////////////////////////////////////////////////////
              width: MediaQuery.of(context).size.width, //이게 왜??? 진짜 절대 모르겠어;;;;
              ///////////////////////////////////////////////////////////////////////////
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: (phoneNumController.text.isEmpty || certificationController.text.isEmpty)? MaterialStateProperty.all(Theme.of(context).colorScheme.onSecondary)
                      : MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                ),
                onPressed: () {
                  if(_formKey.currentState!.validate()) {
                    Get.to(AgreementTOSPage());
                  }
                },
                child: Text('다음', style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).colorScheme.background
                )),
              ),
            ),

            // SizedBox(
            //   height: 44.h,
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ButtonStyle(
            //       elevation: MaterialStateProperty.all(0),
            //       backgroundColor: registerController.submitButtonActive.value? MaterialStateProperty.all(Theme.of(context).colorScheme.primary)
            //           : MaterialStateProperty.all(Theme.of(context).colorScheme.onSurface),
            //     ),
            //     onPressed: null,
            //     child: Text('다음', style: Theme.of(context).textTheme.headline4!.copyWith(
            //         color: Theme.of(context).colorScheme.onPrimary
            //     )),
            //   ),
            // ),
          ],
        ),
      )),
    );
  }
}


