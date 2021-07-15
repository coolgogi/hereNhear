import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class Sms extends StatefulWidget {
  @override
  _SmsPage createState() => _SmsPage();
}

class _SmsPage extends State<Sms> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String? _verificationId;
  final SmsAutoFill _autoFill = SmsAutoFill();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('sms'),
        ),
        key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                        labelText: 'Phone number (+xx xxx-xxx-xxxx)'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: TextButton(
                        child: Text("Get current number"),
                        onPressed: () async => {
                              _phoneNumberController.text =
                                  (await _autoFill.hint)!
                            },
               ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: TextButton(

                      child: Text("Verify Number"),
                      onPressed: () async {
                        verifyPhoneNumber();
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _smsController,
                    decoration:
                        const InputDecoration(labelText: 'Verification code'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16.0),
                    alignment: Alignment.center,
                    child: TextButton(

                        onPressed: () async {
                          signInWithPhoneNumber();
                        },
                        child: Text("Sign in")),
                  ),
                ],
              )),
        ));
  }

  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsController.text,
      );

      final User user = ((await _auth.signInWithCredential(credential)).user)!;

      showSnackbar("Successfully signed in UID: ${user.uid}");
    } catch (e) {
      showSnackbar("Failed to sign in: " + e.toString());
    }
  }

  void verifyPhoneNumber() async {
    // PhoneVerificationCompleted verificationCompleted =
    //     (PhoneAuthCredential credential) async {
    //   // ANDROID ONLY!
    //
    //   // Sign the user in (or link) with the auto-generated credential
    //   await _auth.signInWithCredential(credential);
    //   showSnackbar("Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}");
    // };
    //
    // PhoneVerificationFailed verificationFailed =
    //     (FirebaseAuthException e){
    //       if (e.code == 'invalid-phone-number'){
    //   showSnackbar('Phone number verification failed. Code: ${e.code}. Message: ${e.message}');}
    // };
    //
    // PhoneCodeSent codeSent =
    //
    //     (String verificationId, int? resendToken) async {
    //   // Update the UI - wait for the user to enter the SMS code
    //   String smsCode = 'xxxx';
    //
    //   // Create a PhoneAuthCredential with the code
    //   PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    //   _verificationId = verificationId;
    //   // Sign the user in (or link) with the credential
    //   await _auth.signInWithCredential(credential);
    // };
    //
    //
    // PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
    //     (String verificationId) {
    //   showSnackbar("verification code: " + verificationId);
    //   _verificationId = verificationId;
    // };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // ANDROID ONLY!

            // Sign the user in (or link) with the auto-generated credential
            await _auth.signInWithCredential(credential);
          },
          verificationFailed:(FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
            }

            // Handle other errors
          },
          codeSent: (String verificationId, int? resendToken) async {
            // Update the UI - wait for the user to enter the SMS code
            String smsCode = 'xxxx';

            // Create a PhoneAuthCredential with the code
            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

            // Sign the user in (or link) with the credential
            await _auth.signInWithCredential(credential);
          },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },);
    } catch (e) {
      showSnackbar("Failed to Verify Phone Number: ${e}");
    }
  }

  void showSnackbar(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(message)));
  }
}
