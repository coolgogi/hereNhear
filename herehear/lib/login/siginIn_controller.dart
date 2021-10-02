import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  RxBool isObscureText = true.obs;
  RxBool isIdActive = false.obs;
  RxBool isPwdActive = false.obs;

  Rx<FocusNode> idFocus = FocusNode().obs;
  Rx<FocusNode> pwdFocus = FocusNode().obs;

  final validNumbers = RegExp(r'(\d+)');
  final validAlphabet = RegExp(r'[a-zA-Z]');
  final validSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  String? checkId(String value) {
    if (value.isEmpty) {
      idFocus.value.requestFocus();
      return '아이디를 입력해주세요.';
    }
    if (!(value.isEmail)) {
      idFocus.value.requestFocus();
      return '유효하지 않은 이메일형식입니다.';
    }
    return null;
  }

  String? checkPassword(String value) {
    if (value.isEmpty) {
      pwdFocus.value.requestFocus();
      return '비밀번호를 입력해주세요.';
    }
    //8~21자인지 확인
    if ((12 <= value.length) ||
        (value.length <= 8) ||
        !validSpecial.hasMatch(value) ||
        !validAlphabet.hasMatch(value) ||
        !validNumbers.hasMatch(value)) {
      pwdFocus.value.requestFocus();
      return '잘못된 비밀번호입니다.';
    }
    return null;
  }

  Future<void> loginWithGoogle() async {
    try {
      print("check1");
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final authResult = await _auth.signInWithCredential(credential);

      final User? user = authResult.user;
      assert(!user!.isAnonymous);
      assert(await user!.getIdToken() != null);
      final User? currentUser = _auth.currentUser;
      assert(user!.uid == currentUser!.uid);
      update();
      print("login");
      Get.toNamed('/'); // navigate to your wanted page
      return;
    } catch (e) {
      print("error");
      print(e);
      //throw (e);
    }
  }

  Future<void> loginWithButton(String email, String password) async {
    UserCredential rt;
    try {
      var _auth = FirebaseAuth.instance;

      rt = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return;
    } catch (e) {
      print("error in signIn_controller.dart in line 87");
      print(e);
      return;
    }
  }

  Future<void> logoutGoogle() async {
    await googleSignIn.signOut();
    Get.back(); // navigate to your wanted page after logout.
  }
}
