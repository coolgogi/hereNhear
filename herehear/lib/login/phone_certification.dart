import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/login/agreeToS.dart';
import 'package:herehear/login/signUp_controller.dart';
import 'package:sms_autofill/sms_autofill.dart';

class CertificationPage extends StatefulWidget {
  @override
  _CertificationPageState createState() => _CertificationPageState();
}

class _CertificationPageState extends State<CertificationPage> {
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController certificationController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final registerController = Get.put(RegisterController());

  bool authOk = false;
  bool showLoading = false;
  bool requestedAuth = false;
  String? _verificationId;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final validNumbers = RegExp(r'(\d+)');
  final validAlphabet = RegExp(r'[a-zA-Z]');
  final validSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  final SmsAutoFill _autoFill = SmsAutoFill();

  autoFill() async {
    phoneNumController.text = (await _autoFill.hint)!;
  }

  @override
  void initState() {
    super.initState();
    _auth.setLanguageCode("ko");
    autoFill();
  }

  @override
  Widget build(BuildContext context) {
    registerController.isPhoneNumActive.value = false;
    registerController.isCertificationNumActive.value = false;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                          color: registerController.isPhoneNumActive.value? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface,
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
                                onTap: () => {
                                Get.defaultDialog(
                                title: '',
                                middleText: registerController.checkPhoneNumber(phoneNumController.text) != null? '유효하지 않은 번호입니다.'
                                    : registerController.isExistPhoneNumber.value? '이미 가입한 번호입니다.' : '인증번호가 전송되었습니다.',
                                textConfirm: '확인',
                                buttonColor: Theme.of(context).colorScheme.background,
                                confirmTextColor: Theme.of(context).colorScheme.onBackground,
                                onConfirm: () => Get.back(),
                                ),
                                setState(() {
                                showLoading = true;
                                }),
                                  verifyPhoneNumber(),} ,
                                child: Text('인증번호 받기', style:Theme.of(context).textTheme.headline6!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                              ))),
                              onTap: () {
                                registerController.isPhoneNumActive.value =
                                    true;
                                registerController
                                    .isCertificationNumActive.value = false;
                              },
                              validator: (value) =>
                                  registerController.checkPhoneNumber(value!),
                            ),
                          ),
                      Text(
                        "인증번호 6자리",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: registerController.isCertificationNumActive.value? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onSurface,
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
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(0.w, 12.h, 3.w, 0.h),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.defaultDialog(
                                      title: '',
                                      middleText: registerController
                                          .checkCertificationNumber(
                                          certificationController
                                              .text) !=
                                          null
                                          ? '인증번호를 입력해주세요.'
                                          : registerController
                                          .isCorrectCertificationNum
                                          .value
                                          ? '인증번호가 틀렸습니다.'
                                          : '인증이 완료되었습니다.',
                                      textConfirm: '확인',
                                      buttonColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      confirmTextColor: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      onConfirm: () => Get.back(),
                                    );
                                    PhoneAuthCredential phoneAuthCredential =
                                    PhoneAuthProvider.credential(
                                        verificationId: _verificationId!,
                                        smsCode:
                                        certificationController.text);

                                    signInWithPhoneAuthCredential(
                                        phoneAuthCredential);
                                  },
                                  child: Text('인증확인', style:Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  )),
                                ),
                              ),
                          ),
                          onTap: () {
                            registerController.isPhoneNumActive.value =
                            false;
                            registerController
                                .isCertificationNumActive.value = true;
                          },
                          validator: (value) => registerController
                              .checkCertificationNumber(value!),
                        ),
                      ),
                      // registerController.
                    ])),
                SizedBox(
                  height: 44.h,
                  ///////////////////////////////////////////////////////////////////////////
                  width: MediaQuery.of(context).size.width,
                  //이게 왜??? 진짜 절대 모르겠어;;;;
                  ///////////////////////////////////////////////////////////////////////////
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: (phoneNumController.text.isEmpty ||
                              certificationController.text.isEmpty)
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onSecondary)
                          : MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Get.to(AgreementTOSPage());
                      }
                    },
                    child: Text('다음',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Theme.of(context).colorScheme.background)),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {
        setState(() {
          print("인증완료 및 로그인성공");
          authOk = true;
          requestedAuth = false;
        });
        await _auth.currentUser!.delete();
        print("auth정보삭제");
        _auth.signOut();
        print("phone로그인된것 로그아웃");
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        print("인증실패..로그인실패");
        showLoading = false;
      });

      await Fluttertoast.showToast(
          msg: e.message!,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          fontSize: 16.0);
    }
  }

  void verifyPhoneNumber() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      print("otp 문자옴");
      // await _auth.signInWithCredential(credential);
      // showSnackbar("Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException verificationFailed) async {
      print(verificationFailed.code);
      print("코드발송실패");
      setState(() {
        showLoading = false;
      });
    };

    PhoneCodeSent codeSent = (String verificationId, int? resendToken) async {
      // Update the UI - wait for the user to enter the SMS code
      print("코드보냄");

      // Create a PhoneAuthCredential with the code
      Fluttertoast.showToast(
          msg:
              "${phoneNumController.text} 로 인증코드를 발송하였습니다. 문자가 올때까지 잠시만 기다려 주세요.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          fontSize: 12.0);
      setState(() {
        requestedAuth = true;
        showLoading = false;
        this._verificationId = verificationId;
      });
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print('Time out');
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumController.text,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          timeout: const Duration(seconds: 120),
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print('Failed to Verify Phone Number: $e');
    }
  }
}
