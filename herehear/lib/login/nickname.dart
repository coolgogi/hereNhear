import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/login/phone_certification.dart';
import 'package:herehear/login/siginIn_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/login/nickname_controller.dart';

class NicknamePage extends StatelessWidget {
  final loginController = Get.put(LoginController());
  final nickNameController = TextEditingController();
  final idController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmPwdController = TextEditingController();

  final registerController = Get.put(NicknameController());

  final validNumbers = RegExp(r'(\d+)');
  final validAlphabet = RegExp(r'[a-zA-Z]');
  final validSpecial = RegExp(r'^[a-zA-Z0-9 ]+$');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    registerController.isNicknameActive.value = false;
    registerController.isIdActive.value = false;
    registerController.isPwdActive.value = false;
    registerController.isConfirmPwdActive.value = false;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(() => Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 40.0.w, top: 60.h, right: 35.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "닉네임",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                color: registerController.isNicknameActive.value
                                    ? Theme.of(context).colorScheme.onBackground
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.0.h),
                          child: TextFormField(
                            controller: nickNameController,
                            focusNode: registerController.nickNameFocus.value,
                            decoration: InputDecoration(
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              suffixIcon: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.w, 12.h, 3.w, 0.h),
                                child: GestureDetector(
                                  onTap: () => Get.defaultDialog(
                                    title: '',
                                    middleText:
                                        registerController.checkNickname(
                                                    nickNameController.text) !=
                                                null
                                            ? '사용할 수 없는 닉네임입니다'
                                            : registerController
                                                    .isExistNickname.value
                                                ? '이미 존재하는 닉네임입니다.'
                                                : '사용 가능한 닉네임입니다.',
                                    textConfirm: '확인',
                                    buttonColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    confirmTextColor: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    onConfirm: () => Get.back(),
                                  ),
                                  child: Text('중복확인',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          )),
                                ),
                              ),
                            ),
                            onTap: () {
                              registerController.isNicknameActive.value = true;
                              registerController.isIdActive.value = false;
                              registerController.isPwdActive.value = false;
                              registerController.isConfirmPwdActive.value =
                                  false;
                            },
                            validator: (value) =>
                                registerController.checkNickname(value!),
                          ),
                        ),
                        Text(
                          "프로필",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                color: registerController.isIdActive.value
                                    ? Theme.of(context).colorScheme.onBackground
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
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
            backgroundColor: (nickNameController.text.isEmpty ||
                    idController.text.isEmpty ||
                    pwdController.text.isEmpty ||
                    confirmPwdController.text.isEmpty)
                ? MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onSurface)
                : MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) Get.to(CertificationPage());
          },
          child: Text('다음',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary)),
        ),
      ),
    );
  }
}
