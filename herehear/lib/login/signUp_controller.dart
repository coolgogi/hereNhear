import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxBool isExistID = false.obs;
  RxBool isNicknameActive = false.obs;
  RxBool isIdActive = false.obs;
  RxBool isPwdActive = false.obs;
  RxBool isConfirmPwdActive = false.obs;
  RxBool isPhoneNumActive = false.obs;
  RxBool isCertificationNumActive = false.obs;
  RxBool allAgree = false.obs;
  RxBool firstTermAgree = false.obs;
  RxBool secondTermAgree = false.obs;
  RxBool thirdTermAgree = false.obs;

  Rx<FocusNode> nickNameFocus = FocusNode().obs;
  Rx<FocusNode> idFocus = FocusNode().obs;
  Rx<FocusNode> pwdFocus = FocusNode().obs;
  Rx<FocusNode> confirmPwdFocus = FocusNode().obs;


  final validNumbers = RegExp(r'(\d+)');
  final validAlphabet = RegExp(r'[a-zA-Z]');
  final validSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }


  String? checkNickname(String value) {
    if (value.isEmpty) {
      nickNameFocus.value.requestFocus();
      return '닉네임을 입력해주세요.';
    }
    return null;
  }

  String? checkPossibleId(String value) {
    if (value.isEmpty) {
      idFocus.value.requestFocus();
      return '아이디를 입력해주세요.';
    }
    //6~12자인지 확인
    if ((12 <= value.length) || (value.length <= 6)) {
      idFocus.value.requestFocus();
      return '아이디는 6~12자 이내여야 합니다.';
    }
    //특수기호가 있는지 확인
    if (validSpecial.hasMatch(value)) {
      idFocus.value.requestFocus();
      return '아이디는 영문자,숫자만 입력 가능합니다.';
    }
    return null;
  }

  String? checkPossiblePassword(String value) {
    if (value.isEmpty) {
      pwdFocus.value.requestFocus();
      return '비밀번호를 입력해주세요.';
    }
    //8~21자인지 확인
    if ((12 <= value.length) || (value.length <= 8)) {
      pwdFocus.value.requestFocus();
      return '비밀번호는 8~20자 이내여야 합니다.';
    }
    //특수기호가 있는지 확인
    if (!validSpecial.hasMatch(value) || !validAlphabet.hasMatch(value) ||
        !validNumbers.hasMatch(value)) {
      pwdFocus.value.requestFocus();
      return '비밀번호는 영문자,숫자,특수문자를 모두 포함해야 합니다.';
    }
    return null;
  }

  String? checkConfirmPassword(String value, String value2) {
    if (value.isEmpty) {
      confirmPwdFocus.value.requestFocus();
      return '비밀번호를 한 번 더 입력해주세요.';
    }
    //8~21자인지 확인
    if (!(value == value2)) {
      confirmPwdFocus.value.requestFocus();
      return '비밀번호와 같지 않습니다.';
    }
    return null;
  }

  String? checkPhoneNumber(String value) {
    if (value.isEmpty) {
      confirmPwdFocus.value.requestFocus();
      return '휴대전화 번호를 입력해주세요.';
    }
    if(!(value.isPhoneNumber)) {
      confirmPwdFocus.value.requestFocus();
      return '잘못된 형식입니다';
    }
    //8~21자인지 확인
    // if (//전화 번호 인증 조건//) {
    //   _confirmPwdFocus.value.requestFocus();
    //   return '잘못된 형식이거나 유효하지 않은 번호입니다.';
    // }
    return null;
  }

  String? checkCertificationNumber(String value) {
    if (value.isEmpty) {
      confirmPwdFocus.value.requestFocus();
      return '인증번호를 입력해주세요.';
    }
    return null;
  }
}