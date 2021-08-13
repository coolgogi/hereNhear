import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/login/agreeToS.dart';
import 'package:herehear/login/signUp.dart';
import 'package:herehear/login/signUp_controller.dart';
import 'package:sms_autofill/sms_autofill.dart';


class CertificationPage extends StatefulWidget {
  @override
  _CertificationPageState createState() => _CertificationPageState();
}

class _CertificationPageState extends State<CertificationPage> {
  TextEditingController phoneNumController = TextEditingController();
  String? _verificationId;
  TextEditingController certificationController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final registerController = Get.put(RegisterController());

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final  validNumbers = RegExp(r'(\d+)');
  final  validAlphabet = RegExp(r'[a-zA-Z]');
  final  validSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  final SmsAutoFill _autoFill = SmsAutoFill();


  autoFill() async{
    phoneNumController.text =
    (await _autoFill.hint)!;
  }

  @override
  void initState() {
    super.initState();
  autoFill();
  }


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
                                onTap: () => Get.defaultDialog(
                                  title: '',
                                  middleText: registerController.checkPhoneNumber(phoneNumController.text) != null? '유효하지 않은 번호입니다.'
                                          : registerController.isExistPhoneNumber.value? '이미 가입한 번호입니다.' : '인증번호가 전송되었습니다.',
                                  textConfirm: '확인',
                                  buttonColor: Theme.of(context).colorScheme.background,
                                  confirmTextColor: Theme.of(context).colorScheme.onBackground,
                                  onConfirm: () => Get.back(),
                                ),
                                child: Text('인증번호 받기', style:Theme.of(context).textTheme.headline6!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                              ),
                            ),
                          ),
                          onTap: () {
                            verifyPhoneNumber();
                            registerController.isPhoneNumActive.value = true;
                            registerController.isCertificationNumActive.value = false;
                          },
                          validator: (value) => registerController.checkPhoneNumber(value!),
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
                                  onTap: () => Get.defaultDialog(
                                    title: '',
                                    middleText: registerController.checkCertificationNumber(certificationController.text) != null? '인증번호를 입력해주세요.'
                                        : registerController.isCorrectCertificationNum.value? '인증번호가 틀렸습니다.' : '인증이 완료되었습니다.',
                                    textConfirm: '확인',
                                    buttonColor: Theme.of(context).colorScheme.background,
                                    confirmTextColor: Theme.of(context).colorScheme.onBackground,
                                    onConfirm: () => Get.back(),
                                  ),
                                  child: Text('인증확인', style:Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  )),
                                ),
                              ),
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

  void verifyPhoneNumber() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      // ANDROID ONLY!

      // Sign the user in (or link) with the auto-generated credential
      await _auth.signInWithCredential(credential);
     // showSnackbar("Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}");
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e){
          if (e.code == 'invalid-phone-number'){
 //     showSnackbar('Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
          }
    };

    PhoneCodeSent codeSent =

        (String verificationId, int? resendToken) async {
      // Update the UI - wait for the user to enter the SMS code
      String smsCode = 'xxxx';

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      _verificationId = verificationId;
      // Sign the user in (or link) with the credential
      await _auth.signInWithCredential(credential);
    };


    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
     // showSnackbar("verification code: " + verificationId);
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumController.text,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
          timeout: const Duration(seconds: 50),
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print('Failed to Verify Phone Number: $e');
    }
  }
}


